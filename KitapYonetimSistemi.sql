---- Kitap Yönetim Sistemi
-- DB:  Authors - Yazarlar
-- Columns: id, first_name, last_name,birth_date, city
--------
-- DB: Books - Kitaplar
-- Columns: id, name, genre, page, publish_date, author_id(foreign key)
--------
-- DB: Customers - Müşteriler
-- Columns: id, first_name, last_name, city, age, gender, email, phone
--------
-- DB: Orders - Siparişler
-- Columns: id, book_id(foreign key), customer_id(foreign key),
--          date, state(0,1,2....)
---------------------
-- GÖREVLER
-- 1. Tabloların oluşturulması  (20 Dk )
-- -- tüm taboları ilişkileri ile birlikte oluşturum. 20dk
-- 2. Veri Ekleme(update) (17 dk)
-- * yazar tablosuna 4 adet kayıt ekleyin. 3dk
-- * kitaplar tablosuna her yazar için en az 3-5-7 kitap ekleyin. 3dk
-- * müşteriler tabolsuna 50 adet müşteri ekleyiniz. 3dk
-- * siparişler tablosuna her müşteriye 4-5 kayıt gelecek şekilde 8dk
--   ekleme yapınız.
-- İPUCU : mockaroo sitesinden verileri oluşturunuz.
-- 3. Veri Güncelleme(update) (10 dk)
-- * rast gele 2 farklı yazarın doğum tarihlerini güncelleyiniz.
-- * books tablosunda bir kitabın genre(türünü) değiştiriniz.
-- * müşteri tablosunda city null olanların değerini "" olarak güncelleyin.
-- 4. Temel Select komutları (15 dk)
-- * tüm yazarları listeleyin.
-- * kitap tablosundaki tüm kitapları sadece ad,tür, basım yılı şeklinde
--   listeleyin.
-- * müşteri tablosunda ad + soyad, email, phone şeklinde listeleyin.
-- * sipariş tablosundaki tüm kayıtları listeleyin.
-------------
-- 5. Filtreleme ve Koşullar
-- * aynı il de ikamet eden yazarları listeleyin.
-- * 2020(opsiyonel) de yayınlanan kitapları bulunuz
-- * e-posta adresi gmail olan müşterileri listeleyin.
-- * son 1 ayda kiralanan kitapları bulun
-- 6. Join kullanımı
-- * her kitabın yazarının adıyla görüntülenmesini sağlayın
-- * her siparişin; müşteri adı, kitap adı ve tarih şeklinde 
--   görüntülenmesini sağlayın.
-- * bir müşterinin(müşteri adı opsiyonal) verdiği tüm siparişlerin 
--   müşteri adı, kitap adı şeklinde listeleyin.
-- * 2024 yılında verilen siparişlerin müşterilerinin adlarını görüntüleyin
-- 7. Toplama fonksiyonları ve Gruplama
-- * her yazara ait kitap sayısını bulunuz
-- * orders tablosundaki toplam sipariş sayısını bulunuz.
-- * türüne göre kitap sayılarını gruplandırarak listeleyin.
-- * her müşterinin verdiği toplam sipariş miktarlarını yazdırın.
-- 8. Subqueries
-- * En fazla kitap yayınlayan yazarı bulunuz.
-- * ortalama sipariş miktarından fazla olan siparişleri bulunuz.
-- * En yeni yayınlanan kitabın yazarlarını bulunuz.
-- * 3 ten fazla sipariş verilen kitapların listesini bulunuz.
-- 9. Veri Silme (delete)
-- * order tablosunda kiralama adedi 3 ten az olan kitapları  kitap tablosundan siliniz.

select * from books

delete from books where id = 3 -- tek bir kayıt silmek
-- DİKKAT!!! ilişkili olan kayıtları silmek için ilişkisiz olan
-- tablodan başlayarak silme işlemini yaparsınız ya da silme işlemini
-- zorlarsınız.
-- PEKİ DOĞRUSU NEDİR?
-- DB lerden veri silinmez. DB de olan veri pasife çekilir.
-- isActive, isDelete - true/false
delete from orders where id in(
select book_id from orders
group by book_id 
having count(*)<3 and book_id>9
)
delete from books where id in(

select book_id from orders
group by book_id 
having count(*)<3 and book_id>9

)

-- * customer tablosunda adında "ak" or "ir" geçen leri silelim.
-- eğer order tablosunda ilişkileri var ise önce onları silin.
delete from orders where customer_id in (
select id from customers where 
first_name like '%et%' or first_name like '%eh%'
)

delete from customers where 
first_name like '%et%' or first_name like '%eh%'

-- * bir yazara ait tüm kitapları silen kodu yazınız. (!DİKKAT)
-- yine ilk olarak orders tablosunda ilişkilerini siliniz.
delete from orders where book_id in(
select id from books where id in(
select id from  authors where first_name = 'Yaşar'
)
)

delete from books where id in(
select id from  authors where first_name = 'Yaşar'
)
--

-- * belli bir türe ait kitapları silen kodu yazınız.
delete from books where genre = 'Macera'

-- 10. Karma sorgular
-- * belli iki YIL yada AY a ait tüm satışların yazar,müşteri,kitap 
--   adı ile birlikte listeleyin.
select a.first_name as yazar, c.first_name as musteri, b.name from orders as o
left join books as b on o.book_id = b.id
left join authors as a on b.author_id = a.id
left join customers as c on o.customer_id = c.id
where date between '2024-01-01' and '2024-2-10'
-- * en fazla sipariş edilen kitabı ve adedini listeleyin.
select book_id, count(*) from orders group by book_id
order by count(*) desc
limit 1

