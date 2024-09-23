# Car Rental Management System

## Overview

The **Car Rental Management System** is a web application that allows customers to rent cars and manage car rentals. This system provides features for adding new cars to the inventory, renting cars, returning cars, and checking available cars. It uses Java Servlet, JSP, and MySQL for backend processing and HTML, CSS, and JavaScript for the frontend.

## Features

- **Add Car**: Admin can add new cars to the system with details such as brand, model, and price per day.
- **Rent Car**: Customers can rent available cars for a specified number of days.
- **Return Car**: Customers can return rented cars and update their status in the system.
- **Search Available Cars**: Users can view the list of cars currently available for rent.
- **Approximate Billing**: Provides an estimated rental cost for the customer based on the number of days rented.

## Technologies Used

- **Backend**: Java Servlet, JSP
- **Frontend**: HTML, CSS (Bootstrap), JavaScript
- **Database**: MySQL
- **Build Tool**: Apache Maven
- **Deployment**: Apache Tomcat

## Setup Instructions

### Prerequisites
1. **Java 11** or later
2. **Apache Tomcat 9** or later
3. **MySQL 8.0** or later
4. **Maven**

### Database Setup
1. Create a MySQL database for the project:
   ```sql
   CREATE DATABASE CarRental;
CREATE TABLE cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    brand VARCHAR(255),
    model VARCHAR(255),
    base_price_per_day DOUBLE,
    is_available BOOLEAN DEFAULT TRUE
);

CREATE TABLE rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT,
    customer_name VARCHAR(255),
    phone_number VARCHAR(20),
    days INT,
    total_bill DOUBLE,
    FOREIGN KEY (car_id) REFERENCES cars(car_id)
);
