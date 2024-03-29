﻿<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page language="java" import="java.sql.*, java.util.*, java.text.*"%>
<%@include file="config.jsp" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <!-- font awesome -->
    <script src="https://kit.fontawesome.com/c5f2e8b9cc.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <!-- vue -->
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <!-- JQuery -->
    <script src="https://code.jquery.com/jquery-3.6.3.min.js"
        integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css"
        integrity="sha256-kLaT2GOSpHechhsozzB+flnD+zUyjE2LlfWPgU04xyI=" crossorigin="" />
    <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"
        integrity="sha256-WBkoXOwTeyKclOHuWtc+i2uENFpDZ9YPdf5Hf+D7ewM=" crossorigin=""></script>
    <link href="site.css" rel="stylesheet">
    <link href="index.css" rel="stylesheet">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <title>查找站點</title>
</head>

<body>
    <header>
        <div style="display: none;">
            <h2>當前訂單</h2>
            <p>狀態　　　　　　　外送員正前往領取衣物<br>
        </div>
    </header>
    <div id="main">
        <div class="nav">
            <a href="javascript:void(0)" onclick="history.back()" value="上一頁"><i class="fa-solid fa-arrow-left"></i></a>
            <h2>查找站點</h2>
        </div>
        <section>
            <h2>最愛站點</h2>
            <%
sql = "SELECT * FROM site where favorite = 1 ";
rs = smt.executeQuery(sql);
String sid = "";
String name = "";
String address = "";
String phone = "";
int favorite = 0;
while (rs.next()) {
sid = rs.getString("SiteId");
name = name;
address = rs.getString("SiteAddress");
phone = rs.getString("Phone");
favorite = rs.getInt("Favorite");
out.println("<div class='site'>");
out.println("<h2>"+rs.getString("SiteName")+"</h2>");%>
            <!-- <button class="favorite-button" data-site-id="<%= sid %>" data-is-added="<%= favorite %>">
                <i class="fa fa-heart"></i>
            </button> -->
            <%
out.println("<p>"+rs.getString("SiteAddress")+"<br>"+rs.getString("Phone")+"</p>");
out.println("</div>");
}
%>
        </section>
        <section>
            <h2>其他站點</h2>
            <%					
					sql = "SELECT * FROM site where favorite = '0' ";
					rs = smt.executeQuery(sql);
					

                    while (rs.next()) {
                        sid = rs.getString("SiteId");
                        name = rs.getString("SiteName");
                        address = rs.getString("SiteAddress");
                        phone = rs.getString("Phone");
                        favorite = rs.getInt("Favorite");
                        out.println("<div class='site'>");
                        out.println("<h2>"+rs.getString("SiteName")+"</h2>");%>
            <!-- <button class="favorite-button" data-site-id="<%= sid %>" data-is-added="<%= favorite %>">
                <i class="fa fa-heart-o"></i>
            </button> -->
            <%
                        out.println("<p>"+rs.getString("SiteAddress")+"<br>"+rs.getString("Phone")+"</p>");
                        out.println("</div>");
}
%>
        </section>
        <a href="javascript:void(0)" id="openMap" onclick="map_open()"><i class="fa-solid fa-store">地圖找點</i></a>
    </div>
    <div class="" style="display:none" id="mapDiv">
        <a href="javascript:void(0)" onclick="map_close()"><i class="fa-solid fa-xmark"></i></a>
        <section>
            <div id="map"></div>
        </section>
    </div>
</body>

<script>
    const cycu = [24.957547210362748, 121.24075323625465];
    var map = L.map('map').setView(cycu, 16);

    var osm = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        minZoom: 16,
        maxZoom: 20,
        attribution: '© OpenStreetMap'
    }).addTo(map);

    var marker = L.marker([24.957547210362748, 121.24075323625465]).addTo(map);

    map.locate({
        setView: false,
        watch: true,
        enableHighAccuracy: true
    });
    const self = L.marker([24.957547210362748, 121.24075323625465]).addTo(map).bindPopup("<strong>現在位置</strong>")
        .openPopup();
    const circle = L.circle([24.957547210362748, 121.24075323625465], 50).addTo(map);

    function clickInfo(e) {
        var c = L.latLng(e.latlng)
        var distance = c.distanceTo(self.getLatLng());
        marker.bindPopup("<strong>中原大學</strong><br>距離" + parseInt(distance) + "公尺<br><a href=orderlist.html>建立訂單</a>");
    }
    marker.on('click', clickInfo);

    function onLocationError(e) {
        alert(e.message);
    }
    map.on('locationerror', onLocationError);

    function onLocationFound(e) {
        self.setLatLng(e.latlng);
        circle.setLatLng(e.latlng);
        circle.setRadius(e.accuracy);
        map.panTo(e.latlng);
    }

    map.on('locationfound', onLocationFound);
</script>

<script>
    // mapbutton
    function map_open(e) {
        document.getElementById("mapDiv").style.display = "block";
        document.getElementById("openMap").style.display = "none";
        map.invalidateSize();
    }

    function map_close() {
        document.getElementById("mapDiv").style.display = "none";
        document.getElementById("openMap").style.display = "block";
        map.invalidateSize();
    }
</script>
<script>
    $(document).ready(function () {
        $('.favorite-button').click(function () {
            var siteId = $(this).data('siteId');
            var favorite = $(this).data('is-added');
            $.ajax({
                type: 'POST',
                url: 'update_favorite.jsp',
                data: {
                    siteId: siteId,
                    favorite: favorite
                },
                success: function (response) {
                    $(this).data('is-added', !favorite);
                    $(this).find('i').toggleClass('fa-heart fa-heart-o');
                }.bind(this),
                error: function (xhr, status, error) {
                    console.log('Error updating favorites: ' + error);
                }
            });
        });
    });
</script>
<%
con.close();
			}
            catch (SQLException sExec) {
                out.println("SQL錯誤!" + sExec.toString());
            }
        }
        catch (ClassNotFoundException err) {
            out.println("class錯誤" + err.toString());
    }
%>

</html>