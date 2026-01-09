<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
    .sidebar-container {
        width: 280px;
        min-height: 100vh;
        background: linear-gradient(180deg, #1e1e2d 0%, #151521 100%); /* Màu nền Gradient hiện đại */
        box-shadow: 4px 0 10px rgba(0,0,0,0.1);
        color: #a2a3b7; /* Màu chữ xám bạc dễ chịu */
        transition: all 0.3s ease;
    }

    .sidebar-brand {
        height: 70px;
        display: flex;
        align-items: center;
        padding: 0 25px;
        font-weight: 700;
        font-size: 1.25rem;
        color: #ffffff;
        letter-spacing: 1px;
        border-bottom: 1px solid rgba(255,255,255,0.05);
    }

    .sidebar-brand i {
        color: #0d6efd; /* Màu xanh của Bootstrap Primary */
        font-size: 1.5rem;
    }

    .nav-item {
        margin-bottom: 5px;
    }

    .nav-link {
        color: #a2a3b7 !important;
        font-weight: 500;
        padding: 12px 25px;
        display: flex;
        align-items: center;
        transition: all 0.3s;
        border-left: 3px solid transparent;
        border-radius: 0 !important; /* Vuông vức hoặc bo góc tùy sở thích */
    }

    .nav-link i {
        font-size: 1.1rem;
        margin-right: 12px;
        width: 24px;
        text-align: center;
        transition: all 0.3s;
    }

    /* Hiệu ứng khi di chuột */
    .nav-link:hover {
        background-color: rgba(255, 255, 255, 0.05);
        color: #ffffff !important;
        padding-left: 30px; /* Hiệu ứng trượt nhẹ sang phải */
    }

    .nav-link:hover i {
        color: #0d6efd;
    }

    /* Trạng thái đang chọn (Active) */
    .nav-link.active {
        background-color: rgba(13, 110, 253, 0.1); /* Nền xanh nhạt */
        color: #ffffff !important;
        border-left-color: #0d6efd; /* Viền trái màu xanh */
    }

    .nav-link.active i {
        color: #0d6efd;
    }

    .sidebar-footer {
        border-top: 1px solid rgba(255,255,255,0.05);
        padding: 20px 25px;
    }

    .btn-logout {
        background: rgba(220, 53, 69, 0.1);
        color: #dc3545;
        border: none;
        width: 100%;
        padding: 10px;
        border-radius: 8px;
        transition: 0.3s;
        text-decoration: none;
        display: block;
        text-align: center;
        font-weight: 600;
    }

    .btn-logout:hover {
        background: #dc3545;
        color: #fff;
    }
</style>

<div class="sidebar-container d-flex flex-column flex-shrink-0">
    <a href="/admin/dashboard" class="sidebar-brand text-decoration-none">
        <i class="bi bi-controller me-2"></i> <span>MU ADMIN</span>
    </a>

    <ul class="nav flex-column mb-auto py-3" id="adminMenu">

        <li class="nav-item">
            <a href="/admin/dashboard" class="nav-link">
                <i class="bi bi-grid-1x2-fill"></i>
                Dashboard
            </a>
        </li>

        <li class="px-4 py-2 text-uppercase text-muted" style="font-size: 0.75rem; font-weight: 700;">Quản lý Server</li>

        <li class="nav-item">
            <a href="/admin/pending" class="nav-link">
                <i class="bi bi-hourglass-split"></i>
                Chờ duyệt
            </a>
        </li>

        <li class="nav-item">
            <a href="/admin/approved" class="nav-link">
                <i class="bi bi-check-circle-fill"></i>
                Đang hoạt động
            </a>
        </li>
        <li class="nav-item">
            <a href="/admin/banners" class="nav-link">
                <i class="bi bi-check-circle-fill"></i>
                Quản lý banner
            </a>
        </li>

        <li class="px-4 py-2 mt-2 text-uppercase text-muted" style="font-size: 0.75rem; font-weight: 700;">Hệ thống</li>

        <li class="nav-item">
            <a href="/admin/users" class="nav-link">
                <i class="bi bi-people-fill"></i>
                Quản lý User
            </a>
        </li>
    </ul>

    <div class="sidebar-footer mt-auto">
        <c:if test="${not empty sessionScope.currentUser}">
            <div class="d-flex align-items-center mb-3">
                <div class="bg-primary rounded-circle d-flex justify-content-center align-items-center text-white fw-bold"
                     style="width: 40px; height: 40px; margin-right: 10px;">
                    A
                </div>
                <div style="line-height: 1.2;">
                    <span class="d-block text-white fw-bold">${sessionScope.currentUser.username}</span>
                    <small class="text-muted" style="font-size: 0.8rem;">Administrator</small>
                </div>
            </div>
        </c:if>

        <a href="/logout" class="btn-logout">
            <i class="bi bi-box-arrow-right me-2"></i> Đăng xuất
        </a>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        // Lấy đường dẫn hiện tại (ví dụ: /admin/approved)
        var currentPath = window.location.pathname;

        // Tìm tất cả thẻ a trong menu
        var menuLinks = document.querySelectorAll('#adminMenu .nav-link');

        menuLinks.forEach(function(link) {
            // Nếu href của link trùng với đường dẫn hiện tại
            if (link.getAttribute('href') === currentPath) {
                link.classList.add('active'); // Thêm class active
            }
        });
    });
</script>