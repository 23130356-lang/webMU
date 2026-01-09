<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thuê Quảng Cáo | MU Ads Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">

    <style>
        :root {
            --mu-gold: #cfaa56;
            --mu-red: #8b0000;
            --mu-dark: #05070a;
            --mu-glass: rgba(10, 15, 20, 0.85);
            --mu-glass-hover: rgba(20, 30, 40, 0.95);
        }

        body {
            background-color: var(--mu-dark);
            font-family: 'Inter', sans-serif;
            color: #e0e0e0;
            margin: 0;
            padding: 0;
        }

        /* Background chung */
        .page-wrapper {
            min-height: 100vh;
            padding: 40px 0;
            background: url('https://wallpaperaccess.com/full/1524368.jpg') no-repeat center center/cover;
            background-attachment: fixed;
            position: relative;
        }

        .page-wrapper::before {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: radial-gradient(circle, rgba(0,0,0,0.7) 0%, rgba(0,0,0,0.95) 100%);
            z-index: 0;
        }

        .container { position: relative; z-index: 1; }

        /* Tiêu đề trang */
        .page-header {
            text-align: center;
            margin-bottom: 40px;
        }
        .page-header h3 {
            font-family: 'Cinzel', serif;
            color: var(--mu-gold);
            font-weight: 700;
            text-transform: uppercase;
            text-shadow: 0 0 10px rgba(207, 170, 86, 0.5);
            font-size: 2rem;
        }

        /* === BANNER SLOT STYLES === */
        .banner-slot {
            background: var(--mu-glass);
            border: 1px solid #333;
            border-radius: 6px;
            padding: 25px;
            text-align: center;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            position: relative;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0,0,0,0.5);
            backdrop-filter: blur(5px);
            height: 100%; /* Để cột fill chiều cao */
        }

        .banner-slot:hover {
            transform: translateY(-5px);
            background: var(--mu-glass-hover);
            border-color: var(--mu-gold);
            box-shadow: 0 0 20px rgba(207, 170, 86, 0.2);
        }

        /* Border màu trên đầu card */
        .banner-slot::after {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 2px;
            background: linear-gradient(90deg, transparent, #555, transparent);
        }

        .slot-title {
            font-family: 'Cinzel', serif;
            color: #fff;
            font-weight: 700;
            font-size: 1.3rem;
            text-transform: uppercase;
            margin-bottom: 10px;
            letter-spacing: 1px;
        }

        .slot-vip .slot-title { color: #ff3333; text-shadow: 0 0 5px rgba(255,51,51,0.5); }
        .slot-vip { border: 1px solid rgba(255, 51, 51, 0.3); }
        .slot-vip:hover { border-color: #ff3333; }

        .slot-info {
            font-size: 0.9rem;
            color: #aaa;
            margin-bottom: 15px;
        }
        .slot-size { color: var(--mu-gold); font-weight: 600; }

        .qty-badge {
            background: #333;
            color: #fff;
            border: 1px solid #555;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 0.85em;
            margin-left: 5px;
        }

        .slot-status-label { font-size: 0.8rem; text-transform: uppercase; color: #777; margin-bottom: 5px; }
        .slot-status-text { font-family: 'Cinzel', serif; font-size: 1.1rem; font-weight: bold; margin-bottom: 20px; }

        /* Màu trạng thái */
        .status-available { color: #00ff00; text-shadow: 0 0 5px rgba(0,255,0,0.3); }
        .status-full { color: #ffcc00; text-shadow: 0 0 5px rgba(255,204,0,0.3); }
        .status-vip { color: #ff3333; text-shadow: 0 0 5px rgba(255,51,51,0.3); }

        /* Nút bấm Custom */
        .btn-mu-action {
            background: linear-gradient(180deg, var(--mu-red) 0%, #550000 100%);
            border: 1px solid #ff3333;
            color: #fff;
            font-weight: bold;
            text-transform: uppercase;
            font-family: 'Cinzel', serif;
            transition: all 0.3s;
        }
        .btn-mu-action:hover {
            background: linear-gradient(180deg, #cc0000 0%, #800000 100%);
            box-shadow: 0 0 15px rgba(255, 51, 51, 0.6);
            color: white;
        }

        .btn-mu-waitlist {
            background: linear-gradient(180deg, #1e3c72 0%, #122546 100%);
            border: 1px solid #4a90e2;
            color: #fff;
            font-weight: bold;
            text-transform: uppercase;
            font-family: 'Cinzel', serif;
        }
        .btn-mu-waitlist:hover {
            box-shadow: 0 0 15px rgba(74, 144, 226, 0.6);
            color: white;
        }

        .btn-mu-login {
            background: transparent;
            border: 1px solid #555;
            color: #aaa;
            text-transform: uppercase;
            font-size: 0.9rem;
        }
        .btn-mu-login:hover {
            border-color: var(--mu-gold);
            color: var(--mu-gold);
        }

        /* === MODAL STYLE === */
        .modal-content {
            background-color: #111;
            border: 1px solid #333;
            color: #fff;
            box-shadow: 0 0 30px rgba(0,0,0,0.9);
        }
        .modal-header { border-bottom: 1px solid #333; }
        .btn-close-white { filter: invert(1); }

        .modal-custom-header {
            background: linear-gradient(90deg, #550000, #220000);
            color: var(--mu-gold);
            font-family: 'Cinzel', serif;
        }
        .modal-custom-header.waitlist {
            background: linear-gradient(90deg, #002244, #001122);
            color: #4a90e2;
        }

        .form-control {
            background-color: rgba(255,255,255,0.05);
            border: 1px solid #444;
            color: #fff;
        }
        .form-control:focus {
            background-color: rgba(255,255,255,0.1);
            border-color: var(--mu-gold);
            color: #fff;
            box-shadow: none;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="page-wrapper">
    <div class="container">

        <div class="page-header">
            <h3><i class="fa-solid fa-scroll me-2"></i> Bảng Giá & Đăng Ký Quảng Cáo</h3>
            <p class="text-secondary small text-uppercase">Nâng tầm thương hiệu Server của bạn</p>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success bg-dark border-success text-success text-center mb-4">
                <i class="bi bi-check-circle-fill"></i> ${successMessage}
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger bg-dark border-danger text-danger text-center mb-4">
                <i class="bi bi-exclamation-triangle-fill"></i> ${errorMessage}
            </div>
        </c:if>

        <div class="row g-4 align-items-stretch">

            <div class="col-md-3">
                <div class="banner-slot">
                    <div class="slot-title">Banner Trái</div>
                    <div class="slot-info">
                        <div><i class="bi bi-aspect-ratio me-1"></i> <span class="slot-size">280 x 500 px</span></div>
                        <div class="mt-1">Đã đặt: <span class="qty-badge">${qtyInfo['LEFT_SIDEBAR']}</span></div>
                    </div>

                    <div class="slot-status-label">Tình trạng</div>
                    <div class="slot-status-text ${isFullLeft ? 'status-full' : 'status-available'}">
                        ${availability['LEFT_SIDEBAR']}
                    </div>

                    <div class="w-100 mt-auto">
                        <c:choose>
                            <c:when test="${not empty currentUser && !isFullLeft}">
                                <button class="btn btn-mu-action w-100 py-2"
                                        onclick="openRegisterModal('LEFT_SIDEBAR', 'Banner Trái', false)">
                                    Thuê Ngay
                                </button>
                            </c:when>
                            <c:when test="${not empty currentUser && isFullLeft}">
                                <button class="btn btn-mu-waitlist w-100 py-2"
                                        onclick="openRegisterModal('LEFT_SIDEBAR', 'Banner Trái', true)">
                                    <i class="bi bi-hourglass-split"></i> Đặt Chỗ Trước
                                </button>
                                <div class="mt-2 text-muted fst-italic small" style="font-size: 0.75rem">Xếp hàng chờ slot trống</div>
                            </c:when>
                            <c:otherwise>
                                <a href="/login" class="btn btn-mu-login w-100">Đăng nhập để thuê</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="d-flex flex-column h-100 gap-4">

                    <div class="banner-slot slot-vip flex-fill">
                        <div class="position-absolute top-0 end-0 p-2 text-danger"><i class="fa-solid fa-crown fa-lg"></i></div>

                        <div class="slot-title">Banner Giữa (VIP)</div>
                        <div class="slot-info">
                            <div><i class="bi bi-aspect-ratio me-1"></i> <span class="slot-size">1200 x 250 px</span></div>
                            <div class="mt-1">Đã đặt: <span class="qty-badge bg-danger text-white border-danger">${qtyInfo['HERO']}</span></div>
                        </div>

                        <div class="slot-status-label">Tình trạng</div>
                        <div class="slot-status-text ${isFullHero ? 'status-full' : 'status-vip'}">
                            ${availability['HERO']}
                        </div>

                        <div class="w-75 mt-auto">
                            <c:choose>
                                <c:when test="${not empty currentUser && !isFullHero}">
                                    <button class="btn btn-mu-action w-100 py-2 shadow-lg"
                                            onclick="openRegisterModal('HERO', 'Banner VIP Center', false)">
                                        THUÊ NGAY
                                    </button>
                                </c:when>
                                <c:when test="${not empty currentUser && isFullHero}">
                                    <button class="btn btn-mu-waitlist w-100 py-2"
                                            onclick="openRegisterModal('HERO', 'Banner VIP Center', true)">
                                        <i class="bi bi-hourglass-split"></i> Đặt Chỗ VIP
                                    </button>
                                    <div class="mt-2 text-muted fst-italic small">Vị trí HOT đang full</div>
                                </c:when>
                                <c:otherwise>
                                    <a href="/login" class="btn btn-mu-login w-100">Đăng nhập để thuê</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="banner-slot flex-fill">
                        <div class="slot-title">Banner Giữa (Nhỏ)</div>
                        <div class="slot-info">
                            <div><i class="bi bi-aspect-ratio me-1"></i> <span class="slot-size">1200 x 120 px</span></div>
                            <div class="mt-1">Đã đặt: <span class="qty-badge">${qtyInfo['STD']}</span></div>
                        </div>

                        <div class="slot-status-label">Tình trạng</div>
                        <div class="slot-status-text ${isFullStd ? 'status-full' : 'status-available'}">
                            ${availability['STD']}
                        </div>

                        <div class="w-75 mt-auto">
                            <c:choose>
                                <c:when test="${not empty currentUser && !isFullStd}">
                                    <button class="btn btn-mu-action w-100 py-2"
                                            onclick="openRegisterModal('STD', 'Banner Giữa Nhỏ', false)">
                                        Thuê Ngay
                                    </button>
                                </c:when>
                                <c:when test="${not empty currentUser && isFullStd}">
                                    <button class="btn btn-mu-waitlist w-100 py-2"
                                            onclick="openRegisterModal('STD', 'Banner Giữa Nhỏ', true)">
                                        <i class="bi bi-hourglass-split"></i> Đặt Chỗ Trước
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <a href="/login" class="btn btn-mu-login w-100">Đăng nhập để thuê</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="banner-slot">
                    <div class="slot-title">Banner Phải</div>
                    <div class="slot-info">
                        <div><i class="bi bi-aspect-ratio me-1"></i> <span class="slot-size">280 x 500 px</span></div>
                        <div class="mt-1">Đã đặt: <span class="qty-badge">${qtyInfo['RIGHT_SIDEBAR']}</span></div>
                    </div>

                    <div class="slot-status-label">Tình trạng</div>
                    <div class="slot-status-text ${isFullRight ? 'status-full' : 'status-available'}">
                        ${availability['RIGHT_SIDEBAR']}
                    </div>

                    <div class="w-100 mt-auto">
                        <c:choose>
                            <c:when test="${not empty currentUser && !isFullRight}">
                                <button class="btn btn-mu-action w-100 py-2"
                                        onclick="openRegisterModal('RIGHT_SIDEBAR', 'Banner Phải', false)">
                                    Thuê Ngay
                                </button>
                            </c:when>
                            <c:when test="${not empty currentUser && isFullRight}">
                                <button class="btn btn-mu-waitlist w-100 py-2"
                                        onclick="openRegisterModal('RIGHT_SIDEBAR', 'Banner Phải', true)">
                                    <i class="bi bi-hourglass-split"></i> Đặt Chỗ Trước
                                </button>
                                <div class="mt-2 text-muted fst-italic small" style="font-size: 0.75rem">Admin sẽ liên hệ khi trống</div>
                            </c:when>
                            <c:otherwise>
                                <a href="/login" class="btn btn-mu-login w-100">Đăng nhập để thuê</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<div class="modal fade" id="registerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header modal-custom-header" id="modalHeaderBg">
                <h5 class="modal-title fw-bold" id="modalTitle">ĐĂNG KÝ</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body p-4">
                <c:url var="postUrl" value="/banner-register"/>

                <form action="${postUrl}" method="post">
                    <sec:csrfInput />
                    <input type="hidden" name="positionCode" id="hiddenPosCode">

                    <div class="mb-3">
                        <label class="form-label text-secondary small text-uppercase fw-bold">Link Ảnh Banner (URL)</label>
                        <div class="input-group">
                            <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fa-solid fa-image"></i></span>
                            <input type="url" name="imageUrl" class="form-control" placeholder="https://imgur.com/..." required>
                        </div>
                        <div class="form-text text-secondary fst-italic" style="font-size: 0.8rem">Khuyên dùng: Upload ảnh lên Imgur và lấy link trực tiếp.</div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label text-secondary small text-uppercase fw-bold">Link Đích (Target URL)</label>
                        <div class="input-group">
                            <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fa-solid fa-link"></i></span>
                            <input type="url" name="targetUrl" class="form-control" placeholder="https://mu-server-cuaban.com" required>
                        </div>
                    </div>

                    <div class="alert alert-secondary bg-dark border-secondary text-secondary small d-flex align-items-center mb-4">
                        <i class="bi bi-info-circle me-2"></i>
                        <div>Sau khi gửi, Admin sẽ kiểm duyệt nội dung và liên hệ qua thông tin tài khoản để thanh toán Coin.</div>
                    </div>

                    <button type="submit" class="btn btn-mu-action w-100 py-2" id="btnSubmit">
                        <i class="fa-solid fa-paper-plane me-2"></i> GỬI YÊU CẦU
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function openRegisterModal(code, name, isWaitlist) {
        document.getElementById('hiddenPosCode').value = code;

        var headerBg = document.getElementById('modalHeaderBg');
        var title = document.getElementById('modalTitle');
        var btnSubmit = document.getElementById('btnSubmit');

        if (isWaitlist) {
            // Style cho Waitlist (Xanh tối)
            headerBg.classList.remove('modal-custom-header');
            headerBg.classList.add('waitlist');

            title.innerHTML = '<i class="bi bi-hourglass-split"></i> ĐẶT CHỖ TRƯỚC: ' + name;

            btnSubmit.className = 'btn btn-mu-waitlist w-100 py-2';
            btnSubmit.innerHTML = 'XÁC NHẬN VÀO HÀNG CHỜ';
        } else {
            // Style cho Thuê ngay (Đỏ MU)
            headerBg.classList.remove('waitlist');
            headerBg.classList.add('modal-custom-header');

            title.innerHTML = '<i class="fa-solid fa-bolt me-2"></i> THUÊ NGAY: ' + name;

            btnSubmit.className = 'btn btn-mu-action w-100 py-2';
            btnSubmit.innerHTML = 'GỬI ĐĂNG KÝ NGAY';
        }

        var myModal = new bootstrap.Modal(document.getElementById('registerModal'));
        myModal.show();
    }
</script>

</body>
</html>