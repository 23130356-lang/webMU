<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thuê Quảng Cáo | MUXUA.CO</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        body { background-color: #f0f2f5; font-family: 'Segoe UI', sans-serif; }
        .page-header { text-align: center; margin: 30px 0; text-transform: uppercase; color: #041421; }

        /* Style cho từng ô Banner */
        .banner-slot {
            background-color: #051b2c; /* Màu nền tối */
            color: white;
            border: 1px solid #0d3b5e;
            padding: 20px;
            margin-bottom: 20px;
            text-align: center;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            min-height: 200px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            position: relative;
            border-radius: 8px;
        }

        .banner-slot:hover {
            transform: translateY(-5px);
            border-color: #ffc107;
            box-shadow: 0 8px 15px rgba(0,0,0,0.4);
        }

        .slot-title {
            color: #ffc107;
            font-weight: 800;
            font-size: 1.4rem;
            text-transform: uppercase;
            margin-bottom: 10px;
        }

        .slot-info {
            font-size: 0.95rem;
            color: #aebfd1;
            margin-bottom: 15px;
            line-height: 1.6;
        }

        .slot-size { color: #fff; font-weight: bold; }

        .slot-status-label { font-size: 0.85rem; margin-bottom: 5px; opacity: 0.8; }
        .slot-status-text { font-size: 1.1rem; font-weight: bold; margin-bottom: 20px; }

        .sidebar-slot { height: 100%; min-height: 480px; }

        /* Hiệu ứng badge số lượng */
        .qty-badge {
            background: #dc3545;
            color: white;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 0.9em;
            margin-left: 5px;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container pb-5">
    <h3 class="page-header fw-bold">
        <i class="bi bi-megaphone-fill text-danger"></i> Đăng Ký Quảng Cáo Banner
    </h3>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success text-center shadow-sm">
            <i class="bi bi-check-circle-fill"></i> ${successMessage}
        </div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger text-center shadow-sm">
            <i class="bi bi-exclamation-triangle-fill"></i> ${errorMessage}
        </div>
    </c:if>

    <div class="row g-4">

        <div class="col-md-3">
            <div class="banner-slot sidebar-slot">
                <div class="slot-title">Banner Trái</div>
                <div class="slot-info">
                    Kích thước: <span class="slot-size">280 x 500 px</span><br>
                    Đã đặt: <span class="qty-badge">${qtyInfo['LEFT_SIDEBAR']}</span>
                </div>

                <div class="slot-status-label">Trạng thái:</div>
                <div class="slot-status-text ${isFullLeft ? 'text-warning' : 'text-success'}">
                    ${availability['LEFT_SIDEBAR']}
                </div>

                <%-- LOGIC NÚT BẤM --%>
                <c:choose>
                    <%-- 1. Đã đăng nhập & CÒN CHỖ --%>
                    <c:when test="${not empty currentUser && !isFullLeft}">
                        <button class="btn btn-warning fw-bold w-100 py-2"
                                onclick="openRegisterModal('LEFT_SIDEBAR', 'Banner Trái', false)">
                            THUÊ NGAY
                        </button>
                    </c:when>
                    <%-- 2. Đã đăng nhập & HẾT CHỖ (Waitlist) --%>
                    <c:when test="${not empty currentUser && isFullLeft}">
                        <button class="btn btn-primary fw-bold w-100 py-2"
                                onclick="openRegisterModal('LEFT_SIDEBAR', 'Banner Trái', true)">
                            <i class="bi bi-hourglass-split"></i> ĐẶT SLOT TRƯỚC
                        </button>
                        <small class="mt-2 text-white-50 fst-italic">Xếp hàng chờ khi có slot trống</small>
                    </c:when>
                    <%-- 3. Chưa đăng nhập --%>
                    <c:otherwise>
                        <a href="/login" class="btn btn-secondary w-100">ĐĂNG NHẬP ĐỂ THUÊ</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="col-md-6">
            <div class="d-flex flex-column h-100 gap-4">

                <div class="banner-slot flex-fill">
                    <div class="slot-title text-uppercase" style="color: #ff5722;">Banner Giữa To (VIP)</div>
                    <div class="slot-info">
                        Kích thước: <span class="slot-size">1200 x 250 px</span><br>
                        Đã đặt: <span class="qty-badge">${qtyInfo['HERO']}</span>
                    </div>

                    <div class="slot-status-label">Trạng thái:</div>
                    <div class="slot-status-text ${isFullHero ? 'text-warning' : 'text-danger'}">
                        ${availability['HERO']}
                    </div>

                    <c:choose>
                        <c:when test="${not empty currentUser && !isFullHero}">
                            <button class="btn btn-danger fw-bold w-75 py-2"
                                    onclick="openRegisterModal('HERO', 'Banner Giữa To', false)">
                                THUÊ NGAY
                            </button>
                        </c:when>
                        <c:when test="${not empty currentUser && isFullHero}">
                            <button class="btn btn-primary fw-bold w-75 py-2"
                                    onclick="openRegisterModal('HERO', 'Banner Giữa To', true)">
                                <i class="bi bi-hourglass-split"></i> ĐẶT SLOT TRƯỚC
                            </button>
                            <small class="mt-2 text-white-50 fst-italic">Vị trí VIP hiện đã full, đăng ký chờ ưu tiên.</small>
                        </c:when>
                        <c:otherwise>
                            <a href="/login" class="btn btn-secondary w-75">ĐĂNG NHẬP ĐỂ THUÊ</a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="banner-slot flex-fill">
                    <div class="slot-title">Banner Giữa Nhỏ</div>
                    <div class="slot-info">
                        Kích thước: <span class="slot-size">1200 x 120 px</span><br>
                        Đã đặt: <span class="qty-badge">${qtyInfo['STD']}</span>
                    </div>

                    <div class="slot-status-label">Trạng thái:</div>
                    <div class="slot-status-text ${isFullStd ? 'text-warning' : 'text-success'}">
                        ${availability['STD']}
                    </div>

                    <c:choose>
                        <c:when test="${not empty currentUser && !isFullStd}">
                            <button class="btn btn-warning fw-bold w-75 py-2"
                                    onclick="openRegisterModal('STD', 'Banner Giữa Nhỏ', false)">
                                THUÊ NGAY
                            </button>
                        </c:when>
                        <c:when test="${not empty currentUser && isFullStd}">
                            <button class="btn btn-primary fw-bold w-75 py-2"
                                    onclick="openRegisterModal('STD', 'Banner Giữa Nhỏ', true)">
                                <i class="bi bi-hourglass-split"></i> ĐẶT SLOT TRƯỚC
                            </button>
                            <small class="mt-2 text-white-50 fst-italic">Đăng ký vào danh sách chờ.</small>
                        </c:when>
                        <c:otherwise>
                            <a href="/login" class="btn btn-secondary w-75">ĐĂNG NHẬP ĐỂ THUÊ</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="banner-slot sidebar-slot">
                <div class="slot-title">Banner Phải</div>
                <div class="slot-info">
                    Kích thước: <span class="slot-size">280 x 500 px</span><br>
                    Đã đặt: <span class="qty-badge">${qtyInfo['RIGHT_SIDEBAR']}</span>
                </div>

                <div class="slot-status-label">Trạng thái:</div>
                <div class="slot-status-text ${isFullRight ? 'text-warning' : 'text-success'}">
                    ${availability['RIGHT_SIDEBAR']}
                </div>

                <c:choose>
                    <c:when test="${not empty currentUser && !isFullRight}">
                        <button class="btn btn-warning fw-bold w-100 py-2"
                                onclick="openRegisterModal('RIGHT_SIDEBAR', 'Banner Phải', false)">
                            THUÊ NGAY
                        </button>
                    </c:when>
                    <c:when test="${not empty currentUser && isFullRight}">
                        <button class="btn btn-primary fw-bold w-100 py-2"
                                onclick="openRegisterModal('RIGHT_SIDEBAR', 'Banner Phải', true)">
                            <i class="bi bi-hourglass-split"></i> ĐẶT SLOT TRƯỚC
                        </button>
                        <small class="mt-2 text-white-50 fst-italic">Admin sẽ liên hệ khi có slot trống.</small>
                    </c:when>
                    <c:otherwise>
                        <a href="/login" class="btn btn-secondary w-100">ĐĂNG NHẬP ĐỂ THUÊ</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div>
</div>

<div class="modal fade" id="registerModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header text-white" id="modalHeaderBg">
                <h5 class="modal-title fw-bold" id="modalTitle">ĐĂNG KÝ</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <c:url var="postUrl" value="/banner-register"/>

                <form action="${postUrl}" method="post">

                    <sec:csrfInput />

                    <input type="hidden" name="positionCode" id="hiddenPosCode">

                    <div class="mb-3">
                        <label class="form-label fw-bold">Link Ảnh Banner (URL)</label>
                        <input type="url" name="imageUrl" class="form-control" placeholder="Ví dụ: https://imgur.com/..." required>
                        <div class="form-text">Bạn có thể upload ảnh lên imgur.com rồi dán link vào đây.</div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Link Đích (Khi click vào banner)</label>
                        <input type="url" name="targetUrl" class="form-control" placeholder="Ví dụ: https://website-cua-ban.com" required>
                    </div>

                    <div class="alert alert-warning small d-flex align-items-center">
                        <i class="bi bi-info-circle-fill me-2"></i>
                        <div>Sau khi đăng ký, Admin sẽ duyệt và liên hệ thanh toán.</div>
                    </div>

                    <button type="submit" class="btn btn-success w-100 fw-bold py-2" id="btnSubmit">
                        <i class="bi bi-send-fill"></i> GỬI YÊU CẦU
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    /**
     * Hàm mở Modal
     * @param {string} code - Mã vị trí (HERO, STD...)
     * @param {string} name - Tên hiển thị
     * @param {boolean} isWaitlist - True nếu là đặt trước (đang full)
     */
    function openRegisterModal(code, name, isWaitlist) {
        // 1. Set giá trị vào input ẩn
        document.getElementById('hiddenPosCode').value = code;

        // 2. Lấy các element giao diện modal
        var headerBg = document.getElementById('modalHeaderBg');
        var title = document.getElementById('modalTitle');
        var btnSubmit = document.getElementById('btnSubmit');

        // 3. Thay đổi giao diện dựa trên trạng thái (Thuê ngay hay Đặt trước)
        if (isWaitlist) {
            // Giao diện Đặt trước (Màu Xanh Dương)
            headerBg.className = 'modal-header bg-primary text-white';
            title.innerHTML = '<i class="bi bi-hourglass-split"></i> ĐẶT CHỖ TRƯỚC: ' + name;
            btnSubmit.className = 'btn btn-primary w-100 fw-bold py-2';
            btnSubmit.innerHTML = 'XÁC NHẬN VÀO HÀNG CHỜ';
        } else {
            // Giao diện Thuê ngay (Màu Cam/Đỏ)
            headerBg.className = 'modal-header bg-danger text-white';
            title.innerHTML = '<i class="bi bi-lightning-fill"></i> THUÊ NGAY: ' + name;
            btnSubmit.className = 'btn btn-danger w-100 fw-bold py-2';
            btnSubmit.innerHTML = 'GỬI ĐĂNG KÝ NGAY';
        }

        // 4. Hiển thị Modal
        var myModal = new bootstrap.Modal(document.getElementById('registerModal'));
        myModal.show();
    }
</script>

</body>
</html>