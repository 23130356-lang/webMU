<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Banner - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <style>
        .banner-thumb {
            height: 50px;
            border-radius: 4px;
            border: 1px solid #ddd;
            transition: transform 0.2s;
        }
        .banner-thumb:hover {
            transform: scale(3);
            z-index: 100;
            position: relative;
            box-shadow: 0 0 15px rgba(0,0,0,0.3);
        }
    </style>
</head>
<body>

<div class="d-flex">
    <%@ include file="sidebar.jsp" %>

    <div class="flex-grow-1 p-4 bg-light" style="height:100vh;overflow-y:auto">

        <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-2">
            <h3 class="text-success fw-bold m-0">
                <i class="bi bi-broadcast"></i> Banner Đang Chạy
            </h3>
            <button class="btn btn-outline-secondary btn-sm" onclick="location.reload()">
                <i class="bi bi-arrow-clockwise"></i> Làm mới
            </button>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show">
                ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Vị trí</th>
                        <th>Ảnh</th>
                        <th>Người thuê</th>
                        <th>Thời gian</th>
                        <th class="text-end pe-4">Hành động</th>
                    </tr>
                    </thead>
                    <tbody>

                    <c:forEach var="item" items="${activeList}">
                        <tr>
                            <td class="fw-bold text-center">#${item.id}</td>
                            <td><span class="badge bg-primary">${item.positionCode}</span></td>

                            <td>
                                <a href="${item.imageUrl}" target="_blank">
                                    <img src="${item.imageUrl}" class="banner-thumb">
                                </a>
                            </td>

                            <td class="fw-bold">${item.user.username}</td>

                            <td>
                                <small class="text-success d-block">
                                    BĐ:
                                    <fmt:parseDate value="${item.startDate}" pattern="yyyy-MM-dd'T'HH:mm" var="s"/>
                                    <fmt:formatDate value="${s}" pattern="dd/MM/yyyy"/>
                                </small>
                                <small class="text-danger d-block">
                                    KT:
                                    <fmt:parseDate value="${item.endDate}" pattern="yyyy-MM-dd'T'HH:mm" var="e"/>
                                    <fmt:formatDate value="${e}" pattern="dd/MM/yyyy"/>
                                </small>
                            </td>

                            <td class="text-end">
                                <button class="btn btn-info btn-sm text-white"
                                    onclick="showDetail(
                                        '${item.id}',
                                        '${item.positionCode}',
                                        '${item.imageUrl}',
                                        '${item.targetUrl}',
                                        '${item.user.username}',
                                        '${item.user.email}',
                                        '${item.user.phone}',
                                        '${item.user.fullName}',
                                        '${item.user.coin}')">
                                    <i class="bi bi-eye-fill"></i>
                                </button>

                                <a href="/admin/banner/delete/${item.id}"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Dừng chạy banner này?')">
                                    <i class="bi bi-stop-circle"></i> Dừng
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty activeList}">
                        <tr>
                            <td colspan="6" class="text-center text-muted py-5 fst-italic">
                                Chưa có banner đang chạy
                            </td>
                        </tr>
                    </c:if>

                    </tbody>
                </table>
            </div>
        </div>

    </div>
</div>

<!-- MODAL CHI TIẾT -->
<div class="modal fade" id="detailModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title">Chi tiết Banner</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <img id="detailImage" class="img-fluid rounded mb-3">
                <p><b>ID:</b> <span id="detailId"></span></p>
                <p><b>Vị trí:</b> <span id="detailPos"></span></p>
                <p><b>Link:</b> <a id="detailTarget" target="_blank"></a></p>
                <hr>
                <p><b>User:</b> <span id="detailUsername"></span></p>
                <p><b>Họ tên:</b> <span id="detailFullName"></span></p>
                <p><b>Email:</b> <span id="detailEmail"></span></p>
                <p><b>SĐT:</b> <span id="detailPhone"></span></p>
                <p><b>Coin:</b> <span id="detailCoin"></span></p>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function showDetail(id, pos, img, link, user, email, phone, fullName, coin) {
        detailId.innerText = '#' + id;
        detailPos.innerText = pos;
        detailImage.src = img;
        detailTarget.href = link;
        detailTarget.innerText = link;
        detailUsername.innerText = user;
        detailFullName.innerText = fullName || '---';
        detailEmail.innerText = email || '---';
        detailPhone.innerText = phone || '---';
        detailCoin.innerText = (coin || 0) + ' Coin';
        new bootstrap.Modal(detailModal).show();
    }
</script>

</body>
</html>
