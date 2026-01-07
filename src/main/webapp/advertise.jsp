<%@ page contentType="text/html;charset=UTF-8" %>
<%
    com.muads.model.User u =
            (com.muads.model.User) session.getAttribute("user");

    if (u == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Đăng ký quảng cáo MU</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">

<div class="container mt-4">
    <h3>Đăng ký quảng cáo Server MU</h3>

    <form action="../advertise" method="post" class="card p-4 shadow">

        <input type="hidden" name="userId" value="<%= u.getUserId() %>">

        <!-- Thông tin server -->
        <div class="mb-3">
            <label>Tên server</label>
            <input type="text" name="serverName" class="form-control" required>
        </div>

        <div class="mb-3">
            <label>Tên MU</label>
            <input type="text" name="muName" class="form-control" required>
        </div>

        <div class="mb-3">
            <label>Website</label>
            <input type="url" name="websiteUrl" class="form-control">
        </div>

        <div class="mb-3">
            <label>Fanpage</label>
            <input type="url" name="fanpageUrl" class="form-control">
        </div>

        <div class="mb-3">
            <label>Slogan</label>
            <input type="text" name="slogan" class="form-control">
        </div>

        <div class="mb-3">
            <label>Mô tả</label>
            <textarea name="description" class="form-control"></textarea>
        </div>

        <hr>

        <!-- Lịch mở server -->
        <h5>Lịch mở server</h5>

        <div class="row">
            <div class="col-md-6">
                <label>Alpha Date</label>
                <input type="date" name="alphaDate" class="form-control">
            </div>
            <div class="col-md-6">
                <label>Alpha Time</label>
                <input type="time" name="alphaTime" class="form-control">
            </div>
        </div>

        <div class="row mt-2">
            <div class="col-md-6">
                <label>Beta Date</label>
                <input type="date" name="betaDate" class="form-control">
            </div>
            <div class="col-md-6">
                <label>Beta Time</label>
                <input type="time" name="betaTime" class="form-control">
            </div>
        </div>

        <hr>

        <!-- Thông số server -->
        <h5>Thông số server</h5>

        <div class="row">
            <div class="col-md-4">
                <label>EXP</label>
                <input type="number" name="expRate" class="form-control" required>
            </div>
            <div class="col-md-4">
                <label>Drop</label>
                <input type="number" name="dropRate" class="form-control" required>
            </div>
            <div class="col-md-4">
                <label>Anti Hack</label>
                <input type="text" name="antiHack" class="form-control">
            </div>
        </div>

        <button class="btn btn-primary mt-4">
            Gửi đăng ký quảng cáo
        </button>
    </form>
</div>

</body>
</html>
