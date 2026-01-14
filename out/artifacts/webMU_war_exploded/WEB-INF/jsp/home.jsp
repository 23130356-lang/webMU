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
            --mu-gold: #cfaa56;
            --mu-gold-dark: #8a6d3b;
            --mu-red: #cc0000;
            --mu-border: #3d2b1f;
            --mu-text: #ccc;
        }

        body {
            background-color: var(--mu-bg);
            background-image: radial-gradient(circle at 50% 0%, #1a0505 0%, #000000 80%);
            background-attachment: fixed;
            font-family: 'Rajdhani', sans-serif;
            color: var(--mu-text);
            min-width: 1400px;
            overflow-x: auto;
            margin: 0;
        }

        a { text-decoration: none; transition: 0.3s; }

        /* === LAYOUT CHÍNH === */
        .main-wrapper { display: flex; justify-content: center; gap: 15px; padding: 15px; max-width: 1900px; margin: 0 auto; }
        .sidebar { width: 280px; min-width: 280px; flex-shrink: 0; display: flex; flex-direction: column; gap: 15px; }
        .content-area { flex-grow: 1; max-width: 750px; }

        /* === QUẢNG CÁO (BANNER) === */
        .mu-item-frame {
            display: block; width: 100%; border: 1px solid var(--mu-border); background: #000;
            position: relative; transition: all 0.3s ease; box-shadow: 0 0 10px rgba(0,0,0,0.8);
            outline: 1px solid rgba(255, 255, 255, 0.05); outline-offset: -5px; overflow: hidden;
        }
        .mu-item-frame:hover { border-color: var(--mu-gold); box-shadow: 0 0 15px rgba(207, 170, 86, 0.3); transform: translateY(-2px); z-index: 10; }
        .real-ad-img { width: 100%; height: 100%; display: block; object-fit: fill; opacity: 0.9; transition: 0.3s; }
        .mu-item-frame:hover .real-ad-img { opacity: 1; scale: 1.02; }
        .h-banner-box { margin-bottom: 12px; height: 90px; width: 100%; }
        .v-banner-box { height: 450px; }

        .hero-frame { border: 1px solid var(--mu-gold-dark); padding: 3px; background: rgba(0,0,0,0.5); margin-bottom: 15px; box-shadow: 0 0 20px rgba(0,0,0,0.8); }
        .ads-placeholder { display: flex; justify-content: center; align-items: center; background: rgba(255, 255, 255, 0.03); border: 1px dashed var(--mu-gold-dark); color: #666; }
        .ads-text { font-family: 'Cinzel', serif; font-size: 0.8rem; font-weight: 700; text-transform: uppercase; }

        /* === ANIMATIONS === */
        @keyframes spinBorder {
            0% { transform: translate(-50%, -50%) rotate(0deg); }
            100% { transform: translate(-50%, -50%) rotate(360deg); }
        }
        @keyframes shimmerGold {
            0% { background-position: -150% 0; }
            100% { background-position: 150% 0; }
        }
        @keyframes pulseRed {
            0% { box-shadow: 0 0 10px rgba(255, 0, 0, 0.3); }
            50% { box-shadow: 0 0 25px rgba(255, 0, 0, 0.7); }
            100% { box-shadow: 0 0 10px rgba(255, 0, 0, 0.3); }
        }

        /* === SERVER SECTION === */
        .server-section {
            background: var(--mu-panel-bg);
            border: 1px solid var(--mu-border);
            box-shadow: 0 0 30px rgba(0,0,0,0.8);
            margin-bottom: 15px; width: 100%;
        }
        .section-header {
            background: linear-gradient(90deg, #330000 0%, #1a0505 100%); border-bottom: 1px solid var(--mu-red);
            padding: 10px 20px; display: flex; align-items: center; justify-content: space-between;
        }
        .section-title { font-family: 'Cinzel', serif; font-weight: 700; color: var(--mu-gold); font-size: 1.1rem; margin: 0; }

        .srv-header {
            display: flex; background: linear-gradient(180deg, #1f0a0a 0%, #0a0505 100%);
            border-top: 1px solid var(--mu-gold-dark); border-bottom: 1px solid var(--mu-gold-dark);
            padding: 12px 0; font-family: 'Cinzel', serif; font-size: 0.8rem; color: var(--mu-gold);
            text-transform: uppercase; font-weight: 800; z-index: 5; position: relative;
        }
        .hdr-left { width: 30%; padding-left: 20px; }
        .hdr-right { width: 70%; display: flex; justify-content: space-between; padding-right: 15px; text-align: center; }
        .hdr-item { flex: 1; }

        /* === CẤU TRÚC ROW MỚI (CHUNG) === */
        .srv-row-inner {
            display: flex; align-items: center; padding: 12px 0; position: relative; z-index: 2;
            width: 100%; height: 100%;
        }

        .col-left-identity { width: 30%; padding-left: 20px; padding-right: 10px; display: flex; flex-direction: column; justify-content: center; }
        .col-right-wrapper { width: 70%; display: flex; flex-direction: column; padding: 0 15px; justify-content: center; gap: 8px; }
        .stats-line { display: flex; justify-content: space-between; align-items: center; width: 100%; text-align: center; }
        .stat-box { flex: 1; font-size: 0.9rem; }

        .banner-line { width: 100%; display: flex; justify-content: center; align-items: center; margin-top: 5px;}
        /* Ảnh banner bên trong không cần viền nữa, chỉ bo góc nhẹ */
        .inner-banner-img { width: 100%; height: 60px; object-fit: cover; border-radius: 2px; border: 1px solid #333; }


        /* =========================================
           1. SUPER VIP STYLE (Viền rực cháy TOÀN BỘ ROW)
           ========================================= */
        .svip-wrapper {
            position: relative;
            margin-bottom: 14px; /* Khoảng cách giữa các server */
            border-radius: 6px;
            padding: 4px; /* Độ dày của viền lửa */
            overflow: hidden; /* Cắt phần thừa của tia sáng xoay */
            animation: pulseRed 1s infinite alternate; /* Hiệu ứng nhấp nháy bóng đỏ */
            background: #000;
        }

        /* Lớp tia sáng xoay tròn phía sau */
        .svip-wrapper {
            position: relative;
            overflow: hidden;
        }

        .svip-wrapper::before,
        .svip-wrapper::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 300%;
            height: 1000%;
            background: conic-gradient(
                    transparent 0deg,
                    transparent 140deg,
                    #da0000 160deg,
                    #ff7300 170deg,
                    #ffff00 175deg,
                    #ffffff 180deg,
                    #ffff00 185deg,
                    #ff7300 190deg,
                    #da0000 200deg,
                    transparent 220deg
            );
            transform: translate(-50%, -50%);
            animation: spinBorder 2.5s linear infinite;
            z-index: 1;
        }

        /* TIA GỐC */
        .svip-wrapper::before {
            animation-delay: 0s;
        }

        /* TIA ĐỐI DIỆN 180° */
        .svip-wrapper::after {
            animation-delay: -1.25s; /* 2.5s / 2 */
        }

        @keyframes spinBorder {
            from {
                transform: translate(-50%, -50%) rotate(0deg);
            }
            to {
                transform: translate(-50%, -50%) rotate(360deg);
            }
        }


        /* Lớp nội dung bên trong (Đè lên tia sáng) */
        .svip-content {
            position: relative; z-index: 2;
            background: linear-gradient(90deg, #250000 0%, #150000 100%); /* Nền đỏ đen tối */
            border-radius: 4px;
            width: 100%; height: 100%;
        }

        .name-super-vip {
            color: rgb(212 253 13);
            font-size: 1.25rem;
            font-weight: 700;
            text-shadow: 0 0 10px #f7ff00;
            font-family: 'Cinzel', serif;
        }        .btn-view-svip { background: linear-gradient(180deg, #cc0000 0%, #660000 100%); border: 1px solid #ff3333; color: #fff; padding: 4px 15px; font-size: 0.75rem; }
        .btn-view-svip:hover { box-shadow: 0 0 15px red; color: #fff; transform: scale(1.05); }


        /* =========================================
           2. VIP STYLE (Viền vàng chạy nhẹ TOÀN BỘ ROW)
           ========================================= */
        .vip-wrapper {
            position: relative;
            margin-bottom: 10px;
            border-radius: 4px;
            padding: 2px; /* Độ dày viền vàng */
            background: linear-gradient(110deg, #333 30%, #cfaa56 45%, #fff 50%, #cfaa56 55%, #333 70%);
            background-size: 200% 100%;
            animation: shimmerGold 2.5s linear infinite;
            box-shadow: 0 0 5px rgba(207, 170, 86, 0.2);
        }

        .vip-content {
            position: relative; z-index: 2;
            background: linear-gradient(90deg, #1a1a1a 0%, #0c0c0c 100%);
            border-radius: 3px;
        }

        .name-vip { color: var(--mu-gold); font-size: 1.1rem; font-weight: 700; font-family: 'Cinzel', serif; }
        .btn-view { border: 1px solid var(--mu-gold-dark); color: var(--mu-gold); padding: 4px 12px; font-size: 0.75rem; font-family: 'Cinzel', serif; }
        .btn-view:hover { background: var(--mu-gold); color: #000; }
        .vip-content .inner-banner-img { height: 50px; border-color: #444; }


        /* =========================================
           3. NORMAL STYLE
           ========================================= */
        .normal-wrapper {
            border-bottom: 1px solid #222;
            transition: 0.2s;
        }
        .normal-wrapper:hover { background-color: rgba(255, 255, 255, 0.02); }
        .name-normal { color: #ccc; font-weight: 600; font-size: 0.95rem; }

        /* Badges */
        .badge-ver { background: #222; border: 1px solid #444; color: #aaa; padding: 2px 6px; font-size: 0.7rem; }
        .badge-svip { background: #d00; color: #fff; font-size: 0.7rem; padding: 1px 5px; font-weight: bold; border-radius: 2px; }

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
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="/banner-register" class="mu-item-frame ads-placeholder v-banner-box">
                        <div class="ads-content text-center">
                            <i class="fa-solid fa-plus click-icon"></i>
                            <div class="ads-text">Banner Trái<br>Vị trí ${i + 1}</div>
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
                                <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="${status.index}" class="${status.first ? 'active' : ''}"></button>
                            </c:forEach>
                        </div>
                        <div class="carousel-inner">
                            <c:forEach items="${bannersHero}" var="banner" varStatus="status">
                                <div class="carousel-item ${status.first ? 'active' : ''}" data-bs-interval="3000">
                                    <a href="${banner.targetUrl}" target="_blank">
                                        <img src="${banner.imageUrl}" class="d-block w-100" style="height: 320px; object-fit: fill;">
                                    </a>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <a href="/banner-register" class="mu-item-frame ads-placeholder mb-3" style="width: 100%; height: 320px;">
                    <div class="ads-content text-center">
                        <span class="ads-text fs-5 text-warning">VỊ TRÍ HERO BANNER (VIP)</span>
                    </div>
                </a>
            </c:otherwise>
        </c:choose>

        <c:forEach var="i" begin="0" end="6">
            <c:set var="banner" value="${(not empty bannersStd && fn:length(bannersStd) > i) ? bannersStd[i] : null}" />
            <c:choose>
                <c:when test="${not empty banner}">
                    <a href="${banner.targetUrl}" class="mu-item-frame h-banner-box" target="_blank">
                        <img src="${banner.imageUrl}" class="real-ad-img">
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="/banner-register" class="mu-item-frame ads-placeholder h-banner-box">
                        <div class="ads-content d-flex align-items-center gap-3">
                            <i class="fa-regular fa-image click-icon mb-0"></i>
                            <div class="text-start">
                                <div class="ads-text">Banner Ngang ${i + 1}</div>
                            </div>
                        </div>
                    </a>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <div class="server-section">
            <div class="section-header">
                <div class="d-flex align-items-center">
                    <i class="fa-solid fa-dragon text-danger me-2 fs-5"></i>
                    <h3 class="section-title">DANH SÁCH SERVER VIP</h3>
                </div>
                <div class="small text-secondary fst-italic">
                    <i class="fa-solid fa-clock me-1"></i> <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy"/>
                </div>
            </div>

            <div class="srv-header">
                <div class="hdr-left">Thông tin Server</div>
                <div class="hdr-right">
                    <div class="hdr-item">Phiên bản</div>
                    <div class="hdr-item">Reset</div>
                    <div class="hdr-item">Open Beta</div>
                    <div class="hdr-item">Chi tiết</div>
                </div>
            </div>

            <div style="padding: 15px;"> <c:forEach var="sv" items="${superVips}">
                <div class="svip-wrapper">
                    <div class="svip-content">
                        <div class="srv-row-inner">
                            <div class="col-left-identity">

                                <div class="d-flex align-items-center mb-1">

                                    <span class="badge badge-svip me-2">HOT</span>
                                    <a href="/server/detail/${sv.id}" class="name-super-vip">${sv.serverName}</a>
                                </div>
                                <div style="font-size: 0.8rem; color: #ddd; line-height: 1.2;">
                                    <img src="https://cdn.pixabay.com/animation/2025/11/03/21/48/21-48-26-427_512.gif" style="width: 20px; margin-right: 5px;" alt="icon">
                                ${sv.muName}</div>
                                <div class="text-warning fst-italic mt-1 text-truncate" style="font-size: 0.75rem;">
                                    "${sv.slogan}"
                                </div>
                            </div>

                            <div class="col-right-wrapper">
                                <div class="stats-line">
                                    <div class="stat-box"><span class="badge-ver text-warning">${sv.serverStat.muVersion.versionName}</span></div>
                                    <div class="stat-box text-light fw-bold">${sv.serverStat.resetType.resetName}</div>
                                    <div class="stat-box text-danger fw-bold" style="font-size: 1rem;">${sv.schedule.betaDate}</div>
                                    <div class="stat-box"><a href="/server/detail/${sv.id}" class="btn-view btn-view-svip">XEM NGAY</a></div>
                                </div>
                                <div class="banner-line">
                                    <c:choose>
                                        <c:when test="${not empty sv.bannerImage}">
                                            <img src="${sv.bannerImage}" class="inner-banner-img" alt="${sv.serverName}">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://via.placeholder.com/600x60/550000/FFFFFF?text=MU+ONLINE+VIP" class="inner-banner-img">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>

                <c:forEach var="sv" items="${vips}">
                    <div class="vip-wrapper">
                        <div class="vip-content">
                            <div class="srv-row-inner">
                                <div class="col-left-identity">
                                    <div class="d-flex align-items-center mb-1">
                                        <i class="fa-solid fa-star text-warning me-2" style="font-size: 0.7rem;"></i>
                                        <a href="/server/detail/${sv.id}" class="name-vip">${sv.serverName}</a>
                                    </div>
                                    <div style="font-size: 0.75rem; color: #888;">${sv.muName}</div>
                                </div>

                                <div class="col-right-wrapper">
                                    <div class="stats-line">
                                        <div class="stat-box"><span class="badge-ver">${sv.serverStat.muVersion.versionName}</span></div>
                                        <div class="stat-box text-secondary">${sv.serverStat.resetType.resetName}</div>
                                        <div class="stat-box text-light">${sv.schedule.betaDate}</div>
                                        <div class="stat-box"><a href="/server/detail/${sv.id}" class="btn-view">XEM</a></div>
                                    </div>
                                    <div class="banner-line">
                                        <c:if test="${not empty sv.bannerImage}">
                                            <img src="${sv.bannerImage}" class="inner-banner-img" alt="${sv.serverName}">
                                        </c:if>
                                        <c:if test="${empty sv.bannerImage}">
                                            <img src="https://via.placeholder.com/600x50/333333/888888?text=VIP+SERVER" class="inner-banner-img">
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:forEach var="sv" items="${normals}">
                    <div class="normal-wrapper">
                        <div class="srv-row-inner">
                            <div class="col-left-identity">
                                <a href="/server/detail/${sv.id}" class="name-normal mb-1">${sv.serverName}</a>
                                <div style="font-size: 0.75rem; color: #555;">${sv.muName}</div>
                            </div>

                            <div class="col-right-wrapper" style="justify-content: center;">
                                <div class="stats-line mb-0">
                                    <div class="stat-box">
                                        <span class="badge-ver" style="border:none; background:transparent;">${sv.serverStat.muVersion.versionName}</span>
                                    </div>
                                    <div class="stat-box text-secondary small">${sv.serverStat.resetType.resetName}</div>
                                    <div class="stat-box text-secondary small">${sv.schedule.betaDate}</div>
                                    <div class="stat-box">
                                        <a href="/server/detail/${sv.id}" class="btn-view" style="color: #666; border-color: #444;">Xem</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty superVips && empty vips && empty normals}">
                    <div class="text-center text-muted py-5 fst-italic">
                        Hiện chưa có server nào ra mắt hôm nay.
                    </div>
                </c:if>

            </div> </div>
    </main>

    <aside class="sidebar">
        <c:forEach var="i" begin="0" end="2">
            <c:set var="banner" value="${(not empty bannersRight && fn:length(bannersRight) > i) ? bannersRight[i] : null}" />
            <c:choose>
                <c:when test="${not empty banner}">
                    <a href="${banner.targetUrl}" class="mu-item-frame v-banner-box" target="_blank">
                        <img src="${banner.imageUrl}" class="real-ad-img" alt="Quảng cáo">
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="/banner-register" class="mu-item-frame ads-placeholder v-banner-box">
                        <div class="ads-content text-center">
                            <i class="fa-solid fa-plus click-icon"></i>
                            <div class="ads-text">Banner Phải<br>Vị trí ${i + 4}</div>
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