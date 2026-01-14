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
                              <p><strong>Phone:</strong> ${sv.user.phone}</p>
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

               <div class="card-footer bg-white p-4">
    <div class="d-flex justify-content-end gap-2">

        <c:choose>

            <%-- TRƯỜNG HỢP 1: CHỜ DUYỆT (Hiện nút thao tác) --%>
            <c:when test="${sv.status == 'PENDING'}">

                <form action="/admin/reject/${sv.id}" method="post" onsubmit="return confirm('Bạn chắc chắn muốn từ chối server này?');">
                    <button type="submit" class="btn btn-danger">
                        <i class="bi bi-x-circle"></i> Từ chối
                    </button>
                </form>

                <form action="/admin/approve/${sv.id}" method="post" onsubmit="return confirm('Xác nhận duyệt và trừ tiền thành viên?');">
                    <button type="submit" class="btn btn-success">
                        <i class="bi bi-check-circle"></i> Duyệt ngay
                    </button>
                </form>

            </c:when>

            <%-- TRƯỜNG HỢP 2: ĐÃ DUYỆT (Chỉ hiện thông báo, ẩn nút) --%>
            <c:when test="${sv.status == 'APPROVED'}">
                <div class="alert alert-success m-0 py-2 px-4 d-flex align-items-center">
                    <i class="bi bi-check-circle-fill me-2"></i>
                    <strong>Đã duyệt</strong>
                    <span class="ms-2 small">(Ngày hết hạn: ${sv.expiredAt.toLocalDate()})</span>
                </div>
                <a href="/admin/approved" class="btn btn-secondary">Quay lại</a>
            </c:when>

            <%-- TRƯỜNG HỢP 3: ĐÃ TỪ CHỐI --%>
            <c:when test="${sv.status == 'REJECTED'}">
                <div class="alert alert-danger m-0 py-2 px-4">
                    <i class="bi bi-x-circle-fill me-2"></i> Đã từ chối
                </div>
                <a href="/admin/pending" class="btn btn-secondary">Quay lại</a>
            </c:when>

        </c:choose>

    </div>
</div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>