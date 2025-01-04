create table tblmusteri(
	id bigserial primary key,
	ad varchar(100),
	adres varchar(100),
	state int,
	createat bigint default extract(epoch from now()) * 1000,
	updateat bigint default extract(epoch from now()) * 1000
)
-- now() timestamp olarak timezone dahil zamanı verir.
--select extract(epoch from now()) * 1000 
-- saniye 1000
-- dakika sn*60
-- saat dk*60
-- gün sa*24
-- 1 hafta gün*7

create table tblurun(
	id bigserial primary key,
	ad varchar(100),
	stok int,
	marka varchar(100),
	model varchar(100),
	fiyat numeric(6,2),
	state int,
	createat bigint default extract(epoch from now()) * 1000,
	updateat bigint default extract(epoch from now()) * 1000	
)

create table tblsatis(
	id bigserial primary key,
	musteriid bigint references tblmusteri(id),
	urunid bigint references tblurun(id),
	adet int,
	toplamfiyat numeric(6,2),
	tarih bigint default extract(epoch from now()) * 1000,
	state int,
	createat bigint default extract(epoch from now()) * 1000,
	updateat bigint default extract(epoch from now()) * 1000
)

-- PostgreSQL de en sık kullanılan DataType ları içeren 
-- küçük bir makale yazınız.


