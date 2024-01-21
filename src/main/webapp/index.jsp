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
            margin-right: 0;
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
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCH2_0evVV_7FWcFOD2mg2ASqP6Tv5rBK8&callback=initMap" async defer></script>
    <script>
        var map;
        var sourcemarker
        var destmarker
        var marker
        var infoWindow;
        var issourceCoordinates = false;
        var isdestinationCoordinates = false;
        var path;

       var startLine;
       var endLine;
        function initMap() {

            var myLatLng = { lat: 21.031369, lng: 105.832756 };
            map = new google.maps.Map(document.getElementById('map'), {
                zoom: 16,
                center: myLatLng
            });
            infoWindow = new google.maps.InfoWindow();

            makeGetRequest().then(function (coordinatesString) {
                var coordinatesArray = coordinatesString.split("|");
                var outlineCoordinates = [];

                for (var i = 0; i < coordinatesArray.length; i++) {
                    var latLngComponents = coordinatesArray[i].split(',');
                    var lat = parseFloat(latLngComponents[0]);
                    var lng = parseFloat(latLngComponents[1]);

                    if (!isNaN(lat) && !isNaN(lng)) {
                        var point = new google.maps.LatLng(lat, lng);
                        outlineCoordinates.push(point);
                    }
                }

                var outlinePath = new google.maps.Polyline({
                    path: outlineCoordinates,
                    geodesic: true,
                    strokeColor: '#FC6480',
                    strokeOpacity: 0.8,
                    strokeWeight: 2
                });

                outlinePath.setMap(map);
            });
            document.getElementById("Dijkstra").checked = true;
            google.maps.event.addListener(map, 'click', function(event) {
                if (!issourceCoordinates && !isdestinationCoordinates) {
                    setSourceLocation(event.latLng);
                } else if(issourceCoordinates && !isdestinationCoordinates) {
                    setDestinationLocation(event.latLng);
                }
            });
        }

        function setSourceLocation(location) {
            if (sourcemarker) {
                sourcemarker.setMap(null);
            }
            sourcemarker = new google.maps.Marker({
                position: location,
                map: map,
                icon: 'http://maps.google.com/mapfiles/ms/icons/red-dot.png',
                title: 'Source Location'
            });

            sourceCoordinates = location;
            var latitude = location.lat().toFixed(6);
            var longitude = location.lng().toFixed(6);

            infoWindow.setContent('Source Latitude: ' + latitude + '<br>Source Longitude: ' + longitude);
            infoWindow.open(map, sourcemarker);

            // Set tọa độ vào thẻ input
            document.getElementById('src').value = latitude + ',' + longitude;
        }

        function setDestinationLocation(location) {
            if (destmarker) {
                destmarker.setMap(null);
            }
            destmarker = new google.maps.Marker({
                position: location,
                map: map,
                icon: 'http://maps.google.com/mapfiles/ms/icons/blue-dot.png',
                title: 'Destination Location'
            });

            destinationCoordinates = location;
            var latitude = location.lat().toFixed(6);
            var longitude = location.lng().toFixed(6);

            infoWindow.setContent('Destination Latitude: ' + latitude + '<br>Destination Longitude: ' + longitude);
            infoWindow.open(map, destmarker);

            // Set tọa độ vào thẻ input
            document.getElementById('dest').value = latitude + ',' + longitude;
        }
        function makeGetRequest() {
            // Replace with your servlet URL and parameters
            var servletUrl = 'http://localhost:8080/demo_war_exploded/DataServlet';

            return fetch(servletUrl)
                .then(response => response.text())
                .catch(error => {

                    console.error('Error:', error);
                });
        }
        function findPath(start, end, algorithm) {
            return new Promise(function (resolve, reject) {
                $.ajax({
                    type: "POST",
                    url: "http://localhost:8080/demo_war_exploded/DataServlet",
                    data: { start: start, end: end, algorithm: algorithm },
                    success: function (response) {
                        var path = response.split(":");
                        if (path[0] === "false") {
                            alert("Please choose coordinates again! Marker is out of area")
                            resolve(""); // Empty string if the path is false
                        } else {
                            resolve(path[1]); // Resolve with the actual path
                        }
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        reject(errorThrown); // Reject with the error message
                    }
                });
            });
        }

        function drawPath() {
            if(path)path.setMap(null);
            if(startLine)startLine.setMap(null);
            if(endLine)endLine.setMap(null);
            findPath(document.getElementById('src').value.toString(), document.getElementById('dest').value.toString(), document.querySelector('input[name="alg"]:checked').value.toString())
                .then(function (result) {
                    // Handle the result (the resolved value from the promise)
                    var coordinatesArray = result.split("|");
                    var pathCoordinates = [];
                    var startCoordinate = coordinatesArray[0].split(",");
                    var endCoordinate = coordinatesArray[coordinatesArray.length-1].split(",");
                    var startOfVertical = document.getElementById("src").value.toString().split(",");
                    var endOfVertical = document.getElementById("dest").value.toString().split(",");

                    startLine = new google.maps.Polyline({
                        path:  [{lat:parseFloat(startOfVertical[0]),lng:parseFloat(startOfVertical[1])},
                            {lat:parseFloat(startCoordinate[0]),lng:parseFloat(startCoordinate[1])}
                        ],
                        geodesic: true,
                        strokeColor: '#FF0000',
                        strokeOpacity: 1.0,
                        strokeWeight: 2,
                        icons: [{
                            icon: {
                                path: 'M 0,-1 0,1',
                                strokeOpacity: 1,
                                scale: 4
                            },
                            offset: '0',
                            repeat: '20px'
                        }]
                    });

                    endLine = new google.maps.Polyline({
                        path: [{lat:parseFloat(endOfVertical[0]), lng:parseFloat(endOfVertical[1])},
                            {lat:parseFloat(endCoordinate[0]), lng:parseFloat(endCoordinate[1])}
                        ],
                        geodesic: true,
                        strokeColor: '#FF0000',
                        strokeOpacity: 1.0,
                        strokeWeight: 2,
                        icons: [{
                            icon: {
                                path: 'M 0,-1 0,1',
                                strokeOpacity: 1,
                                scale: 4
                            },
                            offset: '0',
                            repeat: '20px'
                        }]
                    });

                    startLine.setMap(map);
                    endLine.setMap(map);
                    for (var i = 0; i < coordinatesArray.length; i++) {
                        var latLngComponents = coordinatesArray[i].split(',');
                        var lat = parseFloat(latLngComponents[0]);
                        var lng = parseFloat(latLngComponents[1]);

                        if (!isNaN(lat) && !isNaN(lng)) {
                            var point = new google.maps.LatLng(lat, lng);
                            pathCoordinates.push(point);
                        }
                    }

                    path = new google.maps.Polyline({
                        path: pathCoordinates,
                        geodesic: true,
                        strokeColor: '#FFFFFF',
                        strokeOpacity: 0.8,
                        strokeWeight: 8
                    });

                    path.setMap(map);
                })
                .catch(function (error) {
                    // Handle errors (the rejected value from the promise)
                    console.error('Error:', error);
                });
        }
        function searchLocation() {
            if(!issourceCoordinates && !isdestinationCoordinates) issourceCoordinates=true;
            else isdestinationCoordinates=true;
        }

        function resetInputs() {
            document.getElementById('src').value = '';
            document.getElementById('dest').value = '';
            issourceCoordinates = false;
            isdestinationCoordinates = false;
            if (marker) {
                marker.setMap(null);
            }
            if(sourcemarker) {
                sourcemarker.setMap(null)
            }
            if(destmarker) {
                destmarker.setMap(null)
            }
        }


        google.maps.event.addDomListener(window, 'load', initMap);
    </script>
