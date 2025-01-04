-- user tablosu
create table tblkullanici(
		id bigserial primary key, -- msSQL identity(1,1)
	ad varchar(100),
	soyad varchar(100),
	adres varchar(200),
	il varchar(50),
	state int default 1 -- 0- pasif, 1-aktif, 2-bloke, 3-silinmiş
)

-- car tablosu
create table tblarac(
	id bigserial primary key,
	marka varchar(100),
	model varchar(100),
	modelyili int,
	kapasite int,
	kiradami boolean,	
	state int default 1 -- 0- pasif, 1-kiralanabilir, 2- bakımda, 3- silinmiş
)

create table tblkiralama(
	id bigserial primary key,
	kullaniciid bigint references tblkullanici(id), -- fk, foreignkey
	arabaid bigint references tblarac(id),
	kiralamatarihi bigint, -- long
	tarih date, -- date YYYY-MM-DD
	kiralamasuresi int, -- gün sayısı
	iadetarihi bigint,
	iadetarih date,
	birimfiyat double precision,
	toplamfiyat double precision,
	odemedurumu int, -- 1- ödendi, 2-iadede ödenecek, 3-kısmi ödeme
	state int default 1 -- 1-aktif, 2-iade edilmiş, 3-gecikmiş, 4-iptal edilmiş
)

create table tblodeme(
	id bigserial primary key,
	kiralamaid bigint references tblkiralama(id),
	toplamtutar double precision,
	nakitodeme double precision,
	kredikartiodeme double precision	
)
---------------------------
---- BİLGİLERİ İŞLEMEK
--- CRUD
-- Create 
-- Read
-- Update
-- Delete
---------------------------
--- insert into -> veritabanı tablolarına kayıt eklemek için kullanılır.
--- insert into [TABLO_ADI] ([COLUMN_NAME],[COLUMN_NAME]....) devam ediyor.
--- values([VALUE], [VALUE]....)
--- DİKKAT!!!!!
--- eğer string bir değer girilecek ise '' tek tırnak arasında 
--- eğer sayı ise direkt olarak yazılır.
--- eğer değer date ise '' tek tırnak içerisinde. '2025-01-02' - YYYY-MM-DD
--- ÇOOOOOK DİKKAT!!!!!
--- alan adlarını hangi sıra ile yazmış iseniz değlerinide aynı sıra ile 
--- yazmak zorundasınız.
insert into tblkullanici(ad,soyad,adres,il) 
values('Muhammet','HOCA','Ankara da bir yerler', 'Ankara')

insert into tblkullanici(il, adres, ad)
values('İzmir','merkez de bir yerler','Canan')

insert into tblkullanici(ad,soyad) values ('Ahmet', 'TAŞ')

insert into tblkullanici(ad,soyad,adres,il) values
('Kenan','TEKİN','Bursa - Merkez','Bursa'),
('Ahmet', 'TAKAN','İstanbul- Beşiktaş','İstanbul'),
('Deniz', 'TAŞKIN','Antalya - Merkez', 'Antalya')

insert into tblarac(marka,model,modelyili,kapasite,kiradami) values
('Alfa Romeo', 'Guilia',2020,4,false),('Alfa Romeo', 'Spider',2024,4,false),
('Alfa Romeo', 'GTV',2019,4,false),('Alfa Romeo', 'MiTo',2017,4,false),
('Ford','C-Max',2024,4,false), ('Ford','Focusx',2020,4,false), 
('Ford','Mondeo',2021,4,false), ('Ford','Mustang',2021,4,false), 
('Ford','Fiesta',2020,4,false), 
('Mazda','RX', 2021, 2, false), ('Mazda','6',2006,4,false)
---------
--- double precision -> hassas işlemler için kullanılır
--- finansal (bitcoin ..) (, sonra 15-17 basamak), matematik, istatistik
--- NUMERIC,NUMBER
insert into tblkiralama(kullaniciid,arabaid,kiralamatarihi,
tarih,kiralamasuresi, iadetarihi, iadetarih,birimfiyat, toplamfiyat,
odemedurumu) values
(4,3,1735840538000,'2025-01-02',4,1736186138000,
'2025-01-06',2000, 8000,1)

