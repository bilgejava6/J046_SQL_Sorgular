----------------------------------
--- KİTAP KİRALAMA UYGULAMASI ----
---- TABLOLAR

create table tblyazar(
    id serial primary key ,
    ad varchar(50),
    biyografi varchar(5000),
    resim varchar(255),
    artalanresmi varchar(255),
    createat bigint default extract(epoch from now())*1000,
    updateat bigint default extract(epoch from now())*1000,
    -- 0 -> pasif 1 -> aktif 2 -> silinmiş
    state int default 1
);

create table tblkonu(
	id serial primary key,
	ad varchar(100)
);

create table tblyazarkonu(
	id serial primary key,
	yazarid int references tblyazar(id),
	konuid int references tblkonu(id)	
);

create table tblkitap(
	id serial primary key,
	ad varchar(200),
	sayfasayisi int,
	yayinevi varchar(300),
	cevirmen varchar(100),
	basimsayisi int,
	basimyili bigint,
	aciklama varchar(1000),
	konuid int references tblkonu(id),
    createat bigint default extract(epoch from now())*1000,
    updateat bigint default extract(epoch from now())*1000,
    -- 0 -> pasif 1 -> aktif 2 -> silinmiş
    state int default 1
);

create table tblyazarkitap(
	id serial primary key,
	yazarid int references tblyazar(id),
	kitapid int references tblkitap(id)
);

create table tblbrans(
	id serial primary key,
	ad varchar(100)	
);

create table tblokul(
	id serial primary key,
	ad varchar(250),
	adres varchar(500),
	iletisim varchar(200),
	yetkili varchar(200)
);

create table tblogretmen(
	id serial primary key,
	ad varchar(100),
	soyad varchar(100),
	telefon varchar(20),
	bransid int references tblbrans(id),
	okulid int references tblokul(id),
	tecrube int
);

create table tbladres(
	id serial primary key,
	ad varchar(255),
	il varchar(100),
	ilce varchar(150),
	mahalle varchar(200),
	tanim varchar(500),
	telefon varchar(20),
	ogretmenid int references tblogretmen(id)
);

create table tblkiralama(
	id serial primary key,
	tarih bigint,
	sure int,
	ucret numeric(5,2),
	odemedurumu int, -- 0: ödenmedi, 1:ödendi, 2:iade
	iadetarihi bigint,
	gecikmenedeni varchar(250),
	farkucreti  numeric(5,2),
	toplamucret  numeric(5,2),
	durum int,
	kitapid int references tblkitap(id),
	ogretmenid int references tblogretmen(id)
);

create table tblodeme(
	id serial primary key,
	kiralamaid int references tblkiralama(id),
	toplamtutar numeric(5,2),
	odemeyontemi varchar(100),
	odemetarihi bigint,
	odemeturu varchar(100)
);

create table tblkargo(
	id serial primary key,
	adresid int references tbladres(id),
	aliciadsoyad varchar(200),	
	kiralamaid int references tblkiralama(id),
	durum int,
	kargofirmasi varchar(200),
	takipno varchar(100),
	istektarihi bigint,
	gonderimtarihi bigint,
	ulasimtarihi bigint,
	iadetarihi bigint
);

------------------
------------------
--- DATALAR
-- YAZARLAR

insert into tblyazar(ad,biyografi,resim) values
('T-1','T-1','T-1'),('T-2','T-2','T-2'),('T-3','T-3','T-3'),
('Matt Haig',
	   'Matt Haig (1975, Sheffield) Hull Üniversitesi ve Leeds Üniversitesi’nde İngilizce ve Tarih üzerine öğrenim gördü. Çocuklar için yazdığı ilk romanı “Shadow Forest” 2007 yılında yayımlandı ve pek çok ödül aldı. Yetişkinler ve çocuklar için pek çok kitap yazdı. Kitapları çok satan listelerinde yer almaktadır.',
	   'https://img.kitapyurdu.com/v1/getImage/fn:11614652/wi:120/wh:b5eee0853'),
