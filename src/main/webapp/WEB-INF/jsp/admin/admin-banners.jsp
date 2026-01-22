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
        /* Style cho Admin Form */
        .admin-form-label {
            font-weight: 600;
            font-size: 0.9rem;
            color: #555;
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

            <div>
                <button class="btn btn-success btn-sm me-2" data-bs-toggle="modal" data-bs-target="#createBannerModal">
                    <i class="bi bi-plus-circle"></i> Thêm Banner
                </button>
                <button class="btn btn-outline-secondary btn-sm" onclick="location.reload()">
                    <i class="bi bi-arrow-clockwise"></i> Làm mới
                </button>
            </div>
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
                            <td>
                                <c:choose>
                                    <c:when test="${item.positionCode == 'HERO'}"><span class="badge bg-danger">HERO (VIP)</span></c:when>
                                    <c:when test="${item.positionCode == 'STD'}"><span class="badge bg-primary">Center</span></c:when>
                                    <c:otherwise><span class="badge bg-secondary">${item.positionCode}</span></c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <a href="${item.imageUrl}" target="_blank">
                                    <img src="${item.imageUrl}" class="banner-thumb">
                                </a>
                            </td>

                            <td class="fw-bold">
                                <c:if test="${not empty item.user}">${item.user.username}</c:if>
                                <c:if test="${empty item.user}">System</c:if>
                            </td>

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
                                        '${item.user != null ? item.user.username : 'System'}',
                                        '${item.user != null ? item.user.email : ''}',
                                        '${item.user != null ? item.user.phone : ''}',
                                        '${item.user != null ? item.user.fullName : ''}',
                                        '${item.user != null ? item.user.coin : 0}')">
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

<div class="modal fade" id="detailModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title">Chi tiết Banner</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <img id="detailImage" class="img-fluid rounded mb-3" style="max-height: 300px; width: auto; display: block; margin: 0 auto;">
                <div class="row">
                    <div class="col-md-6">
                        <p><b>ID:</b> <span id="detailId"></span></p>
                        <p><b>Vị trí:</b> <span id="detailPos"></span></p>
                        <p><b>Link đích:</b> <a id="detailTarget" target="_blank" class="text-truncate d-inline-block" style="max-width: 200px; vertical-align: bottom;"></a></p>
                    </div>
                    <div class="col-md-6">
                        <p><b>User:</b> <span id="detailUsername"></span></p>
                        <p><b>Họ tên:</b> <span id="detailFullName"></span></p>
                        <p><b>Coin:</b> <span id="detailCoin"></span></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="createBannerModal" tabindex="-1" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-plus-square me-2"></i>Thêm Banner Mới</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <form action="/admin/banner/create" method="post" enctype="multipart/form-data" id="adminBannerForm">

                    <div class="mb-3">
                        <label class="form-label admin-form-label">Chọn vị trí hiển thị <span class="text-danger">*</span></label>
                        <select class="form-select" name="positionCode" required>
                            <option value="" disabled selected>-- Chọn Slot --</option>
                            <option value="HERO">Banner Giữa (VIP) - 1200x250</option>
                            <option value="STD">Banner Giữa (Nhỏ) - 1200x120</option>
                            <option value="LEFT_SIDEBAR">Banner Trái - 280x500</option>
                            <option value="RIGHT_SIDEBAR">Banner Phải - 280x500</option>
                        </select>
                    </div>

                    <div class="row mb-3">
                        <div class="col-6">
                             <label class="form-label admin-form-label">Thời hạn (Ngày)</label>
                             <input type="number" name="durationDays" class="form-control" value="30" min="1" required>
                        </div>
                        <div class="col-6">
                             <label class="form-label admin-form-label">Thứ tự ưu tiên</label>
                             <input type="number" name="displayOrder" class="form-control" value="1" min="0">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label admin-form-label">Nguồn hình ảnh</label>
                        <div class="d-flex gap-3 mb-2">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="uploadType" id="admTypeFile" value="file" checked onchange="toggleAdminInput()">
                                <label class="form-check-label" for="admTypeFile">Upload File</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="uploadType" id="admTypeLink" value="url" onchange="toggleAdminInput()">
                                <label class="form-check-label" for="admTypeLink">Link Ảnh (URL)</label>
                            </div>
                        </div>

                        <input type="file" name="imageFile" id="inpFile" class="form-control" accept="image/*" required>
                        <input type="url" name="imageUrl" id="inpUrl" class="form-control d-none" placeholder="https://example.com/image.jpg">
                    </div>

                    <div class="mb-3">
                        <label class="form-label admin-form-label">Link đích (Target URL) <span class="text-danger">*</span></label>
                        <input type="url" name="targetUrl" class="form-control" placeholder="https://mu-moi-ra.com" required>
                    </div>

                    <div class="d-grid mt-4">
                        <button type="submit" class="btn btn-success fw-bold py-2">
                            <i class="bi bi-check-circle me-2"></i> KÍCH HOẠT NGAY
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Xử lý Modal chi tiết
    function showDetail(id, pos, img, link, user, email, phone, fullName, coin) {
        document.getElementById('detailId').innerText = '#' + id;
        document.getElementById('detailPos').innerText = pos;
        document.getElementById('detailImage').src = img;

        const linkEl = document.getElementById('detailTarget');
        linkEl.href = link;
        linkEl.innerText = link;

        document.getElementById('detailUsername').innerText = user;
        document.getElementById('detailFullName').innerText = fullName || '---';
        document.getElementById('detailCoin').innerText = (coin || 0) + ' Coin';

        new bootstrap.Modal(document.getElementById('detailModal')).show();
    }

    // Xử lý Toggle Upload/Link ở Modal Thêm mới
    function toggleAdminInput() {
        const isFile = document.getElementById('admTypeFile').checked;
        const fileInput = document.getElementById('inpFile');
        const urlInput = document.getElementById('inpUrl');

        if (isFile) {
            fileInput.classList.remove('d-none');
            fileInput.setAttribute('required', 'required');

            urlInput.classList.add('d-none');
            urlInput.removeAttribute('required');
            urlInput.value = '';
        } else {
            fileInput.classList.add('d-none');
            fileInput.removeAttribute('required');
            fileInput.value = '';

            urlInput.classList.remove('d-none');
            urlInput.setAttribute('required', 'required');
        }
    }
</script>

</body>
</html>