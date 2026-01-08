<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
    /* --- PHẦN 1: CÔ LẬP VÀ RESET --- */
    #mu-header-isolate {
        /* Cắt đứt mọi thừa kế font chữ/màu sắc từ Body trang Login */
        all: initial; /* (Tuỳ chọn) Reset toàn bộ về mặc định trình duyệt */

        display: block;
        width: 100%;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important;
        font-size: 16px !important;
        line-height: 1.5 !important;
        color: #fff !important;
        text-align: left !important;
        background-color: #041421 !important;
        box-sizing: border-box;

        /* Đảm bảo nằm trên cùng */
        position: relative;
        z-index: 9999;
    }

    /* Reset toàn bộ thẻ con bên trong về box-sizing chuẩn */
    #mu-header-isolate *,
    #mu-header-isolate *::before,
    #mu-header-isolate *::after {
        box-sizing: border-box;
    }

    /* Reset thẻ A (Link) để không dính màu xanh/gạch chân của Bootstrap */
    #mu-header-isolate a {
        text-decoration: none !important;
        color: #fff !important;
        font-weight: normal;
        font-style: normal;
        cursor: pointer;
    }

    /* --- PHẦN 2: STYLE CỤ THỂ (Đều bắt đầu bằng #mu-header-isolate) --- */

    /* Navbar Container */
    #mu-header-isolate .mu-navbar {
        background-color: #041421 !important;
        border-bottom: 2px solid #b70000 !important;
        padding: 0 !important;
    }

    /* Brand / Logo */
    #mu-header-isolate .navbar-brand {
        font-weight: 800 !important;
        font-size: 1.5rem !important;
        text-transform: uppercase !important;
        margin-right: 1rem !important;
        display: inline-block;
    }
    #mu-header-isolate .brand-yellow { color: #ffd700 !important; }
    #mu-header-isolate .brand-white { color: #ffffff !important; }
    #mu-header-isolate .brand-desc {
        font-size: 0.6rem !important;
        color: #aaa !important;
        font-weight: normal !important;
        letter-spacing: 1px !important;
        line-height: 1 !important;
        display: block;
    }

    /* Menu Item */
    #mu-header-isolate .nav-link {
        color: #ffffff !important;
        font-weight: 700 !important;
        text-transform: uppercase !important;
        font-size: 0.9rem !important;
        padding: 18px 15px !important;
        transition: all 0.3s;
        display: block;
    }

    #mu-header-isolate .nav-link:hover {
        background-color: #b70000 !important;
        color: white !important;
    }

    #mu-header-isolate .nav-link i {
        color: #ff0000 !important;
        margin-right: 5px;
        font-size: 0.7rem;
    }

    /* Dropdown Menu */
    #mu-header-isolate .dropdown-menu {
        background-color: #041421 !important;
        border: 1px solid #333 !important;
        border-top: 3px solid #b70000 !important;
        border-radius: 0 !important;
        margin-top: 0 !important;
        padding: 0 !important;
    }

    #mu-header-isolate .dropdown-item {
        color: #fff !important;
        padding: 12px 20px !important;
        border-bottom: 1px solid rgba(255,255,255,0.1) !important;
        font-weight: 600 !important;
        text-transform: uppercase !important;
        font-size: 0.85rem !important;
        background: transparent !important;
        display: block;
        width: 100%;
        clear: both;
    }

    #mu-header-isolate .dropdown-item:hover {
        background-color: #0d2a42 !important;
        color: #ffd700 !important;
    }

    /* Nút Đăng MU Mới */
    #mu-header-isolate .btn-post-mu {
        background-color: #cc0000 !important;
        color: white !important;
        font-weight: bold !important;
        text-transform: uppercase !important;
        border-radius: 2px !important;
        padding: 8px 20px !important;
        border: 1px solid #ff3333 !important;
        box-shadow: 0 0 10px rgba(255, 0, 0, 0.3) !important;
        display: inline-block;
        white-space: nowrap;
    }
    #mu-header-isolate .btn-post-mu:hover {
        background-color: #ff0000 !important;
    }

    /* User Area */
    #mu-header-isolate .user-area {
        display: flex;
        align-items: center;
        color: white !important;
    }
    #mu-header-isolate .user-avatar {
        width: 32px;
        height: 32px;
        background-color: #ddd;
        border-radius: 50%;
        margin-right: 8px;
        object-fit: cover;
    }

    /* Login Link */
    #mu-header-isolate .login-link-custom {
        color: #fff !important;
        font-weight: bold;
        margin-right: 10px;
        font-size: 0.9rem;
    }
    .mu-header-container {
        /* Reset cứng các thuộc tính có thể bị thừa kế */
        display: block !important;
        width: 100% !important;
        font-family: 'Segoe UI', sans-serif !important;
        line-height: 1.5 !important;
        text-align: left !important;
        font-size: 16px !important;

        /* Đảm bảo nó nằm trên cùng */
        position: sticky;
        top: 0;
        z-index: 1030;
    }

