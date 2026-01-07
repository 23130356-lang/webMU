<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Phê duyệt bài đăng - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body>

<div class="d-flex">
    <%@ include file="sidebar.jsp" %>

    <div class="flex-grow-1 p-4 bg-light" style="height: 100vh; overflow-y: auto;">
        <h2 class="mb-4 text-primary fw-bold">Danh sách Server chờ duyệt</h2>

        <c:if test="${empty servers}">
            <div class="alert alert-warning" role="alert">
                Hiện tại không có server nào đang chờ duyệt.
            </div>
        </c:if>

        <c:if test="${not empty servers}">
            <div class="card shadow-sm">
                <div class="card-body p-0">
                    <table class="table table-hover table-bordered mb-0">
                        <thead class="table-dark">
                        <tr>
                            <th scope="col" class="text-center">ID</th>
                            <th scope="col">Tên Server</th>
                            <th scope="col">Người đăng</th>
                            <th scope="col">Ngày Alpha</th>
                            <th scope="col" class="text-center">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="s" items="${servers}">
                            <tr>
                                <td class="text-center fw-bold">${s.id}</td>

                                <td>${s.serverName}</td>

                                <td>
                                    <c:choose>
                                        <c:when test="${not empty s.user}">
                                            <span class="badge bg-info text-dark">${s.user.username}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">Không rõ (Lỗi data)</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${not empty s.schedule}">
                                            ${s.schedule.alphaDate}
                                        </c:when>
                                        <c:otherwise>Chưa cập nhật</c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="text-center">
                                    <a href="/admin/server/${s.id}" class="btn btn-primary btn-sm">
                                        <i class="bi bi-eye"></i> Xem & Duyệt
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