<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết Server: ${sv.serverName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body>
<div class="d-flex">
    <%@ include file="sidebar.jsp" %>

    <div class="flex-grow-1 p-4 bg-light">
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger shadow-sm">
                <i class="bi bi-exclamation-triangle-fill"></i> ${errorMessage}
            </div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success shadow-sm">
                <i class="bi bi-check-circle-fill"></i> ${successMessage}
            </div>
        </c:if>

        <a href="/admin/pending" class="btn btn-secondary mb-3">&larr; Quay lại danh sách</a>

        <div class="row">
            <div class="col-md-8">
                <div class="card mb-4 shadow-sm">
                    <div class="card-header bg-primary text-white fw-bold">
                        <i class="bi bi-hdd-network"></i> Thông tin Server
                    </div>
                    <div class="card-body">
                        <h3 class="text-primary">${sv.serverName}</h3>
                        <p><strong>MU:</strong> ${sv.muName}</p>
                        <p><strong>Slogan:</strong> <i>"${sv.slogan}"</i></p>

                        <div class="mb-3">
                            <strong>Gói Quảng Cáo: </strong>
                            <span class="badge bg-warning text-dark border border-dark">
                                <i class="bi bi-star-fill"></i> ${sv.bannerPackage.label}
                            </span>
                        </div>

                        <hr>

                        <div class="row">
                            <div class="col-6">
                                <h5 class="text-decoration-underline">Lịch trình</h5>
                                <c:if test="${not empty sv.schedule}">
                                    <p><strong>Alpha:</strong> ${sv.schedule.alphaDate} <br> <small>(${sv.schedule.alphaTime})</small></p>
                                    <p><strong>Open:</strong> ${sv.schedule.betaDate} <br> <small>(${sv.schedule.betaTime})</small></p>
                                </c:if>
                                <c:if test="${empty sv.schedule}">
                                    <p class="text-danger">Chưa cập nhật lịch trình</p>
                                </c:if>
                            </div>

                            <div class="col-6">
                                <h5 class="text-decoration-underline">Cấu hình</h5>
                                <c:if test="${not empty sv.serverStat}">
                                    <p><strong>Exp:</strong> ${sv.serverStat.expRate}x</p>
                                    <p><strong>Drop:</strong> ${sv.serverStat.dropRate}%</p>

                                    <p><strong>Version:</strong>
                                        <c:choose>
                                            <c:when test="${not empty sv.serverStat.muVersion}">
                                                ${sv.serverStat.muVersion.versionName}
                                            </c:when>
                                            <c:otherwise>Chưa rõ</c:otherwise>
                                        </c:choose>
                                    </p>
                                </c:if>
                                <c:if test="${empty sv.serverStat}">
                                    <p class="text-danger">Chưa cập nhật thông số</p>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">

                <div class="card mb-3 shadow-sm">
                    <div class="card-header bg-info text-white fw-bold">
                        <i class="bi bi-person-circle"></i> Thông tin Người đăng
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty sv.user}">
                            <p><strong>User:</strong> ${sv.user.username}</p>
                            <p><strong>Email:</strong> ${sv.user.email}</p>

                            <div class="alert alert-light border text-center mb-0">
                                <small>Số dư hiện tại:</small><br>
                                <span class="text-warning fw-bold fs-4">${sv.user.coin} Xu</span>
                            </div>
                        </c:if>

                        <c:if test="${empty sv.user}">
                            <p class="text-danger">Không tìm thấy chủ server</p>
                        </c:if>
                    </div>
                </div>

                <div class="card shadow-sm border-0">
                    <div class="card-header bg-success text-white fw-bold">
                        <i class="bi bi-lightning-charge"></i> Xử lý
                    </div>
                    <div class="card-body">

                        <c:choose>
                            <%-- TRƯỜNG HỢP 1: ĐỦ TIỀN --%>
                            <c:when test="${sv.user.coin >= sv.bannerPackage.price}">
                                <div class="alert alert-info text-center py-2" style="font-size: 0.9rem;">
                                    <i class="bi bi-check-circle"></i> Khách đủ tiền thanh toán.<br>
                                    <strong>Phí duyệt: ${sv.bannerPackage.price} Xu</strong>
                                </div>

                                <form action="/admin/approve/${sv.id}" method="post" class="d-grid mb-2">
                                    <button type="submit" class="btn btn-success btn-lg fw-bold"
                                            onclick="return confirm('Xác nhận duyệt và trừ ${sv.bannerPackage.price} Xu?')">
                                        ✔ DUYỆT BÀI
                                    </button>
                                </form>
                            </c:when>

                            <%-- TRƯỜNG HỢP 2: KHÔNG ĐỦ TIỀN --%>
                            <c:otherwise>
                                <div class="alert alert-danger text-center py-2">
                                    <strong><i class="bi bi-x-circle"></i> KHÔNG ĐỦ TIỀN</strong><br>
                                    Cần: ${sv.bannerPackage.price} Xu<br>
                                    Thiếu: <span class="fw-bold">${sv.bannerPackage.price - sv.user.coin} Xu</span>
                                </div>

                                <div class="d-grid mb-2">
                                    <button class="btn btn-secondary btn-lg" disabled>
                                        🚫 Không thể duyệt
                                    </button>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <form action="/admin/reject/${sv.id}" method="post" class="d-grid">
                            <button type="submit" class="btn btn-outline-danger"
                                    onclick="return confirm('Bạn muốn từ chối/xóa server này?')">
                                ✘ TỪ CHỐI / XÓA
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>