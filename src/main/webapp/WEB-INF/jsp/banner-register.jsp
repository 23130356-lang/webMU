<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng Ký Quảng Cáo | MU Ads Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        body { background-color: #f0f2f5; font-family: 'Segoe UI', sans-serif; }
        .form-container {
            max-width: 700px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .header-title { color: #b70000; font-weight: 800; text-transform: uppercase; text-align: center; margin-bottom: 20px; }
        .price-note { font-size: 0.9rem; color: #666; font-style: italic; margin-bottom: 15px; }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container">
    <div class="form-container">
        <h3 class="header-title"><i class="bi bi-megaphone-fill"></i> Đăng Ký Đặt Banner</h3>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success"><i class="bi bi-check-circle"></i> ${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger"><i class="bi bi-exclamation-triangle"></i> ${errorMessage}</div>
        </c:if>

        <form action="/banner-register" method="post">

            <div class="mb-3">
                <label class="form-label fw-bold">Chọn vị trí quảng cáo</label>
                <select name="positionCode" class="form-select" required>
                    <option value="" disabled selected>-- Chọn vị trí --</option>
                    <option value="LEFT_SIDEBAR">Cột Trái (280x500px) - [HOT]</option>
                    <option value="RIGHT_SIDEBAR">Cột Phải (280x500px) - [HOT]</option>
                    <option value="HERO">Banner Ngang Lớn (1200x250px) - [VIP]</option>
                    <option value="STD">Banner Ngang Nhỏ (1200x120px)</option>
                    <option value="HALF">Banner Vuông Nhỏ (600x100px)</option>
                </select>
                <div class="form-text text-muted">Vui lòng chọn đúng vị trí để hệ thống hiển thị chính xác.</div>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Link Ảnh Banner</label>
                <input type="url" name="imageUrl" class="form-control" placeholder="https://imgur.com/example.jpg" required>
                <div class="form-text">Bạn hãy upload ảnh lên upanh.org hoặc imgur.com rồi dán link vào đây.</div>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Link Website / Fanpage của bạn</label>
                <input type="url" name="targetUrl" class="form-control" placeholder="https://mu-vietnam.com" required>
            </div>

            <div class="alert alert-warning small">
                <i class="bi bi-info-circle-fill"></i> <strong>Lưu ý:</strong> Sau khi đăng ký, trạng thái banner sẽ là <em>"Chờ duyệt"</em>. Vui lòng liên hệ Admin qua Facebook/Zalo để thanh toán và kích hoạt.
            </div>

            <button type="submit" class="btn btn-danger w-100 py-2 fw-bold text-uppercase">Gửi Đăng Ký Ngay</button>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>