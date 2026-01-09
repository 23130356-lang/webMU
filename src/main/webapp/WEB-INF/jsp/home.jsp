<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %> <!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>MU Mới Ra - Cộng Đồng MU Online Lớn Nhất VN</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        /* --- GIỮ NGUYÊN CSS CŨ CỦA BẠN --- */
        body { background-color: #f0f2f5; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; min-width: 1400px; overflow-x: auto; }
        .main-wrapper { display: flex; justify-content: center; gap: 15px; padding: 15px; max-width: 1800px; margin: 0 auto; }
        .sidebar { width: 280px; min-width: 280px; flex-shrink: 0; display: flex; flex-direction: column; gap: 15px; }
        .content-area { flex-grow: 1; max-width: 1000px; }
        .banner-box { display: block; width: 100%; border-radius: 6px; overflow: hidden; text-decoration: none; position: relative; }
        .real-ad-img { width: 100%; height: 100%; object-fit: cover; display: block; border: 1px solid #ddd; transition: opacity 0.2s; }
        .real-ad-img:hover { opacity: 0.9; border-color: #cc0000; }
        .ads-placeholder { display: flex; justify-content: center; align-items: center; background-color: #f9fafb; border: 2px dashed #9ca3af; border-radius: 8px; text-decoration: none; transition: all 0.3s ease; cursor: pointer; box-sizing: border-box; color: #6b7280; }
        .ads-placeholder:hover { background-color: #e5e7eb; border-color: #3b82f6; transform: translateY(-2px); color: #2563eb; }
        .ads-content { display: flex; flex-direction: column; align-items: center; gap: 5px; text-align: center; padding: 10px; }
        .ads-text { font-size: 13px; font-weight: 700; text-transform: uppercase; }
        .click-icon { width: 28px; height: 28px; animation: bounce 2s infinite; }
        @keyframes bounce { 0%, 20%, 50%, 80%, 100% { transform: translateY(0); } 40% { transform: translateY(-5px); } 60% { transform: translateY(-3px); } }
        .h-banner-box { margin-bottom: 15px; width: 100%; height: 110px; }
        .v-banner-box { width: 100%; height: 450px; }
        .server-section { background: #fff; border: 1px solid #d1d5db; border-radius: 6px; margin-bottom: 15px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); overflow: hidden; }
        .section-header { background: linear-gradient(180deg, #b91c1c 0%, #991b1b 100%); color: #fff; padding: 10px 15px; font-weight: bold; text-transform: uppercase; display: flex; align-items: center; justify-content: space-between; }
        .mu-table { width: 100%; border-collapse: collapse; }
        .mu-table th { background: #f3f4f6; color: #374151; padding: 10px; font-size: 0.85rem; border-bottom: 2px solid #e5e7eb; }
        .mu-table td { padding: 12px 10px; border-bottom: 1px solid #e5e7eb; vertical-align: middle; font-size: 0.95rem; }
        .mu-table tr:hover { background-color: #fdf2f8; }
        .sv-name { color: #b91c1c; font-weight: 800; text-decoration: none; font-size: 1.1rem; }
        .version-badge { background: #1f2937; color: #fbbf24; padding: 3px 6px; border-radius: 4px; font-size: 0.75rem; font-weight: bold; }
        .btn-view { background-color: #dc2626; color: white; border: none; padding: 5px 15px; border-radius: 4px; font-weight: 600; font-size: 0.85rem; text-decoration: none; transition: background 0.2s; }
        .btn-view:hover { background-color: #b91c1c; color: #fff; }
    </style>
</head>
<body>

<jsp:include page="header.jsp"/>

<div class="main-wrapper">

    <aside class="sidebar">
        <c:forEach var="i" begin="0" end="2">
            <c:set var="banner" value="${(not empty bannersLeft && fn:length(bannersLeft) > i) ? bannersLeft[i] : null}" />

            <c:choose>
                <c:when test="${not empty banner}">
                    <a href="${banner.targetUrl}" class="banner-box v-banner-box" target="_blank">
                        <img src="${banner.imageUrl}" class="real-ad-img" alt="Quảng cáo">
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="/banner-register" class="ads-placeholder v-banner-box">
                        <div class="ads-content">
                            <svg class="click-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M14 9l6 6-6 6"/><path d="M4 15v-3a8 8 0 0 1 16 0v2.34"/><line x1="4" y1="15" x2="4" y2="15"/><circle cx="4" cy="15" r="1" fill="currentColor" stroke="none"/><path d="M10 14l2 2 4-4"/><path d="M8.21 13.89L7 23l6-3 6 3-1.21-9.12"/>
                            </svg>
                            <span class="ads-text">Thuê Banner<br>Dọc Trái ${i + 1}</span>
                        </div>
                    </a>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </aside>

    <main class="content-area">

        <c:choose>
            <c:when test="${not empty bannersHero}">
                <div id="heroCarousel" class="carousel slide mb-3 shadow-sm" data-bs-ride="carousel"
                     style="border-radius: 6px; overflow: hidden; border: 1px solid #d1d5db;">

                    <div class="carousel-indicators">
                        <c:forEach items="${bannersHero}" var="banner" varStatus="status">
                            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="${status.index}"
                                    class="${status.first ? 'active' : ''}" aria-current="${status.first ? 'true' : 'false'}"></button>
                        </c:forEach>
                    </div>

                    <div class="carousel-inner">
                        <c:forEach items="${bannersHero}" var="banner" varStatus="status">
                            <div class="carousel-item ${status.first ? 'active' : ''}" data-bs-interval="3000">
                                <a href="${banner.targetUrl}" target="_blank">
                                    <img src="${banner.imageUrl}" class="d-block w-100" alt="Hero Banner"
                                         style="height: 400px; object-fit: cover;">
                                </a>
                            </div>
                        </c:forEach>
                    </div>

                    <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Previous</span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Next</span>
                    </button>
                </div>
            </c:when>
            <c:otherwise>
                <a href="/banner-register" class="ads-placeholder" style="width: 100%; height: 400px; margin-bottom: 15px; display: flex;">
                    <div class="ads-content">
                        <span class="ads-text" style="font-size: 1.5rem;">VỊ TRÍ HERO BANNER (VIP)</span>
                        <span style="color: #666;">Kích thước hiển thị: 1000x400px</span>
                    </div>
                </a>
            </c:otherwise>
        </c:choose>

        <c:forEach var="i" begin="0" end="6">
            <c:set var="banner" value="${(not empty bannersStd && fn:length(bannersStd) > i) ? bannersStd[i] : null}" />

            <c:choose>
                <c:when test="${not empty banner}">
                    <a href="${banner.targetUrl}" class="banner-box h-banner-box" target="_blank">
                        <img src="${banner.imageUrl}" class="real-ad-img" alt="Quảng cáo Std">
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="/banner-register" class="ads-placeholder h-banner-box">
                        <div class="ads-content">
                            <svg class="click-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M14 9l6 6-6 6"/><path d="M4 15v-3a8 8 0 0 1 16 0v2.34"/><line x1="4" y1="15" x2="4" y2="15"/><circle cx="4" cy="15" r="1" fill="currentColor" stroke="none"/><path d="M10 14l2 2 4-4"/><path d="M8.21 13.89L7 23l6-3 6 3-1.21-9.12"/>
                            </svg>
                            <span class="ads-text">Banner Ngang Số ${i + 1}</span>
                        </div>
                    </a>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <div class="server-list-container">
            <div class="section-header">
                <i class="bi bi-trophy-fill text-danger me-2"></i>
                <h3 class="section-title">DANH SÁCH SERVER MU MỚI</h3>
            </div>
            <div class="table-responsive">
                <table class="mu-table">
                    <thead>
                    <tr>
                        <th style="width: 40%;">Tên Server</th>
                        <th>Phiên bản</th>
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
                                    <img src="https://cdn.pixabay.com/animation/2025/11/03/21/48/21-48-26-427_512.gif" style="width: 20px; margin-right: 5px;" alt="hot">
                                    <a href="/server/detail/${sv.id}" class="sv-name-link text-uppercase" style="font-size: 1.1rem; color: #b70000; text-shadow: 0px 0px 1px #ffaa00;">${sv.serverName}</a>
                                </div>
                                <div style="font-size: 0.8rem; color: #555; font-style: italic;">
                                    <i class="bi bi-info-circle-fill text-warning"></i> ${sv.muName} - ${sv.slogan}
                                </div>
                            </td>
                            <td><span class="version-tag bg-danger text-white border border-warning">${sv.serverStat.muVersion.versionName}</span></td>
                            <td class="fw-bold text-dark">${sv.serverStat.resetType.resetName}</td>
                            <td class="text-muted fw-bold">${sv.schedule.alphaDate}</td>
                            <td class="date-col text-danger" style="font-size: 1.1rem;">${sv.schedule.betaDate}</td>
                            <td><a href="/server/detail/${sv.id}" class="btn btn-sm btn-danger fw-bold shadow-sm">XEM</a></td>
                        </tr>
                    </c:forEach>
                    <c:forEach var="sv" items="${vips}">
                        <tr style="background-color: #fffae6;">
                            <td class="text-start ps-3">
                                <span class="badge bg-warning text-dark mb-1" style="font-size: 0.65rem;">VIP</span>
                                <div><a href="/server/detail/${sv.id}" class="sv-name-link" style="color: #9c4a00;">${sv.serverName}</a></div>
                                <div style="font-size: 0.75rem; color: #666;">${sv.muName}</div>
                            </td>
                            <td><span class="version-tag" style="background: #ffcaca;">${sv.serverStat.muVersion.versionName}</span></td>
                            <td>${sv.serverStat.resetType.resetName}</td>
                            <td>${sv.schedule.alphaDate}</td>
                            <td class="date-col">${sv.schedule.betaDate}</td>
                            <td><a href="/server/detail/${sv.id}" class="btn btn-sm btn-outline-danger fw-bold">XEM</a></td>
                        </tr>
                    </c:forEach>
                    <c:forEach var="sv" items="${normals}">
                        <tr style="background-color: #ffffff;">
                            <td class="text-start ps-3">
                                <div><a href="/server/detail/${sv.id}" class="sv-name-link text-dark fw-bold">${sv.serverName}</a></div>
                                <div style="font-size: 0.75rem; color: #888;">${sv.muName}</div>
                            </td>
                            <td><span class="badge bg-secondary text-white">${sv.serverStat.muVersion.versionName}</span></td>
                            <td class="text-secondary">${sv.serverStat.resetType.resetName}</td>
                            <td class="text-secondary">${sv.schedule.alphaDate}</td>
                            <td class="fw-bold text-dark">${sv.schedule.betaDate}</td>
                            <td><a href="/server/detail/${sv.id}" class="btn btn-sm btn-light border">Xem</a></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty superVips && empty vips && empty normals}">
                        <tr><td colspan="6" class="text-center text-muted py-4">Chưa có server nào được đăng ký.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>

    </main>

    <aside class="sidebar">
        <c:forEach var="i" begin="0" end="2">
            <c:set var="banner" value="${(not empty bannersRight && fn:length(bannersRight) > i) ? bannersRight[i] : null}" />

            <c:choose>
                <c:when test="${not empty banner}">
                    <a href="${banner.targetUrl}" class="banner-box v-banner-box" target="_blank">
                        <img src="${banner.imageUrl}" class="real-ad-img" alt="Quảng cáo">
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="/banner-register" class="ads-placeholder v-banner-box">
                        <div class="ads-content">
                            <svg class="click-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M14 9l6 6-6 6"/><path d="M4 15v-3a8 8 0 0 1 16 0v2.34"/><line x1="4" y1="15" x2="4" y2="15"/><circle cx="4" cy="15" r="1" fill="currentColor" stroke="none"/><path d="M10 14l2 2 4-4"/><path d="M8.21 13.89L7 23l6-3 6 3-1.21-9.12"/>
                            </svg>
                            <span class="ads-text">Thuê Banner<br>Dọc Phải ${i + 4}</span>
                        </div>
                    </a>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </aside>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>