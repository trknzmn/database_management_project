--VERİ TABANI OLUŞTURMA
create database VTYS
use VTYS

--TABLOLARI OLUŞTURMA VE KEYLERİ TANIMLAMA
create table MainMenu
( MainID int identity (1,1) primary key,
    AnaMenuAdi varchar(50)
);

create table SubMenu
( SubID int identity (1,1) primary key,
AltMenuAdi varchar(50),
AnaMenuID int,
FOREIGN KEY (AnaMenuID) REFERENCES MainMenu(MainID) ON DELETE CASCADE
);

create table Markalar
(MarkaID varchar(10) primary key,
MarkaAdi varchar(50),
MarkaMail varchar(50)
)

create table Urunler
(UrunKodu varchar(10) primary key,
UrunAdi varchar(50),
MarkaID varchar (10),
AltMenuID int,
BirimFiyat int,
Stok int,
FOREIGN KEY (AltMenuID) REFERENCES SubMenu(SubID) ON DELETE CASCADE,
FOREIGN KEY (MarkaID) REFERENCES Markalar(MarkaID) ON DELETE CASCADE
);

create table Musteriler
(MusteriID int identity (1,1) primary key,
MusteriSifre varchar(10),
MusteriAdi varchar(50),
MusteriSoyadi varchar(50),
MusteriTelNo int,
MusteriAdres varchar(100),
)

create table MusteriArsiv
(ArsivID int identity (1,1) primary key,
MusteriAdi varchar(50),
MusteriSoyadi varchar(50),
MusteriTelNo int,
SilmeTarihi datetime,
)

create table Favoriler
(FavoriID varchar(10) primary key,
MusteriID int,
UrunID varchar(10),
FOREIGN KEY (MusteriID) REFERENCES Musteriler(MusteriID) ON DELETE CASCADE,
FOREIGN KEY (UrunID) REFERENCES Urunler(UrunKodu) ON DELETE CASCADE
)

create table Yorumlar
(YorumID varchar(10) primary key,
MusteriID int,
UrunID varchar(10),
YorumMetni varchar(100),
Puan int,
FOREIGN KEY (MusteriID) REFERENCES Musteriler(MusteriID) ON DELETE CASCADE,
FOREIGN KEY (UrunID) REFERENCES Urunler(UrunKodu) ON DELETE CASCADE
)

create table Siparisler
(SiparisID varchar(10) primary key,
MusteriID int,
ToplamFiyat int,
FOREIGN KEY (MusteriID) REFERENCES Musteriler(MusteriID) ON DELETE CASCADE,
)

create table SiparisDetayi
(DetayID varchar(10) primary key,
SiparisID varchar(10),
UrunID varchar(10),
UrunAdedi int,
FOREIGN KEY (SiparisID) REFERENCES Siparisler(SiparisID) ON DELETE CASCADE,
FOREIGN KEY (UrunID) REFERENCES Urunler(UrunKodu) ON DELETE CASCADE
)

--TABLOLARI VERİ İLE DOLDURMA
INSERT INTO MainMenu (AnaMenuAdi)
VALUES 
    ('Sanat'),
    ('Kırtasiye');

INSERT INTO SubMenu (AltMenuAdi, AnaMenuID)
VALUES 
    ('Boyalar', 1),
    ('Tuvaller', 1),
    ('Kalemler', 2),
    ('Defterler', 2);

INSERT INTO Markalar (MarkaID, MarkaAdi, MarkaMail)
VALUES
    ('M1', 'Çınar Defter', 'cinardefter@gmail.com'),
    ('M2', 'Faber Castel', 'fabercastel@gmail.com'),
    ('M3', 'Gvn Art', 'gvnart@gmail.com');

INSERT INTO Urunler (UrunKodu, UrunAdi, MarkaID, AltMenuID, BirimFiyat, Stok)
VALUES 
    ('U1', 'Akrilik Boya', 'M3', 1, 50, 100),
    ('U2', 'Sulu Boya', 'M3', 1, 40, 100),
    ('U3', 'Profesyonel Tuval', 'M3', 2, 200, 100),
    ('U4', 'Pres Tuval', 'M3', 2, 130, 100),
    ('U5', 'Dolma Kalem', 'M2', 3, 90, 100),
    ('U6', 'Kurşun Kalem','M2', 3, 20, 100),
    ('U7', 'Not Defteri','M1', 4, 100, 100),
    ('U8', 'Müzik Defteri','M1', 4, 120, 100);