</style>

<div id="mu-header-isolate">

    <nav class="navbar navbar-expand-lg mu-navbar sticky-top">
        <div class="container">
            <a class="navbar-brand" href="/">
                <span class="brand-yellow">MU</span><span class="brand-white">XUA.CO</span>
                <span class="brand-desc">Website tổng hợp MU lớn nhất VN</span>
            </a>

            <button class="navbar-toggler bg-secondary" type="button" data-bs-toggle="collapse" data-bs-target="#muNav">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="muNav">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">

                    <li class="nav-item">
                        <a class="nav-link" href="/">
                            <i class="bi bi-diamond-fill"></i> MU Mới Ra
                        </a>
                    </li>

                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="bi bi-diamond-fill"></i> Mu Theo Phiên Bản
                        </a>
                        <ul class="dropdown-menu">
                            <c:if test="${not empty menuVersions}">
                                <c:forEach var="ver" items="${menuVersions}">
                                    <li><a class="dropdown-item" href="/search?version=${ver.id}">${ver.versionName}</a></li>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty menuVersions}">
                                <li><a class="dropdown-item text-muted" href="#">(Đang cập nhật...)</a></li>
                            </c:if>
                        </ul>
                    </li>

                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="bi bi-diamond-fill"></i> Mu Theo Loại
                        </a>
                        <ul class="dropdown-menu">
                            <c:if test="${not empty menuTypes}">
                                <c:forEach var="type" items="${menuTypes}">
                                    <li><a class="dropdown-item" href="/search?type=${type.id}">${type.resetName}</a></li>
                                </c:forEach>
                            </c:if>
                        </ul>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link" href="/huong-dan">
                            <i class="bi bi-diamond-fill"></i> Hướng Dẫn
                        </a>
                    </li>
                </ul>

                <div class="d-flex align-items-center gap-3">
                    <c:choose>
                        <c:when test="${not empty sessionScope.currentUser}">
                            <div class="dropdown">
                                <a href="#" class="user-area text-decoration-none dropdown-toggle" data-bs-toggle="dropdown">
                                    <img src="/images/default-avatar.png" class="user-avatar" alt="User">
                                    <span class="fw-bold">${sessionScope.currentUser.username}</span>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><a class="dropdown-item" href="/user/profile">Trang cá nhân</a></li>
                                    <li><a class="dropdown-item" href="/user/my-servers">Quản lý Server</a></li>
                                    <li><hr class="dropdown-divider bg-light"></li>
                                    <li><a class="dropdown-item text-danger" href="/logout">Đăng xuất</a></li>
                                </ul>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="/login" class="login-link-custom">Đăng nhập</a>
                        </c:otherwise>
                    </c:choose>

                    <a href="/server/register" class="btn-post-mu">ĐĂNG MU MỚI</a>
                </div>
            </div>
        </div>
    </nav>
</div>