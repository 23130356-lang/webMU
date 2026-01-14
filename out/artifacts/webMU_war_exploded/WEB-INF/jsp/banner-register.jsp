<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thuê Quảng Cáo | Muxua.co Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700;900&family=Rajdhani:wght@500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            /* Palette màu MU Sang trọng */
            --mu-bg: #050505;
            --mu-panel-bg: rgba(15, 10, 10, 0.9);

            --mu-gold: #ffcc00;
            --mu-gold-dark: #b8860b;
            --mu-text-gold: #deb887;

            --mu-red: #ff0000;
            --mu-red-dark: #550000;

            --mu-border: #3d2b1f; /* Màu nâu đất viền */
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

        /* === PAGE HEADER === */
        .page-header h3 {
            font-family: 'Cinzel', serif;
            font-weight: 900;
            text-transform: uppercase;
            background: linear-gradient(180deg, #fff 10%, #ffcc00 50%, #b8860b 90%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-shadow: 0 0 30px rgba(255, 204, 0, 0.3);
            letter-spacing: 2px;
            margin-bottom: 5px;
        }
        .page-header p {
            font-family: 'Cinzel', serif;
            letter-spacing: 3px;
            color: #888;
            font-size: 0.85rem;
            border-bottom: 1px solid #333;
            display: inline-block;
            padding-bottom: 10px;
        }

        /* === COIN BALANCE BADGE === */
        .user-balance-box {
            background: linear-gradient(90deg, rgba(0,0,0,0) 0%, rgba(255, 204, 0, 0.1) 50%, rgba(0,0,0,0) 100%);
            border-top: 1px solid #333;
            border-bottom: 1px solid #333;
            padding: 10px 0;
            margin-bottom: 20px;
            text-align: center;
        }
        .coin-amount {
            font-family: 'Cinzel', serif;
            color: var(--mu-gold);
            font-size: 1.2rem;
            font-weight: bold;
            text-shadow: 0 0 10px rgba(255, 204, 0, 0.4);
        }

        /* === BANNER SLOT (CORE STYLE) === */
        .banner-slot {
            background: var(--mu-panel-bg);
            border: 1px solid var(--mu-border);
            padding: 20px;
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all 0.3s ease-in-out;
            backdrop-filter: blur(5px);
            clip-path: polygon(
                    20px 0, 100% 0,
                    100% calc(100% - 20px), calc(100% - 20px) 100%,
                    0 100%, 0 20px
            );
            box-shadow: 0 10px 30px rgba(0,0,0,0.8);
        }

        .banner-slot:hover {
            transform: translateY(-5px);
            border-color: var(--mu-gold);
            box-shadow: var(--mu-glow-gold);
            z-index: 10;
        }

        .banner-slot::before {
            content: ''; position: absolute; top: 0; left: 0;
            width: 15px; height: 15px;
            border-top: 2px solid #555; border-left: 2px solid #555;
            opacity: 0.5;
        }
        .banner-slot:hover::before { border-color: var(--mu-gold); }

        .slot-title {
            font-family: 'Cinzel', serif;
            font-weight: 700;
            color: #e0e0e0;
            font-size: 1.25rem;
            text-transform: uppercase;
            border-bottom: 1px solid #444;
            padding-bottom: 8px;
            margin-bottom: 15px;
            text-align: center;
        }
        .banner-slot:hover .slot-title { color: var(--mu-gold); border-color: var(--mu-gold-dark); }

        .slot-info { font-size: 0.95rem; color: #888; margin-bottom: 8px; }
        .slot-size { color: var(--mu-text-gold); font-weight: 600; font-family: 'Rajdhani', sans-serif; letter-spacing: 1px; }

        .qty-badge {
            background: #222; border: 1px solid #444;
            color: #fff; padding: 2px 8px; font-size: 0.8rem;
            vertical-align: middle;
        }

        /* New: Giá tiền trong slot */
        .slot-price-tag {
            font-family: 'Rajdhani', sans-serif;
            font-weight: 700;
            font-size: 1.1rem;
            color: #fff;
            background: rgba(0,0,0,0.6);
            border: 1px solid #444;
            padding: 5px 10px;
            display: inline-block;
            margin-bottom: 15px;
            border-radius: 4px;
        }
        .slot-price-tag i { color: var(--mu-gold); margin-right: 5px; }

        .slot-status-label { font-size: 0.75rem; text-transform: uppercase; color: #666; letter-spacing: 1px; text-align: center; }
        .slot-status-text {
            font-family: 'Cinzel', serif; font-size: 1.1rem; font-weight: bold; margin-bottom: 10px; text-align: center;
        }
        .status-available { color: #00ff00; text-shadow: 0 0 8px rgba(0,255,0,0.4); }
        .status-full { color: #ffaa00; text-shadow: 0 0 8px rgba(255,170,0,0.4); }
        .status-vip { color: #ff3333; text-shadow: 0 0 10px rgba(255,51,51,0.6); }

        .slot-vip {
            background: linear-gradient(180deg, rgba(40,0,0,0.8) 0%, rgba(10,0,0,0.9) 100%);
            border-color: var(--mu-red-dark);
        }
        .slot-vip .slot-title { color: var(--mu-red); font-size: 1.5rem; text-shadow: 0 0 10px rgba(139,0,0,0.5); }
        .slot-vip:hover {
            border-color: var(--mu-red);
            box-shadow: var(--mu-glow-red);
        }
        .slot-vip:hover .slot-title { color: #ff5555; text-shadow: 0 0 15px red; }

        /* === BUTTONS === */
        .btn-mu-action {
            background: linear-gradient(90deg, #550000 0%, #8b0000 100%);
            color: #e0e0e0;
            border: 1px solid #a00000;
            font-family: 'Cinzel', serif;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s;
            clip-path: polygon(10px 0, 100% 0, 100% calc(100% - 10px), calc(100% - 10px) 100%, 0 100%, 0 10px);
        }
        .btn-mu-action:hover {
            background: linear-gradient(90deg, #8b0000 0%, #ff0000 100%);
            color: #fff;
            box-shadow: 0 0 15px rgba(255,0,0,0.6);
            border-color: #ff3333;
        }

        .btn-mu-waitlist {
            background: linear-gradient(90deg, #0f2027 0%, #203a43 100%);
            border: 1px solid #444;
            color: #ccc;
            font-family: 'Cinzel', serif;
            text-transform: uppercase;
            clip-path: polygon(10px 0, 100% 0, 100% calc(100% - 10px), calc(100% - 10px) 100%, 0 100%, 0 10px);
        }
        .btn-mu-waitlist:hover {
            background: #2c5364; color: #fff; border-color: #666;
            box-shadow: 0 0 15px rgba(44, 83, 100, 0.5);
        }

        .btn-mu-login {
            border: 1px dashed #555; color: #888; text-transform: uppercase; font-size: 0.85rem;
        }
        .btn-mu-login:hover { border-color: var(--mu-gold); color: var(--mu-gold); }

        /* === VIP NAVIGATOR BOX === */
        .vip-nav-box {
            display: block; position: relative; text-decoration: none;
            background: linear-gradient(90deg, rgba(20,0,0,0.9) 0%, rgba(50,0,0,0.9) 50%, rgba(20,0,0,0.9) 100%);
            border: 1px solid var(--mu-border);
            border-top: 1px solid #7a5c00; border-bottom: 1px solid #7a5c00;
            padding: 15px 25px; transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            overflow: hidden;
            clip-path: polygon(15px 0, 100% 0, 100% calc(100% - 15px), calc(100% - 15px) 100%, 0 100%, 0 15px);
        }
        .vip-nav-box:hover {
            transform: translateY(-3px) scale(1.01);
            border-color: var(--mu-gold);
            box-shadow: 0 0 25px rgba(255, 204, 0, 0.2);
            background: linear-gradient(90deg, #2b0505 0%, #4a0a0a 50%, #2b0505 100%);
        }
        .vip-nav-box::after {
            content: ''; position: absolute; top: 0; left: -120%; width: 60%; height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 215, 0, 0.4), transparent);
            transform: skewX(-25deg); transition: none;
        }
        .vip-nav-box:hover::after { left: 120%; transition: all 0.7s ease-in-out; }
        .vip-nav-title {
            font-family: 'Cinzel', serif; font-weight: 900; font-size: 1.3rem;
            color: var(--mu-gold); text-transform: uppercase; letter-spacing: 1px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.8);
        }
        .vip-nav-desc { font-family: 'Rajdhani', sans-serif; color: #aaa; font-size: 0.95rem; margin-top: 2px; }
        .vip-nav-icon {
            font-size: 1.8rem;
            background: -webkit-linear-gradient(#fff, #ffcc00);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
            filter: drop-shadow(0 0 5px rgba(255, 204, 0, 0.5));
        }
        .vip-nav-arrow { color: var(--mu-red); transition: margin-right 0.3s; }
        .vip-nav-box:hover .vip-nav-arrow { margin-right: -5px; color: var(--mu-gold); }

        /* === MARKETING SECTION === */
        .marketing-section {
            margin-top: 5rem; padding: 3rem; background: rgba(0, 0, 0, 0.6);
            border: 1px solid var(--mu-gold-dark); position: relative;
        }
        .marketing-section::after {
            content: ''; position: absolute; top: -1px; left: -1px; width: 30px; height: 30px;
            border-top: 3px solid var(--mu-gold); border-left: 3px solid var(--mu-gold);
        }
        .marketing-section::before {
            content: ''; position: absolute; bottom: -1px; right: -1px; width: 30px; height: 30px;
            border-bottom: 3px solid var(--mu-gold); border-right: 3px solid var(--mu-gold);
        }
        .marketing-title {
            color: var(--mu-gold); font-family: 'Cinzel', serif; text-align: center;
            font-weight: 700; text-shadow: 0 0 10px rgba(184, 134, 11, 0.3); margin-bottom: 2rem;
        }
        .marketing-subtitle {
            font-family: 'Cinzel', serif; border-left: 4px solid var(--mu-red);
            padding-left: 15px; margin-top: 30px; margin-bottom: 15px;
        }
        .marketing-list li { margin-bottom: 10px; font-size: 1.05rem; }
        .highlight-text { color: var(--mu-text-gold); font-weight: bold; }

        /* === MODAL === */
        .modal-content {
            background: #0f0f0f; border: 1px solid var(--mu-gold-dark);
            box-shadow: 0 0 50px rgba(0,0,0,0.9);
        }
        .modal-custom-header {
            background: linear-gradient(90deg, #330000, #110000); border-bottom: 1px solid #333;
        }
        .form-control {
            background: #1a1a1a; border: 1px solid #333; color: #eee;
        }
        .form-control:focus {
            background: #222; border-color: var(--mu-gold); color: #fff; box-shadow: none;
        }

        /* Modal Price Box */
        .modal-price-box {
            background: rgba(0,0,0,0.5); border: 1px dashed #555;
            padding: 10px; margin-bottom: 20px; border-radius: 5px;
        }
        .price-row {
            display: flex; justify-content: space-between; margin-bottom: 5px; font-size: 0.9rem;
        }
        .price-row.total {
            border-top: 1px solid #444; padding-top: 8px; margin-top: 8px; font-weight: bold; font-size: 1rem; color: #fff;
        }
        .text-coin { color: var(--mu-gold); }
        /* Thêm style cho nút bị khóa */
        .btn-locked {
            background-color: #343a40 !important;
            border-color: #454d55 !important;
            color: #adb5bd !important;
            cursor: not-allowed;
            opacity: 0.8;
        }
        .next-available-text {
            color: #ffc107; /* Màu vàng */
            font-size: 0.8rem;
            font-weight: bold;
            margin-top: 8px;
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0% { opacity: 0.8; }
            50% { opacity: 1; text-shadow: 0 0 5px #ffc107; }
            100% { opacity: 0.8; }
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="page-wrapper pt-5 pb-5">
    <div class="container">

        <div class="page-header text-center">
            <h3><i class="fa-solid fa-dragon me-2"></i> Bảng Giá & Đăng Ký Quảng Cáo</h3>
            <p>Khẳng định đẳng cấp Server - Tiếp cận cộng đồng Game thủ</p>
        </div>

        <c:if test="${not empty currentUser}">
            <div class="user-balance-box">
                <span class="text-secondary text-uppercase small me-2">Số dư của bạn:</span>
                <span class="coin-amount">
                    <i class="fa-solid fa-coins"></i>
                    <fmt:formatNumber value="${currentUser.coin != null ? currentUser.coin : 0}" pattern="#,###"/> Coin
                </span>
                <a href="/nap-tien" class="btn btn-sm btn-outline-warning ms-3" style="font-size: 0.7rem;">
                    <i class="fa-solid fa-plus"></i> Nạp thêm
                </a>
            </div>
        </c:if>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success bg-dark border-success text-success text-center mb-4">
                <i class="bi bi-check-circle-fill"></i> ${successMessage}
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger bg-dark border-danger text-danger text-center mb-4">
                <i class="bi bi-exclamation-triangle-fill"></i> ${errorMessage}
            </div>
        </c:if>

        <div class="row g-4 align-items-stretch">

            <div class="col-md-3 d-flex align-items-center">
                <div class="banner-slot w-100" style="height: 380px;">
                    <div>
                        <div class="slot-title">Banner Trái</div>
                        <div class="text-center px-2">
                            <div class="slot-price-tag">
                                <i class="fa-solid fa-tag"></i>
                                <fmt:formatNumber value="${prices['LEFT_SIDEBAR'] != null ? prices['LEFT_SIDEBAR'] : 0}" pattern="#,###"/> Coin
                            </div>
                            <div class="slot-info">
                                <i class="bi bi-aspect-ratio me-1"></i> <span class="slot-size">280 x 500 px</span>
                            </div>
                            <div class="slot-info">
                                Đã đặt: <span class="qty-badge">${qtyInfo['LEFT_SIDEBAR']}</span>
                            </div>
                            <div class="slot-status-label mt-3">Tình trạng</div>
                            <div class="slot-status-text ${isFullLeft ? 'status-full' : 'status-available'}">
                                ${availability['LEFT_SIDEBAR']}
                            </div>
                        </div>
                    </div>

                    <div class="w-100 mt-4 px-2">
                        <c:choose>
                            <c:when test="${not empty currentUser && !isFullLeft}">
                                <button class="btn btn-mu-action w-100 py-2"
                                        onclick="openRegisterModal('LEFT_SIDEBAR', 'Banner Trái', ${prices['LEFT_SIDEBAR'] != null ? prices['LEFT_SIDEBAR'] : 0})">
                                    Thuê Ngay
                                </button>
                            </c:when>
                            <c:when test="${not empty currentUser && isFullLeft}">
                                <button class="btn btn-locked w-100 py-2" disabled>
                                    <i class="fa-solid fa-lock"></i> Đã Hết Slot
                                </button>
                                <div class="text-center mt-2">
                                    <small class="text-secondary">Trống sau:</small>
                                    <div class="countdown-timer fw-bold text-warning fs-6"
                                         data-countdown="${nextAvailableMap['LEFT_SIDEBAR']}">
                                        Đang tính toán...
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise><a href="/login" class="btn btn-mu-login w-100">Đăng nhập</a></c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="d-flex flex-column h-100 gap-4">

                    <div class="banner-slot slot-vip flex-fill">
                        <div class="position-absolute top-0 end-0 p-3 text-danger" style="filter: drop-shadow(0 0 5px red);"><i class="fa-solid fa-crown fa-2x"></i></div>

                        <div>
                            <div class="slot-title">BANNER GIỮA (VIP)</div>
                            <div class="text-center px-4">
                                <div class="slot-price-tag border-danger text-warning">
                                    <i class="fa-solid fa-gem"></i>
                                    <fmt:formatNumber value="${prices['HERO'] != null ? prices['HERO'] : 0}" pattern="#,###"/> Coin
                                </div>
                                <div class="slot-info text-light">
                                    <i class="bi bi-aspect-ratio me-1"></i> <span class="slot-size text-warning" style="font-size: 1.1rem">1200 x 250 px</span>
                                </div>
                                <div class="slot-info">
                                    Đã đặt: <span class="qty-badge bg-danger border-danger">${qtyInfo['HERO']}</span>
                                </div>
                                <div class="slot-status-label mt-3 text-warning">Tình trạng</div>
                                <div class="slot-status-text ${isFullHero ? 'status-full' : 'status-vip'}">
                                    ${availability['HERO']}
                                </div>
                            </div>
                        </div>

                        <div class="w-75 mx-auto mt-3">
                            <c:choose>
                                <c:when test="${not empty currentUser && !isFullHero}">
                                    <button class="btn btn-mu-action w-100 py-3 fs-5"
                                            onclick="openRegisterModal('HERO', 'Banner VIP Center', ${prices['HERO'] != null ? prices['HERO'] : 0})">
                                        THUÊ VỊ TRÍ VIP
                                    </button>
                                </c:when>
                                <c:when test="${not empty currentUser && isFullHero}">
                                    <button class="btn btn-locked w-100 py-3 fs-5" disabled>
                                        <i class="fa-solid fa-lock"></i> TẠM HẾT SLOT
                                    </button>
                                    <div class="text-center mt-2">
                                        <small class="text-secondary">Trống sau:</small>
                                        <div class="countdown-timer fw-bold text-warning fs-6"
                                             data-countdown="${nextAvailableMap['HERO']}">
                                            Đang tính toán...
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise><a href="/login" class="btn btn-mu-login w-100">Đăng nhập</a></c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="banner-slot flex-fill" style="min-height: auto;">
                        <div class="d-flex align-items-center justify-content-between w-100 px-2">
                            <div class="text-start">
                                <div class="slot-title border-0 mb-0 text-start" style="font-size: 1.1rem">Banner Giữa (Nhỏ)</div>
                                <div class="text-warning small mb-1 fw-bold">
                                    <i class="fa-solid fa-tag"></i> <fmt:formatNumber value="${prices['STD'] != null ? prices['STD'] : 0}" pattern="#,###"/> Coin
                                </div>
                                <div class="slot-size mb-1">1200 x 120 px</div>
                                <div class="slot-info mb-0" style="font-size: 0.9rem;">
                                    Đã đặt: <span class="qty-badge">${qtyInfo['STD']}</span>
                                </div>
                            </div>

                            <div class="text-end">
                                <div class="slot-status-text mb-1 ${isFullStd ? 'status-full' : 'status-available'}" style="font-size: 1rem">
                                    ${availability['STD']}
                                </div>
                                <c:choose>
                                    <c:when test="${not empty currentUser && !isFullStd}">
                                        <button class="btn btn-mu-action btn-sm px-4"
                                                onclick="openRegisterModal('STD', 'Banner Giữa Nhỏ', ${prices['STD'] != null ? prices['STD'] : 0})">
                                            Thuê Ngay
                                        </button>
                                    </c:when>
                                    <c:when test="${not empty currentUser && isFullStd}">
                                        <button class="btn btn-locked btn-sm px-3" disabled>
                                            <i class="fa-solid fa-lock"></i> Khóa
                                        </button>
                                        <div class="text-center mt-2">
                                            <small class="text-secondary">Trống sau:</small>
                                            <div class="countdown-timer fw-bold text-warning fs-6"
                                                 data-countdown="${nextAvailableMap['STD']}">
                                                Đang tính toán...
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise><a href="/login" class="btn btn-mu-login btn-sm px-3">Đăng nhập</a></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <a href="/server/register" class="vip-nav-box">
                        <div class="d-flex align-items-center justify-content-between">
                            <div class="me-3">
                                <i class="fa-solid fa-gem vip-nav-icon"></i>
                            </div>

                            <div class="flex-grow-1">
                                <div class="vip-nav-title">
                                    ĐĂNG MU VIP TẠI ĐÂY
                                    <span class="badge bg-danger text-white border border-warning ms-2" style="font-size: 0.6rem; vertical-align: middle;">HOT</span>
                                </div>
                                <div class="vip-nav-desc">
                                    <i class="bi bi-stars text-warning me-1"></i> Tổng hợp các máy chủ Alpha Test & Open Beta đáng chơi nhất
                                </div>
                            </div>

                            <div class="ms-3">
                                <i class="fa-solid fa-chevron-right fa-lg vip-nav-arrow"></i>
                            </div>
                        </div>
                    </a>
                </div>
            </div>

            <div class="col-md-3 d-flex align-items-center">
                <div class="banner-slot w-100" style="height: 380px;">
                    <div>
                        <div class="slot-title">Banner Phải</div>
                        <div class="text-center px-2">
                            <div class="slot-price-tag">
                                <i class="fa-solid fa-tag"></i>
                                <fmt:formatNumber value="${prices['RIGHT_SIDEBAR'] != null ? prices['RIGHT_SIDEBAR'] : 0}" pattern="#,###"/> Coin
                            </div>
                            <div class="slot-info">
                                <i class="bi bi-aspect-ratio me-1"></i> <span class="slot-size">280 x 500 px</span>
                            </div>
                            <div class="slot-info">
                                Đã đặt: <span class="qty-badge">${qtyInfo['RIGHT_SIDEBAR']}</span>
                            </div>
                            <div class="slot-status-label mt-3">Tình trạng</div>
                            <div class="slot-status-text ${isFullRight ? 'status-full' : 'status-available'}">
                                ${availability['RIGHT_SIDEBAR']}
                            </div>
                        </div>
                    </div>

                    <div class="w-100 mt-4 px-2">
                        <c:choose>
                            <%-- TRƯỜNG HỢP 1: CÒN SLOT --%>
                            <c:when test="${not empty currentUser && !isFullRight}">
                                <button class="btn btn-mu-action w-100 py-2"
                                        onclick="openRegisterModal('RIGHT_SIDEBAR', 'Banner Phải', ${prices['RIGHT_SIDEBAR'] != null ? prices['RIGHT_SIDEBAR'] : 0})">
                                    Thuê Ngay
                                </button>
                            </c:when>

                            <%-- TRƯỜNG HỢP 2: FULL SLOT -> HIỆN ĐẾM NGƯỢC --%>
                            <c:when test="${not empty currentUser && isFullRight}">
                                <button class="btn btn-locked w-100 py-2" disabled>
                                    <i class="fa-solid fa-lock"></i> Hết Slot
                                </button>

                                <div class="text-center mt-2">
                                    <small class="text-secondary" style="font-size: 0.75rem">Sẽ trống sau:</small>
                                    <div class="countdown-timer fw-bold text-warning small w-100"
                                         data-countdown="${nextAvailableMap['RIGHT_SIDEBAR']}">
                                        <i class="fas fa-spinner fa-spin"></i> ...
                                    </div>
                                </div>
                            </c:when>

                            <%-- TRƯỜNG HỢP 3: CHƯA ĐĂNG NHẬP --%>
                            <c:otherwise>
                                <a href="/login" class="btn btn-mu-login w-100">Đăng nhập</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <div class="marketing-section">
            <h2 class="marketing-title">QUẢNG CÁO TẠI MUXUA.CO - CỘNG ĐỒNG MU LỚN NHẤT</h2>
            <div class="row">
                <div class="col-lg-10 mx-auto">
                    <ul class="marketing-list text-secondary fa-ul ms-4">
                        <li><span class="fa-li"><i class="fa-solid fa-check text-success"></i></span>Thống kê có hơn <strong class="text-white">6.000 Admin Mu Online</strong> đã tin tưởng và sử dụng dịch vụ.</li>
                        <li><span class="fa-li"><i class="fa-solid fa-check text-success"></i></span>Hơn <strong class="text-white">16.800 Game Mu Online</strong> đăng bài giới thiệu, tiếp cận hàng vạn game thủ.</li>
                        <li><span class="fa-li"><i class="fa-solid fa-check text-success"></i></span>Giải pháp Marketing toàn diện: <strong class="text-white">Banner, VIP Ghim Bài & Facebook Ads.</strong></li>
                    </ul>
                    <div class="p-3 my-4 fst-italic text-center" style="background: rgba(0,0,0,0.5); border-left: 3px solid var(--mu-red);">
                        "Ngay cả khi... Mu bạn mới không ai tới?<br>
                        Ngay cả khi... Mu bạn cũ bị gamer phũ?<br>
                        Ngay cả khi... Mu chà bá, cần bứt phá?"
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="registerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header modal-custom-header" id="modalHeaderBg">
                <h5 class="modal-title fw-bold text-warning" id="modalTitle">ĐĂNG KÝ</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <c:url var="postUrl" value="/banner-register"/>
                <form action="${postUrl}" method="post" enctype="multipart/form-data" id="bannerForm">
                    <sec:csrfInput />
                    <input type="hidden" name="positionCode" id="hiddenPosCode">
                    <div class="modal-price-box">
                        <div class="price-row">
                            <span class="text-secondary">Số dư hiện tại:</span>
                            <span class="text-white" id="modalCurrentBalance">0</span>
                        </div>
                        <div class="price-row">
                            <span class="text-secondary">Chi phí:</span>
                            <span class="text-danger" id="modalPrice">- 0</span>
                        </div>
                        <div class="price-row total">
                            <span>Số dư sau mua:</span>
                            <span id="modalRemaining" class="text-coin">0</span>
                        </div>
                        <div id="insufficientFundsMsg" class="text-danger text-center mt-2 small d-none fw-bold">
                            <i class="bi bi-x-circle"></i> Số dư không đủ! Vui lòng nạp thêm.
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label text-secondary small text-uppercase fw-bold">Chọn nguồn ảnh</label>
                        <div class="d-flex gap-4">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="uploadType" id="optUpload" value="file" checked onchange="toggleImageInput()">
                                <label class="form-check-label text-white" for="optUpload">
                                    <i class="fa-solid fa-cloud-arrow-up me-1"></i> Tải ảnh lên
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="uploadType" id="optLink" value="url" onchange="toggleImageInput()">
                                <label class="form-check-label text-white" for="optLink">
                                    <i class="fa-solid fa-link me-1"></i> Dùng Link ảnh
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="mb-3" id="groupFile">
                        <label class="form-label text-secondary small text-uppercase fw-bold">Chọn file (Ảnh/Gif)</label>
                        <div class="input-group">
                            <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fa-solid fa-file-image"></i></span>
                            <input type="file" name="imageFile" id="inputImageFile" class="form-control" accept="image/png, image/jpeg, image/gif" required>
                        </div>
                        <div class="form-text text-muted small">Hỗ trợ: JPG, PNG, GIF (Tối đa 5MB)</div>
                    </div>
                    <div class="mb-3 d-none" id="groupUrl">
                        <label class="form-label text-secondary small text-uppercase fw-bold">Dán Link Ảnh</label>
                        <div class="input-group">
                            <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fa-solid fa-globe"></i></span>
                            <input type="url" name="imageUrl" id="inputImageUrl" class="form-control" placeholder="https://imgur.com/example.gif">
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label text-secondary small text-uppercase fw-bold">Link Đích (Target URL)</label>
                        <div class="input-group">
                            <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fa-solid fa-link"></i></span>
                            <input type="url" name="targetUrl" class="form-control" placeholder="https://mu-server-cuaban.com" required>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-mu-action w-100 py-2" id="btnSubmit">
                        <i class="fa-solid fa-scroll me-2"></i> THANH TOÁN & ĐĂNG KÝ
                    </button>

                    <a href="/nap-tien" id="btnRecharge" class="btn btn-outline-warning w-100 py-2 d-none">
                        <i class="fa-solid fa-coins me-2"></i> NẠP TIỀN NGAY
                    </a>
                </form>
            </div>
        </div>
    </div>
</div>
<script>
    // Hàm chạy đếm ngược
    function startCountdowns() {
        const timers = document.querySelectorAll('[data-countdown]');

        timers.forEach(timer => {
            const dateString = timer.getAttribute('data-countdown');
            if (!dateString || dateString === 'null') {
                timer.innerHTML = "Liên hệ Admin";
                return;
            }

            // Chuyển chuỗi ISO từ Java thành đối tượng Date của JS
            const countDownDate = new Date(dateString).getTime();
            const now = new Date().getTime();
            const distance = countDownDate - now;

            if (distance < 0) {
                // Nếu hết giờ đếm ngược -> Reload trang để hiện nút Mua
                timer.innerHTML = '<span class="text-success">Đã có slot! Vui lòng F5</span>';
                // Tùy chọn: location.reload();
                return;
            }

            // Tính toán thời gian
            const days = Math.floor(distance / (1000 * 60 * 60 * 24));
            const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((distance % (1000 * 60)) / 1000);

            // Hiển thị kết quả đẹp
            let output = "";
            if (days > 0) output += days + "d : ";
            output += (hours < 10 ? "0" + hours : hours) + "h : ";
            output += (minutes < 10 ? "0" + minutes : minutes) + "m : ";
            output += (seconds < 10 ? "0" + seconds : seconds) + "s";

            timer.innerHTML = '<i class="bi bi-alarm"></i> ' + output;
        });
    }

    // Cập nhật mỗi 1 giây
    setInterval(startCountdowns, 1000);

    // Chạy ngay lập tức khi tải trang để không bị delay 1s đầu
    startCountdowns();
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const userCoin = ${not empty currentUser && not empty currentUser.coin ? currentUser.coin : 0};

    function toggleImageInput() {
        const isUpload = document.getElementById('optUpload').checked;
        const groupFile = document.getElementById('groupFile');
        const groupUrl = document.getElementById('groupUrl');
        const inputFile = document.getElementById('inputImageFile');
        const inputUrl = document.getElementById('inputImageUrl');

        if (isUpload) {
            groupFile.classList.remove('d-none');
            groupUrl.classList.add('d-none');
            inputFile.setAttribute('required', '');
            inputUrl.removeAttribute('required');
            inputUrl.value = '';
        } else {
            groupFile.classList.add('d-none');
            groupUrl.classList.remove('d-none');
            inputUrl.setAttribute('required', '');
            inputFile.removeAttribute('required');
            inputFile.value = '';
        }
    }

    function formatMoney(n) {
        if (!n) return '0';
        return n.toFixed(0).replace(/./g, function(c, i, a) {
            return i > 0 && c !== "." && (a.length - i) % 3 === 0 ? "." + c : c;
        });
    }

    // Đã xóa tham số isWaitlist vì không dùng nữa
    function openRegisterModal(code, name, price) {
        if (price === undefined || price === null) price = 0;

        document.getElementById('hiddenPosCode').value = code;

        var headerBg = document.getElementById('modalHeaderBg');
        var title = document.getElementById('modalTitle');
        var btnSubmit = document.getElementById('btnSubmit');
        var btnRecharge = document.getElementById('btnRecharge');
        var msgError = document.getElementById('insufficientFundsMsg');

        // Render thông tin
        document.getElementById('modalCurrentBalance').innerText = formatMoney(userCoin) + ' Coin';
        document.getElementById('modalPrice').innerText = '- ' + formatMoney(price) + ' Coin';

        var remaining = userCoin - price;
        document.getElementById('modalRemaining').innerText = formatMoney(remaining) + ' Coin';

        var isEnoughMoney = remaining >= 0;

        // Luôn hiển thị giao diện Mua ngay (vì nếu Full thì nút ở ngoài đã bị khóa rồi)
        headerBg.style.background = 'linear-gradient(90deg, #550000, #220000)';
        title.innerHTML = '<i class="fa-solid fa-bolt me-2"></i> THUÊ NGAY: ' + name;
        title.className = "modal-title fw-bold text-warning";

        if (!isEnoughMoney) {
            document.getElementById('modalRemaining').classList.remove('text-coin');
            document.getElementById('modalRemaining').classList.add('text-danger');

            btnSubmit.classList.add('d-none');
            btnRecharge.classList.remove('d-none');
            msgError.classList.remove('d-none');
        } else {
            document.getElementById('modalRemaining').classList.add('text-coin');
            document.getElementById('modalRemaining').classList.remove('text-danger');

            btnSubmit.classList.remove('d-none');
            btnRecharge.classList.add('d-none');
            msgError.classList.add('d-none');
        }

        var myModal = new bootstrap.Modal(document.getElementById('registerModal'));
        myModal.show();
    }
</script>
</body>
</html>