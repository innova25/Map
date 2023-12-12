<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bản đồ Google Maps</title>
    <style>
        /* Tạo overlay cho div chứa bản đồ */
        #map {
            position: relative;
            height: 700px;
            width: 79%;
            float: right; /* Hiển thị bản đồ bên phải */
        }

        #map-overlay {
            position: absolute;
            top: 0;
            left: 0;
            height: 100%;
            width: 100%;
            background-color: rgba(255, 255, 255, 0.7); /* Màu overlay */
            z-index: 1; /* Đảm bảo overlay nằm phía trên bản đồ */
        }

        #search-container {
            position: relative;
            top: 15px;
            left: 15px;
            z-index: 2; /* Đặt ô search trên cùng */
            float: left; /* Hiển thị ô search bên trái */
        }

        #search-container input[type="text"],
        #search-container button {
            padding: 8px;
            font-size: 16px;
        }

        .suggestion_container {
            position: absolute; /* Sẽ được đặt ở một vị trí cụ thể trong #search_container */
            top: 100%; /* Đặt vị trí từ phía trên dưới của input */
            left: 0; /* Đặt vị trí từ bên trái */
            width: 100%; /* Chiều rộng tối đa */
            background-color: #fff; /* Màu nền */
            border: 1px solid #ccc; /* Viền */
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* Đổ bóng */
            display: none; /* Ban đầu ẩn đi, sẽ được hiển thị khi có suggestion */
            z-index: 1; /* Đặt layer trên các phần tử khác nằm dưới */
        }

        /* CSS để hiển thị suggestion container khi input được focus */
        #search_input:focus+.suggestion_container {
            display: block;
        }

        /* CSS cho suggestion items (cần điều chỉnh thêm) */
        .suggestion_container .suggestion_item {
            padding: 8px;
            border-bottom: 1px solid #ddd;
            cursor: pointer;
        }
    </style>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDNI_ZWPqvdS6r6gPVO50I4TlYkfkZdXh8"></script>
    <script>
        var map;
        var myLatLng = {lat: 21.031369, lng: 105.832756};
        function initMap() {

            var map = new google.maps.Map(document.getElementById('map'), {
                zoom: 16,
                center: myLatLng
            });

            var r=['21.021975117831158,105.83149383663209|21.021550869108463,105.83130220433894|21.021457398089282,105.8312537151797|21.020871846134106,105.83098153820569|21.02083829275326,105.83106541118066|21.021427814781646,105.83133291314785|21.021314617796623,105.83161263890256|21.021199814420847,105.831809039632|21.021339735030125,105.83219478359138'];


            var coordinates = r[0].split("|");
            var flightPlanCoordinates = new Array();
            for (i = 0; i < coordinates.length; i++) {
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


        }
        function send() {
            map.setCenter = myLatLng;
            var clientData = "21.021710,105.828918|21.022475066870633,105.8281084508101";
            console.log('Data from server:');
            fetch('http://localhost:8080/DataServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'clientData=' + encodeURIComponent(clientData),
            })
                .then(response => response.text())
                .then(data => {r = data
                    // Nhận dữ liệu từ server và xử lý
                    console.log('Data from server:', data);
                })
                .catch(error => console.error('Error:', error));
        }
        google.maps.event.addDomListener(window, 'load', initialize);
    </script>
</head>

<body>
<div id="search-container">
    <input type="text" name="search" placeholder="Tìm kiếm">
    <button onclick="send()" type="submit">Search</button>
    <div class="suggestion_container">
        <div class="suggestion_item">Kết quả tìm kiếm 1</div>
        <div class="suggestion_item">Kết quả tìm kiếm 2</div>
        <div class="suggestion_item">Kết quả tìm kiếm 3</div>
        <!-- Các suggestion items sẽ được thêm vào đây -->
    </div>
</div>
<div id="map">
    <div id="map-overlay">
        <!-- Nội dung của overlay -->
    </div>
</div>
<script>
    initMap();
</script>
</body>

</html>