</head>
<body>
<div style="width: 100%; display: flex;">
    <div style="display: block; margin-right: 10px; margin-left: 5px; margin-top: 10px;">
        <div style="display: flex;">
            <label for="src"></label><input type="text" id="src" style="height: 40px;" placeholder="Start">
            <button type="submit" form="src" onclick="searchLocation()" style="margin-left: 2px;">Confirm</button>
        </div>

        <div style="display: flex;">
            <label for="dest"></label><input type="text" id="dest" style="height: 40px;" placeholder="Destination">
            <button type="submit" form="dest" onclick="searchLocation()" style="margin-left: 2px;">Confirm</button>
        </div>
        <div style="display: block; margin-top: 10px;">
            <div style="display: block;">
                <h3 style="margin-bottom: 2px; margin-left: 7px; font-weight: bold;">Select algorithm</h3>
                <form id="algorithm" style="display: flex;">
                    <input type="radio" id="A_star" name="alg" value="A*">
                    <label for="A_star">A*</label><br>
                    <input type="radio" id="Dijkstra" name="alg" value="Dijkstra">
                    <label for="Dijkstra">Dijkstra</label><br>
                </form>
            </div>
            <div style="margin-top: 8px;">
                <button onclick="drawPath()" style="margin-right: 10px;height: 25px;">Shortest Path</button>
                <button onclick="resetInputs()" style="height: 25px;">Reset</button>
            </div>
        </div>
    </div>

    <div id="map">
        <div id="map-overlay"></div>
    </div>
</div>
</body>
</html>