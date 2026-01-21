<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản Lý Server | MUNORIA.MOBILE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700;900&family=Rajdhani:wght@500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* === GLOBAL THEME (Copy từ Profile) === */
        :root { --mu-bg: #050505; --mu-gold: #cfaa56; --mu-red: #8b0000; --mu-red-bright: #dc3545; --mu-glass: rgba(15, 15, 15, 0.95); --mu-border: #3d2b1f; }
        body { background-color: var(--mu-bg); color: #d1d1d1; font-family: 'Rajdhani', sans-serif; background-image: linear-gradient(to bottom, rgba(0,0,0,0.8), rgba(0,0,0,0.95)), url('https://wallpaperaccess.com/full/1524368.jpg'); background-size: cover; background-attachment: fixed; background-position: center; }
        h1, h2, h3, h4, h5 { font-family: 'Cinzel', serif; text-transform: uppercase; letter-spacing: 1px; }
        .text-gold { color: var(--mu-gold) !important; }

        /* === CONTENT BOX === */
        .content-section { background: var(--mu-glass); border: 1px solid var(--mu-border); border-radius: 4px; padding: 30px; margin-bottom: 30px; position: relative; box-shadow: 0 0 20px rgba(0,0,0,0.8); }
        .content-section::after { content: ''; position: absolute; top: -1px; right: -1px; width: 20px; height: 20px; border-top: 2px solid var(--mu-gold); border-right: 2px solid var(--mu-gold); }
        .content-section::before { content: ''; position: absolute; bottom: -1px; left: -1px; width: 20px; height: 20px; border-bottom: 2px solid var(--mu-gold); border-left: 2px solid var(--mu-gold); }

        /* === BUTTONS === */
        .btn-gold { background: linear-gradient(to bottom, #d4af37, #aa8822); border: 1px solid #886611; color: #000; font-weight: 700; font-family: 'Cinzel', serif; text-transform: uppercase; transition: all 0.3s; }
        .btn-gold:hover { background: linear-gradient(to bottom, #ffdb58, #ccaa33); box-shadow: 0 0 15px rgba(212, 175, 55, 0.5); color: #000; }

        /* === SERVER CARD STYLE === */
        .server-item {
            background: rgba(0, 0, 0, 0.4);
            border: 1px solid #333;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .server-item:hover {
            background: rgba(0, 0, 0, 0.8);
            border-color: var(--mu-gold);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.5);
        }
        .server-thumb {
            width: 100%;
            height: 100px;
            object-fit: fill;
            border-bottom: 1px solid #333;
        }
        .status-badge {
            position: absolute; top: 10px; right: 10px;
            font-size: 0.7rem; font-weight: bold; padding: 4px 8px; border-radius: 2px;
            text-transform: uppercase; font-family: 'Cinzel', serif;
            box-shadow: 0 2px 5px rgba(0,0,0,0.5);
        }
        .status-approved { background: #198754; color: white; border: 1px solid #146c43; }
        .status-pending { background: #ffc107; color: black; border: 1px solid #d39e00; }
        .status-rejected { background: var(--mu-red); color: white; border: 1px solid #5c0000; }

        .meta-info { font-size: 0.9rem; color: #aaa; }
        .meta-info i { width: 20px; text-align: center; color: var(--mu-gold); margin-right: 5px; }
    </style>
</head>
<body>

<jsp:include page="../header.jsp" />

<div class="container py-5">
    <div class="row">
        <div class="col-lg-3 mb-4">
            <div class="content-section p-0 overflow-hidden">
                <div class="p-3 bg-black border-bottom border-secondary">
                    <h5 class="text-gold mb-0 text-center">MENU QUẢN LÝ</h5>
                </div>
                <div class="list-group list-group-flush bg-transparent">
                    <a href="/profile" class="list-group-item list-group-item-action bg-transparent text-light border-secondary"><i class="fa-solid fa-user me-2"></i> Hồ Sơ</a>
                    <a href="/manage/servers" class="list-group-item list-group-item-action bg-transparent text-gold border-secondary fw-bold" style="border-left: 3px solid var(--mu-gold);"><i class="fa-solid fa-server me-2"></i> Server Của Tôi</a>
                    <a href="/manage/banners" class="list-group-item list-group-item-action bg-transparent text-light border-secondary"><i class="fa-solid fa-image me-2"></i> Banner Quảng Cáo</a>
                    <a href="/logout" class="list-group-item list-group-item-action bg-transparent text-danger border-0"><i class="fa-solid fa-right-from-bracket me-2"></i> Đăng Xuất</a>
                </div>
            </div>
        </div>

        <div class="col-lg-9">
            <div class="content-section">
                <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom border-secondary">
                    <h4 class="mb-0"><i class="fa-solid fa-dungeon text-gold me-2"></i> QUẢN LÝ MÁY CHỦ</h4>
                    <a href="/server-register" class="btn btn-gold btn-sm"><i class="fa-solid fa-plus-circle me-1"></i> Đăng Mới</a>
                </div>

                <c:if test="${not empty successMessage}"><div class="alert alert-success bg-dark text-success border-success mb-3"><i class="fa-solid fa-check me-2"></i> ${successMessage}</div></c:if>
                <c:if test="${not empty errorMessage}"><div class="alert alert-danger bg-dark text-danger border-danger mb-3"><i class="fa-solid fa-bug me-2"></i> ${errorMessage}</div></c:if>

                <div class="row g-3">
                    <c:forEach var="sv" items="${servers}">
                        <div class="col-md-6">
                            <div class="server-item rounded">
                                <c:choose>
                                    <c:when test="${sv.status == 'APPROVED'}"><span class="status-badge status-approved">Đang chạy</span></c:when>
                                    <c:when test="${sv.status == 'PENDING'}"><span class="status-badge status-pending">Chờ duyệt</span></c:when>
                                    <c:when test="${sv.status == 'REJECTED'}"><span class="status-badge status-rejected">Từ chối</span></c:when>
                                </c:choose>

                                <img src="${sv.bannerImage}" class="server-thumb" alt="Banner">

                                <div class="p-3">
                                    <h5 class="text-white mb-2 text-truncate" style="font-family: 'Cinzel', serif;">${sv.serverName}</h5>

                                    <div class="meta-info mb-1"><i class="fa-solid fa-gamepad"></i> ${sv.muName}</div>
                                    <div class="meta-info mb-1">
                                        <i class="fa-solid fa-hourglass-end"></i> Hết hạn:
                                        <span class="text-light">
                                            <fmt:parseDate value="${sv.expiredAt}" pattern="yyyy-MM-dd'T'HH:mm" var="pExp" type="both"/>
                                            <fmt:formatDate value="${pExp}" pattern="dd/MM/yyyy"/>
                                        </span>
                                    </div>
                                    <div class="meta-info mb-3">
                                        <i class="fa-solid fa-crown"></i> Gói: <span class="text-warning">${sv.bannerPackage}</span>
                                    </div>

                                    <div class="d-flex gap-2">
                                        <a href="/manage/servers/edit/${sv.id}" class="btn btn-outline-light btn-sm w-50" style="border-color: #555;">
                                            <i class="fa-solid fa-pen-nib"></i> Sửa
                                        </a>
                                        <a href="/manage/servers/renew/${sv.id}"
                                           class="btn btn-outline-warning btn-sm w-50 text-gold border-warning"
                                           onclick="return confirm('Gia hạn gói ${sv.bannerPackage.label}?\nGiá: ${sv.bannerPackage.price} Xu / 10 Ngày\nBạn có chắc chắn muốn tiếp tục?');">
                                            <i class="fa-solid fa-cart-arrow-down"></i> Gia Hạn
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty servers}">
                        <div class="col-12 py-5 text-center text-muted">
                            <i class="fa-solid fa-ghost fa-3x mb-3 opacity-25"></i>
                            <p>Bạn chưa có máy chủ nào.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../footer.jsp" />
</body>
</html>