<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${server.serverName} | Muxua.co Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700;900&family=Rajdhani:wght@500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            /* Palette màu MU Sang trọng (Giữ nguyên từ code mẫu của bạn) */
            --mu-bg: #050505;
            --mu-panel-bg: rgba(15, 10, 10, 0.9);
            --mu-gold: #ffcc00;
            --mu-gold-dark: #b8860b;
            --mu-text-gold: #deb887;
            --mu-red: #ff0000;
            --mu-red-dark: #550000;
            --mu-border: #3d2b1f;
            --mu-glow-gold: 0 0 20px rgba(255, 204, 0, 0.3);
            --mu-glow-red: 0 0 25px rgba(255, 0, 0, 0.5);
        }

        body {
            background-color: var(--mu-bg);
            background-image: radial-gradient(circle at 50% 30%, #2a0505 0%, #000000 70%);
            background-attachment: fixed;
            font-family: 'Rajdhani', sans-serif;
            color: #ccc;
            min-height: 100vh;
        }

        /* === TYPOGRAPHY === */
        .server-header h1 {
            font-family: 'Cinzel', serif;
            font-weight: 900;
            text-transform: uppercase;
            background: linear-gradient(180deg, #fff 10%, #ffcc00 50%, #b8860b 90%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-shadow: 0 0 30px rgba(255, 204, 0, 0.3);
            margin-bottom: 0;
        }
        .server-mu-name {
            font-family: 'Cinzel', serif;
            letter-spacing: 3px;
            color: #888;
            font-size: 1rem;
            border-bottom: 1px solid #333;
            display: inline-block;
            padding-bottom: 5px;
            margin-bottom: 20px;
        }

        /* === LAYOUT CONTAINERS === */
        .detail-panel {
            background: var(--mu-panel-bg);
            border: 1px solid var(--mu-border);
            padding: 20px;
            height: 100%;
            backdrop-filter: blur(5px);
            /* Cắt vát 4 góc */
            clip-path: polygon(
                    15px 0, 100% 0,
                    100% calc(100% - 15px), calc(100% - 15px) 100%,
                    0 100%, 0 15px
            );
            box-shadow: 0 10px 30px rgba(0,0,0,0.8);
            display: flex;
            flex-direction: column;
        }

        /* === SCHEDULE BOXES === */
        .schedule-row {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }
        .schedule-item {
            flex: 1;
            background: rgba(0,0,0,0.4);
            border: 1px solid #333;
            padding: 15px;
            text-align: center;
            border-radius: 4px; /* Nhẹ nhàng hơn clip-path cho box con */
            transition: 0.3s;
        }
        .schedule-title {
            font-family: 'Cinzel', serif;
            font-weight: 700;
            text-transform: uppercase;
            font-size: 0.9rem;
            margin-bottom: 5px;
        }
        .schedule-time {
            font-family: 'Rajdhani', sans-serif;
            font-size: 1.4rem;
            font-weight: 700;
            color: #fff;
        }
        .schedule-date {
            font-size: 1.5rem;
            color: #aaa;
        }

        /* Alpha Style */
        .sch-alpha { border-color: #004466; }
        .sch-alpha .schedule-title { color: #00d2ff; }
        .sch-alpha:hover { box-shadow: 0 0 15px rgba(0, 210, 255, 0.2); border-color: #00d2ff; }

        /* Beta Style */
        .sch-beta { border-color: #660000; background: linear-gradient(180deg, rgba(40,0,0,0.5) 0%, rgba(10,0,0,0.5) 100%); }
        .sch-beta .schedule-title { color: #ff3333; }
        .sch-beta .schedule-time { text-shadow: 0 0 10px rgba(255, 51, 51, 0.5); }
        .sch-beta:hover { box-shadow: var(--mu-glow-red); border-color: var(--mu-red); }

        /* === INFO GRID (SPECS) === */
        .spec-list {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin-bottom: 20px;
        }
        .spec-item {
            background: rgba(255, 255, 255, 0.03);
            border-left: 3px solid #333;
            padding: 8px 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .spec-item:hover { background: rgba(255, 204, 0, 0.05); border-left-color: var(--mu-gold); }
        .spec-label { font-size: 0.85rem; text-transform: uppercase; color: #888; }
        .spec-value { font-weight: 700; color: #e0e0e0; font-size: 1.1rem; }
        .spec-highlight { color: var(--mu-gold); }

        /* === DESCRIPTION BOX === */
        .desc-container {
            flex-grow: 1;
            background: rgba(0,0,0,0.3);
            border: 1px solid #333;
            padding: 15px;
            overflow-y: auto;
            max-height: 400px; /* Giới hạn chiều cao để không vỡ layout */
            color: #ccc;
            font-size: 0.95rem;
            line-height: 1.6;
            white-space: pre-wrap;
        }
        /* Custom Scrollbar */
        .desc-container::-webkit-scrollbar { width: 6px; }
        .desc-container::-webkit-scrollbar-track { background: #111; }
        .desc-container::-webkit-scrollbar-thumb { background: #444; }
        .desc-container::-webkit-scrollbar-thumb:hover { background: var(--mu-gold); }

        /* === BUTTONS === */
        .btn-mu-main {
            background: linear-gradient(90deg, #550000 0%, #8b0000 100%);
            color: #fff;
            border: 1px solid #a00000;
            font-family: 'Cinzel', serif;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            width: 100%;
            padding: 12px;
            clip-path: polygon(10px 0, 100% 0, 100% calc(100% - 10px), calc(100% - 10px) 100%, 0 100%, 0 10px);
            transition: all 0.3s;
            text-decoration: none;
            display: block;
            text-align: center;
            margin-bottom: 10px;
        }
        .btn-mu-main:hover {
            background: linear-gradient(90deg, #8b0000 0%, #ff0000 100%);
            color: #fff;
            box-shadow: 0 0 15px rgba(255,0,0,0.6);
            border-color: #ff3333;
        }

        .btn-mu-sub {
            background: linear-gradient(90deg, #b8860b 0%, #daa520 100%);
            color: #000;
            border: 1px solid #ffd700;
        }
        .btn-mu-sub:hover {
            background: linear-gradient(90deg, #daa520 0%, #ffd700 100%);
            box-shadow: 0 0 15px rgba(255, 215, 0, 0.4);
            color: #000;
        }

        .status-badge {
            font-family: 'Cinzel', serif;
            font-size: 0.8rem;
            padding: 5px 10px;
            border: 1px solid;
            text-transform: uppercase;
        }
        .text-muted {
            color: #e4e4e4 !important;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container pt-5 pb-5">

    <div class="text-center server-header mb-4">
        <h1>${server.serverName}</h1>
        <div class="server-mu-name">${server.muName}</div>

        <div class="d-flex justify-content-center gap-2">
            <c:if test="${server.bannerPackage == 'VIP' || server.bannerPackage == 'SUPER_VIP'}">
                <span class="status-badge" style="color: var(--mu-gold); border-color: var(--mu-gold);">
                    <i class="fa-solid fa-crown me-1"></i> VIP SERVER
                </span>
            </c:if>
            <span class="status-badge" style="color: #aaa; border-color: #555;">
                <i class="fa-solid fa-tag me-1"></i> ${server.slogan}
            </span>
        </div>
    </div>

    <div class="row g-4">

        <div class="col-lg-4">
            <div class="detail-panel">
                <div style="font-family: 'Cinzel', serif; color: var(--mu-gold); margin-bottom: 15px; border-bottom: 1px solid #333; padding-bottom: 5px;">
                    <i class="fa-solid fa-gears me-2"></i> Thông Tin Server
                </div>

                <div class="spec-list">
                    <div class="spec-item">
                        <span class="spec-label">Version</span>
                        <span class="spec-value text-white">${server.serverStat.muVersion.versionName}</span>
                    </div>
                    <div class="spec-item">
                        <span class="spec-label">Exp</span>
                        <span class="spec-value spec-highlight">x${server.serverStat.expRate}</span>
                    </div>
                    <div class="spec-item">
                        <span class="spec-label">Drop</span>
                        <span class="spec-value">${server.serverStat.dropRate}%</span>
                    </div>
                    <div class="spec-item">
                        <span class="spec-label">Anti-Hack</span>
                        <span class="spec-value text-success">${server.serverStat.antiHack}</span>
                    </div>
                </div>

                <div class="spec-item mb-2">
                    <span class="spec-label">Reset Type</span>
                    <span class="spec-value">
                        <c:out value="${server.serverStat.resetType.resetName}" default="Thường" />
                    </span>
                </div>
                <div class="spec-item mb-4">
                    <span class="spec-label">Point Type</span>
                    <span class="spec-value">
                        <c:out value="${server.serverStat.pointType.pointName}" default="Thường" />
                    </span>
                </div>

                <div class="mt-auto">
                    <a href="${server.websiteUrl}" target="_blank" class="btn-mu-main btn-mu-sub">
                        <i class="fa-solid fa-globe me-2"></i> Trang Chủ
                    </a>
                    <a href="${server.fanpageUrl}" target="_blank" class="btn-mu-main">
                        <i class="fa-brands fa-facebook me-2"></i> Fanpage
                    </a>
                    <a href="/" class="btn btn-sm btn-outline-secondary w-100 mt-2 border-0">
                        <i class="fa-solid fa-arrow-left me-1"></i> Quay lại
                    </a>
                </div>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="detail-panel">

                <div class="schedule-row">
                    <div class="schedule-item sch-alpha">
                        <div class="schedule-title">Alpha Test</div>
                        <c:choose>
                            <c:when test="${not empty server.schedule.alphaDate}">
                                <div class="schedule-time">${server.schedule.alphaTime}</div>
                                <div class="schedule-date">
                                    <fmt:parseDate value="${server.schedule.alphaDate}" pattern="yyyy-MM-dd" var="pAlpha" type="date"/>
                                    <fmt:formatDate value="${pAlpha}" pattern="dd/MM/yyyy"/>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="schedule-date text-muted mt-2">Chưa cập nhật</div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="schedule-item sch-beta">
                        <div class="schedule-title"><i class="fa-solid fa-fire me-1"></i> Open Beta</div>
                        <c:choose>
                            <c:when test="${not empty server.schedule.betaDate}">
                                <div class="schedule-time">${server.schedule.betaTime}</div>
                                <div class="schedule-date">
                                    <fmt:parseDate value="${server.schedule.betaDate}" pattern="yyyy-MM-dd" var="pBeta" type="date"/>
                                    <fmt:formatDate value="${pBeta}" pattern="dd/MM/yyyy"/>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="schedule-time" style="font-size: 1.2rem; margin-top: 5px;">Coming Soon</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div style="font-family: 'Cinzel', serif; color: #fff; margin-bottom: 10px; border-bottom: 1px solid #333; padding-bottom: 5px;">
                    <i class="fa-solid fa-scroll me-2 text-warning"></i> Giới Thiệu
                </div>

                <div class="desc-container">
                    <c:out value="${server.description}" escapeXml="false"/>
                </div>

            </div>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>