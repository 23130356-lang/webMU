<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="d-flex flex-column flex-shrink-0 p-3 text-white bg-dark" style="width: 280px; min-height: 100vh;">
    <a href="/" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none">
        <span class="fs-4">MU ADS ADMIN</span>
    </a>
    <hr>
    <ul class="nav nav-pills flex-column mb-auto">
        <li class="nav-item">
            <a href="/admin/dashboard" class="nav-link text-white">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
        </li>
        <li>
            <a href="/admin/pending" class="nav-link active"> <i class="bi bi-check-circle"></i> Phê duyệt bài đăng
            </a>
        </li>
        <li>
            <a href="/admin/users" class="nav-link text-white">
                <i class="bi bi-people"></i> Quản lý User
            </a>
        </li>
        <li>
            <a href="/logout" class="nav-link text-danger">
                <i class="bi bi-box-arrow-right"></i> Đăng xuất
            </a>
        </li>
    </ul>
</div>