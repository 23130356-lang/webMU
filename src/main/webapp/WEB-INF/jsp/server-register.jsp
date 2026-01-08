<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Quảng Cáo Server | MU Ads Portal</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #141E30 0%, #243B55 100%); /* Darker, more serious gaming theme */
            min-height: 100vh;
            padding: 40px 0;
            color: #333;
        }

        .main-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.4);
            overflow: hidden;
            background: #fff;
        }

        .card-header-custom {
            background: linear-gradient(to right, #1e3c72, #2a5298);
            padding: 30px;
            text-align: center;
            color: white;
            border-bottom: 5px solid #ffa502; /* Accent color */
        }

        .card-header-custom h2 {
            font-weight: 700;
            margin: 0;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 1.8rem;
        }

        .card-header-custom p {
            margin-top: 10px;
            font-size: 0.95rem;
            opacity: 0.9;
        }

        .form-section-title {
            font-size: 1.15rem;
            font-weight: 700;
            color: #1e3c72;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #eef2f7;
            display: flex;
            align-items: center;
        }

        .form-section-title i {
            margin-right: 12px;
            background: #eef2f7;
            padding: 10px;
            border-radius: 50%;
            color: #1e3c72;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .form-label {
            font-weight: 600;
            font-size: 0.9rem;
            color: #444;
            margin-bottom: 0.5rem;
        }

        .input-group-text {
            background-color: #f1f4f8;
            border-color: #dee2e6;
            color: #555;
        }

        .form-control, .form-select {
            padding: 0.6rem 0.75rem;
            border: 1px solid #dee2e6;
        }

        .form-control:focus, .form-select:focus {
            border-color: #2a5298;
            box-shadow: 0 0 0 0.25rem rgba(42, 82, 152, 0.15);
        }

        .btn-submit {
            background: linear-gradient(to right, #11998e, #38ef7d);
            border: none;
            padding: 14px 40px;
            font-size: 1.2rem;
            font-weight: 700;
            color: white;
            border-radius: 50px;
            transition: all 0.3s ease;
            width: 100%;
            text-transform: uppercase;
            box-shadow: 0 5px 15px rgba(56, 239, 125, 0.3);
        }

        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(56, 239, 125, 0.5);
        }

        .schedule-box {
            background: #f8faff;
            border: 1px dashed #cce0ff;
            border-radius: 10px;
            padding: 20px;
            height: 100%;
        }

        .schedule-box.important {
            background: #fff5f5;
            border-color: #ffcccc;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-10 col-xl-9">

            <form action="${pageContext.request.contextPath}/server/create" method="post" class="main-card card">

                <div class="card-header-custom">
                    <h2><i class="fa-solid fa-dragon me-2"></i> Đăng Ký Server Mới</h2>
                    <p>Khởi tạo chiến dịch quảng bá máy chủ MU Online của bạn ngay hôm nay</p>
                </div>

                <div class="card-body p-4 p-md-5">

                    <div class="mb-5">
                        <div class="form-section-title">
                            <i class="fa-solid fa-circle-info"></i> 1. Thông Tin Chung
                        </div>

                        <div class="row g-3">
                            <div class="col-md-8">
                                <label class="form-label">Tên Máy Chủ (Server Name) <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-server"></i></span>
                                    <input type="text" class="form-control" name="serverName" placeholder="VD: Máy chủ Huyền Thoại - Đua Top Alpha" required>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Tên Cụm (MU Name)</label>
                                <input type="text" class="form-control" name="muName" placeholder="VD: MU Hà Nội" required>
                            </div>

                            <div class="col-12">
                                <label class="form-label">Slogan (Câu giới thiệu ngắn)</label>
                                <input type="text" class="form-control" name="slogan" placeholder="Đông người chơi nhất - Đồ xanh chín - Admin nhiệt tình...">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Website Trang Chủ</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-globe"></i></span>
                                    <input type="url" class="form-control" name="websiteUrl" placeholder="https://..." required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Fanpage Facebook</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-brands fa-facebook"></i></span>
                                    <input type="url" class="form-control" name="fanpageUrl" placeholder="https://facebook.com/..." required>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mb-5">
                        <div class="form-section-title">
                            <i class="fa-solid fa-calendar-days"></i> 2. Lịch Trình Ra Mắt
                        </div>

                        <div class="row g-4">
                            <div class="col-md-6">
                                <div class="schedule-box">
                                    <h6 class="text-primary fw-bold mb-3"><i class="fa-solid fa-flask me-2"></i>Alpha Test</h6>
                                    <div class="row g-2">
                                        <div class="col-7">
                                            <label class="small text-muted">Ngày bắt đầu</label>
                                            <input type="date" class="form-control" name="alphaDate">
                                        </div>
                                        <div class="col-5">
                                            <label class="small text-muted">Giờ</label>
                                            <input type="time" class="form-control" name="alphaTime">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="schedule-box important">
                                    <h6 class="text-danger fw-bold mb-3"><i class="fa-solid fa-fire me-2"></i>Open Beta (Chính thức)</h6>
                                    <div class="row g-2">
                                        <div class="col-7">
                                            <label class="small text-muted">Ngày Open</label>
                                            <input type="date" class="form-control" name="betaDate" required>
                                        </div>
                                        <div class="col-5">
                                            <label class="small text-muted">Giờ Open</label>
                                            <input type="time" class="form-control" name="betaTime" required>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mb-5">
                        <div class="form-section-title">
                            <i class="fa-solid fa-gears"></i> 3. Cấu Hình & Tính Năng
                        </div>

                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Phiên bản (Version)</label>
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
                                <input type="text" class="form-control" name="antiHack" placeholder="VD: VietGuard, UGK...">
                            </div>
                        </div>
                    </div>
                    <div class="card mb-4 border-warning">
                        <div class="card-header bg-warning text-dark fw-bold">
                            <i class="bi bi-star-fill"></i> Chọn Gói Quảng Cáo
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label for="bannerPackage" class="form-label fw-bold">Loại hiển thị:</label>
                                <select name="bannerPackage" id="bannerPackage" class="form-select" required>
                                    <option value="BASIC" selected>Gói Cơ Bản - 1.000 Xu (Mặc định)</option>

                                    <option value="VIP">Gói VIP - 5.000 Xu (Nổi bật, chữ đậm)</option>

                                    <option value="SUPER_VIP">Gói Super VIP - 10.000 Xu (Ghim đầu trang)</option>
                                </select>
                                <div class="form-text text-danger">
                                    * Phí sẽ được trừ trực tiếp vào Coin của bạn khi Admin duyệt bài.
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-bold">Bài viết giới thiệu (Hỗ trợ HTML cơ bản)</label>
                        <textarea class="form-control" name="description" rows="5" placeholder="Viết nội dung quảng cáo chi tiết, tính năng nổi bật, lộ trình server..."></textarea>
                    </div>

                    <div class="text-center mt-5">

                        <button type="submit" class="btn btn-submit">
                            <i class="fa-solid fa-paper-plane me-2"></i> HOÀN TẤT ĐĂNG KÝ
                        </button>
                        <p class="text-muted mt-3 small">Bằng việc đăng ký, bạn đồng ý với quy định của MU Ads Portal.</p>
                    </div>

                </div>
            </form>

            <div class="text-center text-white-50 mt-4 mb-5">
                <small>&copy; 2026 MU Ads Portal. System by Gemini.</small>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>