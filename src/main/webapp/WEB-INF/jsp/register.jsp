<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng Ký Thành Viên | MUNORIA.MOBILE</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700;900&family=Rajdhani:wght@500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* === 1. GLOBAL VARIABLES & RESET (Đồng bộ Login) === */
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
            /* Background tối huyền bí */
            background-image: linear-gradient(rgba(0,0,0,0.85), rgba(0,0,0,0.95)), url('https://toquoc.mediacdn.vn/280518851207290880/2022/6/7/-1654571912757628297204.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
        }

        /* === 2. REGISTER CARD STYLE === */
        #mu-register-page {
            width: 100%;
            padding: 40px 15px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .register-card {
            background: rgba(10, 10, 10, 0.95);
            border: 1px solid var(--mu-border);
            border-top: 3px solid var(--mu-gold);
            width: 100%;
            max-width: 500px; /* Rộng hơn login xíu để chứa 2 cột */
            padding: 35px 30px;
            box-shadow: 0 0 25px rgba(0,0,0,0.9), 0 0 10px rgba(207, 170, 86, 0.15);
            position: relative;
        }

        /* Trang trí 4 góc (Góc vuông vàng) */
        .register-card::before, .register-card::after {
            content: ''; position: absolute; width: 12px; height: 12px;
            border: 2px solid var(--mu-gold); transition: 0.3s;
        }
        .register-card::before { top: -2px; left: -2px; border-right: none; border-bottom: none; }
        .register-card::after { bottom: -2px; right: -2px; border-left: none; border-top: none; }

        /* Tiêu đề */
        .reg-title {
            font-family: 'Cinzel', serif;
            font-weight: 700;
            text-align: center;
            color: var(--mu-gold);
            text-transform: uppercase;
            font-size: 1.6rem;
            margin-bottom: 5px;
            text-shadow: 0 0 10px rgba(207, 170, 86, 0.4);
        }
        .reg-subtitle {
            text-align: center;
            font-size: 0.85rem;
            color: #777;
            margin-bottom: 25px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* === 3. FORM ELEMENTS === */
        .mu-form-group { margin-bottom: 18px; position: relative; }
        .mu-label {
            font-size: 0.8rem;
            font-weight: 700;
            color: #aaa;
            margin-bottom: 5px;
            display: block;
            text-transform: uppercase;
        }

        .mu-input {
            width: 100%;
            background: rgba(255,255,255,0.03);
            border: 1px solid #333;
            padding: 10px 15px 10px 40px; /* Chừa chỗ cho Icon */
            color: #fff;
            font-family: 'Rajdhani', sans-serif;
            font-size: 1rem;
            border-radius: 2px;
            transition: all 0.3s;
        }

        .mu-input:focus {
            background: rgba(0,0,0,0.6);
            border-color: var(--mu-gold);
            outline: none;
            box-shadow: 0 0 8px rgba(207, 170, 86, 0.25);
        }

        .mu-input-icon {
            position: absolute;
            left: 12px;
            bottom: 12px; /* Căn chỉnh theo input height */
            color: #555;
            font-size: 0.9rem;
            transition: 0.3s;
        }

        .mu-input:focus ~ .mu-input-icon { color: var(--mu-gold); }

        /* Button */
        .btn-mu-reg {
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
            margin-top: 15px;
            position: relative;
            overflow: hidden;
        }

        .btn-mu-reg:hover {
            background: linear-gradient(180deg, #dc2626 0%, #991b1b 100%);
            box-shadow: 0 0 20px rgba(220, 38, 38, 0.4);
            color: #fff;
        }

        /* Links */
        .mu-link { color: #888; text-decoration: none; font-size: 0.9rem; }
        .mu-link:hover { color: var(--mu-gold); }

        /* Alert Custom */
        .alert-mu {
            background: rgba(139, 0, 0, 0.1);
            border: 1px solid var(--mu-red);
            color: #ff8888;
            font-size: 0.9rem;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 2px;
            display: flex;
            align-items: center;
        }
    </style>
</head>

<body class="d-flex flex-column min-vh-100">

<jsp:include page="header.jsp" />

<div class="flex-grow-1 d-flex flex-column justify-content-center">

    <div id="mu-register-page">
        <div class="register-card">
            <h2 class="reg-title">Đăng Ký Tài Khoản</h2>
            <p class="reg-subtitle">Gia nhập cộng đồng MU lớn nhất VN</p>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-mu">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i> ${errorMessage}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post">

                <div class="mu-form-group">
                    <label class="mu-label">Tài khoản</label>
                    <input type="text" class="mu-input" name="username" required placeholder="Tên đăng nhập (viết liền)...">
                    <i class="fa-solid fa-user mu-input-icon"></i>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="mu-form-group">
                            <label class="mu-label">Email</label>
                            <input type="email" class="mu-input" name="email" required placeholder="name@example.com">
                            <i class="fa-solid fa-envelope mu-input-icon"></i>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mu-form-group">
                            <label class="mu-label">SĐT / Zalo</label>
                            <input type="text" class="mu-input" name="phone" required placeholder="09xxxxxxxx">
                            <i class="fa-solid fa-phone mu-input-icon"></i>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="mu-form-group">
                            <label class="mu-label">Mật khẩu</label>
                            <input type="password" class="mu-input" name="password" required placeholder="******">
                            <i class="fa-solid fa-lock mu-input-icon"></i>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mu-form-group">
                            <label class="mu-label">Nhập lại MK</label>
                            <input type="password" class="mu-input" name="confirmPassword" required placeholder="******">
                            <i class="fa-solid fa-shield-halved mu-input-icon"></i>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn btn-mu-reg">
                    Khởi Tạo Nhân Vật
                </button>
            </form>

            <div style="border-top: 1px solid #222; margin: 25px 0 15px;"></div>

            <div class="text-center">
                <span class="text-secondary small">Đã có tài khoản?</span>
                <a href="${pageContext.request.contextPath}/login" class="mu-link fw-bold text-warning ms-1">
                    Đăng Nhập Ngay <i class="fa-solid fa-arrow-right ms-1"></i>
                </a>
            </div>

        </div>
    </div>

</div>

<jsp:include page="footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>