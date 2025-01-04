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
	
)