INSERT INTO Musteriler(MusteriSifre, MusteriAdi, MusteriSoyadi, MusteriTelNo, MusteriAdres)
VALUES
    (12345, 'Ali', 'Kılıç', 50001, 'İstanbul, Beyoğlu ilçesi, İstiklal Caddesi, No: 123'),
    (12345, 'Veli', 'Yıldız', 50002, 'Ankara, Çankaya ilçesi, Atatürk Bulvarı, No: 45'),
    (12345, 'Fatma', 'Çelik', 50003, 'İzmir, Konak ilçesi, Cumhuriyet Meydanı, No: 67'),
    (12345, 'Ayşe', 'Öz', 50004, 'Antalya, Muratpaşa ilçesi, Lara Caddesi, No: 21'),
    (12345, 'Pelin', 'Kurt', 50005, 'Bursa, Osmangazi ilçesi, Tophane, No: 8');

INSERT INTO Favoriler (FavoriID, MusteriID, UrunID)
VALUES
    ('F1', 1, 'U7'),
    ('F2', 1, 'U5'),
    ('F3', 3, 'U1');

INSERT INTO Yorumlar (YorumID, MusteriID, UrunID, YorumMetni, Puan)
VALUES
    ('Y1', 1, 'U7', 'Çok kullanışlı ve estetik', 5),
    ('Y2', 2, 'U2', 'Beklediğim gibi değil ama iade etmeyeceğim', 3),
    ('Y3', 3, 'U5', 'Aldığıma pişmanım, kesinlikle iade', 1);

INSERT INTO Siparisler (SiparisID, MusteriID)
VALUES
    ('S1', 1),
    ('S2', 2),
    ('S3', 3),
    ('S4', 5);

INSERT INTO SiparisDetayi (DetayID, SiparisID, UrunID, UrunAdedi)
VALUES
    ('D1', 'S1', 'U7', 2),
    ('D2', 'S2', 'U2', 3),
    ('D3', 'S3', 'U5', 4),
    ('D4', 'S4', 'U1', 5);


--STORED PROCEDURE YARATMA
--Siparisler tablosundaki toplam fiyatı Stored Procedure ile güncelleme
CREATE PROCEDURE ToplamGuncelleme
    @SiparisID NVARCHAR(50)
AS
BEGIN
    -- SiparisID parametresini kullanarak toplam fiyatı güncelle
    UPDATE Siparisler
    SET ToplamFiyat = (
        SELECT SUM(Urunler.BirimFiyat * SiparisDetayi.UrunAdedi)
        FROM SiparisDetayi
        INNER JOIN Urunler ON SiparisDetayi.UrunID = Urunler.UrunKodu
        WHERE SiparisDetayi.SiparisID = @SiparisID
    )
    WHERE SiparisID = @SiparisID;
END;

EXECUTE ToplamGuncelleme 'S1'
EXECUTE ToplamGuncelleme 'S2'
EXECUTE ToplamGuncelleme 'S3'
EXECUTE ToplamGuncelleme 'S4'

SELECT * FROM Siparisler

--VERİ EKLEME, GÜNCELLEME VE SİLME İŞLEMLERİ

INSERT INTO Markalar (MarkaID, MarkaAdi, MarkaMail)
VALUES('M4', 'Stabilo', 'stabilo@gmail.com')

ALTER TABLE Markalar
ADD MarkaTel varchar (20)

UPDATE Markalar
SET MarkaTel='1234567890'
WHERE MarkaID='M4';

ALTER TABLE Markalar
DROP COLUMN MarkaTel;

SELECT * FROM Markalar

DELETE FROM Markalar
WHERE MarkaID = 'M4';


--VIEW OLUŞTURMA
--Birim fiyatı 50'den büyük olan ürünlerin listesi
CREATE VIEW BirimBuyuk50
AS
SELECT Urunler.UrunAdi, Urunler.BirimFiyat from Urunler
WHERE BirimFiyat>50;

SELECT * FROM BirimBuyuk50

--VIEW OLUŞTURMA2
--4. alt kategoriye ait ürünleri ve bu ürünlerin stok durumunu listeleme
CREATE VIEW SubStok
AS
SELECT Urunler.UrunAdi, Urunler.Stok, Urunler.AltMenuID, SubMenu.AltMenuAdi
FROM Urunler
INNER JOIN SubMenu ON Urunler.AltMenuID = SubMenu.SubID
WHERE SubMenu.SubID = 4;

SELECT * FROM SubStok

--ÖRNEK BAZI SQL SORGULARI


--Belirli bir müşterinin favori ürünlerinin detaylarını listeleme
SELECT Urunler.UrunKodu, Urunler.UrunAdi, Urunler.BirimFiyat, Urunler.Stok, Markalar.MarkaAdi
FROM Favoriler
JOIN Musteriler ON Favoriler.MusteriID = Musteriler.MusteriID
JOIN Urunler ON Favoriler.UrunID = Urunler.UrunKodu
JOIN Markalar ON Urunler.MarkaID = Markalar.MarkaID
WHERE Musteriler.MusteriAdi = 'Ali' AND Musteriler.MusteriSoyadi = 'Kılıç';

