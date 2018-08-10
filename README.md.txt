ÖZET
Ana katman ve yüzey katmanlardan oluþan bir harita uygulamasýnda veri ekleme, editleme, bilgi gösterme, harita da konum gösterme ve sorgulama iþlemleri saðlanmýþtýr.
 
Openlayers kullanýlarak web üzerinde çalýþan bir harita uygulamasý geliþtirilmiþtir.
Uygulama, kullanýcýyla harita üzerinde etkileþimde bulunan çeþitli etkinlikler içerir.
Uygulama kullanýcýlarýnýn amacý harita üzerinde ilçe ve yer operasyonlarýný kolaylýkla yapabilir.

PROJE DETAYLARI
Ana katman, "Aerial Map With Labels" dýr ve ilk olarak Türkiye’de açýldý. Ana katman için Bing Maps API kullanýlýr.
Vektör katmaný ayrýca çizim bölgeleri ve nokta yerleri için de kullanýlýr. Bu iki katman haritada gösterilir.
Semtler çokgen tipinde çizildikten sonra WKT (Well Know Text) formatýna dönüþtürülür. 
Ayrýca yerler, Point cinsinden iþaretlendikten sonra WKT formatýna dönüþtürülür.

Harita üzerinde çizim veya iþaretleme iþlemi gerçekleþtirildikten sonra, kullanýcýnýn bilgi girmesi için Popup açýlýr.
Kullanýcýlarýn bilgi giriþi, çizim tipine göre deðiþir. Haritaya bir yer eklenmesi koþulu, bir bölge koordinatýnda bulunmasý gerektiðidir. 
Popup her açýldýðýnda, kayýtlý bölgeler ve yerler Ajax üzerinden veritabanýndan alýnýr. Seçme aracý seçildiðinde kullanýcýlar kayýtlý noktalardan bilgi alabilir.

VERÝTABANI
MsSql sunucusu uygulama veritabanýnda kullanýlýr. Veritabanýnda iki tablo, Mahalle ve kapý tablosu vardýr. Her tablo, çeþitli konum bilgileri içerir. 
Tablolarýn isimleri ve veri türleri aþaðýda gösterilmiþtir.
Veritabaný Tablolarý 
 
Tablo Yapýlarý 
 
Mahalle 
Mahalle Adý - karakter  
Mahalle Kodu – sayýsal - unique 
KOORDINATLAR – karakter max 
 
Kapý 
Mahalle Kodu– Sayýsal 
Kapý No 
KOORDINATLAR – karakter max 

http://openlayers.org/en/v3.13.1/examples/  