<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng Nhập | MUNORIA.MOBILE</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700;900&family=Rajdhani:wght@500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* === GLOBAL RESET & FONTS === */
        :root {
            --mu-bg: #050505;
            --mu-gold: #cfaa56;
            --mu-red: #8b0000;
            --mu-border: #3d2b1f;
        }

        body {
            background-color: var(--mu-bg);
            color: #ccc;
            font-family: 'Rajdhani', sans-serif;
            background-image: linear-gradient(rgba(0,0,0,0.8), rgba(0,0,0,0.9)), url('https://toquoc.mediacdn.vn/280518851207290880/2022/6/7/-1654571912757628297204.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
        }

        /* === LOGIN SECTION STYLE === */
        #mu-login-page {
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 60px 15px;
        }

        .login-card {
            background: rgba(10, 10, 10, 0.95);
            border: 1px solid var(--mu-border);
            border-top: 3px solid var(--mu-gold);
            width: 100%;
            max-width: 420px;
            padding: 40px 30px;
            box-shadow: 0 0 20px rgba(0,0,0,0.8), 0 0 10px rgba(207, 170, 86, 0.1);
            position: relative;
        }

        .login-card::before, .login-card::after {
            content: ''; position: absolute; width: 10px; height: 10px;
            border: 2px solid var(--mu-gold); transition: 0.3s;
        }
        .login-card::before { top: -2px; left: -2px; border-right: none; border-bottom: none; }
        .login-card::after { bottom: -2px; right: -2px; border-left: none; border-top: none; }

        .login-title {
            font-family: 'Cinzel', serif;
            font-weight: 700;
            text-align: center;
            color: var(--mu-gold);
            text-transform: uppercase;
            font-size: 1.8rem;
            margin-bottom: 10px;
            text-shadow: 0 0 10px rgba(207, 170, 86, 0.3);
        }

        .login-subtitle {
            text-align: center;
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 30px;
        }

        .mu-form-group { margin-bottom: 20px; position: relative; }

        .mu-input {
            width: 100%;
            background: rgba(255,255,255,0.05);
            border: 1px solid #333;
            padding: 12px 15px 12px 45px;
            color: #fff;
            font-family: 'Rajdhani', sans-serif;
            font-size: 1.1rem;
            border-radius: 2px;
            transition: all 0.3s;
        }

        .mu-input:focus {
            background: rgba(0,0,0,0.8);
            border-color: var(--mu-gold);
            outline: none;
            box-shadow: 0 0 8px rgba(207, 170, 86, 0.3);
        }

        .mu-input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #666;
            transition: 0.3s;
        }

        .mu-input:focus + .mu-input-icon { color: var(--mu-gold); }

        .form-check-input {
            background-color: #222;
            border-color: #444;
        }
        .form-check-input:checked {
            background-color: var(--mu-red);
            border-color: var(--mu-red);
        }

        .btn-mu-submit {
            width: 100%;
            background: linear-gradient(180deg, #b91c1c 0%, #7f1d1d 100%);
            border: 1px solid #ff5555;
            color: white;
            padding: 12px;
            font-family: 'Cinzel', serif;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s;
            margin-top: 10px;
        }

        .btn-mu-submit:hover {
            background: linear-gradient(180deg, #dc2626 0%, #991b1b 100%);
            box-shadow: 0 0 15px rgba(220, 38, 38, 0.5);
            color: #fff;
            transform: translateY(-1px);
        }

        .mu-link { color: #888; text-decoration: none; font-size: 0.95rem; transition: 0.3s; }
        .mu-link:hover { color: var(--mu-gold); }
        .divider { border-top: 1px solid #222; margin: 25px 0; }
    </style>
</head>

<body class="d-flex flex-column min-vh-100">

<jsp:include page="header.jsp" />

<div class="flex-grow-1 d-flex flex-column justify-content-center">

    <div id="mu-login-page">
        <div class="login-card">
            <h2 class="login-title">Thành Viên</h2>
            <p class="login-subtitle">Đăng nhập để quản lý Server & Quảng cáo</p>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger py-2" role="alert" style="background: rgba(220,53,69,0.1); border: 1px solid #dc3545; color: #ff6b6b; font-size: 0.9rem;">
                    <i class="fa-solid fa-circle-exclamation me-2"></i> ${errorMessage}
                </div>
            </c:if>

            <c:if test="${param.registerSuccess}">
                <div class="alert alert-success py-2" role="alert" style="background: rgba(25,135,84,0.1); border: 1px solid #198754; color: #75b798; font-size: 0.9rem;">
                    <i class="fa-solid fa-check-circle me-2"></i> Đăng ký thành công! Vui lòng đăng nhập.
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">

                <div class="mu-form-group">
                    <input type="text" class="mu-input" name="username" placeholder="Tên tài khoản" required autofocus>
                    <i class="fa-solid fa-user mu-input-icon"></i>
                </div>

                <div class="mu-form-group">
                    <input type="password" class="mu-input" name="password" placeholder="Mật khẩu" required>
                    <i class="fa-solid fa-lock mu-input-icon"></i>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="rememberMe" name="remember-me">
                        <label class="form-check-label text-secondary" for="rememberMe" style="font-size: 0.9rem;">
                            Ghi nhớ
                        </label>
                    </div>
                    <a href="#" class="mu-link">Quên mật khẩu?</a>
                </div>

                <button type="submit" class="btn btn-mu-submit">
                    Đăng Nhập Ngay
                </button>
            </form>

            <div class="divider"></div>

            <div class="text-center">
                <span class="text-secondary">Chưa có tài khoản?</span>
                <a href="${pageContext.request.contextPath}/register" class="mu-link text-warning fw-bold ms-2">Đăng Ký Mới</a>
            </div>
        </div>
    </div>

</div>

<jsp:include page="footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>