--5 puana sahip ürünleri ve bu ürünlere yapılan yorumları listeleme
SELECT Urunler.UrunKodu, Urunler.UrunAdi, Yorumlar.YorumMetni, Yorumlar.Puan
FROM Yorumlar
JOIN Urunler ON Yorumlar.UrunID = Urunler.UrunKodu
WHERE Yorumlar.Puan = 5;

--Hangi ürünlerin kaçar adet satıldığını ve bu satışlardan ne kadar kazanç elde edildiğini listeleme
SELECT 
    Urunler.UrunKodu, 
    Urunler.UrunAdi, 
    SUM(SiparisDetayi.UrunAdedi) AS ToplamAdet, 
    SUM(SiparisDetayi.UrunAdedi * Urunler.BirimFiyat) AS ToplamKazanc
FROM 
    SiparisDetayi
JOIN 
    Urunler ON SiparisDetayi.UrunID = Urunler.UrunKodu
GROUP BY 
    Urunler.UrunKodu, Urunler.UrunAdi;

--TRIGGER OLUŞTURMA
--1. Müşteriler tablosundan silinen kişiyi Müşteri Arşiv tablosuna ekleme
CREATE TRIGGER SilinenMusteri ON Musteriler
AFTER DELETE
AS BEGIN
    INSERT INTO MusteriArsiv (MusteriAdi, MusteriSoyadi, MusteriTelNo, SilmeTarihi)
    SELECT MusteriAdi, MusteriSoyadi, MusteriTelNo, GETDATE()
    FROM DELETED;
END;

--Triggerı Çalıştırma
INSERT INTO Musteriler(MusteriAdi, MusteriSoyadi)
VALUES ('Deniz', 'Gören')

DELETE FROM Musteriler
WHERE MusteriAdi = 'Deniz' AND MusteriSoyadi = 'Gören';

SELECT * FROM MusteriArsiv

--2. Yeni bir sipariş girildiğinde Ürünler tablosundaki stok sayısını değiştirme
CREATE TRIGGER StokGuncelleme
ON SiparisDetayi
AFTER INSERT
AS
BEGIN
    -- Eklenecek ürünleri kontrol et ve stokları güncelle
    UPDATE U
    SET U.Stok = U.Stok - I.UrunAdedi
    FROM Urunler U
    INNER JOIN inserted I ON U.UrunKodu = I.UrunID
    WHERE U.Stok >= I.UrunAdedi;

    -- Stok yetersiz olan ürünler için hata mesajı gönder
    IF EXISTS (
        SELECT 1
        FROM inserted I
        LEFT JOIN Urunler U ON U.UrunKodu = I.UrunID
        WHERE U.Stok < I.UrunAdedi
    )
    BEGIN
        RAISERROR('Stok yetersiz! Bazı ürünler için sipariş alınamadı.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;


--YENİ MÜŞTERİ VE SİPARİŞ EKLEYEREK STOKGUNCELLEME TRIGGERINI TEST ETME
--Baştaki stok durumunu görüntüleme
SELECT * FROM Urunler
WHERE UrunKodu='U1'

--Müşteri tablosuna kişiyi ekleme
INSERT INTO musteriler (MusteriAdi, MusteriSoyadi, MusteriTelNo, MusteriAdres)
VALUES ('Elif', 'Sözen', 9000, 'Serdivan ilçesi Sakarya')

--Son eklenenlerden MusteriID alma
DECLARE @musteri_id INT;
SET @musteri_id = SCOPE_IDENTITY();

--Siparişler tablosuna ekleme
INSERT INTO siparisler (MusteriID, SiparisID)
VALUES (@musteri_id, 'S5');

--Sipariş detaylarını ekleme
INSERT INTO SiparisDetayi (DetayID, SiparisID, UrunID, UrunAdedi)
VALUES ('D5','S5', 'U1', 2);

--SP ile siparişler tablosunda toplam fiyatı doldurma
EXECUTE ToplamGuncelleme 'S5'

--Trigger testinin başarılı olup olmadığını görmek için sorgu

SELECT * FROM Urunler
WHERE UrunKodu='U1'


--3. Yorumlara ekleme yapılırken puanın 5'ten büyük olmamasını sağlama
CREATE TRIGGER PuanKontrol
ON Yorumlar
AFTER INSERT
AS
BEGIN
    -- Eklenen satırın puan değerini kontrol et
    IF EXISTS (SELECT 1 FROM inserted WHERE Puan > 5)
    BEGIN
        -- Hata mesajı göster ve işlemi geri al
        RAISERROR('Puan değeri 5ten büyük olamaz!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;

INSERT INTO Yorumlar(YorumID, Puan)
VALUES('Y5', 7)