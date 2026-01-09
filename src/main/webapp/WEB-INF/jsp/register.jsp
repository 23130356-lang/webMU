<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Thành Viên | MU Ads Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">

    <style>
        /* === COPY STYLE TỪ TRANG LOGIN ĐỂ ĐỒNG BỘ === */
        :root {
            --mu-gold: #cfaa56;
            --mu-red: #8b0000;
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

        .register-page-wrapper {
            position: relative;
            min-height: calc(100vh - 80px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px; /* Tăng padding trên dưới vì form dài hơn */
            background: url('https://wallpaperaccess.com/full/1524368.jpg') no-repeat center center/cover;
            z-index: 1;
        }

        .register-page-wrapper::before {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: radial-gradient(circle, rgba(0,0,0,0.5) 0%, rgba(0,0,0,0.95) 100%);
            z-index: -1;
        }

        .auth-card {
            width: 100%;
            max-width: 550px; /* Rộng hơn form login một chút */
            background: var(--mu-glass);
            backdrop-filter: blur(10px);
            border: 1px solid #333;
            border-radius: 8px;
            box-shadow: 0 0 30px rgba(0, 0, 0, 0.8), 0 0 10px rgba(207, 170, 86, 0.15);
            position: relative;
            overflow: hidden;
        }

        .auth-card::after {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, transparent, var(--mu-gold), transparent);
            box-shadow: 0 0 10px var(--mu-gold);
        }

        .auth-header {
            text-align: center;
            padding: 30px 30px 10px;
        }
        .auth-header h3 {
            font-family: 'Cinzel', serif;
            color: var(--mu-gold);
            font-weight: 700;
            font-size: 1.8rem;
            margin-bottom: 5px;
            text-transform: uppercase;
            text-shadow: 0 2px 4px rgba(0,0,0,0.8);
        }
        .auth-header p {
            color: #aaa;
            font-size: 0.85rem;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        /* Input Styles */
        .form-label {
            color: #ccc;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 6px;
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
            font-size: 1rem;
            transition: color 0.3s;
        }

        .custom-input-group:focus-within .input-icon {
            color: var(--mu-gold);
        }

        .form-control {
            background: transparent !important;
            border: none !important;
            color: #fff !important;
            padding: 10px 10px 10px 0;
            font-size: 0.95rem;
            box-shadow: none !important;
        }

        .form-control::placeholder {
            color: #555;
            font-style: italic;
        }

        /* Button */
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
            margin-top: 10px;
        }

        .btn-submit:hover {
            background: linear-gradient(180deg, #bb0000 0%, #770000 100%);
            border-color: #ff6666;
            box-shadow: 0 0 15px rgba(255, 51, 51, 0.6);
            transform: translateY(-1px);
        }

        /* Error Alert */
        .alert-custom {
            background: rgba(255, 0, 0, 0.15);
            border: 1px solid var(--mu-red);
            color: #ffaaaa;
            font-size: 0.9rem;
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
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="register-page-wrapper">
    <div class="auth-card">
        <div class="auth-header">
            <h3><i class="fa-solid fa-user-plus me-2"></i>Đăng Ký</h3>
            <p class="mb-0">Gia nhập liên minh lục địa MU</p>
        </div>

        <div class="px-4 pb-4 pt-2">

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-custom rounded-1 text-center mb-4 py-2">
                    <i class="fa-solid fa-triangle-exclamation me-1"></i> ${errorMessage}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post">

                <div class="mb-3">
                    <label class="form-label">Tài khoản</label>
                    <div class="custom-input-group">
                        <div class="input-icon"><i class="fa-solid fa-user"></i></div>
                        <input type="text" class="form-control" name="username" required placeholder="Chọn tên đăng nhập..." autocomplete="off">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <div class="custom-input-group">
                        <div class="input-icon"><i class="fa-solid fa-envelope"></i></div>
                        <input type="email" class="form-control" name="email" required placeholder="Nhập địa chỉ email...">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Số điện thoại</label>
                    <div class="custom-input-group">
                        <div class="input-icon"><i class="fa-solid fa-phone"></i></div>
                        <input type="text" class="form-control" name="phone" required placeholder="09xx xxx xxx">
                    </div>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <label class="form-label">Mật khẩu</label>
                        <div class="custom-input-group">
                            <div class="input-icon"><i class="fa-solid fa-lock"></i></div>
                            <input type="password" class="form-control" name="password" required placeholder="******">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Xác nhận MK</label>
                        <div class="custom-input-group">
                            <div class="input-icon"><i class="fa-solid fa-shield-halved"></i></div>
                            <input type="password" class="form-control" name="confirmPassword" required placeholder="******">
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn btn-submit mb-4">TẠO TÀI KHOẢN</button>

                <div class="text-center small text-secondary">
                    Đã có tài khoản chiến binh? <a href="${pageContext.request.contextPath}/login" class="text-link fw-bold ms-1">Đăng nhập ngay</a>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>