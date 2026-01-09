<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hướng Dẫn & Quy Định - MUMOIRA.TV</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #0d1117; /* Nền tối */
            color: #c9d1d9; /* Chữ xám sáng */
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* SIDEBAR MỤC LỤC */
        .guide-sidebar {
            background-color: #161b22;
            border: 1px solid #30363d;
            border-radius: 6px;
            overflow: hidden;
            position: sticky;
            top: 90px; /* Cách top để không bị Header che khi cuộn */
        }

        .list-group-item {
            background-color: transparent;
            color: #c9d1d9;
            border: none;
            border-bottom: 1px solid #30363d;
            padding: 15px 20px;
            font-weight: 600;
            transition: all 0.2s;
        }

        .list-group-item:hover {
            background-color: #21262d;
            color: #58a6ff; /* Màu xanh GitHub */
            padding-left: 25px; /* Hiệu ứng trượt */
        }

        .list-group-item.active {
            background-color: #1f6feb !important;
            border-color: #1f6feb !important;
            color: white !important;
        }

        /* CONTENT BOX */
        .content-section {
            background-color: #161b22;
            border: 1px solid #30363d;
            border-radius: 6px;
            padding: 30px;
            margin-bottom: 30px;
        }

        h2 {
            color: #58a6ff;
            border-bottom: 2px solid #30363d;
            padding-bottom: 10px;
            margin-bottom: 20px;
            font-size: 1.5rem;
            font-weight: 700;
        }

        h4 { color: #d2a8ff; margin-top: 20px; } /* Màu tím nhạt */

        /* BẢNG GIÁ VIP */
        .table-dark-custom {
            --bs-table-bg: #21262d;
            --bs-table-color: #c9d1d9;
            border-color: #30363d;
        }
        .text-vip { color: #ffd700; font-weight: bold; }
        .text-super-vip { color: #ff4747; font-weight: bold; text-transform: uppercase; }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container py-5">
    <div class="row">

        <div class="col-md-3 mb-4">
            <div class="guide-sidebar list-group">
                <div class="p-3 bg-dark text-white fw-bold text-center text-uppercase border-bottom border-secondary">
                    <i class="bi bi-book-half"></i> Mục lục
                </div>
                <a href="#section-rules" class="list-group-item list-group-item-action">
                    1. Quy định đăng tin
                </a>
                <a href="#section-packages" class="list-group-item list-group-item-action">
                    2. Các gói quảng cáo
                </a>
                <a href="#section-payment" class="list-group-item list-group-item-action">
                    3. Hướng dẫn nạp Xu
                </a>
                <a href="#section-contact" class="list-group-item list-group-item-action">
                    4. Liên hệ hỗ trợ
                </a>
            </div>
        </div>

        <div class="col-md-9">

            <div id="section-rules" class="content-section">
                <h2><i class="bi bi-shield-check"></i> 1. Quy định đăng tin</h2>
                <p>Để đảm bảo cộng đồng game MU Online trong sạch và uy tín, các Admin Server vui lòng tuân thủ:</p>
                <ul>
                    <li>Không đăng server lừa đảo, server "mì ăn liền" mở vài ngày rồi đóng.</li>
                    <li>Thông tin phiên bản, tỉ lệ Drop/Exp phải chính xác với thực tế trong game.</li>
                    <li>Hình ảnh Banner phải rõ nét, không chứa nội dung phản cảm hoặc chính trị.</li>
                    <li>Nghiêm cấm spam tin, tạo nhiều tin rác giống nhau.</li>
                </ul>
                <div class="alert alert-warning bg-opacity-10 border-warning text-warning">
                    <i class="bi bi-exclamation-triangle-fill"></i> Những server vi phạm sẽ bị xóa vĩnh viễn và khóa tài khoản không hoàn tiền.
                </div>
            </div>

            <div id="section-packages" class="content-section">
                <h2><i class="bi bi-star-fill"></i> 2. Các gói dịch vụ quảng cáo</h2>
                <p>Chúng tôi cung cấp các gói hiển thị giúp Server của bạn tiếp cận hàng nghìn game thủ mỗi ngày.</p>

                <div class="table-responsive">
                    <table class="table table-dark-custom table-bordered text-center align-middle">
                        <thead class="table-secondary">
                        <tr>
                            <th>Tên Gói</th>
                            <th>Chi phí (Xu)</th>
                            <th>Thời gian</th>
                            <th>Quyền lợi nổi bật</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>CƠ BẢN</td>
                            <td>1.000</td>
                            <td>7 Ngày</td>
                            <td>Hiển thị trong danh sách thường.</td>
                        </tr>
                        <tr>
                            <td class="text-vip">VIP</td>
                            <td class="text-vip">5.000</td>
                            <td>10 Ngày</td>
                            <td>
                                <i class="bi bi-check-circle text-success"></i> Viền vàng nổi bật<br>
                                <i class="bi bi-check-circle text-success"></i> Ưu tiên xếp trên gói thường
                            </td>
                        </tr>
                        <tr>
                            <td class="text-super-vip">SUPER VIP</td>
                            <td class="text-super-vip">10.000</td>
                            <td>14 Ngày</td>
                            <td>
                                <i class="bi bi-fire text-danger"></i> <strong>Vị trí TOP 1</strong><br>
                                <i class="bi bi-check-circle text-danger"></i> Viền đỏ + Hiệu ứng<br>
                                <i class="bi bi-check-circle text-danger"></i> Có huy hiệu S-VIP
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div id="section-payment" class="content-section">
                <h2><i class="bi bi-credit-card-2-front"></i> 3. Hướng dẫn nạp Xu</h2>
                <p>Hệ thống nạp tiền tự động qua chuyển khoản ngân hàng. Tỉ lệ quy đổi: <strong>1.000 VNĐ = 1 Xu</strong>.</p>

                <div class="card bg-secondary bg-opacity-10 border-secondary p-3">
                    <h4 class="mt-0">Thông tin chuyển khoản:</h4>
                    <ul class="list-unstyled">
                        <li class="mb-2" style="color: #d1d1d1 !important;">
                            🏦 <strong>Ngân hàng:</strong> MB BANK (Quân Đội)
                        </li>

                        <li class="mb-2">
                            💳
                            <strong style="color:#dcdcdc !important;">Số tài khoản:</strong>
                            <span style="color:#ffd158 !important;">9999.8888.6666</span>
                        </li>

                        <li class="mb-2" style="color:#c6c6c6 !important;">
                            👤 <strong>Chủ tài khoản:</strong> NGUYEN VAN A
                        </li>
                        <li>
                            📝
                            <strong style="color:#dfdfdf !important;">
                                Nội dung CK:
                            </strong>
                            <code style="color:#e17b88 !important; font-size:1.25rem;">
                                NAP [Tên_Tài_Khoản_Của_Bạn]
                            </code>
                        </li>

                    </ul>
                    <small class="fst-italic" style="color:#dfdfdf !important;">
                        * Xu sẽ được cộng tự động sau 1-3 phút.
                    </small>
                </div>
            </div>

            <div id="section-contact" class="content-section">
                <h2><i class="bi bi-headset"></i> 4. Liên hệ hỗ trợ</h2>
                <p>Nếu gặp khó khăn trong quá trình đăng tin hoặc nạp thẻ, vui lòng liên hệ:</p>
                <div class="d-flex gap-3 mt-3">
                    <a href="#" class="btn btn-primary"><i class="bi bi-facebook"></i> Facebook Admin</a>
                    <a href="#" class="btn btn-success"><i class="bi bi-telegram"></i> Telegram</a>
                    <a href="#" class="btn btn-outline-light"><i class="bi bi-envelope"></i> Email: hotro@mumoira.tv</a>
                </div>
            </div>

        </div>
    </div>
</div>

<footer class="bg-dark text-center text-secondary py-4 mt-5 border-top border-secondary">
    <div class="container">
        <p class="mb-0">© 2026 MUXUA.CO - Bản quyền thuộc về đội ngũ Admin.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>