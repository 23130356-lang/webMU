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
            width: auto;
            border-radius: 4px;
            border: 1px solid #ddd;
            transition: transform 0.2s;
        }

        .banner-thumb:hover {
            transform: scale(3.0);
            z-index: 100;
            position: relative;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.3);
            border: 2px solid #fff;
        }
    </style>
</head>
<body>

<div class="d-flex">

    <%@ include file="sidebar.jsp" %>

    <div class="flex-grow-1 p-4 bg-light" style="height: 100vh; overflow-y: auto;">

        <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-2">
            <h3 class="text-primary fw-bold m-0"><i class="bi bi-layers-fill"></i> Quản Lý Quảng Cáo</h3>
            <button class="btn btn-outline-secondary btn-sm" onclick="location.reload()">
                <i class="bi bi-arrow-clockwise"></i> Làm mới
            </button>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <ul class="nav nav-tabs mb-3" id="bannerTabs" role="tablist">
            <li class="nav-item">
                <button
                        class="nav-link fw-bold active"
                        id="pending-tab"
                        data-bs-toggle="tab"
                        data-bs-target="#pending"
                        type="button"
                        role="tab"
                        aria-selected="true"
                        style="
        background-color: #dc3545 !important;
        color: #ffffff !important;
        border-color: #dc3545 !important;
    "
                >
                    <i class="bi bi-hourglass-split" style="color:#ffffff !important;"></i>
                    CHỜ DUYỆT
                    <span
                            class="badge rounded-pill ms-1"
                            style="background-color:#ffffff !important; color:#dc3545 !important;"
                    >
        3
    </span>
                </button>

            </li>
            <li class="nav-item">
                <button
                        class="nav-link fw-bold"
                        id="active-tab"
                        data-bs-toggle="tab"
                        data-bs-target="#active"
                        type="button"
                        style="
        background-color:#198754 !important;
        color:#ffffff !important;
        border-color:#198754 !important;
    "
                >
                    <i class="bi bi-broadcast" style="color:#ffffff !important;"></i>
                    ĐANG CHẠY
                    <span
                            class="badge rounded-pill ms-1"
                            style="background-color:#ffffff !important; color:#198754 !important;"
                    >
                        ${activeList.size()}
                    </span>
                </button>

            </li>
        </ul>

        <div class="tab-content" id="bannerTabsContent">

            <div class="tab-pane fade show active" id="pending">
                <div class="card shadow-sm border-0">
                    <div class="card-body p-0">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-dark">
                            <tr>
                                <th>Người đăng</th>
                                <th>Vị trí / ID</th>
                                <th>Ảnh Demo</th>
                                <th>Link Đích</th>
                                <th>Ngày tạo</th>
                                <th class="text-end pe-4">Hành động</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="item" items="${pendingList}">
                                <tr>
                                    <td>
                                        <div class="fw-bold">${item.user.username}</div>
                                        <small class="text-muted"><i class="bi bi-telephone"></i> ${item.user.phone}
                                        </small>
                                    </td>
                                    <td>
                                        <span class="badge bg-info text-dark mb-1">${item.positionCode}</span><br>
                                        <small class="text-muted">#${item.id}</small>
                                    </td>
                                    <td>
                                        <a href="${item.imageUrl}" target="_blank">
                                            <img src="${item.imageUrl}" class="banner-thumb" alt="Img">
                                        </a>
                                    </td>
                                    <td>
                                        <a href="${item.targetUrl}" target="_blank"
                                           class="text-truncate d-inline-block text-decoration-none"
                                           style="max-width: 150px;">
                                            Link
                                        </a>
                                    </td>
                                    <td>
                                        <fmt:parseDate value="${item.createdAt}" pattern="yyyy-MM-dd'T'HH:mm"
                                                       var="parsedDate" type="both"/>
                                        <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td class="text-end">
                                        <button class="btn btn-info btn-sm text-white me-1"
                                                onclick="showDetail('${item.id}', '${item.positionCode}', '${item.imageUrl}', '${item.targetUrl}', '${item.user.username}', '${item.user.email}', '${item.user.phone}', '${item.user.fullName}', '${item.user.coin}')">
                                            <i class="bi bi-eye-fill"></i>
                                        </button>
                                        <button class="btn btn-success btn-sm me-1"
                                                onclick="openApproveModal('${item.id}', '${item.positionCode}')">
                                            <i class="bi bi-check-lg"></i>
                                        </button>
                                        <a href="/admin/banner/delete/${item.id}" class="btn btn-outline-danger btn-sm"
                                           onclick="return confirm('Xóa yêu cầu này?')">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty pendingList}">
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted fst-italic">Không có yêu cầu chờ
                                        duyệt.
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="tab-pane fade" id="active">
                <div class="card shadow-sm border-0">
                    <div class="card-body p-0">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Vị trí</th>
                                <th>Người thuê</th>
                                <th>Thời gian</th>
                                <th>Trạng thái</th>
                                <th class="text-end pe-4">Hành động</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="item" items="${activeList}">
                                <tr>
                                    <td class="fw-bold text-center">#${item.id}</td>
                                    <td><span class="badge bg-primary">${item.positionCode}</span></td>
                                    <td><span class="fw-bold">${item.user.username}</span></td>
                                    <td>
                                        <small class="d-block text-success">Bắt đầu: <fmt:parseDate
                                                value="${item.startDate}" pattern="yyyy-MM-dd'T'HH:mm" var="sDate"
                                                type="both"/><fmt:formatDate value="${sDate}"
                                                                             pattern="dd/MM/yyyy"/></small>
                                        <small class="d-block text-danger">Kết thúc: <fmt:parseDate
                                                value="${item.endDate}" pattern="yyyy-MM-dd'T'HH:mm" var="eDate"
                                                type="both"/><fmt:formatDate value="${eDate}"
                                                                             pattern="dd/MM/yyyy"/></small>
                                    </td>
                                    <td><span class="badge bg-success">Active</span></td>
                                    <td class="text-end">
                                        <button class="btn btn-info btn-sm text-white me-1"
                                                onclick="showDetail('${item.id}', '${item.positionCode}', '${item.imageUrl}', '${item.targetUrl}', '${item.user.username}', '${item.user.email}', '${item.user.phone}', '${item.user.fullName}', '${item.user.coin}')">
                                            <i class="bi bi-eye-fill"></i></button>
                                        <a href="/admin/banner/delete/${item.id}" class="btn btn-danger btn-sm"
                                           onclick="return confirm('Dừng chạy banner này?')"><i
                                                class="bi bi-stop-circle"></i> Dừng</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty activeList}">
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted fst-italic">Chưa có banner hoạt
                                        động.
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
<div class="modal fade" id="approveModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title">Duyệt Banner</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="/admin/banner/approve" method="post">
                <div class="modal-body">
                    <input type="hidden" name="id" id="approveId">
                    <div class="alert alert-light border mb-3">Vị trí: <strong id="approvePos"
                                                                               class="text-danger"></strong></div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Ngày bắt đầu</label>
                        <input type="date" name="startDate" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Ngày kết thúc</label>
                        <input type="date" name="endDate" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-success fw-bold">XÁC NHẬN</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="detailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title fw-bold">CHI TIẾT ĐẦY ĐỦ</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-12 mb-4 text-center">
                        <div class="p-2 border rounded bg-light">
                            <img id="detailImage" src="" class="img-fluid rounded" style="max-height: 250px;">
                        </div>
                    </div>
                    <div class="col-md-6 border-end">
                        <h6 class="text-primary fw-bold text-uppercase border-bottom pb-2">Thông tin Quảng Cáo</h6>
                        <table class="table table-sm table-borderless">
                            <tr>
                                <td class="fw-bold text-secondary" style="width: 100px">ID:</td>
                                <td id="detailId"></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-secondary">Vị trí:</td>
                                <td id="detailPos" class="fw-bold text-danger"></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-secondary">Link:</td>
                                <td><a id="detailTarget" href="#" target="_blank" class="text-break"></a></td>
                            </tr>
                        </table>
                    </div>
                    <div class="col-md-6 ps-md-4">
                        <h6 class="text-success fw-bold text-uppercase border-bottom pb-2">Thông tin Người Thuê</h6>
                        <table class="table table-sm table-borderless">
                            <tr>
                                <td class="fw-bold text-secondary">User:</td>
                                <td id="detailUsername" class="fw-bold"></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-secondary">Họ tên:</td>
                                <td id="detailFullName"></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-secondary">Coin:</td>
                                <td id="detailCoin" class="fw-bold text-warning"></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-secondary">Email:</td>
                                <td id="detailEmail"></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-secondary">SĐT:</td>
                                <td id="detailPhone"></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div class="modal-footer bg-light">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function openApproveModal(id, position) {
        document.getElementById('approveId').value = id;
        document.getElementById('approvePos').innerText = position;
        var modal = new bootstrap.Modal(document.getElementById('approveModal'));
        modal.show();
    }

    function showDetail(id, pos, imgUrl, targetUrl, username, email, phone, fullName, coin) {
        document.getElementById('detailId').innerText = '#' + id;
        document.getElementById('detailPos').innerText = pos;
        document.getElementById('detailImage').src = imgUrl;
        document.getElementById('detailTarget').href = targetUrl;
        document.getElementById('detailTarget').innerText = targetUrl;
        document.getElementById('detailUsername').innerText = username;
        document.getElementById('detailCoin').innerText = (coin ? coin : '0') + ' Coin';
        document.getElementById('detailFullName').innerText = (fullName && fullName !== 'null' && fullName.trim() !== '') ? fullName : '---';
        document.getElementById('detailEmail').innerText = (email && email !== 'null' && email.trim() !== '') ? email : '---';
        document.getElementById('detailPhone').innerText = (phone && phone !== 'null' && phone.trim() !== '') ? phone : '---';
        var myModal = new bootstrap.Modal(document.getElementById('detailModal'));
        myModal.show();
    }
</script>

</body>
</html>