('Anıl Basılı','1991 yılında İstanbul’da doğdu. Kocaeli Üniversitesi Gazetecilik Bölümü mezunu. Bir çocuğa en güzel hediyenin kitap olduğunu düşünüyor. Köpeği Dali ile birlikte çimlerde yuvarlanmayı seviyor. Köy okulları için oyuncak ve kitap topluyor. Sosyal sorumluluk projeleri yürütüyor. Balino, Melodi ve Kitap Kurdu Olmak İstemeyen Maya isimli kitapları bulunan yazar, çocuklar için yazmaya devam ediyor',''),
('Prof. Dr. İlber Ortaylı','1947 yılında doğdu. Ankara Üniversitesi Siyasal Bilgiler Fakültesi (1969) ile Ankara Üniversitesi Dil Tarih Coğrafya Fakültesi Tarih Bölümü’nü bitirdi. Chicago Üniversitesi′nde master çalışmasını Prof. Halil İnalcık ile yaptı. “Tanzimat Sonrası Mahalli İdareler” adlı tezi ile doktor, “Osmanlı İmparatorluğu′nda Alman Nüfuzu” adlı çalışmasıyla da doçent oldu. Viyana, Berlin, Paris, Princeton, Moskova, Roma, Münih, Strasbourg, Yanya, Sofya, Kiel, Cambridge, Oxford ve Tunus üniversitelerinde misafir öğretim üyeliği yaptı, seminerler ve konferanslar verdi. Yerli ve yabancı bilimsel dergilerde Osmanlı tarihinin 16. ve 19. yüzyılı ve Rusya tarihiyle ilgili makaleler yayınladı. 1989–2002 yılları arasında Siyasal Bilgiler Fakültesi′nde İdare Tarihi Bilim Dalı Başkanı olarak görev yapmış, 2002 yılında Galatasaray Üniversitesi′ne geçmiştir. Uluslararası Osmanlı Etüdleri Komitesi Yönetim Kurulu üyesi ve Avrupa Iranoloji Cemiyeti üyesidir.',''),
('George Orwell','GEORGE ORWELL, 1903’te Hindistan’ın Bengal eyaletinin Montihari kentinde doğdu. Ailesiyle birlikte İngiltere’ye döndükten sonra, öğrenimini Eton College’de tamamladı. Gerçek adı Eric Arthur Blair olan Orwell, 1922-1927 yılları arasında Hindistan İmparatorluk Polisi olarak görev yaptı. Ancak imparatorluk yönetiminin içyüzünü görünce istifa etti. 1950’de yayımladığı Shooting an Elephant (Bir Fili Vurmak) adlı kitabı, sömürge memurlarının davranışlarını eleştiren makalelerin derlemesidir. İkinci Dünya Savaşı’nın sonlarına doğru yazdığı Hayvan Çiftliği, Stalin rejimine karşı sert bir taşlamadır. Orwell’in en çok tanınan yapıtlarından Bin Dokuz Yüz Seksen Dört, bilimkurgu türünün klasik örneklerinden biri olmanın yanı sıra, modern dünyayı protesto eden bir romandır. Burma Günleri ise, Orwell’in Burma’daki (bugünkü Myanmar) İngiliz sömürgeciliğini dile getirdiği ilk kitabıdır. Orwell 1950’de Londra’da öldü.',''),
('Yaşar Kemal','Yaşar Kemal, asıl adı Kemal Sadık Gökçeli. Van Gölü’ne yakın Ernis (bugün Ünseli) köyünden olan ailesinin Birinci Dünya Savaşı’ndaki Rus işgali yüzünden uzun bir göç süreci sonunda yerleştiği Osmaniye’nin Kadirli ilçesine bağlı Hemite köyünde 1926’da doğdu. Doğum yılı bazı biyografilerde 1923 olarak geçer. Ortaokulu son sınıf öğrencisiyken terk ettikten sonra ırgat kâtipliği, ırgatbaşılık, öğretmen vekilliği, kütüphane memurluğu, traktör sürücülüğü, çeltik tarlalarında kontrolörlük yaptı. 1940’lı yılların başlarında Pertev Naili Boratav, Abidin Dino ve Arif Dino gibi sol eğilimli sanatçı ve yazarlarla ilişki kurdu; 17 yaşındayken siyasi nedenlerle ilk tutukluluk deneyimini yaşadı. 1943’te bir folklor derlemesi olan ilk kitabı Ağıtlar’ı yayımladı. Askerliğini yaptıktan sonra 1946’da gittiği İstanbul’da Fransızlara ait Havagazı Şirketi’nde gaz kontrol memuru olarak çalıştı. 1948’de Kadirli’ye döndü, bir süre yine çeltik tarlalarında kontrolörlük, daha sonra arzuhalcilik yaptı. 1950’de Komünizm propagandası yaptığı iddiasıyla tutuklandı, Kozan cezaevinde yattı. 1951’de salıverildikten sonra İstanbul’a gitti, 1951-63 arasında Cumhuriyet gazetesinde Yaşar Kemal imzası ile fıkra ve röportaj yazarı olarak çalıştı. Bu arada 1952’de ilk öykü kitabı Sarı Sıcak’ı, 1955’te ise bugüne dek kırktan fazla dile çevrilen romanı İnce Memed’i yayımladı. 1962’de girdiği Türkiye İşçi Partisi’nde genel yönetim kurulu üyeliği, merkez yürütme kurulu üyeliği görevlerinde bulundu. Yazıları ve siyasi etkinlikleri dolayısıyla birçok kez kovuşturmaya uğradı. 1967’de haftalık siyasi dergi Ant’ın kurucuları arasında yer aldı. 1973’te Türkiye Yazarlar Sendikası’nın kuruluşuna katıldı ve 1974-75 arasında ilk genel başkanlığını üstlendi. 1988’de kurulan PEN Yazarlar Derneği’nin de ilk başkanı oldu. 1995’te Der Spiegel’deki bir yazısı nedeniyle İstanbul Devlet Güvenlik Mahkemesi’nde yargılandı, aklandı. Aynı yıl bu kez Index on Censorhip’teki yazısı nedeniyle 1 yıl 8 ay hapis cezasına mahkûm edildiyse de cezası ertelendi. Şaşırtıcı imgelemi, insan ruhunun derinliklerini kavrayışı, anlatımının şiirselliğiyle yalnızca Türk romanının değil dünya edebiyatının da önde gelen isimlerinden biri olan Yaşar Kemal’in yapıtları kırkı aşkın dile çevrilmiştir. Yaşar Kemal, Türkiye’de aldığı çok sayıda ödülün yanı sıra yurtdışında aralarında Uluslararası Cino del Duca ödülü, Légion d’Honneur nişanı Commandeur payesi, Fransız Kültür Bakanlığı Commandeur des Arts et des Lettres nişanı, Premi Internacional Catalunya, Fransa Cumhuriyeti tarafından Légion d’Honneur Grand Officier rütbesi, Alman Kitapçılar Birliği Frankfurt Kitap Fuarı Barış Ödülü’nün de bulunduğu yirmiyi aşkın ödül, ikisi yurtdışında beşi Türkiye’de olmak üzere, yedi fahri doktorluk payesi aldı. 28 Şubat 2015 tarihinde vefat etti.',''),
('Lev N. Tolstoy','Lev Tolstoy, 1828 yılında doğdu. Toprak sahibi, soylu bir ailenin oğluydu. Çocuk yaşta anne ve babası öldüğü için, akrabaları tarafından yetiştirildi. 16 yaşında Rusya’daki Kazan Üniversitesi’ne girdi ama bir süre sonra, resmi eğitime duyduğu tepki nedeniyle oradan ayrıldı ve topraklarını yöneterek kendi kendini eğitmeye karar verdi. 1862 yılında Sofya Andreyevna Bers ile evlendi, on üç çocuğu oldu. Tolstoy, Shakespeare den sonra dünya dillerine en çok tercümesi yapılan yazardır.Yirminci yüzyılın en önemli ahlakçı yazarlarından Lev Tolstoy, 1910 yılında, ıssız bir tren istasyonunda, zatürreden öldü.','');

