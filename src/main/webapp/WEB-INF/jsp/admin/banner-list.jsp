<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Banner - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body>

<div class="d-flex">
    <%@ include file="sidebar.jsp" %>

    <div class="flex-grow-1 p-4 bg-light" style="height: 100vh; overflow-y: auto;">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary fw-bold mb-0">Danh sách Banner Quảng cáo</h2>
            <a href="/admin/banners/create" class="btn btn-success">
                <i class="bi bi-plus-lg"></i> Thêm mới
            </a>
        </div>

        <c:if test="${empty banners}">
            <div class="alert alert-warning shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> Hiện tại chưa có banner nào được tạo.
            </div>
        </c:if>

        <c:if test="${not empty banners}">
            <div class="card shadow-sm border-0">
                <div class="card-body p-0">
                    <table class="table table-hover table-bordered mb-0 align-middle">
                        <thead class="table-dark">
                        <tr>
                            <th scope="col" class="text-center" width="5%">ID</th>
                            <th scope="col" width="15%" class="text-center">Hình ảnh</th>
                            <th scope="col" width="15%">Vị trí</th>
                            <th scope="col" width="15%">Người đăng</th>
                            <th scope="col" width="10%" class="text-center">Thứ tự</th>
                            <th scope="col">Link đích</th>
                            <th scope="col" width="10%" class="text-center">Trạng thái</th>
                            <th scope="col" class="text-center" width="15%">Thao tác</th>
                        </tr>
                        </thead>
                       <tbody>
                        <c:forEach var="b" items="${banners}">
                            <tr>
                                <td class="text-center fw-bold text-secondary">${b.id}</td>

                                <td class="text-center bg-light">
                                    <img src="${b.imageUrl}" alt="Banner" style="height: 40px; border-radius: 4px;">
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${b.positionCode == 'HERO'}"><span class="badge bg-danger">HERO</span></c:when>
                                        <c:when test="${b.positionCode == 'STD'}"><span class="badge bg-primary">STD</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">${b.positionCode}</span></c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <c:if test="${not empty b.user}">
                                        <span class="badge bg-info text-dark">
                                            <i class="bi bi-person-fill"></i> ${b.user.username}
                                        </span>
                                    </c:if>
                                    <c:if test="${empty b.user}">
                                        <span class="text-muted small">System / Ẩn danh</span>
                                    </c:if>
                                </td>
                                <td class="text-center fw-bold">${b.displayOrder}</td>
                                <td class="text-truncate" style="max-width: 200px;">
                                    <a href="${b.targetUrl}" target="_blank" class="text-decoration-none text-dark">
                                        <i class="bi bi-link-45deg"></i> ${b.targetUrl}
                                    </a>
                                </td>

                                <td class="text-center">
                                    <a href="/admin/banners/toggle/${b.id}" class="text-decoration-none">
                                        <c:choose>
                                            <c:when test="${b.active}">
                                                <span class="badge bg-success"><i class="bi bi-check-circle"></i> Hiển thị</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary"><i class="bi bi-slash-circle"></i> Đang ẩn</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </a>
                                </td>

                                <td class="text-center">
                                    <div class="btn-group" role="group">
                                        <a href="/admin/banners/edit/${b.id}" class="btn btn-outline-primary btn-sm" title="Sửa">
                                            <i class="bi bi-pencil-square"></i>
                                        </a>
                                        <a href="/admin/banners/delete/${b.id}"
                                           class="btn btn-outline-danger btn-sm"
                                           onclick="return confirm('Bạn có chắc chắn muốn xóa banner này không?');" title="Xóa">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </div>
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