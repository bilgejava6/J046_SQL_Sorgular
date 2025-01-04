---------   SQL Komutları -----------
-- çift tire yorum yazmak için kullanılır.
---- CREATE
-- bir veritabanı nesnesi oluşturmak için kullanılır.
-- SYNTAX: create/CREATE [DB OBJECT TYPE] [NAME] ...
-- EXAM: create table tbl_musteri ..., create view vw_musteri ...
--- DİKKAT!!!
--- postgresql de büyük küçük harf duyarlılığı vardır.
--- SORUN: tblMusteri -> "tblMusteri"
--- ÇÖZÜM: büyük harf kullanmayın, bunun yerine _ (alt tire) kullanın
--- tbl_musteri
-----------------
-- public class tblUsers{
-- 	public Long id;
-- 	public String userName;
--	public String password;
--}
-- ** serial or bigserial nedir? bizim id alanlarımızn ya da otomatik artım 
-- gerektiren alanların, otomatik artımını üstlenen sequence adı verilen 
-- yapılardır. Bunlar serial ile oluşturulur ve işaretlenen alanın otomatik
-- artmasını sağlar. bir değeri (sayıyı) asla tekrar üretmez.
-- ** primary key -> birincil anahtar olarak geçer, ilgili alanın ilgili 
-- kayıt için benzersiz ve işaretleyici olduğunu belirtir.
-- ** default -> eğer bir alan mutlaka değer atanmak zorunda ise bunu
-- kullnırız.
create table tblusers(
	id bigserial primary key,
	username varchar(100),
	password varchar(64),
	name varchar(150),
	avatar varchar(255) default 'https://avatar.com/default.jpg' ,
	email varchar(250),
	phone varchar(20),
	ulke varchar(100),
	sehir varchar(100),
	state int default 0, -- 0-> pasif, 1->aktif, 2->bloke, 3-> silinmiş
	createat bigint, -- ilk oluşturulma zamanı
	updateat bigint -- güncellenme zamanı
)

create table tblfilm(
	id bigserial primary key,
	ad varchar(250),
	vizyontarihi bigint,
	oyuncular varchar(1000),
	yonetmen varchar(150),
	aciklama varchar(1000),
	afis varchar(255),
	uzunluk int,
	state int ,
	createat bigint,
	updateat bigint
)

create table tbldizi(
	id bigserial primary key,
	ad varchar(250),
	vizyontarihi bigint,
	sezonadedi int,
	state int,
	createat bigint,
	updateat bigint
)


create table tblturler(
	id bigserial primary key,
	ad varchar(100),
	aciklama varchar(300),
	state int,
	createat bigint,
	updateat bigint
)
-- DİKKAT!!!!
-- eğer bir tablo başka bir tablo ile ilişkili ise aralarında bir 
-- bağıntı var ise, mutlaka ama mutlaka bir birlerine refere edilmelidir
-- YANİ, veri tutarlılığı için alanların kontrolünü yapacak bir kontrolcü
-- uygulanmalıdır. İşte tam burada bir tabloyu diğer tabloya refere eden
-- alanın varlığını kontrol eden yapıya FOREIGNKEY diyoruz ve bunu 
-- oluşturmak için "references" anahtar kelimesini kullanıyoruz.
create table tblfilmtur(
	id bigserial primary key,
	filmid bigint references tblfilm(id), -- film tablosunun id kolonunu kontrol et
	turid bigint references tblturler(id)
)

create table tbldizitur(
	id bigserial primary key,
	dizid bigint references tbldizi(id),
	turid bigint references tblturler(id)
)

create table tblsezon(
	id bigserial primary key,
	diziid bigint references tbldizi(id),
	ad varchar(150),
	aciklama varchar(1000)
)

create table tblbolum(
	id bigserial primary key,
	sezonid bigint references tblsezon(id),
	ad varchar(200),
	aciklama varchar(1000),
	vizyontarihi bigint,
	afis varchar(200),
	uzunluk int
)

create table tblizlemegecmisi(
	id bigserial primary key,
	userid bigint references tblusers(id),
	icerikturu int, -- FILM / DIZI
	icerikid bigint,
	baslangictarihi bigint,
	islemesuresi int,
	durmaani int,
	izlemedurumu int, -- IZLIYOR, DEVAMEDIYOR, BITTI,
	ensonerisimtarihi bigint
)
-----------------------------------------
--- 
----- SORU-1
--- Bir SatisDB veritabanı oluşturun
--- Ürün, Musteri ve Satış tablolarını oluşturun.
--- İlişkileri refere edin.
--- 3 ürün ekleyin, 2 müşteri ekleyin ve her müşteriye 1 adet satış yapın.
--------
-- double precision
-- numeric(6,2)


