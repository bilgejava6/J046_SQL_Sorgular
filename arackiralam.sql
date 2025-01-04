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
select * from tblkullanici order by ad limit 5
-- en çok satılan 10 ürün
-- yeni kayıt olan üyelerimiz.
-- günün ürünü
-- en büyük indirimler
-- uygulamada en çok satın alma işlemi yapan ilk 10 müşteri
------------------------------------
------------------------------------
--- IN ([ARRAY_VALUES])
--- Eğer aralarında bir bağıntı olmayan farklı id leri 
--- listelemek isteseydiniz nasıl yapardınız?
--- 4,98,102,21,987,432,214,655 ... 50 adet daha var
select * from tblkullanici where id=4 or id=98 or id=102 -- ....
select * from tblkullanici where id in (5,12,89,56,43,27,48,67)
select * from tblkullanici where il in ('Ankara', 'Maralik', 'Labrador')
--- INNER SELECT
select * from tblkullanici where id in (
	select kullaniciid from tblkiralama -- 4
)
----------------------------------
----------------------------------
--- arama işlemleri bazen net olmayacaktır, yani =(eşittir) ile arama 
--- işlemi her zaman işimizi görmeyecek. Bu nedenle daha geniş arama 
--- seçenmeklerine iihtiyacımız var.
--- Örneğin, bir isim araması yaparken sadece bir kaç harfi ile arama 
--- yapmak isteye biliriz. Instagramda arkadaş aramak gibi. İşte
--- bu tarz, metin içerisinde arama işlemleri için;
--- LIKE '[SEARCH_VALUE]'
select * from tblkullanici where ad = 'Ahmet'
select * from tblkullanici where ad like 'Ahmet'
--- özel karaterleri ile detaylı arama imkanı sunar.
--- [ % ] -> joker karaterdir, herhangi bir ifadenin yerine geçer. 0..n
select * from tblkullanici where ad like 'A%'
-- A% -> A ile başlayıp devamında herhangi bir ifade olması
-- A, Ax, Axx, Axx...n olabilir. A ile başlayıp herhangi bir değe ile devam edebilir.
select * from tblkullanici where ad like '%a'
-- %a -> herhangi bir değer ile başlayıp a ile bitenler.
-- a, xa, xxa, xx xxa, xx....na
select * from tblkullanici where ad like '%a%' 
-- %a% -> herhangi bir değer ile başlayıp a ile devam edip herhangi bir değer ile bitenler
-- içinde a harfi olanlar, a, xa, xax, xxxxxxxxax, xxxxxxxaxxxx,
select * from tblkullanici where ad like '%a%' and soyad like '%i%' -- 21
select * from tblkullanici where ad like '%a%' or soyad like '%i%' -- 73
select * from tblkullanici where ad like '%a%h%'
--- [ _ ] -> alt çizgi, bu bir karakter yerine geçer.
select * from tblkullanici where ad like '%n_' 
-- herhangi bir değer ile başlayan,  n harfi ve devamında bir karakter ile bitenler.
select * from tblkullanici where ad like '%a__n%'
select * from tblkullanici where ad like '___a%'
select * from tblkullanici where ad like '___a'
select * from tblkullanici where ad like 'A____'
-------------------------------------------
-------------------------------------------
--- örnek; intagramda al başlayan kişilerden ilk 5 ini göster
select * from tblkullanici where ad like '%ar%' limit 5
----------
-- JAVA İÇİN ÖRNEK YAZDIM, SONRA İŞLEYECEĞİZ.
-- String aranan;
-- aranan = "yoğun";
-- select * from tblmakale where icerik like '%[$aranan]%';
----------
-- arama yaparken eşitlik genelde bire bir şeklinde yapılır, ancak 
-- günlük işlemlerde bu çok fayda sağlamaz, çünkü veriler karışık olabilir
-- bu nedenle büyük-küçük harf duyarlılığını kontrol etmek gerekli.
-- ilike -> büyük küçük harf duyarlılığını ortadan kaldırır. daha kapsamlı arama 
-- yapılabilir.
select * from tblkullanici where ad ilike 'a%'
--------------
-- WHERE [COLUMN_NAME] BETWEEN [START] and [END]
select * from tblkullanici where id>=5 and id<=25
select * from tblkullanici where id between 5 and 25
--------------
-- Tablolarımızda boş bırakılmış alanları bulmak isteyebiliriz, bu işlemleri
-- yapmak için null olan alanları bulan özel bir kodumuz var
-- = NULL, NOT NULL, | IS NULL (değer null ise), IS NOT NULL (değer null değil ise) 
-- adres bilgisi null olanları bulalım
select * from tblkullanici where adres is null
select * from tblkullanici where adres is not null
-----
-- bazen bazı alanları null olsa bile kayıtları listelemek isteyebiliriz.
-- ancak bu null olan kayıtların bir şekilde düzenlenmesi de gereklidir. Bu gibi
-- durumlarda null olan kayıtları başka bir default değer ile değiştiririz.
-- coalesce -> null olan alanlara default değer atayarak döner.
-- bu işlem sadece sorguda işe yarar gerçek veri üzerinde değişiklik yapmaz.
-- coalesce sadece postgresql için geçerlidir.
-- SQL -> ifNull, MsSQL -> isNull
select id,ad,soyad,coalesce(adres,'Türkiye') as adres
from tblkullanici where adres is null

