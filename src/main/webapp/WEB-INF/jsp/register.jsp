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

    <style>
        /* 1. Thiết lập Body là một cột dọc full màn hình */
        body {
            background: linear-gradient(135deg, #141E30 0%, #243B55 100%);
            min-height: 100vh; /* Quan trọng: Chiều cao tối thiểu bằng màn hình */
            margin: 0;

            display: flex;
            flex-direction: column; /* Xếp Header trên, Nội dung dưới */
        }

        /* 2. Wrapper chiếm toàn bộ khoảng trống còn lại */
        .main-content-wrapper {
            flex: 1; /* Tự động giãn ra lấp đầy khoảng trống giữa Header và đáy màn hình */
            display: flex; /* Biến nó thành khung chứa linh hoạt */
            width: 100%;
            padding: 20px; /* Cách lề 1 chút trên điện thoại */
        }

        /* 3. Card đăng nhập - Dùng margin: auto để tự căn giữa */
        .auth-card {
            margin: auto; /* CODE QUAN TRỌNG NHẤT: Tự động đẩy về giữa trung tâm theo cả 4 phía */

            background: white;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.5);
            overflow: hidden;
            width: 100%;
            max-width: 500px;
        }

        /* --- Các phần trang trí bên trong Card giữ nguyên --- */
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
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(56, 239, 125, 0.4);
        }
    </style>

</head>
<body>
<jsp:include page="header.jsp" />

<div class="auth-card">
    <div class="auth-header">
        <h3><i class="fa-solid fa-user-plus me-2"></i>ĐĂNG KÝ</h3>
        <p class="mb-0">Tham gia cộng đồng MU Online lớn nhất</p>
    </div>

    <div class="p-4 p-md-5">

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> ${errorMessage}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post">

            <div class="mb-3">
                <label class="form-label">Tài khoản</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                    <input type="text" class="form-control" name="username" required placeholder="Nhập tên đăng nhập">
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Email</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-envelope"></i></span>
                    <input type="email" class="form-control" name="email" required placeholder="Nhập email thực">
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Số điện thoại</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-phone"></i></span>
                    <input type="text" class="form-control" name="phone" required placeholder="09xxxxxxxx">
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Mật khẩu</label>
                    <input type="password" class="form-control" name="password" required>
                </div>
                <div class="col-md-6 mb-4">
                    <label class="form-label">Nhập lại MK</label>
                    <input type="password" class="form-control" name="confirmPassword" required>
                </div>
            </div>

            <button type="submit" class="btn btn-submit mb-3">ĐĂNG KÝ NGAY</button>

            <div class="text-center">
                <small>Đã có tài khoản? <a href="${pageContext.request.contextPath}/login" class="text-decoration-none fw-bold">Đăng nhập</a></small>
            </div>
        </form>
    </div>
</div>

</body>
</html>