-- KONULAR
insert into tblkonu(ad) values
('Anı'),('Belgesel Roman'),('Çizgi Roman'),('Günlük'),('Polisiye'),('Roman'),('Şiir');

-- KİTAPLAR
insert into tblkitap(ad,sayfasayisi,yayinevi,basimsayisi,basimyili,konuid)
values 
('Bir Ömür Nasıl Yaşanır? Hayatta Doğru Seçimler İçin Öneriler',288,'KRONİK KİTAP',3,2021,1),
('Cumhuriyet’in İlk Sabahı',120,'KRONİK KİTAP',1,2023,3),
('Osmanlı İmparatorluğu’nda Alman Nüfuzu',240,'KRONİK KİTAP',4,2020,2),
('Cumhuriyet’in Doğuşu Kurtuluş ve Kuruluş Yılları',304,'KRONİK KİTAP',2,2023,6),
('Türklerin Tarihi Orta Asya’nın Bozkırlarından Avrupa’nın Kapılarına',272,'KRONİK KİTAP',5,2020,2),
('Gazi Mustafa Kemal Atatürk',480,'KRONİK KİTAP',10,2020,2),
('Türkiye’nin Yakın Tarihi',256,'KRONİK KİTAP',1,2018,6),
('İstanbul’dan Sayfalar',304,'KRONİK KİTAP',3,2019,4),
('Hukuk ve İdare Adamı Olarak Osmanlı Devleti nde Kadı',112,'KRONİK KİTAP',1,2020,6),
('Osmanlı Toplumunda Aile',240,'KRONİK KİTAP',2,2020,2),
('Zamanı Durdurmanın Yolları',328,'DOMİNGO YAYINEVİ',12,2018,6),
('Rahatlama Kitabı Suyun Üstünde Kalmamı Sağlayan Düşünceler',272,'DOMİNGO YAYINEVİ',4,2022,4),
('Yaşama Tutunmak İçin Nedenler',264,'DOMİNGO YAYINEVİ',5,2023,3),
('Nevrotik Bir Gezegenden Notlar',320,'DOMİNGO YAYINEVİ',7,2022,2),
('Doğruluk Perisi Okula Gidiyor',128,'YAPI KREDİ YAYINLARI',3,2022,3),
('Gece Yarısı Kütüphanesi',283,'DOMİNGO YAYINEVİ',8,2022,5),
('İnsanlar',296,'DOMİNGO YAYINEVİ',8,2022,1),
('Doğruluk Perisi',124,'YAPI KREDİ YAYINLARI',15,2021,3),
('Nikolas Noel Adında Bir Çocuk',256,'ORMAN KİTAP',6,2021,3),
('Nohut Adam',64,'TİMAŞ ÇOCUK YAYINLARI',3,2023,4),
('Başarısızlar Kulübü',160,' TİMAŞ İLK GENÇ',2,2022,4),
('Mükemmeller Kulübü',128,'TİMAŞ İLK GENÇ',1,2023,4),
('Büyük Dostum',25,'TİMAŞ İLK GENÇ',2,2022,4),
('Melodi',64,'TİMAŞ ÇOCUK YAYINLARI',1,2023,4),
('Balino',64,'TİMAŞ ÇOCUK YAYINLARI',2,2023,4),
('Çekilin Ben Okurum',104,'DOĞAN ÇOCUK',2,2022,4),
('Hayta',128,'TİMAŞ İLK GENÇ',1,2023,4),
('Çekilin, Ben Yazarım!',104,'DOĞAN ÇOCUK',1,2023,4),
('Bin Dokuz Yüz Seksen Dört - 1984',296,'KAPRA YAYINCILIK',4,2021,2),
('Hayvan Çiftliği',96, 'KAPRA YAYINCILIK',2,2021,3),
('Kitaplar ve Sigaralar',111,'KAPRA YAYINCILIK',1,2021,6),
('Papazın Kızı',295,'KAPRA YAYINCILIK',3,2021,1),
('Boğulmamak İçin',232,'KAPRA YAYINCILIK',4,2021,5),
('Paris ve Londra’da Beş Parasız',208,'KAPRA YAYINCILIK',3,2021,3),
('Aspidistra',272,'KAPRA YAYINCILIK',2,2021,1),
('Balinanın Karnında',144,'KAPRA YAYINCILIK',3,2021,4),
('Burma Günleri',324,'KAPRA YAYINCILIK',2,2021,3),
('Katalonya’ya Selam',248,'KAPRA YAYINCILIK',3,2021,2),
('itiraflarım',88,'Kapra Yayıncılık',3,2020,6),
('diriliş',234,'Kapra Yayıncılık',3,2021,6),
('Anna Karanina',384,'Can Yayınları',2,2019,6),
('Hacı Murat',152,'Kapra Yayıncılık',3,2021,6),
('Hacı Murat',152,'Kapra Yayıncılık',4,2021,6),
('Erik Çekirdeği',72,'Can Cocuk Yayınları',5,2018,6),
('Insan ne ile yaşar ?',48,'Karbon Kitap',4,2020,6),
('Ivan Ilyic in Olümü',88,'Karbon Kitaplar',2,2022,6),
('Cocukluk',128,'Kapra yayıncılık',1,2023,6),
('Seytan',80,'kapra Yayıncılık',2,2021,6),
('Baldaki Tuz',424,'Yapı Kredi Yayınları',10,2021,3),
('Yılanı Öldürseler',102,'Yapı Kredi Yayınları',7,202,4),
('Filler Sultanı ile Kırmızı Sakallı Topal Karınca',208,'Yapı Kredi Yayınları',9,2022,3),
('Kuşlar Da Gitti',79,'Adam Yayıncılık',5,2001,5),
('Ağrıdağı Efsanesi',120,'Adam Yayıncılık',4,2001,3),
('Binbir Çiçekli Bahçe',294,'Yapı Kredi Yayınları',17,20019,4),
('İnce Memed 1',436,'Yapı Kredi Yayınları',8,20021,3),
('İnce Memed 2',459,'Yapı Kredi Yayınları',11,20019,3),
('İnce Memed 3',639,'Yapı Kredi Yayınları',13,20019,3),
('İnce Memed 4',629,'Yapı Kredi Yayınları',7,2020,3),
('İnce Memed 5',639,'Yapı Kredi Yayınları',13,20019,3);

