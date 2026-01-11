<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Sửa Server | MUXUA.CO</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700;900&family=Rajdhani:wght@500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* === GLOBAL THEME (Copy) === */
        :root { --mu-bg: #050505; --mu-gold: #cfaa56; --mu-red: #8b0000; --mu-border: #3d2b1f; --mu-glass: rgba(15, 15, 15, 0.95); }
        body { background-color: var(--mu-bg); color: #d1d1d1; font-family: 'Rajdhani', sans-serif; background-image: linear-gradient(to bottom, rgba(0,0,0,0.8), rgba(0,0,0,0.95)), url('https://wallpaperaccess.com/full/1524368.jpg'); background-attachment: fixed; background-size: cover; }
        .text-gold { color: var(--mu-gold) !important; }

        /* === CONTENT BOX === */
        .content-section { background: var(--mu-glass); border: 1px solid var(--mu-border); border-radius: 4px; padding: 30px; margin-bottom: 30px; position: relative; box-shadow: 0 0 20px rgba(0,0,0,0.8); }
        .content-section::after { content: ''; position: absolute; top: -1px; right: -1px; width: 20px; height: 20px; border-top: 2px solid var(--mu-gold); border-right: 2px solid var(--mu-gold); }
        .content-section::before { content: ''; position: absolute; bottom: -1px; left: -1px; width: 20px; height: 20px; border-bottom: 2px solid var(--mu-gold); border-left: 2px solid var(--mu-gold); }

        /* === FORM INPUTS (Khớp với profile.jsp) === */
        .form-label { color: var(--mu-gold); font-weight: 600; font-family: 'Cinzel', serif; font-size: 0.9rem; }
        .form-control-mu { background-color: rgba(255, 255, 255, 0.05); border: 1px solid #333; color: #fff; padding: 10px 15px; font-family: 'Rajdhani', sans-serif; font-size: 1.1rem; }
        .form-control-mu:focus { background-color: rgba(0, 0, 0, 0.5); border-color: var(--mu-gold); color: #fff; box-shadow: 0 0 10px rgba(207, 170, 86, 0.2); }
        .input-group-text { background-color: #111; border-color: #333; color: #777; }

        /* === BUTTONS === */
        .btn-gold { background: linear-gradient(to bottom, #d4af37, #aa8822); border: 1px solid #886611; color: #000; font-weight: 700; font-family: 'Cinzel', serif; text-transform: uppercase; transition: all 0.3s; }
        .btn-gold:hover { background: linear-gradient(to bottom, #ffdb58, #ccaa33); box-shadow: 0 0 15px rgba(212, 175, 55, 0.5); }
    </style>
</head>
<body>

<jsp:include page="../header.jsp" />

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="content-section">
                <h4 class="mb-4 pb-2 border-bottom border-secondary text-center">
                    <i class="fa-solid fa-scroll text-gold me-2"></i> YÊU CẦU CHỈNH SỬA
                </h4>

                <div class="alert alert-warning bg-transparent border border-warning text-warning d-flex align-items-center mb-4">
                    <i class="fa-solid fa-triangle-exclamation fa-2x me-3"></i>
                    <div>
                        <strong style="font-family: 'Cinzel', serif;">LƯU Ý QUAN TRỌNG</strong><br>
                        <span class="small">Thông tin sau khi sửa sẽ chuyển sang trạng thái <strong>CHỜ DUYỆT</strong>. Server sẽ hiển thị thông tin cũ cho đến khi Admin xác nhận.</span>
                    </div>
                </div>

                <form action="/manage/servers/edit" method="post">
                    <input type="hidden" name="serverId" value="${server.id}">

                    <div class="mb-3">
                        <label class="form-label">Tên Server (Mới)</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fa-solid fa-dungeon"></i></span>
                            <input type="text" name="newServerName" class="form-control form-control-mu" value="${server.serverName}" required>
                        </div>
                    </div>

                    <div class="mb-3 p-3 border border-secondary rounded" style="background: rgba(0,0,0,0.3);">
                        <label class="form-label mb-2">Hình Ảnh Banner</label>
                        <div class="row align-items-center">
                            <div class="col-4 text-center">
                                <img src="${server.bannerImage}" class="img-fluid border border-secondary" style="max-height: 80px;">
                                <div class="small text-muted fst-italic mt-1">Hiện tại</div>
                            </div>
                            <div class="col-8">
                                <input type="text" name="newBannerImage" class="form-control form-control-mu" value="${server.bannerImage}" placeholder="Link ảnh (Imgur/Postimages...)">
                                <div class="form-text text-secondary small">* Để trống nếu không muốn đổi ảnh.</div>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Trang Chủ URL</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-globe"></i></span>
                                <input type="text" name="newWebsiteUrl" class="form-control form-control-mu" value="${server.websiteUrl}">
                            </div>
                        </div>
                        <div class="col-md-6 mt-3 mt-md-0">
                            <label class="form-label">Fanpage URL</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-brands fa-facebook"></i></span>
                                <input type="text" name="newFanpageUrl" class="form-control form-control-mu" value="${server.fanpageUrl}">
                            </div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Mô Tả Giới Thiệu</label>
                        <textarea name="newDescription" class="form-control form-control-mu" rows="5">${server.description}</textarea>
                    </div>

                    <div class="d-flex justify-content-between pt-3 border-top border-secondary">
                        <a href="/manage/servers" class="btn btn-outline-light px-4" style="font-family: 'Cinzel', serif;">
                            <i class="fa-solid fa-arrow-left me-2"></i> Quay Lại
                        </a>
                        <button type="submit" class="btn btn-gold px-5">
                            <i class="fa-solid fa-paper-plane me-2"></i> Gửi Yêu Cầu
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<jsp:include page="../footer.jsp" />
</body>
</html>