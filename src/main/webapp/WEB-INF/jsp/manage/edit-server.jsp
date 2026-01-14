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
        /* === GLOBAL THEME === */
        :root { --mu-bg: #050505; --mu-gold: #cfaa56; --mu-red: #8b0000; --mu-border: #3d2b1f; --mu-glass: rgba(15, 15, 15, 0.95); }
        body { background-color: var(--mu-bg); color: #d1d1d1; font-family: 'Rajdhani', sans-serif; background-image: linear-gradient(to bottom, rgba(0,0,0,0.8), rgba(0,0,0,0.95)), url('https://wallpaperaccess.com/full/1524368.jpg'); background-attachment: fixed; background-size: cover; }
        .text-gold { color: var(--mu-gold) !important; }

        /* === CONTENT BOX === */
        .content-section { background: var(--mu-glass); border: 1px solid var(--mu-border); border-radius: 4px; padding: 30px; margin-bottom: 30px; position: relative; box-shadow: 0 0 20px rgba(0,0,0,0.8); }
        .content-section::after { content: ''; position: absolute; top: -1px; right: -1px; width: 20px; height: 20px; border-top: 2px solid var(--mu-gold); border-right: 2px solid var(--mu-gold); }
        .content-section::before { content: ''; position: absolute; bottom: -1px; left: -1px; width: 20px; height: 20px; border-bottom: 2px solid var(--mu-gold); border-left: 2px solid var(--mu-gold); }

        /* === BUTTONS === */
        .btn-gold { background: linear-gradient(to bottom, #d4af37, #aa8822); border: 1px solid #886611; color: #000; font-weight: 700; font-family: 'Cinzel', serif; text-transform: uppercase; transition: all 0.3s; }
        .btn-gold:hover { background: linear-gradient(to bottom, #ffdb58, #ccaa33); box-shadow: 0 0 15px rgba(212, 175, 55, 0.5); }
        .text-muted {color: #ffe6be !important;
        }
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

                <div class="text-center py-5">
                    <div class="mb-4">
                        <span class="fa-stack fa-3x">
                            <i class="fa-solid fa-circle fa-stack-2x" style="color: rgba(255,255,255,0.05);"></i>
                            <i class="fa-solid fa-screwdriver-wrench fa-stack-1x text-secondary"></i>
                        </span>
                    </div>

                    <h3 class="text-gold mb-3" style="font-family: 'Cinzel', serif;">TÍNH NĂNG TẠM KHÓA</h3>

                    <p class="text-muted fs-5 px-md-5">
                        Hệ thống đang nâng cấp quy trình kiểm duyệt nội dung.<br>
                        Chức năng chỉnh sửa thông tin Server tạm thời không khả dụng.
                    </p>

                    <div class="alert alert-dark d-inline-block mt-3 border border-secondary text-secondary"
                         style="color: #850000 !important;">
                        <i class="fa-solid fa-circle-info me-2"></i>
                        Vui lòng liên hệ Admin nếu cần thay đổi gấp.
                    </div>


                    <div class="mt-5">
                        <a href="/manage/servers" class="btn btn-gold px-5">
                            <i class="fa-solid fa-arrow-left me-2"></i> QUAY LẠI QUẢN LÝ
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page="../footer.jsp" />
</body>
</html>