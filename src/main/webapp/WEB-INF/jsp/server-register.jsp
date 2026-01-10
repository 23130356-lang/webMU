<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Server Mới | MU Ads Portal</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">

    <style>
        :root {
            --mu-gold: #cfaa56;
            --mu-red: #8b0000;
            --mu-red-hover: #b30000;
            --mu-dark: #05070a;
            --mu-glass: rgba(10, 15, 20, 0.85);
            --mu-input-bg: rgba(0, 0, 0, 0.4);
        }

        body {
            background-color: var(--mu-dark);
            font-family: 'Inter', sans-serif;
            color: #e0e0e0;
            margin: 0;
            padding: 0;
        }

        /* Background chung cho toàn trang */
        .page-wrapper {
            position: relative;
            min-height: 100vh;
            padding-bottom: 50px;
            background: url('https://wallpaperaccess.com/full/1524368.jpg') no-repeat center center/cover;
            background-attachment: fixed; /* Tạo hiệu ứng parallax khi cuộn */
        }

        .page-wrapper::before {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: radial-gradient(circle, rgba(0,0,0,0.6) 0%, rgba(0,0,0,0.95) 100%);
            z-index: 0;
        }

        .content-container {
            position: relative;
            z-index: 1;
            padding-top: 40px;
        }

        /* === GAME CARD STYLE === */
        .game-card {
            background: var(--mu-glass);
            backdrop-filter: blur(10px);
            border: 1px solid #333;
            border-radius: 8px;
            box-shadow: 0 0 30px rgba(0, 0, 0, 0.8), 0 0 10px rgba(207, 170, 86, 0.1);
            overflow: hidden;
            position: relative;
        }

        /* Viền vàng trên cùng */
        .game-card::after {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, transparent, var(--mu-gold), transparent);
            box-shadow: 0 0 15px var(--mu-gold);
        }

        /* Header của Card */
        .card-header-custom {
            text-align: center;
            padding: 30px 20px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .card-header-custom h2 {
            font-family: 'Cinzel', serif;
            color: var(--mu-gold);
            font-weight: 700;
            text-transform: uppercase;
            text-shadow: 0 2px 5px rgba(0,0,0,0.8);
            margin-bottom: 5px;
        }

        .card-header-custom p {
            color: #aaa;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin: 0;
        }

        /* === SECTION TITLES === */
        .section-title {
            font-family: 'Cinzel', serif;
            color: #fff;
            font-size: 1.2rem;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid rgba(207, 170, 86, 0.3);
            display: flex;
            align-items: center;
        }
        .section-title i {
            color: var(--mu-gold);
            margin-right: 10px;
        }

        /* === INPUT STYLES === */
        .form-label {
            color: #ccc;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .input-group-text {
            background-color: rgba(255, 255, 255, 0.05);
            border: 1px solid #444;
            color: var(--mu-gold);
            border-right: none;
        }

        .form-control, .form-select {
            background-color: var(--mu-input-bg) !important;
            border: 1px solid #444;
            color: #fff !important;
            font-size: 0.95rem;
        }

        .form-control:focus, .form-select:focus {
            background-color: rgba(0,0,0,0.6) !important;
            border-color: var(--mu-gold);
            box-shadow: 0 0 8px rgba(207, 170, 86, 0.3);
        }

        /* Fix option select background on dark theme */
        .form-select option {
            background-color: #1a1a1a;
            color: #fff;
        }

        /* === SCHEDULE BOXES === */
        .schedule-box {
            background: rgba(0, 0, 0, 0.3);
            border: 1px dashed #555;
            border-radius: 6px;
            padding: 15px;
            height: 100%;
            transition: all 0.3s;
        }
        .schedule-box:hover {
            border-color: var(--mu-gold);
            background: rgba(0,0,0,0.5);
        }
        .schedule-title {
            font-family: 'Cinzel', serif;
            font-weight: 700;
            text-transform: uppercase;
            margin-bottom: 15px;
            font-size: 1rem;
        }
        .text-alpha { color: #00d2ff; text-shadow: 0 0 5px rgba(0, 210, 255, 0.5); }
        .text-beta { color: #ff3333; text-shadow: 0 0 5px rgba(255, 51, 51, 0.5); }

        /* === PACKAGE CARD === */
        .package-card {
            background: rgba(207, 170, 86, 0.05);
            border: 1px solid var(--mu-gold);
            border-radius: 6px;
        }
        .package-header {
            background: rgba(207, 170, 86, 0.15);
            color: var(--mu-gold);
            padding: 10px 15px;
            font-weight: bold;
            text-transform: uppercase;
            font-family: 'Cinzel', serif;
        }

        /* === BUTTON === */
        .btn-submit {
            background: linear-gradient(180deg, var(--mu-red) 0%, #550000 100%);
            border: 1px solid #ff3333;
            color: #fff;
            padding: 15px 40px;
            font-family: 'Cinzel', serif;
            font-weight: 700;
            font-size: 1.2rem;
            letter-spacing: 1px;
            text-transform: uppercase;
            width: 100%;
            transition: all 0.3s;
            box-shadow: 0 5px 15px rgba(0,0,0,0.5);
        }

        .btn-submit:hover {
            background: linear-gradient(180deg, #cc0000 0%, #800000 100%);
            border-color: #ff6666;
            box-shadow: 0 0 20px rgba(255, 51, 51, 0.6);
            transform: translateY(-2px);
            color: #fff;
        }
        .form-control::placeholder {
            color: #b0b0b0 !important; /* Màu xám sáng (trước đây là #555 rất tối) */
            font-style: italic;
            opacity: 0.8;
        }

        /* 2. Làm sáng icon Lịch/Đồng hồ và giao diện chọn ngày */
        input[type="date"],
        input[type="time"] {
            color-scheme: #e8e8e8; /* Quan trọng: Báo cho trình duyệt hiển thị popup lịch màu tối chữ trắng */
            color: #fff !important; /* Chữ ngày tháng màu trắng */
        }

        /* Đổi màu icon cuốn lịch/đồng hồ sang màu trắng (đảo ngược màu đen mặc định) */
        ::-webkit-calendar-picker-indicator {
            filter: invert(1);
            cursor: pointer;
            opacity: 0.8;
        }

        /* Hiệu ứng khi di chuột vào icon lịch */
        ::-webkit-calendar-picker-indicator:hover {
            opacity: 1;
            transform: scale(1.1);
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="page-wrapper">
    <div class="container content-container">
        <div class="row justify-content-center">
            <div class="col-lg-10 col-xl-9">

                <form action="${pageContext.request.contextPath}/server/create" method="post" class="game-card">

                    <div class="card-header-custom">
                        <h2><i class="fa-solid fa-dragon me-2"></i> Khởi Tạo Máy Chủ</h2>
                        <p>Đăng ký chiến dịch quảng bá MU Online</p>
                    </div>

                    <div class="card-body p-4 p-md-5">

                        <div class="mb-5">
                            <div class="section-title">
                                <i class="fa-solid fa-scroll"></i> 1. Thông Tin Cơ Bản
                            </div>

                            <div class="row g-3">
                                <div class="col-md-8">
                                    <label class="form-label">Tên Máy Chủ (Server Name) <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fa-solid fa-server"></i></span>
                                        <input type="text" class="form-control" name="serverName" placeholder="VD: Máy chủ Lorencia - Season 6" required>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Tên Cụm (MU Name)</label>
                                    <input type="text" class="form-control" name="muName" placeholder="VD: MU Hà Nội" required>
                                </div>

                                <div class="col-12">
                                    <label class="form-label">Slogan (Tiêu đề quảng cáo)</label>
                                    <input type="text" class="form-control" name="slogan" placeholder="Đông người chơi nhất - Đồ xanh chín - Admin nhiệt tình...">
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label">Trang Chủ</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fa-solid fa-globe"></i></span>
                                        <input type="url" class="form-control" name="websiteUrl" placeholder="https://mu-game.vn" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Fanpage</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fa-brands fa-facebook"></i></span>
                                        <input type="url" class="form-control" name="fanpageUrl" placeholder="https://facebook.com/mu-game" required>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mb-5">
                            <div class="section-title">
                                <i class="fa-solid fa-hourglass-half"></i> 2. Lịch Trình Ra Mắt
                            </div>

                            <div class="row g-4">
                                <div class="col-md-6">
                                    <div class="schedule-box">
                                        <div class="schedule-title text-alpha"><i class="fa-solid fa-flask me-2"></i>Alpha Test</div>
                                        <div class="row g-2">
                                            <div class="col-7">
                                                <label class="form-label small mb-1" style="color:#e3e3e3 !important;">
                                                    Ngày bắt đầu
                                                </label>
                                                <input type="date" class="form-control" name="alphaDate">
                                            </div>
                                            <div class="col-5">
                                                <label class="form-label small mb-1 text-muted"style="color:#e3e3e3 !important;">Giờ</label>
                                                <input type="time" class="form-control" name="alphaTime">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="schedule-box" style="border-color: rgba(255, 51, 51, 0.4);">
                                        <div class="schedule-title text-beta"><i class="fa-solid fa-fire me-2"></i>Open Beta</div>
                                        <div class="row g-2">
                                            <div class="col-7">
                                                <label class="form-label small mb-1 text-muted"style="color:#e3e3e3 !important;">Ngày Open</label>
                                                <input type="date" class="form-control" name="betaDate" required>
                                            </div>
                                            <div class="col-5">
                                                <label class="form-label small mb-1 text-muted"style="color:#e3e3e3 !important;">Giờ</label>
                                                <input type="time" class="form-control" name="betaTime" required>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mb-5">
                            <div class="section-title">
                                <i class="fa-solid fa-gears"></i> 3. Cấu Hình & Tính Năng
                            </div>

                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label class="form-label">Phiên bản</label>
                                    <select class="form-select" name="versionId">
                                        <c:forEach items="${versions}" var="v">
                                            <option value="${v.id}">${v.versionName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Exp Rate (x?)</label>
                                    <input type="number" class="form-control" name="expRate" value="150" placeholder="150">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Drop Rate (%)</label>
                                    <input type="number" class="form-control" name="dropRate" value="20" placeholder="20">
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label">Kiểu Reset</label>
                                    <select class="form-select" name="resetId">
                                        <c:forEach items="${resetTypes}" var="r">
                                            <option value="${r.id}">${r.resetName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Kiểu Point</label>
                                    <select class="form-select" name="pointId">
                                        <c:forEach items="${pointTypes}" var="p">
                                            <option value="${p.id}">${p.pointName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Anti-Hack</label>
                                    <input type="text" class="form-control" name="antiHack" placeholder="VietGuard, UGK...">
                                </div>
                            </div>
                        </div>

                        <div class="package-card mb-4 overflow-hidden">
                            <div class="package-header">
                                <i class="fa-solid fa-gem me-2"></i> Chọn Gói Quảng Cáo
                            </div>
                            <div class="p-3">
                                <div class="mb-2">
                                    <label for="bannerPackage" class="form-label">Loại hiển thị:</label>
                                    <select name="bannerPackage" id="bannerPackage" class="form-select" required>
                                        <option value="BASIC" selected>Gói Cơ Bản - Miễn phí (Standard)</option>
                                        <option value="VIP" class="text-warning fw-bold">★ Gói VIP - 5.000 Xu (Nổi bật)</option>
                                        <option value="SUPER_VIP" class="text-danger fw-bold">♛ Gói Super VIP - 10.000 Xu (Ghim Top)</option>
                                    </select>
                                </div>
                                <div
                                        class="small fst-italic"
                                        style="color:#dc3545 !important;"
                                >
                                    <i
                                            class="fa-solid fa-circle-exclamation me-1"
                                            style="color:#c58804 !important;"
                                    ></i>
                                    Phí sẽ được trừ trực tiếp vào Coin của bạn khi Admin duyệt bài.
                                </div>

                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Nội dung bài viết</label>
                            <textarea class="form-control" name="description" rows="5" placeholder="Mô tả chi tiết về server, tính năng, sự kiện..."></textarea>
                        </div>

                        <div class="mt-5 text-center">
                            <button type="submit" class="btn btn-submit">
                                <i class="fa-solid fa-check-circle me-2"></i> Xác Nhận Đăng Ký
                            </button>
                            <p class="text-secondary mt-3 small">Vui lòng kiểm tra kỹ thông tin trước khi gửi duyệt.</p>
                        </div>

                    </div>
                </form>

                <div class="text-center text-muted mt-4 small">
                    &copy; 2026 MU Ads Portal. Design by Admin.
                </div>

            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>