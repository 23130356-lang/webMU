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

    <style>
        body {
            background: linear-gradient(135deg, #141E30 0%, #243B55 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Roboto', sans-serif;
        }
        .auth-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.5);
            overflow: hidden;
            width: 100%;
            max-width: 450px;
        }
        .auth-header {
            background: linear-gradient(to right, #1e3c72, #2a5298);
            padding: 30px;
            text-align: center;
            color: white;
        }
        .btn-submit {
            background: linear-gradient(to right, #11998e, #38ef7d);
            border: none;
            padding: 12px;
            color: white;
            font-weight: bold;
            border-radius: 50px;
            width: 100%;
            transition: all 0.3s;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(56, 239, 125, 0.4);
        }
        .form-control:focus {
            border-color: #2a5298;
            box-shadow: 0 0 0 0.2rem rgba(42, 82, 152, 0.25);
        }
    </style>
</head>
<body>

<div class="auth-card">
    <div class="auth-header">
        <h3><i class="fa-solid fa-right-to-bracket me-2"></i>ĐĂNG NHẬP</h3>
        <p class="mb-0">Chào mừng trở lại với MU Ads Portal</p>
    </div>

    <div class="p-4 p-md-5">

        <c:if test="${param.registerSuccess == 'true'}">
            <div class="alert alert-success text-center">
                Đăng ký thành công! Vui lòng đăng nhập.
            </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger text-center">
                <i class="fa-solid fa-circle-exclamation me-1"></i> ${errorMessage}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">

            <div class="mb-4">
                <label class="form-label fw-bold text-secondary">Tài khoản</label>
                <div class="input-group">
                    <span class="input-group-text bg-light"><i class="fa-solid fa-user"></i></span>
                    <input type="text" class="form-control" name="username" placeholder="Nhập username" required>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label fw-bold text-secondary">Mật khẩu</label>
                <div class="input-group">
                    <span class="input-group-text bg-light"><i class="fa-solid fa-lock"></i></span>
                    <input type="password" class="form-control" name="password" placeholder="Nhập mật khẩu" required>
                </div>
            </div>

            <div class="d-flex justify-content-between mb-4 small">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="remember">
                    <label class="form-check-label" for="remember">Ghi nhớ tôi</label>
                </div>
                <a href="#" class="text-decoration-none text-primary">Quên mật khẩu?</a>
            </div>

            <button type="submit" class="btn btn-submit mb-4">ĐĂNG NHẬP</button>

            <div class="text-center">
                <small>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register" class="text-decoration-none fw-bold text-primary">Đăng ký ngay</a></small>
            </div>
        </form>
    </div>
</div>

</body>
</html>