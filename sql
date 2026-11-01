-- ========== TABEL ==========
create table if not exists mahasiswa (
  nim   text primary key,
  nama  text not null,
  prodi text not null default 'Sains Informasi',
  kelas text not null default 'B',
  email text generated always as (nim || '@mahasiswa.upnvj.ac.id') stored
);

create table if not exists jadwal_kelas (
  id bigint generated always as identity primary key,
  hari text not null,
  mata_kuliah text not null,
  mulai text not null,
  selesai text not null,
  ruang text not null,
  unique (hari, mata_kuliah)
);

create table if not exists pengumuman (
  id bigint generated always as identity primary key,
  nim text not null references mahasiswa(nim),
  nama text not null,
  kategori text not null default 'Info' check (kategori in ('Tugas','Dosen','Info')),
  isi text not null check (char_length(isi) between 5 and 280),
  created_at timestamptz not null default now()
);

-- ========== DATA MAHASISWA ==========
insert into mahasiswa (nim, nama) values
('2610414041','Daffa Dhia Alvaro Temas Praba'),
('2610414042','Felisya Hurina Zahirah'),
('2610414043','Dimas Rafif Syaputra'),
('2610414044','Raina Rizqi Adilla'),
('2610414045','Ariel Rayhans Wijaya'),
('2610414046','Ulvi Mevianti'),
('2610414047','Daniel Ahmad Rahman'),
('2610414048','Melisa Rizqi Septiyani'),
('2610414049','Zahirani Nurrahma'),
('2610414050','Muhammad Daffa Fadhilah'),
('2610414051','Devita Apriyani Kirana'),
('2610414052','Wahyu Komarudin'),
('2610414053','Ravida Azmi'),
('2610414054','Azka Mayyasa Putri Hartadi'),
('2610414055','Nailah Afifah Sri Mulyani'),
('2610414056','Nadisya Feby Putri Guntoro'),
('2610414057','Rana Afifah Ahmad'),
('2610414058','Aqila Fahma Diina'),
('2610414059','Balqis Fathiya Mysha Daulay'),
('2610414060','Angelica Cahyadi'),
('2610414061','Hanif Ramadhani Lutfi'),
('2610414062','Deo Ario Nouval Rolland'),
('2610414063','Azzam Alfathan Lazuardi'),
('2610414064','Jasmine Putri Azzahra'),
('2610414065','Gandewa Rangin Anggita'),
('2610414066','Fachri Ahmad'),
('2610414067','Zulfan Restu Angkasa'),
('2610414068','Reysy Dheca Paays'),
('2610414069','Agung Darmawan'),
('2610414070','Dhefina Caesa Claudya'),
('2610414071','Yakobus Gustaf Pattiwael'),
('2610414072','Rafi Murfid Fadillah'),
('2610414073','Muhammad Gading Yuwono Al Satar'),
('2610414074','Khanza Linda Shafira'),
('2610414075','Sasqia Ayudia Putri Rahardjo'),
('2610414076','Renova Tio Murni Pakpahan'),
('2610414077','Arini Rahmawati'),
('2610414078','Cahaya Cinta Romadona'),
('2610414079','Muhammad Firman Ramadhan'),
('2610414080','Nadya Irmaputri Raharjo')
on conflict (nim) do nothing;

-- ========== DATA JADWAL ==========
insert into jadwal_kelas (hari, mata_kuliah, mulai, selesai, ruang) values
('Senin','Teknologi Informasi dan Komunikasi','09.40','12.10','UPTBAHASA - Ged.Kartini R404'),
('Selasa','Literasi Digital','07.10','09.40','F.201'),
('Selasa','Bahasa Inggris','09.40','12.10','F.402'),
('Rabu','Pengantar Ilmu Informasi','07.10','09.40','F.201'),
('Kamis','Bahasa Indonesia','07.10','08.50','UPTBAHASA - Ged.Kartini R304'),
('Kamis','Pancasila','08.50','10.30','UPTBAHASA - Ged.Kartini R305'),
('Jumat','Kepemimpinan','08.50','10.30','UPTBAHASA - Ged.Kartini R305'),
('Jumat','Pendidikan Agama','10.30','12.10','UPTBAHASA - Ged.Kartini R304')
on conflict (hari, mata_kuliah) do nothing;

-- ========== KEAMANAN (Row Level Security) ==========
alter table mahasiswa    enable row level security;
alter table jadwal_kelas enable row level security;
alter table pengumuman   enable row level security;

drop policy if exists "baca mahasiswa" on mahasiswa;
create policy "baca mahasiswa" on mahasiswa for select to anon using (true);

drop policy if exists "baca jadwal" on jadwal_kelas;
create policy "baca jadwal" on jadwal_kelas for select to anon using (true);

drop policy if exists "baca pengumuman" on pengumuman;
create policy "baca pengumuman" on pengumuman for select to anon using (true);

-- posting hanya sah jika NIM dan nama cocok dengan data mahasiswa
drop policy if exists "tulis pengumuman" on pengumuman;
create policy "tulis pengumuman" on pengumuman for insert to anon
with check (exists (select 1 from mahasiswa m where m.nim = pengumuman.nim and m.nama = pengumuman.nama));