-- KİTAP YAZAR İLİŞKİLERİ
insert into tblyazarkitap(yazarid, kitapid)
values (4,20),(4,12),(4,13),(4,14),(4,15),(4,16),(4,17),(4,18),(4,19),     -- Matt Haig
		(5,29),(5,21),(5,22),(5,23),(5,24),(5,25),(5,26),(5,27),(5,28),    -- Anıl Basılı
		(6,11),(6,2),(6,3),(6,4),(6,5),(6,6),(6,7),(6,8),(6,9),(6,10),    -- İlber Ortaylı
		(7,39),(7,30),(7,31),(7,32),(7,33),(7,34),(7,35),(7,36),(7,37),(7,38),    -- George Orwell
		(8,58),(8,59),(8,50),(8,51),(8,52),(8,53),(8,54),(8,55),(8,56),(8,57),    -- Yaşar Kemal
		(9,49),(9,40),(9,41),(9,42),(9,43),(9,44),(9,45),(9,46),(9,47),(9,48);   -- Lev N. Tolstoy

-- YAZAR KONU İLİŞKİLERİ
insert into tblyazarkonu(yazarid,konuid) values
(4,1),(4,2),(4,3),(4,4),(4,5),(4,6), -- 1,2,3,4,5,6
(5,4), -- 4
(6,1),(6,2),(6,3),(6,4),(6,6),  --1,2,3,4,6
(7,1),(7,2),(7,3),(7,4),(7,5),(7,6), -- 1,2,3,4,5,6
(8,3),(8,4),(8,5), -- 3,4,5
(9,6); -- 6

