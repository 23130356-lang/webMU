<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thuê Quảng Cáo | MUXUA.CO</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        body {
            background-color: #f0f2f5;
            font-family: 'Segoe UI', sans-serif;
        }
        .page-header {
            text-align: center;
            margin: 30px 0;
            text-transform: uppercase;
            color: #041421;
        }
        .banner-slot {
            background-color: #051b2c;
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
            transition: transform 0.2s;
        }
        .banner-slot:hover {
            transform: translateY(-5px);
            border-color: #ffc107;
        }
        .slot-title {
            color: #ffc107;
            font-weight: 800;
            font-size: 1.4rem;
            text-transform: uppercase;
            margin-bottom: 10px;
        }
        .slot-info {
            font-size: 0.9rem;
            color: #aebfd1;
            margin-bottom: 15px;
            line-height: 1.6;
        }
        .slot-size { color: #fff; font-weight: bold; }
        .slot-time-label {
            color: #ffc107;
            font-size: 0.85rem;
            margin-bottom: 5px;
        }
        .slot-time-value {
            font-size: 1.1rem;
            font-weight: bold;
            color: #fff;
            margin-bottom: 20px;
        }
        .sidebar-slot {
            height: 100%;
            min-height: 450px;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container pb-5">
    <h3 class="page-header fw-bold">Thông tin quảng cáo banner tại MuXua.Co</h3>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success text-center">${successMessage}</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger text-center">${errorMessage}</div>
    </c:if>

    <div class="row g-3">
        <div class="col-md-3">
            <div class="banner-slot sidebar-slot">
                <div class="slot-title">Banner Trái</div>
                <div class="slot-info">
                    Số lượng: 3/3<br>
                    Kích thước: <span class="slot-size">280 x 500 px</span>
                </div>
                <div class="slot-time-label">Thời gian có Slot:</div>
                <div class="slot-time-value">${availability['LEFT_SIDEBAR']}</div>

                <%-- Sử dụng JSTL chuẩn để kiểm tra userPrincipal --%>
                <c:choose>
                    <c:when test="${pageContext.request.userPrincipal != null}">
                        <button class="btn btn-warning fw-bold w-75"
                                onclick="openRegisterModal('LEFT_SIDEBAR', 'Banner Trái')">
                            THUÊ NGAY
                        </button>
                    </c:when>
                    <c:otherwise>
                        <a href="/login" class="btn btn-secondary w-75">ĐĂNG NHẬP ĐỂ THUÊ</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="col-md-6">
            <div class="d-flex flex-column h-100 gap-3">

                <div class="banner-slot flex-fill">
                    <div class="slot-title">Banner Giữa To (VIP)</div>
                    <div class="slot-info">
                        Số lượng: 1/1<br>
                        Kích thước: <span class="slot-size">1200 x 250 px</span>
                    </div>
                    <div class="slot-time-label">Thời gian có Slot:</div>
                    <div class="slot-time-value text-danger">${availability['HERO']}</div>

                    <c:choose>
                        <c:when test="${pageContext.request.userPrincipal != null}">
                            <button class="btn btn-warning fw-bold w-75"
                                    onclick="openRegisterModal('HERO', 'Banner Giữa To')">
                                THUÊ NGAY
                            </button>
                        </c:when>
                        <c:otherwise>
                            <a href="/login" class="btn btn-secondary w-75">ĐĂNG NHẬP ĐỂ THUÊ</a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="banner-slot flex-fill">
                    <div class="slot-title">Banner Giữa Nhỏ</div>
                    <div class="slot-info">
                        Số lượng: 5/5<br>
                        Kích thước: <span class="slot-size">1200 x 120 px</span>
                    </div>
                    <div class="slot-time-label">Thời gian có Slot:</div>
                    <div class="slot-time-value text-success">${availability['STD']}</div>

                    <c:choose>
                        <c:when test="${pageContext.request.userPrincipal != null}">
                            <button class="btn btn-warning fw-bold w-75"
                                    onclick="openRegisterModal('STD', 'Banner Giữa Nhỏ')">
                                THUÊ NGAY
                            </button>
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
                    Số lượng: 3/3<br>
                    Kích thước: <span class="slot-size">280 x 500 px</span>
                </div>
                <div class="slot-time-label">Thời gian có Slot:</div>
                <div class="slot-time-value text-success">${availability['RIGHT_SIDEBAR']}</div>

                <c:choose>
                    <c:when test="${pageContext.request.userPrincipal != null}">
                        <button class="btn btn-warning fw-bold w-75"
                                onclick="openRegisterModal('RIGHT_SIDEBAR', 'Banner Phải')">
                            THUÊ NGAY
                        </button>
                    </c:when>
                    <c:otherwise>
                        <a href="/login" class="btn btn-secondary w-75">ĐĂNG NHẬP ĐỂ THUÊ</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div>
</div>

<div class="modal fade" id="registerModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title fw-bold">ĐĂNG KÝ: <span id="modalPosName">...</span></h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form action="/banner-register" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="positionCode" id="hiddenPosCode">

                    <div class="mb-3">
                        <label class="form-label fw-bold">Link Ảnh Banner</label>
                        <input type="url" name="imageUrl" class="form-control" placeholder="https://..." required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Link Website / Fanpage</label>
                        <input type="url" name="targetUrl" class="form-control" placeholder="https://..." required>
                    </div>

                    <div class="alert alert-warning small">
                        Sau khi đăng ký, Admin sẽ liên hệ qua thông tin tài khoản của bạn để xác nhận thanh toán.
                    </div>

                    <button type="submit" class="btn btn-danger w-100 fw-bold">GỬI ĐĂNG KÝ</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function openRegisterModal(code, name) {
        document.getElementById('modalPosName').innerText = name;
        document.getElementById('hiddenPosCode').value = code;
        var myModal = new bootstrap.Modal(document.getElementById('registerModal'));
        myModal.show();
    }
</script>

</body>
</html>