<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="WebApplication5.WebForm1" %>


<!DOCTYPE html>
<html>
<head>
    <title>Map Application</title>

    <link rel="stylesheet" href="https://openlayers.org/en/v4.6.5/css/ol.css" type="text/css">
    <script src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL"></script>
    <script src="https://openlayers.org/en/v4.6.5/build/ol.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <style>
        .ol-popup {
            position: absolute;
            background-color:plum;
            -webkit-filter: drop-shadow(0 1px 4px rgba(0,0,0,0.2));
            filter: drop-shadow(0 1px 4px rgba(0,0,0,0.2));
            padding: 15px;
            border-radius: 10px;
            border: 1px solid #cccccc;
            bottom: 12px;
            left: -50px;
            min-width: 280px;

        }

            .ol-popup:after, .ol-popup:before {
                top: 100%;
                border: solid transparent;
                content: " ";
                height: 0;
                width: 0;
                position: absolute;
                pointer-events: none;
            }

            .ol-popup:after {
                border-top-color: white;
                border-width: 10px;
                left: 48px;
                margin-left: -10px;
            }

            .ol-popup:before {
                border-top-color: #cccccc;
                border-width: 11px;
                left: 48px;
                margin-left: -11px;
            }

        .ol-popup-closer {
            text-decoration: none;
            position: absolute;
            top: 2px;
            right: 8px;
        }

         .ol-popup-closer:after {
            content: "✖";
            }
    </style>
