<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>MU Mới Ra - Cộng Đồng MU Online Lớn Nhất VN</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700;900&family=Rajdhani:wght@500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --mu-bg: #050505;
            --mu-panel-bg: rgba(12, 12, 12, 0.95);
            --mu-gold: #cfaa56;       /* Vàng nhạt */
            --mu-gold-dark: #8a6d3b;  /* Vàng đất */
            --mu-red: #8b0000;
            --mu-border: #3d2b1f;     /* Viền nâu */
            --mu-text: #ccc;
        }

        body {
            background-color: var(--mu-bg);
            /* Background nền tối có vân */
            background-image: radial-gradient(circle at 50% 0%, #1a0505 0%, #000000 80%);
            background-attachment: fixed;
            font-family: 'Rajdhani', sans-serif; /* Font style game */
            color: var(--mu-text);
            min-width: 1400px;
            overflow-x: auto;
        }

        /* --- LAYOUT GIỮ NGUYÊN --- */
        .main-wrapper { display: flex; justify-content: center; gap: 15px; padding: 15px; max-width: 1800px; margin: 0 auto; }
        .sidebar { width: 280px; min-width: 280px; flex-shrink: 0; display: flex; flex-direction: column; gap: 15px; }
        .content-area { flex-grow: 1; max-width: 1000px; }

        /* --- BANNER FRAMES (THEO YÊU CẦU: CÓ KHUNG) --- */
        .mu-item-frame {
            display: block;
            width: 100%;
            border: 1px solid var(--mu-border);
            background: #000;
            position: relative;
            transition: all 0.3s ease;
            box-shadow: 0 0 10px rgba(0,0,0,0.8);
            /* Tạo hiệu ứng viền kép kiểu cổ điển */
            outline: 1px solid rgba(255, 255, 255, 0.05);
            outline-offset: -5px;
            overflow: hidden;
        }

        .mu-item-frame:hover {
            border-color: var(--mu-gold);
            box-shadow: 0 0 15px rgba(207, 170, 86, 0.3);
            transform: translateY(-2px);
            z-index: 10;
        }

        .real-ad-img {
            width: 100%; height: 100%; display: block;
            object-fit: fill;
            opacity: 0.9; transition: 0.3s;
        }
        .mu-item-frame:hover .real-ad-img { opacity: 1; scale: 1.02; }

        /* Kích thước Banner giữ nguyên */
        .h-banner-box { margin-bottom: 15px; height: 110px; }
        .v-banner-box { height: 450px; }

        /* --- PLACEHOLDER (VỊ TRÍ TRỐNG) --- */
        .ads-placeholder {
            display: flex; justify-content: center; align-items: center;
            background: rgba(255, 255, 255, 0.03);
            border: 1px dashed var(--mu-gold-dark);
            text-decoration: none;
            color: #666;
            cursor: pointer;
            transition: 0.3s;
        }
        .ads-placeholder:hover {
            background: rgba(207, 170, 86, 0.05);
            border-color: var(--mu-gold);
            color: var(--mu-gold);
        }
        .ads-text {
            font-family: 'Cinzel', serif; font-size: 0.8rem; font-weight: 700; text-transform: uppercase; letter-spacing: 1px;
        }
        .click-icon { width: 24px; height: 24px; margin-bottom: 5px; opacity: 0.5; }

        /* --- CAROUSEL HERO --- */
        .hero-frame {
            border: 1px solid var(--mu-gold-dark);
            padding: 3px; /* Tạo khoảng cách khung */
            background: rgba(0,0,0,0.5);
            margin-bottom: 15px;
            box-shadow: 0 0 20px rgba(0,0,0,0.8);
        }

        /* --- TABLE STYLE (MU THEME) --- */
        .server-section {
            background: var(--mu-panel-bg);
            border: 1px solid var(--mu-border);
            box-shadow: 0 0 30px rgba(0,0,0,0.8);
            margin-bottom: 15px;
        }

        .section-header {
            /* Gradient đỏ tối sang đen */
            background: linear-gradient(90deg, #330000 0%, #1a0505 100%);
            border-bottom: 1px solid var(--mu-red);
            padding: 12px 20px;
            display: flex; align-items: center; justify-content: space-between;
        }
        .section-title {
            font-family: 'Cinzel', serif; font-weight: 700; color: var(--mu-gold); font-size: 1.2rem; margin: 0;
            text-shadow: 0 0 5px rgba(207, 170, 86, 0.5);
        }

        /* Table Design */
        .mu-table { width: 100%; border-collapse: separate; border-spacing: 0; }
        .mu-table th {
            background: rgba(255, 255, 255, 0.05);
            color: #aaa;
            font-family: 'Cinzel', serif;
            font-size: 0.85rem;
            padding: 15px;
            border-bottom: 2px solid #333;
            text-transform: uppercase;
        }
        .mu-table td {
            padding: 15px;
            border-bottom: 1px solid rgba(255,255,255,0.05);
            vertical-align: middle;
            font-size: 1rem;
        }
        .mu-table tr:last-child td { border-bottom: none; }
        .mu-table tr:hover { background-color: rgba(255, 204, 0, 0.03); }

        /* Row Styles */
        /* Super VIP: Nền đỏ rất nhạt + Viền trái vàng */
        .row-super-vip {
            background: linear-gradient(90deg, rgba(80, 0, 0, 0.2) 0%, transparent 100%);
        }
        .row-super-vip td:first-child { border-left: 3px solid var(--mu-red); }
        .row-super-vip:hover { background: linear-gradient(90deg, rgba(80, 0, 0, 0.3) 0%, transparent 100%); }

        /* VIP: Nền vàng rất nhạt */
        .row-vip {
            background: linear-gradient(90deg, rgba(207, 170, 86, 0.05) 0%, transparent 100%);
        }
        .row-vip td:first-child { border-left: 3px solid var(--mu-gold-dark); }

        /* Links & Text */
        .sv-name-link { text-decoration: none; font-family: 'Cinzel', serif; font-weight: 700; transition: 0.3s; display: block;}

        .name-super-vip { color: #ff3333; font-size: 1.25rem; text-shadow: 0 0 10px rgba(255, 0, 0, 0.4); }
        .name-super-vip:hover { color: #ff6666; text-shadow: 0 0 15px rgba(255, 0, 0, 0.8); }

        .name-vip { color: var(--mu-gold); font-size: 1.05rem; }
        .name-vip:hover { color: #fff; text-shadow: 0 0 10px var(--mu-gold); }

        .name-normal { color: #ccc; font-size: 0.9rem; }
        .name-normal:hover { color: #fff; }

        .date-col { font-family: 'Rajdhani', sans-serif; font-weight: 700; letter-spacing: 1px; }

        /* Badges & Buttons */
        .badge-ver { background: #222; border: 1px solid #444; color: #aaa; padding: 4px 8px; font-size: 0.75rem; }
        .badge-svip { background: var(--mu-red); color: #fff; border: 1px solid #ff5555; padding: 2px 6px; font-size: 0.6rem; vertical-align: middle; margin-right: 5px; }

        .btn-view {
            background: transparent;
            border: 1px solid var(--mu-gold-dark);
            color: var(--mu-gold);
            font-family: 'Cinzel', serif; font-size: 0.75rem;
            padding: 5px 15px;
            transition: 0.3s;
        }
        .btn-view:hover {
            background: var(--mu-gold); color: #000;
            box-shadow: 0 0 10px rgba(207, 170, 86, 0.5);
        }
        .btn-view-svip {
            background: linear-gradient(180deg, #8b0000 0%, #550000 100%);
            border-color: #ff3333; color: #fff;
        }
        .btn-view-svip:hover { box-shadow: 0 0 15px red; }

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
                    <a href="${banner.targetUrl}" class="mu-item-frame v-banner-box" target="_blank">
                        <img src="${banner.imageUrl}" class="real-ad-img" alt="Quảng cáo">
                        <div style="position: absolute; top:0; left:0; width:100%; height:100%; box-shadow: inset 0 0 20px rgba(0,0,0,0.8); pointer-events: none;"></div>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="/banner-register" class="mu-item-frame ads-placeholder v-banner-box">
                        <div class="ads-content text-center">
                            <i class="fa-solid fa-plus click-icon"></i>
                            <div class="ads-text">Banner Trái<br>Vị trí ${i + 1}</div>
                            <div style="font-size: 0.7rem; color: #555; margin-top: 5px;">280x450px</div>
                        </div>
                    </a>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </aside>

    <main class="content-area">

        <c:choose>
            <c:when test="${not empty bannersHero}">
                <div class="hero-frame">
                    <div id="heroCarousel" class="carousel slide" data-bs-ride="carousel">
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
                                             style="height: 400px; object-fit: fill;">
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
                </div>
            </c:when>
            <c:otherwise>
                <a href="/banner-register" class="mu-item-frame ads-placeholder mb-3" style="width: 100%; height: 400px;">
                    <div class="ads-content text-center">
                        <i class="fa-solid fa-crown text-warning fs-2 mb-2"></i>
                        <span class="ads-text fs-5 text-warning">VỊ TRÍ HERO BANNER (VIP)</span>
                        <span style="color: #888;">Kích thước hiển thị: 1000x400px</span>
                    </div>
                </a>
            </c:otherwise>
        </c:choose>

        <c:forEach var="i" begin="0" end="6">
            <c:set var="banner" value="${(not empty bannersStd && fn:length(bannersStd) > i) ? bannersStd[i] : null}" />
            <c:choose>
                <c:when test="${not empty banner}">
                    <a href="${banner.targetUrl}" class="mu-item-frame h-banner-box" target="_blank">
                        <img src="${banner.imageUrl}" class="real-ad-img" alt="Quảng cáo Std">
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="/banner-register" class="mu-item-frame ads-placeholder h-banner-box">
                        <div class="ads-content d-flex align-items-center gap-3">
                            <i class="fa-regular fa-image click-icon mb-0"></i>
                            <div class="text-start">
                                <div class="ads-text">Banner Ngang ${i + 1}</div>
                                <div style="font-size: 0.7rem; color: #555;">1000x110px</div>
                            </div>
                        </div>
                    </a>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <div class="server-section">
            <div class="section-header">
                <div class="d-flex align-items-center">
                    <i class="fa-solid fa-dragon text-danger me-2 fs-4"></i>
                    <h3 class="section-title">SERVER OPEN HÔM NAY</h3>
                </div>
                <div class="small text-secondary fst-italic"><i class="fa-solid fa-clock me-1"></i> Cập nhật: Hôm nay</div>
            </div>

            <div class="table-responsive">
                <table class="mu-table">
                    <thead>
                    <tr>
                        <th style="width: 33%;">Tên Server</th>
                        <th class="text-center">Phiên bản</th>
                        <th class="text-center">Reset</th>
                        <th class="text-center">Alpha Test</th>
                        <th class="text-center">Open Beta</th>
                        <th class="text-center" style="width: 13%;">Chi tiết</th>
                    </tr>
                    </thead>
                    <tbody>

                    <c:forEach var="sv" items="${superVips}">
                        <tr class="row-super-vip">
                            <td class="ps-3">
                                <div class="d-flex align-items-center">
                                    <span class="badge badge-svip">HOT</span>
                                    <img src="https://cdn.pixabay.com/animation/2025/11/03/21/48/21-48-26-427_512.gif"
                                         style="width: 30px; margin-right: 5px; filter: drop-shadow(0 0 5px orange);"
                                         alt="hot">
                                    <a href="/server/detail/${sv.id}" class="sv-name-link name-super-vip">
                                            ${sv.serverName}
                                    </a>
                                </div>
                                <div style="font-size: 0.8rem; color: #dddddd; margin-top: 4px; padding-left: 38px;">
                                        ${sv.muName} &bull; <span class="text-warning">${sv.slogan}</span>
                                </div>
                            </td>
                            <td class="text-center"><span class="badge-ver text-warning">${sv.serverStat.muVersion.versionName}</span></td>
                            <td class="text-center fw-bold text-secondary" style="color:#dadada !important;">${sv.serverStat.resetType.resetName}</td>
                            <td class="text-center text-secondary small" style="color:#dadada !important;">${sv.schedule.alphaDate}</td>
                            <td class="text-center date-col text-danger fs-5" style="color:#ff2b2b !important;">${sv.schedule.betaDate}</td>
                            <td class="text-center"><a href="/server/detail/${sv.id}" class="btn-view btn-view-svip">XEM</a></td>
                        </tr>
                    </c:forEach>

                    <c:forEach var="sv" items="${vips}">
                        <tr class="row-vip">
                            <td class="ps-3">
                                <div class="d-flex align-items-center">
                                    <i class="fa-solid fa-star text-warning me-2" style="font-size: 0.7rem;"></i>
                                    <a href="/server/detail/${sv.id}" class="sv-name-link name-vip">${sv.serverName}</a>
                                </div>
                                <div style="font-size: 0.75rem; color: #666; padding-left: 20px;">${sv.muName}</div>
                            </td>
                            <td class="text-center"><span class="badge-ver">${sv.serverStat.muVersion.versionName}</span></td>
                            <td class="text-center text-secondary">${sv.serverStat.resetType.resetName}</td>
                            <td class="text-center text-secondary small">${sv.schedule.alphaDate}</td>
                            <td class="text-center date-col text-light">${sv.schedule.betaDate}</td>
                            <td class="text-center"><a href="/server/detail/${sv.id}" class="btn-view">XEM</a></td>
                        </tr>
                    </c:forEach>

                    <c:forEach var="sv" items="${normals}">
                        <tr>
                            <td class="ps-3">
                                <a href="/server/detail/${sv.id}" class="sv-name-link name-normal">${sv.serverName}</a>
                                <div style="font-size: 0.75rem; color: #555;">${sv.muName}</div>
                            </td>
                            <td class="text-center"><span class="badge-ver" style="border:none; background:transparent;">${sv.serverStat.muVersion.versionName}</span></td>
                            <td class="text-center text-secondary small">${sv.serverStat.resetType.resetName}</td>
                            <td class="text-center text-secondary small">${sv.schedule.alphaDate}</td>
                            <td class="text-center date-col" style="color:#aaa;">${sv.schedule.betaDate}</td>
                            <td class="text-center"><a href="/server/detail/${sv.id}" class="btn-view" style="color: #666; border-color: #444;">Xem</a></td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty superVips && empty vips && empty normals}">
                        <tr><td colspan="6" class="text-center text-muted py-5 fst-italic">Hiện chưa có server nào ra mắt hôm nay.</td></tr>
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
                    <a href="${banner.targetUrl}" class="mu-item-frame v-banner-box" target="_blank">
                        <img src="${banner.imageUrl}" class="real-ad-img" alt="Quảng cáo">
                        <div style="position: absolute; top:0; left:0; width:100%; height:100%; box-shadow: inset 0 0 20px rgba(0,0,0,0.8); pointer-events: none;"></div>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="/banner-register" class="mu-item-frame ads-placeholder v-banner-box">
                        <div class="ads-content text-center">
                            <i class="fa-solid fa-plus click-icon"></i>
                            <div class="ads-text">Banner Phải<br>Vị trí ${i + 4}</div>
                            <div style="font-size: 0.7rem; color: #555; margin-top: 5px;">280x450px</div>
                        </div>
                    </a>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </aside>

</div>
<jsp:include page="footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>