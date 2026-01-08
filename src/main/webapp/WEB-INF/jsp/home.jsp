<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>MU Mới Ra - Cộng Đồng MU Online Lớn Nhất VN</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        /* --- CẤU HÌNH CỐ ĐỊNH GIAO DIỆN (QUAN TRỌNG) --- */
        body {
            background-color: #e9ecef;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            /* 1. Ép chiều rộng tối thiểu của web là 1550px
               (Đủ để hiển thị 2 banner 2 bên và nội dung ở giữa mà không bị đè) */
            min-width: 1550px;
            overflow-x: auto; /* Hiện thanh cuộn ngang nếu màn hình nhỏ hơn 1550px */
        }

        /* Class bao quanh toàn bộ layout */
        .fixed-layout-wrapper {
            display: flex; /* Dùng Flexbox thay vì Grid */
            padding: 10px;
            gap: 15px;     /* Khoảng cách giữa các cột */
            justify-content: center;
        }

        /* Cột cố định 2 bên (Sidebar) */
        .fixed-sidebar {
            width: 290px;      /* Chiều rộng cố định cho banner 280px + viền */
            min-width: 290px;  /* Không cho phép co nhỏ hơn số này */
            flex-shrink: 0;    /* Tuyệt đối không bị bóp méo khi zoom */
        }

        /* Cột giữa (Nội dung) */
        .fluid-content {
            flex-grow: 1;      /* Tự động giãn ra lấp đầy khoảng trống còn lại */
            max-width: 1200px; /* Giới hạn độ rộng tối đa cho đẹp (tùy chọn) */
        }

        /* --- PHẦN STYLE CŨ --- */
        .ad-container { margin-bottom: 5px; }
        .ad-img {
            width: 100%;
            display: block;
            border: 1px solid #ccc;
            transition: opacity 0.2s;
            object-fit: cover;
            object-position: center;
            border-radius: 4px;
        }
        .ad-img:hover { opacity: 0.9; border-color: #cc0000; }

        /* Chiều cao banner */
        .banner-tall { height: 500px; }
        .banner-tall-sm { height: 400px; }
        .banner-hero { height: 250px; }
        .banner-std { height: 120px; }
        .banner-half { height: 100px; }

        /* Style danh sách server */
        .server-list-container {
            background: #fff;
            border: 1px solid #ddd;
            padding: 5px;
            margin-top: 15px;
            display: block;
            width: 100%;
            border-radius: 4px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .section-header {
            background: linear-gradient(to bottom, #fceabb 0%,#fccd4d 50%,#f8b500 51%,#fbdf93 100%);
            padding: 10px;
            border: 1px solid #eeb400;
            margin-bottom: 0;
            display: flex;
            align-items: center;
        }

        .section-title {
            color: #8f0202;
            font-weight: 900;
            text-transform: uppercase;
            margin: 0;
            font-size: 1.1rem;
            text-shadow: 1px 1px 0px #fff;
        }

        .mu-table { width: 100%; border-collapse: collapse; }
        .mu-table th { background-color: #555; color: #fff; padding: 8px; text-align: center; font-size: 0.8rem; text-transform: uppercase; border: 1px solid #333; }
        .mu-table td { padding: 8px; border: 1px solid #ddd; text-align: center; font-size: 0.9rem; font-weight: 600; color: #333; }
        .mu-table tr:nth-child(even) { background-color: #f9f9f9; }
        .mu-table tr:hover { background-color: #ffffe0; cursor: pointer; }
        .sv-name-link { color: #b70000; text-decoration: none; font-weight: 800; font-size: 1rem; }
        .sv-name-link:hover { text-decoration: underline; color: #ff0000; }
        .date-col { color: #d60000; font-weight: bold; }
        .version-tag { background: #000; color: #ffd700; padding: 2px 5px; border-radius: 3px; font-size: 0.75rem; }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="fixed-layout-wrapper">

    <div class="fixed-sidebar">
        <a href="#" class="ad-container d-block mb-2">
            <img src="https://via.placeholder.com/280x500" class="ad-img banner-tall" alt="QC">
        </a>
        <a href="#" class="ad-container d-block mb-2">
            <img src="https://via.placeholder.com/280x500" class="ad-img banner-tall" alt="QC">
        </a>
        <a href="#" class="ad-container d-block mb-2">
            <img src="https://via.placeholder.com/280x400" class="ad-img banner-tall-sm" alt="QC">
        </a>
    </div>

    <div class="fluid-content">

        <div class="mb-2">
            <a href="#"><img src="https://via.placeholder.com/1200x250" class="ad-img banner-hero" alt="Big Banner"></a>
        </div>

        <div class="row g-1 mb-3">
            <div class="col-12"><a href="#"><img src="https://via.placeholder.com/1200x120" class="ad-img banner-std" alt="QC"></a></div>
            <div class="col-12"><a href="#"><img src="https://via.placeholder.com/1200x120" class="ad-img banner-std" alt="QC"></a></div>
            <div class="col-12"><a href="#"><img src="https://via.placeholder.com/1200x120" class="ad-img banner-std" alt="QC"></a></div>
            <div class="col-md-6"><a href="#"><img src="https://via.placeholder.com/600x100" class="ad-img banner-half" alt="QC"></a></div>
            <div class="col-md-6"><a href="#"><img src="https://via.placeholder.com/600x100" class="ad-img banner-half" alt="QC"></a></div>
            <div class="col-12"><a href="#"><img src="https://via.placeholder.com/1200x120" class="ad-img banner-std" alt="QC"></a></div>
        </div>

        <div class="server-list-container">
            <div class="section-header">
                <i class="bi bi-trophy-fill text-danger me-2"></i>
                <h3 class="section-title">DANH SÁCH SERVER MU MỚI</h3>
            </div>

            <div class="table-responsive">
                <table class="mu-table">
                    <thead>
                    <tr>
                        <th style="width: 40%;">Tên Server</th> <th>Phiên bản</th>
                        <th>Reset</th>
                        <th>Alpha Test</th>
                        <th>Open Beta</th>
                        <th style="width: 10%;">Chi tiết</th>
                    </tr>
                    </thead>
                    <tbody>

                    <c:forEach var="sv" items="${superVips}">
                        <tr style="background: linear-gradient(to bottom, #fffbec, #fff3cd); border-bottom: 2px solid #ffcc00;">
                            <td class="text-start ps-3">
                                <span class="badge bg-danger mb-1" style="font-size: 0.65rem;">SUPER VIP</span>
                                <div class="d-flex align-items-center">
                                    <img src="https://i.imgur.com/wF81T2M.gif" style="width: 20px; margin-right: 5px;" alt="hot">
                                    <a href="/server/detail/${sv.id}" class="sv-name-link text-uppercase" style="font-size: 1.1rem; color: #b70000; text-shadow: 0px 0px 1px #ffaa00;">
                                            ${sv.serverName}
                                    </a>
                                </div>
                                <div style="font-size: 0.8rem; color: #555; font-style: italic;">
                                    <i class="bi bi-info-circle-fill text-warning"></i> ${sv.muName} - ${sv.slogan}
                                </div>
                            </td>
                            <td><span class="version-tag bg-danger text-white border border-warning">${sv.serverStat.muVersion.versionName}</span></td>
                            <td class="fw-bold text-dark">${sv.serverStat.resetType.resetName}</td>
                            <td class="text-muted fw-bold">${sv.schedule.alphaDate}</td>
                            <td class="date-col text-danger" style="font-size: 1.1rem;">${sv.schedule.betaDate}</td>
                            <td>
                                <a href="/server/detail/${sv.id}" class="btn btn-sm btn-danger fw-bold shadow-sm">XEM</a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:forEach var="sv" items="${vips}">
                        <tr style="background-color: #fffae6;">
                            <td class="text-start ps-3">
                                <span class="badge bg-warning text-dark mb-1" style="font-size: 0.65rem;">VIP</span>
                                <div>
                                    <a href="/server/detail/${sv.id}" class="sv-name-link" style="color: #9c4a00;">
                                            ${sv.serverName}
                                    </a>
                                </div>
                                <div style="font-size: 0.75rem; color: #666;">${sv.muName}</div>
                            </td>
                            <td><span class="version-tag" style="background: #333;">${sv.serverStat.muVersion.versionName}</span></td>
                            <td>${sv.serverStat.resetType.resetName}</td>
                            <td>${sv.schedule.alphaDate}</td>
                            <td class="date-col">${sv.schedule.betaDate}</td>
                            <td>
                                <a href="/server/detail/${sv.id}" class="btn btn-sm btn-outline-danger fw-bold">XEM</a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:forEach var="sv" items="${normals}">
                        <tr style="background-color: #ffffff;">
                            <td class="text-start ps-3">
                                <div>
                                    <a href="/server/detail/${sv.id}" class="sv-name-link text-dark fw-bold">
                                            ${sv.serverName}
                                    </a>
                                </div>
                                <div style="font-size: 0.75rem; color: #888;">${sv.muName}</div>
                            </td>
                            <td><span class="badge bg-secondary text-white">${sv.serverStat.muVersion.versionName}</span></td>
                            <td class="text-secondary">${sv.serverStat.resetType.resetName}</td>
                            <td class="text-secondary">${sv.schedule.alphaDate}</td>
                            <td class="fw-bold text-dark">${sv.schedule.betaDate}</td>
                            <td>
                                <a href="/server/detail/${sv.id}" class="btn btn-sm btn-light border">Xem</a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty superVips && empty vips && empty normals}">
                        <tr><td colspan="6" class="text-center text-muted py-4">Chưa có server nào.</td></tr>
                    </c:if>

                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="fixed-sidebar">
        <a href="#" class="ad-container d-block mb-2">
            <img src="https://via.placeholder.com/280x500/444/FFF?text=BANNER+DOC+PHAI+1" class="ad-img banner-tall" alt="QC">
        </a>
        <a href="#" class="ad-container d-block mb-2">
            <img src="https://via.placeholder.com/280x500/666/FFF?text=BANNER+DOC+PHAI+2" class="ad-img banner-tall" alt="QC">
        </a>
        <a href="#" class="ad-container d-block mb-2">
            <img src="https://via.placeholder.com/280x400/888/FFF?text=BANNER+DOC+PHAI+3" class="ad-img banner-tall-sm" alt="QC">
        </a>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>