-- * en çok kitap sipariş eden müşteriyi bulunuz.
select customer_id, count(*) from orders 
group by customer_id
order by count(*) desc
limit 1

-- * kitapları hiç sipariş edilmeyen yazarları bulunuz.
select distinct(concat(a.first_name, ' ',a.last_name))  from books as b 
left join authors as a on a.id = b.author_id
left join orders  as o on o.book_id = b.id
where o.id is null


-- Yazarlar tablosu
create table authors (
    id serial primary key,
    first_name varchar(100),
    last_name varchar(100),
    birth_date date,
    city varchar(100),
    created_at bigint default extract(epoch from now()) * 1000,
    updated_at bigint default extract(epoch from now()) * 1000,
    state int default 1 -- 0: pasif, 1: aktif, 2: silinmiş
);

-- Kitaplar tablosu 
create table books (
    id serial primary key,
    name varchar(200),
    genre varchar(100),
    page int,
    publish_date date,
    author_id int references authors(id),
    created_at bigint default extract(epoch from now()) * 1000,
    updated_at bigint default extract(epoch from now()) * 1000,
    state int default 1
);

-- Müşteriler tablosu
create table customers (
    id serial primary key,
    first_name varchar(100),
    last_name varchar(100), 
    city varchar(100),
    age int,
    gender varchar(20),
    email varchar(200),
    phone varchar(20),
    created_at bigint default extract(epoch from now()) * 1000,
    updated_at bigint default extract(epoch from now()) * 1000,
    state int default 1
);

-- Siparişler tablosu
create table orders (
    id serial primary key,
    book_id int references books(id),
    customer_id int references customers(id),
    date date default current_date,
    state int default 0, -- 0: beklemede, 1: onaylandı, 2: tamamlandı, 3: iptal edildi
    created_at bigint default extract(epoch from now()) * 1000,
    updated_at bigint default extract(epoch from now()) * 1000
);


-- Yazarlar ekleme
INSERT INTO authors (first_name, last_name, birth_date, city) VALUES
('Orhan', 'Pamuk', '1952-06-07', 'İstanbul'),
('Yaşar', 'Kemal', '1923-10-06', 'Adana'),
('Sabahattin', 'Ali', '1907-02-25', 'Kırklareli'),
('Elif', 'Şafak', '1971-10-25', 'Strasbourg');

-- Kitaplar ekleme
INSERT INTO books (name, genre, page, publish_date, author_id) VALUES
-- Orhan Pamuk'un kitapları
('Kar', 'Roman', 474, '2002-01-01', 1),
('Benim Adım Kırmızı', 'Roman', 472, '1998-01-01', 1),
('Masumiyet Müzesi', 'Roman', 592, '2008-01-01', 1),

-- Yaşar Kemal'in kitapları
('İnce Memed', 'Roman', 427, '1955-01-01', 2),
('Yer Demir Gök Bakır', 'Roman', 348, '1963-01-01', 2),
('Demirciler Çarşısı Cinayeti', 'Roman', 280, '1974-01-01', 2),

-- Sabahattin Ali'nin kitapları
('Kürk Mantolu Madonna', 'Roman', 160, '1943-01-01', 3),
('İçimizdeki Şeytan', 'Roman', 254, '1940-01-01', 3),
('Kuyucaklı Yusuf', 'Roman', 220, '1937-01-01', 3),

-- Elif Şafak'ın kitapları
('Aşk', 'Roman', 420, '2009-01-01', 4),
('Mahrem', 'Roman', 216, '2000-01-01', 4),
('İskender', 'Roman', 443, '2011-01-01', 4);

-- Müşteriler ekleme (örnek olarak ilk 5 kayıt)
INSERT INTO customers (first_name, last_name, city, age, gender, email, phone) VALUES
('Ahmet', 'Yılmaz', 'İstanbul', 35, 'Erkek', 'ahmet.yilmaz@gmail.com', '5551112233'),
('Ayşe', 'Demir', 'Ankara', 28, 'Kadın', 'ayse.demir@gmail.com', '5552223344'),
('Mehmet', 'Kaya', 'İzmir', 42, 'Erkek', 'mehmet.kaya@gmail.com', '5553334455'),
('Fatma', 'Çelik', 'Bursa', 31, 'Kadın', 'fatma.celik@gmail.com', '5554445566'),
('Ali', 'Öztürk', 'Antalya', 29, 'Erkek', 'ali.ozturk@gmail.com', '5555556677');
-- ... (Geri kalan 45 müşteri için benzer kayıtlar eklenecek)

-- Siparişler ekleme (örnek olarak ilk 2 müşteri için)
INSERT INTO orders (book_id, customer_id, date, state) VALUES
-- 1. müşteri için siparişler
(1, 1, '2024-01-15', 1),
(3, 1, '2024-02-01', 1),
(5, 1, '2024-02-15', 1),
(7, 1, '2024-03-01', 1),

-- 2. müşteri için siparişler
(2, 2, '2024-01-20', 1),
(4, 2, '2024-02-05', 1),
(6, 2, '2024-02-20', 1),
(8, 2, '2024-03-05', 1),
(10, 2, '2024-03-10', 1);
-- ... (Diğer müşteriler için benzer kayıtlar eklenecek)

select a.first_name, b.name, c.first_name from authors as a
left join books as b on b.author_id = a.id
left join orders as o on o.book_id = b.id
left join customers as c on c.id = o.customer_id










