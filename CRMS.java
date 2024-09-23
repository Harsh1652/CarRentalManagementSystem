import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/CRMS")
public class CRMS extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(CRMS.class.getName());

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");

        String dbUrl = "jdbc:mysql://localhost:3306/CarRental";
        String dbUser = "/* Enter SQL userName*/";
        String dbPassword = "/* Enter SQL Password */";

        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword)) {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Add Car
            if ("addCar".equals(action)) {
                String brand = request.getParameter("brand");
                String model = request.getParameter("model");
                double price = Double.parseDouble(request.getParameter("price"));

                String sql = "INSERT INTO cars (brand, model, base_price_per_day, is_available) VALUES (?, ?, ?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, brand);
                    stmt.setString(2, model);
                    stmt.setDouble(3, price);
                    stmt.setBoolean(4, true);

                    int result = stmt.executeUpdate();
                    if (result > 0) {
                        out.println("<h3>Car successfully added:</h3>");
                        out.println("<p>Brand: " + brand + "</p>");
                        out.println("<p>Model: " + model + "</p>");
                        out.println("<p>Price per day: " + price + "</p>");
                    } else {
                        out.println("<h3>Failed to add car.</h3>");
                    }
                }

           
            } 
         // Rent Car
            else if ("rentCar".equals(action)) {
                int carId = Integer.parseInt(request.getParameter("carId"));
                String customerName = request.getParameter("customerName");
                String phoneNumber = request.getParameter("phoneNumber");
                int days = Integer.parseInt(request.getParameter("days"));

                String selectCarQuery = "SELECT is_available, base_price_per_day FROM cars WHERE car_id = ?";
                try (PreparedStatement selectStmt = conn.prepareStatement(selectCarQuery)) {
                    selectStmt.setInt(1, carId);
                    try (ResultSet rs = selectStmt.executeQuery()) {
                        if (rs.next() && rs.getBoolean("is_available")) {
                            double pricePerDay = rs.getDouble("base_price_per_day");
                            double totalBill = pricePerDay * days;

                            // Rent the car
                            String rentCarQuery = "INSERT INTO rentals (car_id, customer_name, phone_number, days, total_bill) VALUES (?, ?, ?, ?, ?)";
                            try (PreparedStatement rentStmt = conn.prepareStatement(rentCarQuery)) {
                                rentStmt.setInt(1, carId);
                                rentStmt.setString(2, customerName);
                                rentStmt.setString(3, phoneNumber);
                                rentStmt.setInt(4, days);
                                rentStmt.setDouble(5, totalBill);

                                int rentResult = rentStmt.executeUpdate();

                                // Mark the car as unavailable
                                String updateCarQuery = "UPDATE cars SET is_available = false WHERE car_id = ?";
                                try (PreparedStatement updateStmt = conn.prepareStatement(updateCarQuery)) {
                                    updateStmt.setInt(1, carId);
                                    updateStmt.executeUpdate();
                                }

                                if (rentResult > 0) {
                                    out.println("<h3>Car rented successfully to " + customerName + " for " + days + " days.</h3>");
                                    out.println("<p>Total Bill: Rs" + totalBill + "</p>");
                                } else {
                                    out.println("<h3>Failed to rent the car.</h3>");
                                }
                            }
                        } else {
                            out.println("<h3>Car is not available or not found.</h3>");
                        }
                    }
                }
            }

         // Return Car
            else if ("returnCar".equals(action)) {
                int carId = Integer.parseInt(request.getParameter("carId"));
                String customerName = request.getParameter("customerName");
                String phoneNumber = request.getParameter("phoneNumber");

                String selectRentalQuery = "SELECT * FROM rentals WHERE car_id = ? AND customer_name = ? AND phone_number = ?";
                try (PreparedStatement selectStmt = conn.prepareStatement(selectRentalQuery)) {
                    selectStmt.setInt(1, carId);
                    selectStmt.setString(2, customerName);
                    selectStmt.setString(3, phoneNumber);
                    try (ResultSet rs = selectStmt.executeQuery()) {
                        if (rs.next()) {
                            // Delete the rental record
                            String deleteRentalQuery = "DELETE FROM rentals WHERE car_id = ?";
                            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteRentalQuery)) {
                                deleteStmt.setInt(1, carId);
                                deleteStmt.executeUpdate();
                            }

                            // Mark the car as available again
                            String updateCarQuery = "UPDATE cars SET is_available = true WHERE car_id = ?";
                            try (PreparedStatement updateStmt = conn.prepareStatement(updateCarQuery)) {
                                updateStmt.setInt(1, carId);
                                updateStmt.executeUpdate();
                            }

                            out.println("<h3>Car returned successfully!</h3>");
                        } else {
                            out.println("<h3>No matching rental found for the provided details.</h3>");
                        }
                    }
                }
            }

         // Search Available Cars
            if ("searchCar".equals(action)) {
                String selectAvailableCarsQuery = "SELECT * FROM cars WHERE is_available = true";
                try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(selectAvailableCarsQuery)) {
                    out.println("<h3>Available Cars:</h3>");
                    out.println("<table border='1'>");
                    out.println("<tr><th>Car ID</th><th>Brand</th><th>Model</th><th>Price Per Day</th></tr>");
                    while (rs.next()) {
                        out.println("<tr><td>" + rs.getInt("car_id") + "</td><td>" + rs.getString("brand") + "</td><td>" + rs.getString("model") + "</td><td>" + rs.getDouble("base_price_per_day") + "</td></tr>");
                    }
                    out.println("</table>");
                }
            }


        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing request", e);
            out.println("<h3>Error: " + e.getMessage() + "</h3>");
        } finally {
            out.close();  // Ensure the PrintWriter is closed
        }
    }
}
