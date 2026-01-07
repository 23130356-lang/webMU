<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết Server: ${sv.serverName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="d-flex">
    <%@ include file="sidebar.jsp" %>

    <div class="flex-grow-1 p-4 bg-light">
        <a href="/admin/pending" class="btn btn-secondary mb-3">&larr; Quay lại danh sách</a>

        <div class="row">
            <div class="col-md-8">
                <div class="card mb-4 shadow-sm">
                    <div class="card-header bg-primary text-white fw-bold">Thông tin Server</div>
                    <div class="card-body">
                        <h3 class="text-primary">${sv.serverName}</h3>
                        <p><strong>MU:</strong> ${sv.muName}</p>
                        <p><strong>Slogan:</strong> <i>"${sv.slogan}"</i></p>
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
                    <div class="card-header bg-info text-white fw-bold">Thông tin Người đăng</div>
                    <div class="card-body">
                        <c:if test="${not empty sv.user}">
                            <p><strong>User:</strong> ${sv.user.username}</p>
                            <p><strong>Email:</strong> ${sv.user.email}</p>
                            <p><strong>Số dư:</strong> ${sv.user.balance} xu</p>
                        </c:if>
                        <c:if test="${empty sv.user}">
                            <p class="text-danger">Không tìm thấy chủ server</p>
                        </c:if>
                    </div>
                </div>

                <div class="card shadow-sm border-0">
                    <div class="card-body">
                        <form action="/admin/approve/${sv.id}" method="post" class="d-grid mb-2">
                            <button class="btn btn-success btn-lg fw-bold">✔ DUYỆT BÀI</button>
                        </form>

                        <form action="/admin/reject/${sv.id}" method="post" class="d-grid">
                            <button class="btn btn-danger" onclick="return confirm('Bạn chắc chắn muốn xóa Server này?')">✘ TỪ CHỐI / XÓA</button>
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