<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản Lý Banner | MUNORIA.MOBILE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700;900&family=Rajdhani:wght@500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* === GLOBAL THEME (Copy) === */
        :root { --mu-bg: #050505; --mu-gold: #cfaa56; --mu-border: #3d2b1f; --mu-glass: rgba(15, 15, 15, 0.95); }
        body { background-color: var(--mu-bg); color: #d1d1d1; font-family: 'Rajdhani', sans-serif; background-image: linear-gradient(to bottom, rgba(0,0,0,0.8), rgba(0,0,0,0.95)), url('https://wallpaperaccess.com/full/1524368.jpg'); background-attachment: fixed; background-size: cover; }
        .text-gold { color: var(--mu-gold) !important; }

        .content-section { background: var(--mu-glass); border: 1px solid var(--mu-border); border-radius: 4px; padding: 30px; margin-bottom: 30px; position: relative; box-shadow: 0 0 20px rgba(0,0,0,0.8); }
        .content-section::after { content: ''; position: absolute; top: -1px; right: -1px; width: 20px; height: 20px; border-top: 2px solid var(--mu-gold); border-right: 2px solid var(--mu-gold); }
        .content-section::before { content: ''; position: absolute; bottom: -1px; left: -1px; width: 20px; height: 20px; border-bottom: 2px solid var(--mu-gold); border-left: 2px solid var(--mu-gold); }

        /* === LUXURY TABLE STYLE === */
        .table-mu {
            background: transparent;
            color: #ccc;
            vertical-align: middle;
        }
        .table-mu thead th {
            background-color: rgba(0,0,0,0.5);
            color: var(--mu-gold);
            font-family: 'Cinzel', serif;
            font-weight: 700;
            border-bottom: 2px solid var(--mu-gold);
            text-transform: uppercase;
            padding: 15px;
        }
        .table-mu tbody td {
            background: transparent;
            border-bottom: 1px solid #333;
            padding: 15px;
        }
        .table-mu tbody tr:hover td {
            background-color: rgba(207, 170, 86, 0.05);
            color: #fff;
        }
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
                    <a href="/manage/servers" class="list-group-item list-group-item-action bg-transparent text-light border-secondary"><i class="fa-solid fa-server me-2"></i> Server Của Tôi</a>
                    <a href="/manage/banners" class="list-group-item list-group-item-action bg-transparent text-gold border-secondary fw-bold" style="border-left: 3px solid var(--mu-gold);"><i class="fa-solid fa-image me-2"></i> Banner Quảng Cáo</a>
                    <a href="/logout" class="list-group-item list-group-item-action bg-transparent text-danger border-0"><i class="fa-solid fa-right-from-bracket me-2"></i> Đăng Xuất</a>
                </div>
            </div>
        </div>

        <div class="col-lg-9">
            <div class="content-section">
                <h4 class="mb-4 pb-2 border-bottom border-secondary">
                    <i class="fa-solid fa-rectangle-ad text-gold me-2"></i> BANNER QUẢNG CÁO
                </h4>

                <div class="table-responsive">
                    <table class="table table-mu text-center">
                        <thead>
                        <tr>
                            <th width="15%">Hình Ảnh</th>
                            <th width="15%">Vị Trí</th>
                            <th width="30%">Link Đích</th>
                            <th width="20%">Hết Hạn</th>
                            <th width="20%">Trạng Thái</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="bn" items="${banners}">
                            <tr>
                                <td>
                                    <img src="${bn.imageUrl}" class="rounded border border-secondary" style="height: 40px; object-fit: cover;">
                                </td>
                                <td><span class="badge bg-secondary border border-secondary">${bn.positionCode}</span></td>
                                <td class="text-start">
                                    <a href="${bn.targetUrl}" target="_blank" class="text-gold text-decoration-none small text-truncate d-block" style="max-width: 200px;">
                                        <i class="fa-solid fa-link me-1"></i> ${bn.targetUrl}
                                    </a>
                                </td>
                                <td>
                                    <small class="text-light">
                                        <fmt:parseDate value="${bn.endDate}" pattern="yyyy-MM-dd'T'HH:mm" var="pDate" type="both"/>
                                        <fmt:formatDate value="${pDate}" pattern="dd/MM/yyyy"/>
                                    </small>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${bn.active}">
                                            <span class="badge bg-success bg-opacity-75"><i class="fa-solid fa-bolt me-1"></i> ĐANG CHẠY</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary"><i class="fa-solid fa-pause me-1"></i> ĐÃ DỪNG</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty banners}">
                            <tr><td colspan="5" class="py-5 text-muted">Bạn chưa đăng ký banner nào.</td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../footer.jsp" />
</body>
</html>