select * from tblkullanici
------------------------------
--- Özel keyword ve matematiksel işlemler
------ count -> tablonun tamamında yada belirtilen bir sütunda var olan kayıtları
------  sayar.
--- adında a harfi olan kaç adet kayıt vardır?
select count(*) as adinda_a_olanlarin_sayisi from tblkullanici where ad like '%a%'

select count(*) as tablonun_sayisi from tblkullanici
-- NOT!! eğer. saydığınız alanda null olan değerler var ise, sayım o değerleri
-- içerisine katmaz. count(*) işlemi dahi olsa, id alanı null ise ilgili satır
-- sayaç a eklenmez.
--- il bilgisi null olan kaç kişi var?
select count(*) from tblkullanici where il is null -- 14 kayıt
--- il bilgisi dolu olan kaç kişivar?
select count(il) from tblkullanici -- 96 kayıt
--------------------------------
---- 1 
select * from tblkullanici order by id
insert into tblkullanici(id, ad) values
(7,'Kaan'), (8,'Demet'), (9,'Ayşe'), (10,'Uğur')

select * from tblkiralama
select * from tblarac
----------
---- MIN , MAX 
--- benim fiyat olarak en çok ve en az satış yaptığım kişler kimdir?
select max(toplamfiyat) from tblkiralama
select toplamfiyat from tblkiralama 
where toplamfiyat is not null -- null olmayan değerleri getir
order by toplamfiyat desc -- fiyatı en büyükten en küçüğe sırala
limit 1 -- sadece ilk kaydı göster

select min(toplamfiyat) from tblkiralama
-----------------------
--- herhangi bir aracımın ortalama kaç gün kirada kaldığını nasıl bulurum
--- AVG - herhangi bir sütunun oertalamasını verir.
select avg(kiralamasuresi) from tblkiralama where arabaid = 5
select avg(kiralamasuresi) from tblkiralama where arabaid = 1
select avg(kiralamasuresi) from tblkiralama where arabaid = 10

select count(*) from tblkiralama where arabaid = 10
select count(*) from tblkiralama where arabaid = 1
select count(*) from tblkiralama where arabaid = 5

--------------------------
--- bu yıl kiralama üzerinden elde edilen toplam gelir ne kadar?
select sum(toplamfiyat) from tblkiralama

select sum(toplamfiyat) from tblkiralama where arabaid = 10
select sum(toplamfiyat) from tblkiralama where arabaid = 1
select sum(toplamfiyat) from tblkiralama where arabaid = 5
----------------
--- concat -> sütunları birleştirmek için kullanılır.
select id, concat(ad,' ',soyad) as adsoyad from tblkullanici

select concat(id, ' - ', ad) as ozelad from tblkullanici

----------------
--- length -> kolunun içindeki değerin uzunluğunu verir
select ad, length(ad) from tblkullanici order by length(ad) desc,ad asc

----------------
-- trim -> ilgili sütundaki datanın başındaki ve sonundaki boşlukları siler.
select * from tblkullanici
update tblkullanici set ad = '   Muhammet    ' where id=1

select trim(ad) from tblkullanici
select ad, length(ad), length(trim(ad)) from tblkullanici
-----------------
--- arama yaparken ya da verileri belli bir formda almak isterken
--- düzenleme yapmak isteriz ama verinin orjinal halininde korunmasu
--- istenir. Burada ilgili sütun değerinin BÜYÜK yada küçük şekilde
--- yazılmasını sağlayabiliriz.
--- UPPER, LOWER
select ad, upper(ad) from tblkullanici
select * from tblkullanici where lower(ad) = 'ahmet'
----------------------
--- ifadelerin bazen tersten okumak gerekebilir ya da şifrelemek için 
--- bu şkeilde almak işimze gelebilir.  bunun için
--- REVERSE kullanırız
select ad, reverse(ad) from tblkullanici

----------------------------------
-- ad.     |  tarih.  |    fiyat
-- Murat    14.05.2024.  960₺
-- Deniz    15.05.2024.  750₺
-- Hakan    15.05.2024.  1230₺
-- Murat    17.05.2024.  880₺
-- Deniz    19.05.2024.  670₺
-- Melek    19.05.2024.  2690₺
------
--- Bu tabloda hangi müşteri toplam kaç para ödeme yapmış?
-- müşteri adı.  |. toplam ödeme
-- Murat.             1840₺  
-- Deniz.             1420₺
-- Hakan.             1230₺
-- Melek.             2690₺
-------
-- gruplama ile belli alanları tekilleştirerek diğer alanları işleme
-- tabi tutabilirsiniz.
select kullaniciid,sum(toplamfiyat) from tblkiralama group by kullaniciid
order by kullaniciid

select arabaid, sum(toplamfiyat) from tblkiralama group by arabaid
order by arabaid

-----------------------
-- kiralama işlemlerinde kiralama adedi, 15 ve üzerinde olan kullanıcıların
-- listesini bulunuz?
-- DİKKAT!!!!!
-- where select için tabloda alanlarda yapılan kısıtlamayı tanımlar,
-- ancak group by için kısıtlama işlemi HAVING ile yapılır.
select kullaniciid, count(*) as kiralamaadedi from tblkiralama
group by kullaniciid 
having count(*)>14
order by count(*) desc

----------------------------
----------------------------
---- SORU:  kiralama süresi ortalaması en yüksek olan ilk 3 aracı listeleyin
select * from tblkiralama

















































