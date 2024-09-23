document.addEventListener("DOMContentLoaded", function() {
    // Get form elements using IDs for clarity
    const addCarForm = document.getElementById("addCarForm");
    const rentCarForm = document.getElementById("rentCarForm");
    const returnCarForm = document.getElementById("returnCarForm");

    // Add event listeners for each form
    if (addCarForm) {
        addCarForm.addEventListener("submit", function(event) {
            if (!validateAddCarForm()) {
                event.preventDefault(); // Prevent form submission if validation fails
            }
        });
    }

    if (rentCarForm) {
        rentCarForm.addEventListener("submit", function(event) {
            if (!validateRentCarForm()) {
                event.preventDefault();
            }
        });
    }

    if (returnCarForm) {
        returnCarForm.addEventListener("submit", function(event) {
            if (!validateReturnCarForm()) {
                event.preventDefault();
            }
        });
    }
});

// Validate Add Car Form
function validateAddCarForm() {
    const brand = document.querySelector("input[name='brand']").value;
    const model = document.querySelector("input[name='model']").value;
    const price = document.querySelector("input[name='price']").value;

    if (brand === "" || model === "" || price === "") {
        alert("All fields are required for adding a car.");
        return false;
    }
    if (isNaN(price) || price <= 0) {
        alert("Price must be a positive number.");
        return false;
    }
    return true;
}

// Validate Rent Car Form
function validateRentCarForm() {
    const carId = document.querySelector("input[name='carId']").value;
    const customerName = document.querySelector("input[name='customerName']").value;
    const days = document.querySelector("input[name='days']").value;

    if (carId === "" || customerName === "" || days === "") {
        alert("All fields are required for renting a car.");
        return false;
    }
    if (isNaN(days) || days <= 0) {
        alert("Number of days must be a positive number.");
        return false;
    }
    return true;
}

// JavaScript function to calculate the approximate bill
function calculateBill(event) {
    event.preventDefault();  // Prevent form submission for now
    const carId = document.getElementById("carId").value;
    const days = document.getElementById("days").value;

    // Fetch the car's price per day from the backend based on carId (simplified logic)
    // For now, assume pricePerDay is fetched from the server or is a constant for demonstration.
    const pricePerDay = 50; // This value should be fetched dynamically in real-world apps

    if (days && pricePerDay) {
        const totalBill = pricePerDay * days;
        document.getElementById("approximateBill").innerHTML = `<p><strong>Approximate Bill:</strong> ${totalBill}</p>`;
    }

    // Submit the form
    event.target.submit();
}


// Validate Return Car Form
function validateReturnCarForm() {
    const carId = document.querySelector("input[name='carId']").value;

    if (carId === "") {
        alert("Car ID is required for returning a car.");
        return false;
    }
    return true;
}
