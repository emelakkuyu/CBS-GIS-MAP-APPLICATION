�ZET
Ana katman ve y�zey katmanlardan olu�an bir harita uygulamas�nda veri ekleme, editleme, bilgi g�sterme, harita da konum g�sterme ve sorgulama i�lemleri sa�lanm��t�r.
 
Openlayers kullan�larak web �zerinde �al��an bir harita uygulamas� geli�tirilmi�tir.
Uygulama, kullan�c�yla harita �zerinde etkile�imde bulunan �e�itli etkinlikler i�erir.
Uygulama kullan�c�lar�n�n amac� harita �zerinde il�e ve yer operasyonlar�n� kolayl�kla yapabilir.

PROJE DETAYLARI
Ana katman, "Aerial Map With Labels" d�r ve ilk olarak T�rkiye�de a��ld�. Ana katman i�in Bing Maps API kullan�l�r.
Vekt�r katman� ayr�ca �izim b�lgeleri ve nokta yerleri i�in de kullan�l�r. Bu iki katman haritada g�sterilir.
Semtler �okgen tipinde �izildikten sonra WKT (Well Know Text) format�na d�n��t�r�l�r. 
Ayr�ca yerler, Point cinsinden i�aretlendikten sonra WKT format�na d�n��t�r�l�r.

Harita �zerinde �izim veya i�aretleme i�lemi ger�ekle�tirildikten sonra, kullan�c�n�n bilgi girmesi i�in Popup a��l�r.
Kullan�c�lar�n bilgi giri�i, �izim tipine g�re de�i�ir. Haritaya bir yer eklenmesi ko�ulu, bir b�lge koordinat�nda bulunmas� gerekti�idir. 
Popup her a��ld���nda, kay�tl� b�lgeler ve yerler Ajax �zerinden veritaban�ndan al�n�r. Se�me arac� se�ildi�inde kullan�c�lar kay�tl� noktalardan bilgi alabilir.

VER�TABANI
MsSql sunucusu uygulama veritaban�nda kullan�l�r. Veritaban�nda iki tablo, Mahalle ve kap� tablosu vard�r. Her tablo, �e�itli konum bilgileri i�erir. 
Tablolar�n isimleri ve veri t�rleri a�a��da g�sterilmi�tir.
Veritaban� Tablolar� 
 
Tablo Yap�lar� 
 
Mahalle 
Mahalle Ad� - karakter  
Mahalle Kodu � say�sal - unique 
KOORDINATLAR � karakter max 
 
Kap� 
Mahalle Kodu� Say�sal 
Kap� No 
KOORDINATLAR � karakter max 

http://openlayers.org/en/v3.13.1/examples/  