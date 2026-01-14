<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Server Hoạt Động</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body>

<div class="d-flex">
    <%@ include file="sidebar.jsp" %>

    <div class="flex-grow-1 p-4 bg-light" style="height: 100vh; overflow-y: auto;">
        <h2 class="mb-4 text-success fw-bold">Danh sách Server đang chạy</h2>

        <c:if test="${empty servers}">
            <div class="alert alert-info">Chưa có server nào đang hoạt động.</div>
        </c:if>

        <c:if test="${not empty servers}">
            <div class="card shadow-sm">
                <div class="card-body p-0">
                    <table class="table table-hover table-bordered mb-0 align-middle">
                        <thead class="table-success">
                        <tr>
                            <th class="text-center">ID</th>
                            <th>Tên Server</th>
                            <th>Gói Banner</th>
                            <th>Ngày Duyệt</th> <th>Ngày Kết Thúc</th> <th class="text-center">Trạng thái</th>
                            <th class="text-center">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="s" items="${servers}">
                            <tr>
                                <td class="text-center fw-bold text-success">${s.id}</td>
                                <td>
                                    <span class="fw-bold">${s.serverName}</span><br>
                                    <small class="text-muted">${s.muName}</small>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${s.bannerPackage == 'SUPER_VIP'}"><span class="badge bg-danger">SUPER VIP (14d)</span></c:when>
                                        <c:when test="${s.bannerPackage == 'VIP'}"><span class="badge bg-warning text-dark">VIP (10d)</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">Cơ bản (7d)</span></c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <c:if test="${not empty s.approvedAt}">
                                        ${s.approvedAt.toLocalDate()} <br>
                                        <small class="text-muted">${s.approvedAt.toLocalTime().toString().substring(0,5)}</small>
                                    </c:if>
                                </td>

                                <td class="fw-bold text-danger">
                                    <c:if test="${not empty s.expiredAt}">
                                        ${s.expiredAt.toLocalDate()} <br>
                                        <small class="text-muted">${s.expiredAt.toLocalTime().toString().substring(0,5)}</small>
                                    </c:if>
                                </td>

                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${s.isActive}"><span class="badge bg-success">Đang bật</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">Đã tắt</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <a href="/admin/server/${s.id}" class="btn btn-outline-primary btn-sm">
                                        <i class="bi bi-pencil-square"></i> Chi tiết
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>