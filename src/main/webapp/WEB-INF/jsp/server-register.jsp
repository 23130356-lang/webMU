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
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); /* Deep Blue Gradient */
            min-height: 100vh;
            padding: 40px 0;
        }

        .main-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }

        .card-header-custom {
            background: #fff;
            padding: 25px;
            border-bottom: 1px solid #eee;
            text-align: center;
        }

        .card-header-custom h2 {
            color: #1e3c72;
            font-weight: 700;
            margin: 0;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .card-header-custom p {
            color: #777;
            margin-top: 5px;
            font-size: 0.9rem;
        }

        .form-section-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #2a5298;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #eef2f7;
            display: flex;
            align-items: center;
        }

        .form-section-title i {
            margin-right: 10px;
            background: #eef2f7;
            padding: 8px;
            border-radius: 50%;
            color: #1e3c72;
        }

        .form-label {
            font-weight: 500;
            font-size: 0.9rem;
            color: #555;
        }

        .input-group-text {
            background-color: #f8f9fa;
            border-color: #dee2e6;
            color: #6c757d;
        }

        .form-control:focus, .form-select:focus {
            border-color: #2a5298;
            box-shadow: 0 0 0 0.25rem rgba(42, 82, 152, 0.15);
        }

        .btn-submit {
            background: linear-gradient(to right, #11998e, #38ef7d);
            border: none;
            padding: 12px 30px;
            font-size: 1.1rem;
            font-weight: 600;
            color: white;
            border-radius: 50px;
            transition: all 0.3s ease;
            width: 100%;
            box-shadow: 0 5px 15px rgba(56, 239, 125, 0.4);
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(56, 239, 125, 0.6);
        }

        .schedule-box {
            background: #f8faff;
            border: 1px dashed #cce0ff;
            border-radius: 8px;
            padding: 15px;
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
                    <p>Điền thông tin chi tiết để quảng bá máy chủ của bạn đến cộng đồng</p>
                </div>

                <div class="card-body p-4 p-md-5">

                    <div class="mb-5">
                        <div class="form-section-title">
                            <i class="fa-solid fa-circle-info"></i> 1. Thông Tin Cơ Bản
                        </div>

                        <div class="row g-3">
                            <div class="col-md-8">
                                <label class="form-label">Tên hiển thị (Server Name) <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-server"></i></span>
                                    <input type="text" class="form-control" name="serverName" placeholder="VD: Máy chủ Huyền Thoại - Đua Top Alpha" required>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Tên cụm (MU Name)</label>
                                <input type="text" class="form-control" name="muName" placeholder="VD: MU Hà Nội" required>
                            </div>

                            <div class="col-12">
                                <label class="form-label">Slogan (Câu giới thiệu ngắn)</label>
                                <input type="text" class="form-control" name="slogan" placeholder="Đông người chơi nhất - Đồ xanh chín - Admin nhiệt tình...">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Trang chủ</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-solid fa-globe"></i></span>
                                    <input type="url" class="form-control" name="websiteUrl" placeholder="https://..." required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Fanpage</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fa-brands fa-facebook"></i></span>
                                    <input type="url" class="form-control" name="fanpageUrl" placeholder="https://facebook.com/..." required>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mb-5">
                        <div class="form-section-title">
                            <i class="fa-solid fa-calendar-days"></i> 2. Lịch Trình Alpha & Open Beta
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
                                <div class="schedule-box" style="background: #fff4f4; border-color: #ffcccc;">
                                    <h6 class="text-danger fw-bold mb-3"><i class="fa-solid fa-fire me-2"></i>Open Beta (Quan trọng)</h6>
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
                            <i class="fa-solid fa-gears"></i> 3. Cấu Hình Máy Chủ
                        </div>

                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Phiên bản (Version)</label>
                                <select class="form-select" name="versionId">
                                    <c:forEach items="${versions}" var="v" varStatus="loop">
                                        <option value="${loop.index + 1}">${v}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Exp Rate (x?)</label>
                                <input type="number" class="form-control" name="expRate" value="150">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Drop Rate (%)</label>
                                <input type="number" class="form-control" name="dropRate" value="20">
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">Kiểu Reset</label>
                                <select class="form-select" name="resetId">
                                    <c:forEach items="${resetTypes}" var="r" varStatus="loop">
                                        <option value="${loop.index + 1}">${r}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Kiểu Point</label>
                                <select class="form-select" name="pointId">
                                    <c:forEach items="${pointTypes}" var="p" varStatus="loop">
                                        <option value="${loop.index + 1}">${p}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Anti-Hack</label>
                                <input type="text" class="form-control" name="antiHack" placeholder="VD: VietGuard, UGK...">
                            </div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-bold">Bài viết giới thiệu (Hỗ trợ HTML)</label>
                        <textarea class="form-control" name="description" rows="5" placeholder="Viết nội dung quảng cáo chi tiết, tính năng nổi bật, lộ trình server..."></textarea>
                    </div>

                    <div class="text-center mt-5">
                        <button type="submit" class="btn btn-submit">
                            <i class="fa-solid fa-paper-plane me-2"></i> ĐĂNG KÝ & THANH TOÁN
                        </button>
                        <p class="text-muted mt-3 small">Phí đăng ký: 500 Gcoin / Lượt hiển thị tin VIP</p>
                    </div>

                </div>
            </form>

            <div class="text-center text-white-50 mt-4 mb-5">
                <small>&copy; 2026 MU Ads Portal. All rights reserved.</small>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>