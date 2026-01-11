<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700;900&family=Rajdhani:wght@500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    /* =========================================
       CSS ISOLATION: MUXUA HEADER
       Mọi style đều bắt đầu bằng #muxua-unique-header
       để không bị ảnh hưởng bởi Bootstrap bên ngoài
    ========================================= */

    /* 1. RESET CỤC BỘ (Quan trọng để xóa style thừa của trình duyệt/bootstrap) */
    #muxua-unique-header {
        all: initial; /* Reset toàn bộ thuộc tính về mặc định */
        font-family: 'Rajdhani', sans-serif;
        display: block;
        width: 100%;
        background: #050505; /* Màu nền tối */
        border-bottom: 1px solid #3d2b1f; /* Viền nâu đất */
        box-sizing: border-box;
        position: sticky;
        top: 0;
        z-index: 9999;
        box-shadow: 0 4px 15px rgba(0,0,0,0.8);
    }

    /* Reset box-sizing cho tất cả con cháu */
    #muxua-unique-header *,
    #muxua-unique-header *::before,
    #muxua-unique-header *::after {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
        outline: none;
    }

    /* Style mặc định cho link/list trong header */
    #muxua-unique-header a { text-decoration: none; color: inherit; transition: 0.3s; cursor: pointer; }
    #muxua-unique-header ul { list-style: none; }
    #muxua-unique-header button { border: none; background: none; cursor: pointer; }

    /* 2. LAYOUT CONTAINER */
    #muxua-unique-header .mh-container {
        max-width: 1320px;
        margin: 0 auto;
        padding: 0 15px;
        height: 70px; /* Chiều cao cố định */
        display: flex;
        align-items: center;
        justify-content: space-between;
        position: relative;
    }

    /* 3. LOGO SECTION */
    #muxua-unique-header .mh-logo-link {
        display: flex;
        flex-direction: column;
        justify-content: center;
        line-height: 1;
        margin-right: 40px;
    }
    #muxua-unique-header .mh-brand-main {
        font-family: 'Cinzel', serif;
        font-weight: 900;
        font-size: 26px;
        letter-spacing: 1px;
        text-transform: uppercase;
        color: #fff;
    }
    #muxua-unique-header .mh-brand-gold {
        color: #cfaa56; /* Vàng kim */
        text-shadow: 0 0 10px rgba(207, 170, 86, 0.6);
    }
    #muxua-unique-header .mh-brand-desc {
        font-size: 10px;
        color: #888;
        letter-spacing: 2px;
        text-transform: uppercase;
        margin-top: 4px;
    }

    /* 4. NAVIGATION MENU (DESKTOP) */
    #muxua-unique-header .mh-nav {
        flex-grow: 1;
        height: 100%;
        display: flex;
        align-items: center;
    }

    #muxua-unique-header .mh-menu-list {
        display: flex;
        gap: 5px;
        height: 100%;
    }

    #muxua-unique-header .mh-menu-item {
        position: relative; /* Để dropdown bám theo */
        height: 100%;
        display: flex;
        align-items: center;
    }

    #muxua-unique-header .mh-menu-link {
        font-family: 'Cinzel', serif;
        font-weight: 700;
        font-size: 13px;
        padding: 0 15px;
        text-transform: uppercase;
        color: #aaa;
        display: flex;
        align-items: center;
        height: 100%;
        border-bottom: 2px solid transparent;
    }

    #muxua-unique-header .mh-menu-link i { margin-right: 6px; font-size: 12px; color: #555; transition: 0.3s; }

    /* Hover menu item */
    #muxua-unique-header .mh-menu-link:hover {
        color: #cfaa56;
        text-shadow: 0 0 8px rgba(207, 170, 86, 0.4);
        background: rgba(255,255,255,0.02);
    }
    #muxua-unique-header .mh-menu-link:hover i { color: #8b0000; }

    /* Highlight Ads Link */
    #muxua-unique-header .mh-link-ads { color: #cfaa56 !important; }
    #muxua-unique-header .mh-link-ads i { color: #cfaa56 !important; }

    /* 5. DROPDOWN STYLE */
    #muxua-unique-header .mh-dropdown {
        display: none; /* Ẩn mặc định */
        position: absolute;
        top: 100%;
        left: 0;
        background: #0a0a0a;
        border: 1px solid #3d2b1f;
        border-top: 2px solid #8b0000;
        min-width: 220px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.9);
        z-index: 10000;
        animation: mhFadeIn 0.2s ease-in-out;
    }

    /* Hiện dropdown khi hover vào li cha */
    #muxua-unique-header .mh-menu-item:hover .mh-dropdown { display: block; }

    #muxua-unique-header .mh-dropdown-item {
        display: block;
        padding: 12px 15px;
        color: #ccc;
        border-bottom: 1px solid rgba(255,255,255,0.05);
        font-size: 13px;
        font-weight: 600;
        font-family: 'Rajdhani', sans-serif;
        text-transform: uppercase;
    }

    #muxua-unique-header .mh-dropdown-item:hover {
        background-color: rgba(139, 0, 0, 0.2);
        color: #fff;
        padding-left: 20px; /* Hiệu ứng trượt */
    }

    /* 6. RIGHT ACTIONS (Login, Button) */
    #muxua-unique-header .mh-actions {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    #muxua-unique-header .mh-login-link {
        font-size: 13px; font-weight: 700; color: #fff;
        white-space: nowrap; display: flex; align-items: center;
    }
    #muxua-unique-header .mh-login-link:hover { color: #cfaa56; }

    #muxua-unique-header .mh-btn-post {
        background: linear-gradient(180deg, #b91c1c 0%, #7f1d1d 100%);
        color: #fff;
        font-family: 'Cinzel', serif;
        font-weight: 700;
        font-size: 12px;
        padding: 8px 18px;
        border: 1px solid #ff5555;
        text-transform: uppercase;
        white-space: nowrap;
    }
    #muxua-unique-header .mh-btn-post:hover {
        background: linear-gradient(180deg, #dc2626 0%, #991b1b 100%);
        box-shadow: 0 0 10px rgba(220, 38, 38, 0.6);
    }

    /* User Profile Mini */
    #muxua-unique-header .mh-user-box { position: relative; cursor: pointer; }
    #muxua-unique-header .mh-user-display { display: flex; align-items: center; gap: 8px; }
    #muxua-unique-header .mh-avatar { width: 32px; height: 32px; border-radius: 4px; border: 1px solid #cfaa56; object-fit: cover; }
    #muxua-unique-header .mh-username { font-weight: 700; color: #cfaa56; font-size: 13px; }

    /* Dropdown của user */
    #muxua-unique-header .mh-user-dropdown {
        right: 0; left: auto; /* Căn phải */
    }
    #muxua-unique-header .mh-user-box:hover .mh-user-dropdown { display: block; }

    /* 7. RESPONSIVE (MOBILE) */
    #muxua-unique-header .mh-mobile-toggle { display: none; font-size: 24px; color: #cfaa56; padding: 10px; }

    @media (max-width: 991px) {
        #muxua-unique-header .mh-container { height: auto; flex-wrap: wrap; padding: 10px 15px; }
        #muxua-unique-header .mh-mobile-toggle { display: block; margin-left: auto; }
        #muxua-unique-header .mh-actions { margin-left: 0; display: none; /* Tạm ẩn action trên mobile header */ }

        #muxua-unique-header .mh-nav {
            display: none; /* Ẩn menu desktop */
            width: 100%; border-top: 1px solid #333; margin-top: 10px;
        }
        #muxua-unique-header .mh-nav.active { display: block; } /* Hiện khi click toggle */

        #muxua-unique-header .mh-menu-list { flex-direction: column; height: auto; gap: 0; }
        #muxua-unique-header .mh-menu-item { width: 100%; display: block; height: auto; }
        #muxua-unique-header .mh-menu-link { padding: 15px 0; border-bottom: 1px solid rgba(255,255,255,0.05); }

        #muxua-unique-header .mh-dropdown {
            position: static; box-shadow: none; border: none; background: rgba(255,255,255,0.02);
            padding-left: 20px;
        }
    }

    @keyframes mhFadeIn { from { opacity: 0; transform: translateY(5px); } to { opacity: 1; transform: translateY(0); } }
    /* --- LOGO KIM LOẠI 3D (REALISTIC METAL) --- */

    /* --- LOGO SẮC BÉN & GÓC CẠNH (EDGY STYLE) --- */

    #muxua-unique-header .mh-brand-main {
        font-family: 'Metal Mania', cursive; /* Font chữ gai góc */
        font-weight: 400; /* Font này mặc định đã đậm */
        font-size: 36px;  /* Tăng kích thước vì font này nét mảnh hơn */
        letter-spacing: 3px; /* Giãn chữ ra cho thoáng, trông bề thế hơn */
        text-transform: uppercase;
        display: flex;
        align-items: center;
        /* Nghiêng nhẹ (-10deg) để tạo cảm giác tốc độ và hung hãn */
        transform: skewX(-10deg);
        /* Bóng đổ cứng và đen đặc để tăng độ sắc nét */
        filter: drop-shadow(2px 2px 0px #000);
    }

    /* Class chung cho hiệu ứng kim loại */
    .metal-text {
        background-clip: text;
        -webkit-background-clip: text;
        color: transparent;
        background-size: 200% auto;
        animation: shineMetal 3s infinite linear;
        /* Thêm stroke (viền mảnh) để làm rõ các cạnh sắc */
        -webkit-text-stroke: 0.5px rgba(0,0,0,0.3);
    }

    /* 1. MU - CHIẾN BINH VÀNG (WARRIOR GOLD) */
    #muxua-unique-header .mh-brand-gold {
        /* Font này cần chỉnh margin 1 chút để không dính vào chữ sau */
        margin-right: 5px;

        /* Gradient Vàng rực lửa, độ tương phản cực cao */
        background-image: linear-gradient(
                180deg,
                #ffeb3b 0%,     /* Vàng chanh sáng chói trên đỉnh */
                #d4af37 40%,    /* Vàng gold ở giữa */
                #ffffff 50%,    /* TIA SÁNG CẮT NGANG */
                #8a5d18 51%,    /* Chuyển gắt sang nâu đậm (tạo gờ sắc cạnh) */
                #634211 100%    /* Chân chữ tối màu */
        );
    }

    /* 2. XUA.CO - THÉP LẠNH (COLD STEEL) */
    #muxua-unique-header .mh-brand-platinum {
        /* Gradient Thép xanh lạnh lẽo */
        background-image: linear-gradient(
                180deg,
                #e6f0ff 0%,     /* Trắng xanh (ánh trăng) */
                #aaccff 40%,    /* Xanh thép nhạt */
                #ffffff 50%,    /* TIA SÁNG CẮT NGANG */
                #7392ae 51%,    /* Chuyển gắt sang xám xanh đậm */
                #8db2d6 100%    /* Chân chữ xanh đen */
        );
    }

    /* Animation quét ánh sáng giữ nguyên */
    @keyframes shineMetal {
        0% { background-position: -200% center; }
        20% { background-position: 200% center; } /* Quét nhanh hơn (20%) để trông bén hơn */
        100% { background-position: 200% center; }
    }
