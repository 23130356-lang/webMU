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
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        :root {
            --mu-gold: #cfaa56;
            --mu-red: #8b0000;
            --mu-red-glow: #ff3333;
            --mu-dark: #05070a;
            --mu-glass: rgba(10, 15, 20, 0.85);
        }

        body {
            background-color: var(--mu-dark);
            font-family: 'Inter', sans-serif;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }

        /* Wrapper bao quanh, có hình nền game mờ */
        .login-page-wrapper {
            position: relative;
            min-height: calc(100vh - 80px); /* Trừ header */
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            /* Hình nền MU (Bạn có thể thay URL ảnh khác) */
            background: url('https://wallpaperaccess.com/full/1524368.jpg') no-repeat center center/cover;
            z-index: 1;
        }

        /* Lớp phủ tối đè lên hình nền để làm nổi bật Form */
        .login-page-wrapper::before {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: radial-gradient(circle, rgba(0,0,0,0.4) 0%, rgba(0,0,0,0.9) 100%);
            z-index: -1;
        }

        /* === LOGIN CARD === */
        .auth-card {
            width: 100%;
            max-width: 420px;
            background: var(--mu-glass);
            backdrop-filter: blur(10px); /* Hiệu ứng kính mờ */
            border: 1px solid #333;
            border-radius: 8px;
            box-shadow: 0 0 30px rgba(0, 0, 0, 0.8), 0 0 10px rgba(207, 170, 86, 0.2); /* Ánh vàng nhẹ */
            position: relative;
            overflow: hidden;
            transition: transform 0.3s ease;
        }

        /* Viền trên màu vàng gold sang trọng */
        .auth-card::after {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, transparent, var(--mu-gold), transparent);
            box-shadow: 0 0 10px var(--mu-gold);
        }

        /* Header của Card */
        .auth-header {
            text-align: center;
            padding: 40px 30px 20px;
        }
        .auth-header h3 {
            font-family: 'Cinzel', serif; /* Font kiểu Game */
            color: var(--mu-gold);
            font-weight: 700;
            font-size: 2rem;
            margin-bottom: 5px;
            text-transform: uppercase;
            text-shadow: 0 2px 4px rgba(0,0,0,0.8);
            letter-spacing: 2px;
        }
        .auth-header p {
            color: #aaa;
            font-size: 0.85rem;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        /* === INPUT FIELDS === */
        .form-label {
            color: #ccc;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
            font-weight: 600;
        }

        .custom-input-group {
            position: relative;
            background: rgba(0, 0, 0, 0.3);
            border: 1px solid #444;
            border-radius: 4px;
            display: flex;
            align-items: center;
            transition: all 0.3s;
        }

        .custom-input-group:focus-within {
            border-color: var(--mu-gold);
            box-shadow: 0 0 10px rgba(207, 170, 86, 0.2);
        }

        .input-icon {
            padding: 0 15px;
            color: #666;
            font-size: 1.1rem;
            transition: color 0.3s;
        }

        .custom-input-group:focus-within .input-icon {
            color: var(--mu-gold);
        }

        .form-control {
            background: transparent !important;
            border: none !important;
            color: #fff !important;
            padding: 12px 10px 12px 0;
            font-size: 0.95rem;
            box-shadow: none !important;
        }

        .form-control::placeholder {
            color: #555;
            font-style: italic;
        }

        /* === BUTTON === */
        .btn-submit {
            background: linear-gradient(180deg, #990000 0%, #550000 100%);
            border: 1px solid #ff3333;
            color: #fff;
            padding: 12px;
            font-family: 'Cinzel', serif;
            font-weight: 700;
            font-size: 1.1rem;
            letter-spacing: 1px;
            text-transform: uppercase;
            width: 100%;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.5);
        }

        .btn-submit:hover {
            background: linear-gradient(180deg, #bb0000 0%, #770000 100%);
            border-color: #ff6666;
            box-shadow: 0 0 15px rgba(255, 51, 51, 0.6);
            transform: translateY(-1px);
        }

        /* === EXTRAS === */
        .form-check-input {
            background-color: #222;
            border-color: #555;
        }
        .form-check-input:checked {
            background-color: var(--mu-red);
            border-color: var(--mu-red);
        }
        .text-link {
            color: var(--mu-gold);
            text-decoration: none;
            transition: color 0.2s;
        }
        .text-link:hover {
            color: #fff;
            text-shadow: 0 0 5px var(--mu-gold);
        }

        /* Alert styles */
        .alert-custom {
            background: rgba(255, 0, 0, 0.15);
            border: 1px solid var(--mu-red);
            color: #ffaaaa;
            font-size: 0.9rem;
        }
        .alert-success-custom {
            background: rgba(0, 255, 0, 0.1);
            border: 1px solid #00aa00;
            color: #aaffaa;
        }
    </style>
</head>

<body>

<jsp:include page="header.jsp" />

<div class="login-page-wrapper">

    <div class="auth-card">
        <div class="auth-header">
            <h3><i class="fa-solid fa-dragon me-2"></i>MU Portal</h3>
            <p>Cổng thông tin quảng cáo Server</p>
        </div>

        <div class="px-4 pb-4 pt-2">

            <c:if test="${param.registerSuccess == 'true'}">
                <div class="alert alert-success-custom rounded-1 text-center mb-4 py-2">
                    <i class="fa-solid fa-check-circle me-1"></i> Đăng ký tài khoản thành công!
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-custom rounded-1 text-center mb-4 py-2">
                    <i class="fa-solid fa-triangle-exclamation me-1"></i> ${errorMessage}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="mb-3">
                    <label class="form-label">Tài khoản</label>
                    <div class="custom-input-group">
                        <div class="input-icon"><i class="fa-solid fa-user-shield"></i></div>
                        <input type="text" class="form-control" name="username" placeholder="Nhập tên đăng nhập..." required autocomplete="off">
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label">Mật khẩu</label>
                    <div class="custom-input-group">
                        <div class="input-icon"><i class="fa-solid fa-key"></i></div>
                        <input type="password" class="form-control" name="password" placeholder="Nhập mật khẩu..." required>
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-4 small">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="remember">
                        <label class="form-check-label text-secondary" for="remember">Ghi nhớ</label>
                    </div>
                    <a href="#" class="text-link">Quên mật khẩu?</a>
                </div>

                <button type="submit" class="btn btn-submit mb-4">
                    Đăng Nhập
                </button>

                <div class="text-center small text-secondary">
                    Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register" class="text-link fw-bold ms-1">Tạo nhân vật mới</a>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>