----------------------------------
--- VERİ GÜNCELLEME
--- update -> DB tablosunda bulunan satırların güncellenmesi
--- update [TABLO_NAME] set [COLUMN_NAME] = [NEW VALUE], .... DİKKAT devam
--- where [COLUMN_NAME] = [FIND_VALUE]
--- genellikle id ile kısıtlama yapılarak güncelleme yapılır, ankcak
--- belli kriterlere görede güncelleme yapılabilir.

update tblkullanici set il = 'Ankara' where id = 3

update tblkullanici set il = 'İzmir', soyad= 'BEŞTAŞ' where id = 2
-- where id>1 and id<50
-- where id in(3,654,34532,34)
-----------------------------------
---- DELETE -> tablolarınızdan veri silmek için kullanırız.
---- delete from [TABLE_NAME] -- bu kadar yazılabilir ancak tüm datayı siler
---- delete from [TABLE_NAME] where KRİTER 0=> [COLUMN_NAME] = [VALUE]
---- Dikkat!!! tabolardan veri silmek doğru değildir, ancak datalarınız
---- kirlenmiş ise kirli dataları silmek için kullanılabilir.
------------
insert into tblkullanici(ad) values ('Ali'), ('Veli'), ('Zeynep'), ('Elif')

delete from tblkullanici where id>6 and id<10

delete from tblkullanici where id = 4

------------------
--- Veritabanından verileri okumak - SORGULAMA İŞLEMLERİ
--- SELECT -> kendisine verilen bilgiyi tablo olarak göstermeye
--- meyilli okuma ve sorgulama komutudur.
----------

select 'selam gençler SQL öğreniyor muyuz?'
select 50 + 98
select now() -- erişim yaptığınız postgresql sunucusunun üzerinde 
			 -- çalıştığı bilgisayarın timestamp bilgisini alır.
--------------------
-- AS -> takma ad
select 'nasılsınız? ' as Ifade
select 45 + 33 as TOPLAM
---------------------
---- select seç
---- neyi seçeyim? (*) her şeyi seç (tüm kolonları seç)
---- nereden alayım? from (-den -dan) [TABLE_NAME]
----
select * from tblkullanici
select ad,soyad from tblkullanici
select tblkullanici.ad,tblkullanici.soyad from tblkullanici
select ad as kullanici_adi, soyad from tblkullanici
select k.ad, k.soyad, k.adres from tblkullanici as k
----------------------------------
--- Sorguların Kısıtlanması
select * from tblkullanici
select * from tblkullanici where id=4 -- tek bir kayıt döner
select * from tblkullanici where id=9999 -- boş kayıt döner
select * from tblkullanici where id>=5 --id si 5 dahil büyük olan kayıtlar
select * from tblkullanici where id>=2 and id<5
select * from tblkullanici where id<3 or id>=6
select * from tblkullanici where id=4 or id=1 or id=9 or id=3
select * from tblkullanici where il='Ankara' -- Ankara illeri listelenir
select * from tblkullanici where il='ankara' -- büyük küçük harf duyarlı
--------------------------------------
---- Sorguların sıralanması
---- ORDER BY komutu ile sırlama yapılır.
---- SELECT * from [TABLE_NAME] ORDER BY [COLUMN_NAME]
select * from tblkullanici order by id
select * from tblkullanici order by ad
---- DİKKAT!!! burada order by doğal formuna göre sırlama yapar
---- yani [a..z] ya da [0..9] yapar peki tam tersi gerekli ise
---- Sıralamanın yönünü belirleyebilirsiniz
---- ASC - a..z, 0..9
---- DESC - z..a, 9..0
---- SELECT * from [TABLE_NAME] ORDER BY [COLUMN_NAME] [ASC or DESC]
select * from tblkullanici order by ad desc
select * from tblkullanici order by ad asc -- default olarak asc aktiftir.
------------------------------------------
------------------------------------------
-- Tabloda istenilen miktarda veriyi çekmek.
--- LIMIT [miktar] postgreSQL
--- TOP, oracle/plsql - msSQL/t-sql
select * from tblkullanici 





