</style>
<link href="https://fonts.googleapis.com/css2?family=Metal+Mania&display=swap" rel="stylesheet">
<div id="muxua-unique-header">
    <div class="mh-container">

        <a href="/" class="mh-logo-link">
            <div class="mh-brand-main">
                <span class="mh-brand-gold metal-text">MU</span>
                <span class="mh-brand-platinum metal-text">XUA.CO</span>
            </div>
            <div class="mh-brand-desc">Huyền Thoại Trở Lại</div>
        </a>

        <button class="mh-mobile-toggle" onclick="document.querySelector('#muxua-unique-header .mh-nav').classList.toggle('active')">
            <i class="fa-solid fa-bars"></i>
        </button>

        <nav class="mh-nav">
            <ul class="mh-menu-list">
                <li class="mh-menu-item">
                    <a href="/" class="mh-menu-link">
                        <i class="fa-solid fa-house-chimney"></i> Trang Chủ
                    </a>
                </li>

                <li class="mh-menu-item">
                    <a href="#" class="mh-menu-link">
                        <i class="fa-solid fa-scroll"></i> Phiên Bản <i class="fa-solid fa-caret-down" style="margin-left: 5px; font-size: 10px;"></i>
                    </a>
                    <ul class="mh-dropdown">
                        <c:if test="${not empty menuVersions}">
                            <c:forEach var="ver" items="${menuVersions}">
                                <li><a class="mh-dropdown-item" href="/search?version=${ver.id}">${ver.versionName}</a></li>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty menuVersions}">
                            <li><a class="mh-dropdown-item" href="#" style="color:#777;">(Đang cập nhật...)</a></li>
                        </c:if>
                    </ul>
                </li>

                <li class="mh-menu-item">
                    <a href="#" class="mh-menu-link">
                        <i class="fa-solid fa-shield-halved"></i> Loại Reset <i class="fa-solid fa-caret-down" style="margin-left: 5px; font-size: 10px;"></i>
                    </a>
                    <ul class="mh-dropdown">
                        <c:if test="${not empty menuTypes}">
                            <c:forEach var="type" items="${menuTypes}">
                                <li><a class="mh-dropdown-item" href="/search?type=${type.id}">${type.resetName}</a></li>
                            </c:forEach>
                        </c:if>
                    </ul>
                </li>

                <li class="mh-menu-item">
                    <a href="/huong-dan" class="mh-menu-link">
                        <i class="fa-solid fa-book-open"></i> Hướng Dẫn
                    </a>
                </li>

                <li class="mh-menu-item">
                    <a href="/banner-register" class="mh-menu-link mh-link-ads">
                        <i class="fa-solid fa-crown"></i> Quảng Cáo
                    </a>
                </li>
            </ul>
        </nav>

        <div class="mh-actions">
            <c:choose>
                <c:when test="${not empty sessionScope.currentUser}">
                    <div class="mh-user-box">
                        <div class="mh-user-display">
                            <img src="/images/default-avatar.png" class="mh-avatar" alt="Avt">
                            <span class="mh-username">${sessionScope.currentUser.username}</span>
                        </div>
                        <ul class="mh-dropdown mh-user-dropdown">
                            <li><a class="mh-dropdown-item" href="/profile"><i class="fa-solid fa-user me-2"></i> Hồ sơ</a></li>
                            <li><a class="mh-dropdown-item" href="/manage/servers"><i class="fa-solid fa-list me-2"></i> QL Server</a></li>
                            <li><a class="mh-dropdown-item" href="/manage/banners"><i class="fa-solid fa-list me-2"></i> QL Banner</a></li>
                            <li style="border-top: 1px solid #333;"><a class="mh-dropdown-item" href="/logout" style="color: #ff5555;"><i class="fa-solid fa-power-off me-2"></i> Đăng xuất</a></li>
                        </ul>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="/login" class="mh-login-link">
                        <i class="fa-solid fa-right-to-bracket" style="margin-right:5px;"></i> Đăng nhập
                    </a>
                </c:otherwise>
            </c:choose>

            <a href="/server/register" class="mh-btn-post">
                <i class="fa-solid fa-plus"></i> Đăng MU
            </a>
        </div>

    </div>
</div>