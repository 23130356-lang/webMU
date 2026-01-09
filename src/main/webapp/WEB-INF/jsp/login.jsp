<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập | MU Ads Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        /* 1. BODY: Chỉ thiết lập nền, KHÔNG dùng Flexbox ở đây để tránh méo Header */
        body {
            background: #0f1215; /* Màu nền chung */
            margin: 0;
            padding: 0;
            /* Reset font về mặc định để không ảnh hưởng Header */
            font-family: var(--bs-body-font-family);
        }

        /* 2. LOGIN WRAPPER: Đây là không gian riêng của phần Login */
        .login-page-wrapper {
            /* Tính toán chiều cao: Full màn hình trừ đi chiều cao Header (ước lượng 80px) */
            min-height: calc(100vh - 80px);

            /* Bây giờ mới dùng Flexbox để căn giữa Form */
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;

            /* Font chữ riêng cho vùng Login, không ảnh hưởng Header */
            font-family: 'Roboto', sans-serif;
        }

        /* 3. CARD STYLE (Giữ nguyên như cũ) */
        .auth-card {
            width: 100%;
            max-width: 450px;
            background-color: #041421;
            border: 1px solid #444;
            border-top: 4px solid #cc0000;
            border-radius: 4px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.8);
            color: #fff;
        }

        /* ... Các CSS trang trí Form giữ nguyên ... */
        .auth-header {
            background: linear-gradient(to bottom, #a00000, #750000);
            padding: 25px;
            text-align: center;
            border-bottom: 1px solid #500;
        }
        .auth-header h3 { color: #ffd700; font-weight: 800; text-transform: uppercase; margin: 0; }
        .auth-header p { color: #e0e0e0; font-size: 0.9rem; margin-top: 5px; }
        .form-label { color: #ccc !important; font-size: 0.8rem; text-transform: uppercase; }
        .input-group-text { background-color: #1a2c3d; border: 1px solid #444; color: #cc0000; }
        .form-control { background-color: #0d1f2e; border: 1px solid #444; color: #fff !important; }
        .form-control:focus { border-color: #cc0000; box-shadow: 0 0 5px rgba(204, 0, 0, 0.5); }
        .btn-submit { background: linear-gradient(to bottom, #cc0000, #990000); border: 1px solid #ff3333; color: white; padding: 12px; font-weight: 800; width: 100%; text-transform: uppercase; }
        .btn-submit:hover { background: linear-gradient(to bottom, #ff0000, #cc0000); }
        .text-primary { color: #ffd700 !important; }
        .text-primary:hover { color: #fff !important; text-decoration: underline !important; }
    </style>
</head>

<body>

<jsp:include page="header.jsp" />

<div class="login-page-wrapper">

    <div class="auth-card">
        <div class="auth-header">
            <h3><i class="fa-solid fa-shield-halved me-2"></i>ĐĂNG NHẬP</h3>
            <p>Hệ thống quản lý MU Online</p>
        </div>

        <div class="p-4">
            <c:if test="${param.registerSuccess == 'true'}">
                <div class="alert alert-success bg-dark text-success border-success text-center">
                    <i class="fa-solid fa-check-circle"></i> Đăng ký thành công!
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger bg-dark text-danger border-danger text-center">
                    <i class="fa-solid fa-circle-exclamation me-1"></i> ${errorMessage}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="mb-3">
                    <label class="form-label">Tài khoản</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                        <input type="text" class="form-control" name="username" placeholder="Nhập username" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Mật khẩu</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                        <input type="password" class="form-control" name="password" placeholder="Nhập mật khẩu" required>
                    </div>
                </div>

                <div class="d-flex justify-content-between mb-4 small">
                    <div class="form-check">
                        <input class="form-check-input bg-dark border-secondary" type="checkbox" id="remember">
                        <label class="form-check-label text-secondary" for="remember">Ghi nhớ tôi</label>
                    </div>
                    <a href="#" class="text-decoration-none text-primary">Quên mật khẩu?</a>
                </div>

                <button type="submit" class="btn btn-submit mb-3">ĐĂNG NHẬP NGAY</button>

                <div class="text-center text-secondary small">
                    Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register" class="fw-bold text-primary">Đăng ký mới</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>