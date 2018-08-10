# CBS-GIS-MAP-APPLICATION
CBS/GIS MAP APPLICATION
ÖZET
Ana katman ve yüzey katmanlardan oluşan bir harita uygulamasında veri ekleme, editleme, bilgi gösterme, harita da konum gösterme ve sorgulama işlemleri sağlanmıştır.
 
Openlayers kullanılarak web üzerinde çalışan bir harita uygulaması geliştirilmiştir.
Uygulama, kullanıcıyla harita üzerinde etkileşimde bulunan çeşitli etkinlikler içerir.
Uygulama kullanıcılarının amacı harita üzerinde ilçe ve yer operasyonlarını kolaylıkla yapabilir.


PROJE DETAYLARI
Ana katman, "Aerial Map With Labels" dır ve ilk olarak Türkiye’de açıldı. Ana katman için Bing Maps API kullanılır.
Vektör katmanı ayrıca çizim bölgeleri ve nokta yerleri için de kullanılır. Bu iki katman haritada gösterilir.
Semtler çokgen tipinde çizildikten sonra WKT (Well Know Text) formatına dönüştürülür. 
Ayrıca yerler, Point cinsinden işaretlendikten sonra WKT formatına dönüştürülür.


Harita üzerinde çizim veya işaretleme işlemi gerçekleştirildikten sonra, kullanıcının bilgi girmesi için Popup açılır.
Kullanıcıların bilgi girişi, çizim tipine göre değişir. Haritaya bir yer eklenmesi koşulu, bir bölge koordinatında bulunması gerektiğidir. 
Popup her açıldığında, kayıtlı bölgeler ve yerler Ajax üzerinden veritabanından alınır. Seçme aracı seçildiğinde kullanıcılar kayıtlı noktalardan bilgi alabilir.

VERİTABANI
MsSql sunucusu uygulama veritabanında kullanılır. Veritabanında iki tablo, Mahalle ve kapı tablosu vardır. Her tablo, çeşitli konum bilgileri içerir. 
Tabloların isimleri ve veri türleri aşağıda gösterilmiştir.
Veritabanı Tabloları 
 
Tablo Yapıları 
 
Mahalle 
Mahalle Adı - karakter  
Mahalle Kodu – sayısal - unique 
KOORDINATLAR – karakter max 
 
Kapı 
Mahalle Kodu– Sayısal 
Kapı No 
KOORDINATLAR – karakter max 

http://openlayers.org/en/v3.13.1/examples/  