-----------------------------------------
-----------------------------------------
-- bir yazarın kitaplarını listeleyin.
select ad from tblyazar where id = 9

select tblyazar.ad as yazar_adi, tblkitap.ad as kitap_adi from tblyazar
left join tblyazarkitap on tblyazar.id = tblyazarkitap.yazarid
left join tblkitap on tblyazarkitap.kitapid = tblkitap.id
where tblyazar.id = 9

-----------------------
-- id si 37 olan kitabın yazarı kimdir? join ile bulunuz
select * from tblkitap where id = 37

select tblkitap.ad as kitap, tblyazar.ad as yazar from tblkitap
left join tblyazarkitap on tblkitap.id=tblyazarkitap.kitapid
left join tblyazar on tblyazar.id = tblyazarkitap.yazarid
where tblkitap.id = 37

-----------
--- hangi yazarların bizde kitabı bulunmamaktadır?
select * from tblyazar
insert into tblyazar(ad) values 
('Ayfer Tunç'), ('Doğan Cüceloğlu'), ('Prof. Dr. İskender Pala')
-------------
--
select * from tblyazar
left join tblyazarkitap on tblyazarkitap.yazarid = tblyazar.id
where tblyazarkitap.id is null

-------------
select * from tblkitap 
insert into tblkitap(ad) values 
('Test Kitap-3'), ('Test Kitap-4'), ('Test Kitap-5'), ('Test Kitap-6')
-- yazar bilgisi olmayan kitaplar.
select * from tblkitap
left join tblyazarkitap on tblyazarkitap.kitapid = tblkitap.id
where tblyazarkitap.id is null
---------------
--- adında i harfi geçen yazarların yazarAdı, kitapAdı şeklinde tablosunu 
--- getiren sorguyu yazınız.

