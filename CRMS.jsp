<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Car Rental Management System</title>
    <!-- Bootstrap CSS for responsive and interactive UI -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/CRMS.css">
    <script src="${pageContext.request.contextPath}/JS/CRMS.js"></script>
</head>
<body>

<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Car Rental System</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/CRMS.jsp">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#addCarModal" data-bs-toggle="modal">Add Car</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#rentCarModal" data-bs-toggle="modal">Rent Car</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#returnCarModal" data-bs-toggle="modal">Return Car</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#" onclick="document.getElementById('searchForm').submit();">Search Available Cars</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Main Content Section with Image and Description -->
<div class="container mt-5">
    <div class="row">
        <div class="col-md-6">
            <h2>Welcome to the Car Rental System</h2>
            <p>
                Our car rental system provides you with a fast and easy way to rent cars online. Whether you're looking for a car for your business trip, family vacation, or a weekend getaway, we have a wide range of vehicles available to suit your needs.
            </p>
            <p>
                Simply select a car, choose the number of days, and enjoy your ride. We offer affordable prices and excellent customer service to make your rental experience seamless.
            </p>
            <a href="#rentCarModal" class="btn btn-primary" data-bs-toggle="modal">Rent a Car Now</a>
        </div>
        <div class="col-md-6">
            <img src="${pageContext.request.contextPath}/images/car-rental.jpg" alt="Car Rental" class="img-fluid">
        </div>
    </div>
</div>

<!-- Footer Buttons (Optional) -->
<div class="container text-center mt-5">
    <button type="button" class="btn btn-success mx-2" data-bs-toggle="modal" data-bs-target="#addCarModal">Add Car</button>
    <button type="button" class="btn btn-warning mx-2" data-bs-toggle="modal" data-bs-target="#returnCarModal">Return Car</button>
</div>

<!-- Modals for Forms -->

<!-- Add Car Modal -->
<div class="modal fade" id="addCarModal" tabindex="-1" aria-labelledby="addCarModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addCarModalLabel">Add Car</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="addCarForm" action="CRMS" method="post">
                    <input type="hidden" name="action" value="addCar">
                    <div class="mb-3">
                        <label for="brand" class="form-label">Brand</label>
                        <input type="text" class="form-control" id="brand" name="brand" placeholder="Enter car brand" required>
                    </div>
                    <div class="mb-3">
                        <label for="model" class="form-label">Model</label>
                        <input type="text" class="form-control" id="model" name="model" placeholder="Enter car model" required>
                    </div>
                    <div class="mb-3">
                        <label for="price" class="form-label">Price per day</label>
                        <input type="number" class="form-control" id="price" name="price" step="0.01" placeholder="Enter price per day" required>
                    </div>
                    <button type="submit" class="btn btn-success">Add Car</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Rent Car Modal -->
<div class="modal fade" id="rentCarModal" tabindex="-1" aria-labelledby="rentCarModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="rentCarModalLabel">Rent a Car</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="rentCarForm" action="CRMS" method="post" onsubmit="calculateBill(event)">
                    <input type="hidden" name="action" value="rentCar">
                    <div class="mb-3">
                        <label for="carId" class="form-label">Car ID</label>
                        <input type="number" class="form-control" id="carId" name="carId" placeholder="Enter car ID" required>
                    </div>
                    <div class="mb-3">
                        <label for="customerName" class="form-label">Customer Name</label>
                        <input type="text" class="form-control" id="customerName" name="customerName" placeholder="Enter customer name" required>
                    </div>
                    <div class="mb-3">
                        <label for="phoneNumber" class="form-label">Phone Number</label>
                        <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" placeholder="Enter phone number" required>
                    </div>
                    <div class="mb-3">
                        <label for="days" class="form-label">Number of Days</label>
                        <input type="number" class="form-control" id="days" name="days" placeholder="Enter number of days" required>
                    </div>
                    <div id="approximateBill" class="mt-2"></div>
                    <button type="submit" class="btn btn-primary">Rent Car</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Return Car Modal -->
<div class="modal fade" id="returnCarModal" tabindex="-1" aria-labelledby="returnCarModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="returnCarModalLabel">Return a Car</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="returnCarForm" action="CRMS" method="post">
                    <input type="hidden" name="action" value="returnCar">
                    <div class="mb-3">
                        <label for="carId" class="form-label">Car ID</label>
                        <input type="number" class="form-control" id="carId" name="carId" placeholder="Enter car ID" required>
                    </div>
                    <div class="mb-3">
                        <label for="customerName" class="form-label">Customer Name</label>
                        <input type="text" class="form-control" id="customerName" name="customerName" placeholder="Enter customer name" required>
                    </div>
                    <div class="mb-3">
                        <label for="phoneNumber" class="form-label">Phone Number</label>
                        <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" placeholder="Enter phone number" required>
                    </div>
                    <button type="submit" class="btn btn-warning">Return Car</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS and Dependencies -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
