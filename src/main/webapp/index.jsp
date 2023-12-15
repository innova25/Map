<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Google Maps Example</title>
    <style>
        #map {
            display: flex;
            height: 700px;
            width: 80%;
            float: right;
            margin-right: 0px;
            margin-top: 15px;
        }

        #map-overlay {
            position: absolute;
            top: 0;
            left: 0;
            height: 100%;
            width: 100%;
            background-color: rgba(255, 255, 255, 0.7);
            z-index: 1;
        }

        #search-container {
            position: relative;
            top: 0;
            left: 15px;
            z-index: 2;
            float: left;
        }

        #search-container input[type="text"],
        #search-container button {
            padding: 8px;
            font-size: 16px;
        }

        #search-container input[type="text"] {
            margin-right: 10px;
        }

        #search-container button {
            margin-left: 10px;
        }

        .suggestion_container {
            position: absolute;
            top: 100%;
            left: 0;
            width: 100%;
            background-color: #fff;
            border: 1px solid #ccc;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            display: none;
            z-index: 1;
        }

        #search_input:focus + .suggestion_container {
            display: block;
        }

        .suggestion_container .suggestion_item {
            padding: 8px;
            border-bottom: 1px solid #ddd;
            cursor: pointer;
        }
    </style>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDyNLkGVhnKcMxxtDn9yTzjPrXxsqMq08k&callback=initMap" async defer></script>
    <script>
        var map;
        var marker;
        var infoWindow;
        var sourceCoordinates = null;
        var destinationCoordinates = null;

        function initMap() {
            var myLatLng = { lat: 21.031369, lng: 105.832756 };
            map = new google.maps.Map(document.getElementById('map'), {
                zoom: 16,
                center: myLatLng
            });

            marker = new google.maps.Marker({
                position: myLatLng,
                map: map,
                title: 'This is the location!'
            });

            infoWindow = new google.maps.InfoWindow();

            var r = ['21.031916,105.830775|21.031523,105.832145|21.031353,105.832746|21.031002,105.834029|21.031816,105.834199|21.031887,105.834202|21.031994,105.834187|21.034019,105.834596|21.033838,105.835619|21.034974,105.835861|21.034872,105.836461|21.034931,105.836708|21.034876,105.836764|21.034861,105.83685|21.034873,105.836919|21.034921,105.836976|21.035,105.836997|21.035052,105.836996|21.035615,105.837964|21.035705,105.838031'];
            var coordinates = r[0].split("|");
            var flightPlanCoordinates = new Array();
            for (var i = 0; i < coordinates.length; i++) {
                var point = new google.maps.LatLng(coordinates[i].split(',')[0], coordinates[i].split(',')[1]);
                flightPlanCoordinates.push(point);
            }

            var flightPath = new google.maps.Polyline({
                path: flightPlanCoordinates,
                geodesic: true,
                strokeColor: '#FC6480',
                strokeOpacity: 0.8,
                strokeWeight: 10
            });
            flightPath.setMap(map);

            google.maps.event.addListener(map, 'click', function(event) {
                if (sourceCoordinates === null) {
                    setSourceLocation(event.latLng);
                } else {
                    setDestinationLocation(event.latLng);
                }
            });
        }

        function setSourceLocation(location) {
            if (marker) {
                marker.setMap(null);
            }
            marker = new google.maps.Marker({
                position: location,
                map: map,
                icon: 'http://maps.google.com/mapfiles/ms/icons/red-dot.png',
                title: 'Source Location'
            });

            sourceCoordinates = location;
            var latitude = location.lat().toFixed(6);
            var longitude = location.lng().toFixed(6);

            infoWindow.setContent('Source Latitude: ' + latitude + '<br>Source Longitude: ' + longitude);
            infoWindow.open(map, marker);

            // Set tọa độ vào thẻ input
            document.getElementById('src').value = latitude + ', ' + longitude;
        }

        function setDestinationLocation(location) {
            if (marker) {
                marker.setMap(null);
            }
            marker = new google.maps.Marker({
                position: location,
                map: map,
                icon: 'http://maps.google.com/mapfiles/ms/icons/blue-dot.png',
                title: 'Destination Location'
            });

            destinationCoordinates = location;
            var latitude = location.lat().toFixed(6);
            var longitude = location.lng().toFixed(6);

            infoWindow.setContent('Destination Latitude: ' + latitude + '<br>Destination Longitude: ' + longitude);
            infoWindow.open(map, marker);

            // Set tọa độ vào thẻ input
            document.getElementById('dest').value = latitude + ', ' + longitude;
        }

        function searchLocation() {
            // Xử lý tìm kiếm địa điểm
        }

        function resetInputs() {
            document.getElementById('src').value = '';
            document.getElementById('dest').value = '';
            sourceCoordinates = null;
            destinationCoordinates = null;
            if (marker) {
                marker.setMap(null);
            }
        }

        google.maps.event.addDomListener(window, 'load', initMap);
    </script>
</head>
<body>
<div style="width: 100%; display: flex;">
    <div style="display: block; margin-right: 10px; margin-left: 5px; margin-top: 10px;">
        <div style="display: flex;">
            <input type="text" id="src" style="height: 25px;" placeholder="Đỉnh nguồn">
            <button type="submit" for="src" onclick="searchLocation()">Xác nhận</button>
        </div>

        <div style="display: flex;">
            <input type="text" id="dest" style="height: 25px;" placeholder="Đỉnh đích">
            <button type="submit" for="dest" onclick="searchLocation()">Xác nhận</button>
        </div>
        <div style="display: flex; margin-top: 10px;">
            <button style="margin-right: 8px;">Đường đi ngắn nhất</button>
            <button onclick="resetInputs()">Reset</button>
        </div>
    </div>

    <div id="map">
        <div id="map-overlay"></div>
    </div>
</div>
</body>
</html>