select y.ad as yazar_adi, k.ad as kitap_adi from tblyazar as y
left join tblyazarkitap as yk on yk.yazarid = y.id	
left join tblkitap as k on yk.kitapid = k.id
where y.ad ilike '%i%' or y.ad ilike '%İ%'

-------------------
-- YAZAR - KİTAP
-- Tüm join türlerinin kontrolü
-- yazar öncelikli listeleme (LEFT JOIN) - 64 kayıt - 6 BOŞ
select * from tblyazar as y
left join tblyazarkitap as yk on yk.yazarid = y.id
left join tblkitap as k on yk.kitapid = k.id

-- kitap öncelikli listeleme (RIGHT JOIN) - 65 kayıt - 7 BOŞ
select * from tblyazar as y
left join tblyazarkitap as yk on yk.yazarid = y.id
right join tblkitap as k on yk.kitapid = k.id

select * from tblkitap
-- her yazarın mutlaka bir kitabı ve her kitabın mutlaka bir yazarı 
-- olduğu senaryo
-- mutlaka kitap ve yazarın kesiştiği durumlar (INNER JOIN) - 58 kayıt
select * from tblyazar as y
inner join tblyazarkitap as yk on yk.yazarid = y.id
inner join tblkitap as k on yk.kitapid = k.id

-- arada ilişkinin olup olmadığına bakılmaksızın tüm durumların 
-- gösterildiği senaryo
-- tüm alanlar tüm bağıntıları ile (FULL JOIN) - 71 kayıt
select * from tblyazar as y
full join tblyazarkitap as yk on yk.yazarid = y.id
full join tblkitap as k on yk.kitapid = k.id

---------------------------
-- Yazdığımız SQL sorgularını daha sonra tekrar tüketmek ve 
-- daha karmaşık sorguları okunaklı hale getirmek için VIEW 
-- kullanırız.
----
-- yazarı olmayan kitaplar.
create view vw_yazari_olmayan_kitaplar
as
select k.id, k.ad from tblkitap as k
left join tblyazarkitap as yk on yk.kitapid = k.id
where yk.id is null
---------------

select * from vw_yazari_olmayan_kitaplar
where id > 63
ORDER BY id desc
------------------------------
------------------------------
-- s1- belirli bir yazarın hangi kitapları var?
-- s2- yazarı olmayan kitaplar nelerdir?
-- s3- en çok kitabı olan yazar kimdir?
-- s4- belirlir bir konuda yazılmış kitaplar.
-- s5- en çok kiralama yapan öğretmen kimdir?
-- s6- en çok kiralama yapan okul hangisidir?
-- s7- en çok kiralanan kitap hangisidir?
-- s8- belirli bir alanda en çok eser veren yazar ve eser sayısı
-- s9- en çok okunan/kiralanan ilk 3 kitap hangileridir?
-----------