</head>
<body>
     <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.12.1/bootstrap-table.min.css">
    <script src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.12.1/bootstrap-table.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.12.1/locale/bootstrap-table-zh-CN.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/jspanel4@4.0.0/dist/jspanel.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/jspanel4@4.0.0/dist/jspanel.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jspanel4@4.0.0/dist/extensions/modal/jspanel.modal.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jspanel4@4.0.0/dist/extensions/tooltip/jspanel.tooltip.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jspanel4@4.0.0/dist/extensions/hint/jspanel.hint.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jspanel4@4.0.0/dist/extensions/layout/jspanel.layout.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jspanel4@4.0.0/dist/extensions/contextmenu/jspanel.contextmenu.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jspanel4@4.0.0/dist/extensions/dock/jspanel.dock.js"></script>
    <div id="map" class="map"></div>
    <div id="coords"></div>
    <div id="popup" class="ol-popup">
        <a href="#" id="popup-closer" class="ol-popup-closer"></a>
        <div id="popup-content">
        </div>
    </div>
    <form id="options-form" automplete="off">
        <table class="table">
            <tbody>
                <tr>
                    <th scope="row"><input type="button" value="SEARCH" id="searchButton" /></th> <%--mahalle ve kapıları arama butonu--%>
                     <th scope="row"><input type="button" value="SELECT" id="selectButton" /></th> <%--seçilen mahalle ve kapı bilgilerini gösteren buton--%>
                    
                </tr>
            </tbody>
        </table>
    </form>


    <form class="form-inline">

        <label>Geometry type &nbsp;</label>
        <select id="type">
            <option value="Point">Point</option><%--//kapı--%>
            <option value="LineString">LineString</option>
            <option value="Polygon">Polygon</option><%--//mahalle--%>
           <option selected value="null">null</option>
        </select>
    </form>
    <script>
        var container = document.getElementById('popup');
        var content = document.getElementById('popup-content');
        var closer = document.getElementById('popup-closer');
        var optionsForm = document.getElementById('options-form');
        var lastClick = false;
        var vectorDistrict = null;
        var selectedObj = null;
        var districtCode = 0;
        var statusPop = null;
        var selectedFeatureID = 0;
        var wktCoordinate;
        var featureID = 0;
        var showPop = false;
        var urlDistrict = "/Handler1.ashx?f=GetDistricts";
        var urlPlace = "/Handler1.ashx?f=GetPlaces";
        var districtArray = [];
        var lastfea = null;

        $.ajax({ //Mahalle Tablosundaki verileri çekme
            url: urlDistrict,
            success: function (result) {
                var sonuc = JSON.parse(result);
                var format = new ol.format.WKT();//Vektör geometri objelerini harita üzerinde görüntüleyebilmekiçin kullanılan metin işaretleme dilidir. 
                districtCode = sonuc.length;
                for (var i = 0; i < sonuc.length; i++) {
                    var feature = format.readFeature(sonuc[i].Koordinatlar, {
                        dataProjection: 'EPSG:4326',
                        featureProjection: 'EPSG:3857'
                    });
                    feature.set('Mahalle_Adi', sonuc[i].Mahalle_Adi);
                    
                    feature.set('Mahalle_kodu', sonuc[i].Mahalle_kodu);
                    districtArray.push(feature);
                }
            }
        });

        $.ajax({// Kapı Tablosundski verileri çekme
            url: urlPlace,
            success: function (result) {
                var sonuc = JSON.parse(result);
                var format = new ol.format.WKT();
                for (var i = 0; i < sonuc.length; i++) {
                    var feature = format.readFeature(sonuc[i].Koordinatlar, {
                        dataProjection: 'EPSG:4326',
                        featureProjection: 'EPSG:3857'
                    });
                    feature.set('kapi_no', sonuc[i].kapi_no);//kapı tablosundaki kapı no ve mahalle kodunu çeker
                    feature.set('Mahalle_kodu', sonuc[i].Mahalle_kodu);
                    
                    districtArray.push(feature);
                }
                vectorDistrict = new ol.layer.Vector({
                    source: new ol.source.Vector({
                        features: districtArray
                    })
                });
                map.addLayer(vectorDistrict);
            }
        });
        var istanbul = ol.proj.fromLonLat([34.9744, 39.0128]);//harita ilk açıldığında Türkiye görünecektir.  
 
        var view = new ol.View({
            //görünümün başlangıç ​​durumu
            center: istanbul,
            zoom: 6
        });
        var overlay = new ol.Overlay(/** @type {olx.OverlayOptions} */({ //Popup'ı haritaya sabitlemek için bir yer oluşturur
            element: container,
            autoPan: true,
            autoPanAnimation: {
            duration: 250
            }
        }));

         var raster = new ol.layer.Tile({ // Aerial With Labels katmanının eklenmiş bingMaps haritası
            source: new ol.source.BingMaps({
                key: 'AnKlDZi3RroVDKa4dT-96Or6DQD9ZqRNNdTlE3Sz2i919ph-QANW2JI1EmeL357F',//bing maps key
                imagerySet: 'AerialWithLabels'
            })
        });
        var map = new ol.Map({
            layers: [
                raster
            ],
            loadTilesWhileAnimating: true,
            overlays: [overlay],
            target: 'map',
            controls: ol.control.defaults({//yakınlaştırma yapma
                attributionOptions: /** @type {olx.control.AttributionOptions} */ ({
                    collapsible: false
                })
            }),
            view: view
        });
       
         closer.onclick = function () {// Popup gizlemek için bir tıklama işleyici
            if (statusPop == 'district') {//Mahalle eklendiğinde çıkan popup 
                selectedFeatureID = districtCode;
                var features = vector.getSource().getFeatures();
                for (item in features) {
                    var id = features[item].getProperties().DistrictCode;
                    if (id == selectedFeatureID) {
                        vector.getSource().removeFeature(features[item]);
                        districtCode -= 1;
                        break;
                    }
                }
            }
            else if(statusPop == 'place') {// kapı eklendiğinde çıkan popup 
                selectedFeatureID = featureID;
                var features = vector.getSource().getFeatures();
                for (item in features) {
                    var id = features[item].getProperties().id;
                    if (id == selectedFeatureID) {
                        vector.getSource().removeFeature(features[item]);
                        break;
                    }
                }
            }
            hidePopup();
        };
      function hidePopup() {//popup kapatma 
            overlay.setPosition(undefined);
            closer.blur();
            return false;
        }
    
        var vector = new ol.layer.Vector({//
            source: new ol.source.Vector(),
            style: new ol.style.Style({
                fill: new ol.style.Fill({
                    color: 'rgba(255, 255, 255, 0.2)'
                }),
                stroke: new ol.style.Stroke({
                    color: '#ffcc33',
                    width: 2
                }),
                image: new ol.style.Circle({
                    radius: 7,
                    fill: new ol.style.Fill({
                        color: '#ffcc33'
                    })
                })
            })
        });

        var features = new ol.Collection();
        var featureOverlay = new ol.layer.Vector({
            source: new ol.source.Vector({ features: features }),
            style: new ol.style.Style({
                fill: new ol.style.Fill({
                    color: 'rgba(255, 255, 255, 0.2)'
                }),
                stroke: new ol.style.Stroke({
                    color: '#ffcc33',
                    width: 2
                }),
                image: new ol.style.Circle({
                    radius: 7,
                    fill: new ol.style.Fill({
                        color: '#ffcc33'
                    })
                })
            })
        });
        featureOverlay.setMap(map);

        var modify = new ol.interaction.Modify({
            features: features,
            deleteCondition: function (event) {// yeni köşe noktaları aynı pozisyonda çizilebilir
                return ol.events.condition.shiftKeyOnly(event) &&
                    ol.events.condition.singleClick(event);
            }
        });
        map.addInteraction(modify);

        var draw; // global so we can remove it later
        var typeSelect = document.getElementById('type');

        var coords_element = document.getElementById('coords');
        var coords_length = 0;
        addInteraction();

        function addInteraction() {
            var format = new ol.format.WKT();
            draw = new ol.interaction.Draw({
                features: features,
                type: /** @type {ol.geom.GeometryType} */ (typeSelect.value),
                geometryFunction: function (coords, geom) {

                   if (typeSelect.value == "Point") {
                        if (!geom) geom = new ol.geom.Point(null);
                    }
                    if (typeSelect.value == "LineString") {
                        if (!geom) geom = new ol.geom.LineString(null);
                    }
                    if (typeSelect.value == "Polygon") {
                       if (!geom) geom = new ol.geom.Polygon(null);
                    }
                    geom.setCoordinates(coords);

                    if (coords.length !== coords_length) {
                        coords_element.innerHTML = coords;
                        coord = coords;
                        draw.on('drawend', function (e) {//çizme işlemi tamamlandığında

                            var format = new ol.format.WKT();
                            var selFeatureWkt = format.writeGeometry(e.feature.getGeometry(), {
                                dataProjection: 'EPSG:4326',//WGS84 projeksiyonuna sahiptir.
                                featureProjection: 'EPSG:3857'
                            });
                            wktCoordinate = selFeatureWkt;
                        });
                    }              
                    return geom;
                }
            });
            map.addInteraction(draw);
        }
        function writeDatabase() {   //database 
            if (typeSelect.value == "Polygon") {//polygon seçili ise veri tabanına kaydedilcek bilgiler
                var districtName = $("#txtDistrictName").val();
                var url = "/Handler1.ashx?f=AddDistrict&Mahalle_Adi=" + districtName + "&Koordinatlar=" + wktCoordinate + "&Mahalle_kodu=" + districtCode;
                $.ajax({
                    url: url,
                    success: function (result) {
                        alert(result);
                        hidePopup();
                        lastfea.setProperties({
                            'Mahalle_Adi': districtName
                        })
                    }
                });
            }
            if (typeSelect.value == "Point") {//Point seçili ise veri tabanına kaydedilcek bilgiler
                var placeNo = $("#txtPlaceNo").val();
                var url = "/Handler1.ashx?f=AddPlace&kapi_no=" + placeNo + "&Koordinatlar=" + wktCoordinate + "&Mahalle_kodu=" + selectedObj;
                $.ajax({
                    url: url,
                    success: function (result) {
                        alert(result);
                        hidePopup();
                    }
                });
            } 
        }
        map.on('dblclick', function (evt) {//haritaya 2 kez tıklandığında
            if (typeSelect.value == "LineString") {//linesting seçili ise popup açılır ve gelen bilgiler yazılır
                var coordinate = evt.coordinate;
                var hdms = ol.coordinate.toStringHDMS(ol.proj.transform(
                    coordinate, 'EPSG:3857', 'EPSG:4326'));

                content.innerHTML = 'Kapı Ekle <br>' +
                    '<input id="txtPlaceNo" type="text" placeholder="Kapı No"></input><br><center>' +
                    '<input type="button" class="popclass" value="Cancel" onclick="closer.onclick()" />' +//kayıt islemi istenmiyorsa closer fonksiyonuna gönderilir.
                    '<input type="button" class="popclass" value="Save" onclick="writeDatabase();" /><br>' +//save butonu ile bilgiler kaydedilmek için fonksiyona gönderilir.
                    '</code>';
                overlay.setPosition(coordinate);
            } else
            if (typeSelect.value == "Polygon") {//Polygon seçili ise popup açılır ve gelen bilgiler yazılır

                    var coordinate = evt.coordinate;
                    var hdms = ol.coordinate.toStringHDMS(ol.proj.transform(
                        coordinate, 'EPSG:3857', 'EPSG:4326'));

                    content.innerHTML = 'Mahalle Ekle <br>' +
                        '<input id="txtDistrictName" type="text" placeholder="Mahalle Adı"></input><br>' +
                        '<input type="button" value="Cancel" onclick="closer.onclick()" />' +
                        '<input type="button" value="Save" onclick="writeDatabase();" /><br>' +
                        '</code>';
                    overlay.setPosition(coordinate);
            }
        });
        map.on('singleclick', function (evt) {//Haritaya bir kez tıklandığında 
            if (typeSelect.value == "Point" ) {//point seçili ise kapı ekleme işlemi yapılır.
                var coordinate = evt.coordinate;
                var hdms = ol.coordinate.toStringHDMS(ol.proj.transform(
                    coordinate, 'EPSG:3857', 'EPSG:4326'));

                content.innerHTML = 'Kapı Ekle <br>' +
                    '<input id="txtPlaceNo" type="text" placeholder="Kapı No"></input><br>' +
                    '<input type="button" class="popclass" value="Cancel" onclick="closer.onclick()" />' +
                    '<input type="button" class="popclass" value="Save" onclick="writeDatabase();" /><br>' +
                    '</code>';
                overlay.setPosition(coordinate);
            }

        });
        typeSelect.onchange = function () {
            map.removeInteraction(draw);
            addInteraction();
        };
        searchButton.onclick = function () {//arama butonu kapı ve mahalle kodunu ekrana getirerek aramak istenen bilgiler bulunur.
            jsPanel.create({
                theme:       'primary',
                headerTitle: 'Search Place',
                position:    'center-top 0 58',
                contentSize: '500 370',
                content:     "<iframe src='http://localhost:61279/Search.html' width='100%' height='100%'></iframe>",
                callback: function () {
                    this.content.style.padding = '20px';
                }
            });
        }

       
        selectButton.onclick = function () {//seçili olan mahalle veya kapının bilgilerini alert olarak verir.
           
            map.removeInteraction(draw);

            var select = new ol.interaction.Select();
          
            map.addInteraction(select);
            var features = select.getFeatures();

            select.getFeatures().on("add", function (e) {
                var DistrictName = e.element.getProperties().Mahalle_Adi;
                var DistrictCode = e.element.getProperties().Mahalle_kodu;
                var PlaceNo = e.element.getProperties().kapi_no;
                if (DistrictName != undefined)
                    alert("Mahalle Adı:  " + DistrictName + "    Mahale Kodu:  " + DistrictCode);
                else
                    alert( "Kapı No:  "+ PlaceNo  );
                overlay.setPosition(coordinate);
            });
            console.log(select.getFeatures()); 
            console.log(features);
            features.push(feature);
            features.remove(feature);
        };

    </script>
</body>
</html>
