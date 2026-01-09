<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${pageTitle} - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body>

<div class="d-flex">
    <%@ include file="sidebar.jsp" %>

    <div class="flex-grow-1 p-4 bg-light" style="height: 100vh; overflow-y: auto;">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary fw-bold mb-0">${pageTitle}</h2>
            <a href="/admin/banners" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> Quay lại
            </a>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow-sm border-0">
                    <div class="card-body p-4">
                        <form:form action="/admin/banners/save" method="post" modelAttribute="banner">
                            <form:hidden path="id" />

                            <div class="mb-4">
                                <label class="form-label fw-bold text-secondary">Vị trí hiển thị <span class="text-danger">*</span></label>
                                <form:select path="positionCode" class="form-select form-select-lg">
                                    <form:option value="HERO">HERO (Slider Trang chủ - 1000x400)</form:option>
                                    <form:option value="STD">STD (Banner Ngang nhỏ - 1000x110)</form:option>
                                    <form:option value="LEFT_SIDEBAR">LEFT_SIDEBAR (Dọc Trái - 280x450)</form:option>
                                    <form:option value="RIGHT_SIDEBAR">RIGHT_SIDEBAR (Dọc Phải - 280x450)</form:option>
                                </form:select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold text-secondary">Link hình ảnh (URL) <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-image"></i></span>
                                    <form:input path="imageUrl" class="form-control" id="imgInput" placeholder="Ví dụ: https://imgur.com/example.jpg" onchange="previewImage()"/>
                                </div>
                                <div class="mt-2 text-center p-2 bg-light border rounded" style="min-height: 100px;">
                                    <img id="imgPreview" src="" alt="Xem trước ảnh tại đây" style="max-width: 100%; max-height: 200px; display: none; border-radius: 4px;">
                                    <small id="previewText" class="text-muted">Nhập link ảnh để xem trước</small>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold text-secondary">Link đích (Khi bấm vào banner)</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-link-45deg"></i></span>
                                    <form:input path="targetUrl" class="form-control" placeholder="https://website-game-mu.com" />
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold text-secondary">Thứ tự ưu tiên</label>
                                    <form:input type="number" path="displayOrder" class="form-control" min="0" />
                                    <div class="form-text">Số nhỏ xếp trước, số lớn xếp sau.</div>
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold text-secondary">Trạng thái</label>
                                    <div class="form-check form-switch mt-2">
                                        <form:checkbox path="active" class="form-check-input" id="activeSwitch" style="transform: scale(1.3); margin-right: 10px;"/>
                                        <label class="form-check-label pt-1" for="activeSwitch">Hiển thị ngay</label>
                                    </div>
                                </div>
                            </div>

                            <hr class="my-4">

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary btn-lg fw-bold">
                                    <i class="bi bi-save"></i> LƯU BANNER
                                </button>
                            </div>
                        </form:form>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<script>
    function previewImage() {
        const url = document.getElementById('imgInput').value;
        const img = document.getElementById('imgPreview');
        const text = document.getElementById('previewText');

        if (url && url.trim() !== "") {
            img.src = url;
            img.style.display = 'inline-block';
            text.style.display = 'none';
        } else {
            img.style.display = 'none';
            text.style.display = 'inline-block';
        }
    }

    // Chạy khi load trang (để hiển thị ảnh nếu đang Edit)
    document.addEventListener("DOMContentLoaded", function() {
        previewImage();
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>