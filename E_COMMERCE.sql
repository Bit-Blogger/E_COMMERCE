-- DATABASE THAT MANAGES A ECOMMERCE 
    
    CREATE TABLE user(
        user_id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(50) NOT NULL,
        email VARCHAR(100) NOT NULL,
        city VARCHAR(50) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );

CREATE TABLE product(
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    price  DECIMAL(10,2),
    stock INT
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    order_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES user(id)
);

CREATE TABLE ORDER_ITEM(
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY(product_id) REFERENCES product(product_id)
);

CREATE TABLE payment(
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT, 
    amount DECIMAL(10,2),
    payment_status VARCHAR(100),
    payment_mode VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);


INSERT INTO user (name, email, city) VALUES
('Aarav Sharma', 'aarav.sharma@gmail.com', 'Mumbai'),
('Priya Verma', 'priya.verma@gmail.com', 'Delhi'),
('Rohan Patil', 'rohan.patil@gmail.com', 'Pune'),
('Sneha Iyer', 'sneha.iyer@gmail.com', 'Chennai'),
('Vikram Singh', 'vikram.singh@gmail.com', 'Jaipur'),
('Neha Gupta', 'neha.gupta@gmail.com', 'Lucknow'),
('Aditya Kulkarni', 'aditya.kulkarni@gmail.com', 'Nagpur'),
('Kavya Reddy', 'kavya.reddy@gmail.com', 'Hyderabad'),
('Rahul Das', 'rahul.das@gmail.com', 'Kolkata'),
('Ananya Nair', 'ananya.nair@gmail.com', 'Kochi');



INSERT INTO product (product_name, price, stock) VALUES
('Wireless Mouse', 599.00, 50),
('Mechanical Keyboard', 2499.00, 30),
('USB-C Charger', 899.00, 100),
('Bluetooth Headphones', 1999.00, 25),
('Laptop Stand', 799.00, 40),
('Smartphone Case', 299.00, 150),
('Power Bank 10000mAh', 1199.00, 60),
('LED Desk Lamp', 699.00, 35),
('External Hard Drive 1TB', 3499.00, 20),
('Gaming Mouse Pad', 399.00, 80);

INSERT INTO orders (user_id, order_date, status) VALUES
(1, '2026-03-20', 'Delivered'),
(2, '2026-03-21', 'Pending'),
(3, '2026-03-22', 'Shipped'),
(4, '2026-03-22', 'Delivered'),
(5, '2026-03-23', 'Cancelled'),
(6, '2026-03-23', 'Pending'),
(7, '2026-03-24', 'Delivered'),
(8, '2026-03-24', 'Shipped'),
(9, '2026-03-25', 'Pending'),
(10, '2026-03-25', 'Delivered');




INSERT INTO ORDER_ITEM (order_id, product_id, quantity) VALUES
(1, 2, 1),
(1, 5, 2),
(2, 1, 1),
(2, 3, 1),
(3, 4, 1),
(3, 7, 2),
(4, 6, 3),
(5, 8, 1),
(6, 9, 1),
(7, 10, 2),
(8, 2, 1),
(9, 3, 2),
(10, 1, 1),
(10, 4, 1);


INSERT INTO payment (order_id, amount, payment_status, payment_mode) VALUES
(1, 2899.00, 'Paid', 'UPI'),
(2, 1498.00, 'Pending', 'Credit Card'),
(3, 3197.00, 'Paid', 'Debit Card'),
(4, 299.00, 'Paid', 'Cash on Delivery'),
(5, 699.00, 'Failed', 'UPI'),
(6, 3499.00, 'Pending', 'Net Banking'),
(7, 798.00, 'Paid', 'UPI'),
(8, 2499.00, 'Paid', 'Credit Card'),
(9, 1798.00, 'Pending', 'Debit Card'),
(10, 2598.00, 'Paid', 'UPI');



--Display all users from Pune.

SELECT * FROM USER WHERE CITY = 'PUNE';

--List all products with price less than ₹1000.
SELECT * FROM PRODUCT WHERE PRICE <1000;

--Show all orders placed after 1st March 2025.
SELECT * FROM ORDERS WHERE ORDER_DATE > '2025-03-01';

--Find all orders with status = 'Pending'.
SELECT * FROM ORDERS WHERE STATUS='PENDING';

--Display all products where stock is less than 25.
SELECT* FROM PRODUCT WHERE STOCK<25;

--Show all payments with status 'PAID'.
SELECT * FROM PAYMENT WHERE PAYMENT_STATUS='PAID';

--List all users ordered by latest registration.
SELECT * FROM USER ORDER BY CREATED_AT DESC;

--Display all orders along with user names.
SELECT 
    USER.NAME,
    ORDERS.ORDER_ID,
    ORDERS.ORDER_DATE, 
    ORDERS.STATUS
FROM ORDERS
JOIN USER 
    ON USER.ID=ORDERS.USER_ID;

--Find total number of orders placed by each user.
SELECT 
    USER.NAME,
    COUNT(ORDERS.ORDER_ID)
FROM USER
JOIN ORDERS
    ON USER.ID=ORDERS.ORDER_ID
GROUP BY USER.NAME;

--Show all products included in a specific order (order_id = 1).
--Calculate total amount spent by each user.
SELECT 
    USER.NAME,
    SUM(PAYMENT.AMOUNT) AS TOTAL_SPENT
FROM USER
JOIN ORDERS 
    ON USER.USER_ID = ORDERS.USER_ID
JOIN PAYMENT 
    ON ORDERS.ORDER_ID = PAYMENT.ORDER_ID
GROUP BY USER.NAME;            
--List all users who have never placed any order.
SELECT * 
FROM USER
LEFT JOIN ORDERS
    ON USER.USER_ID = ORDERS.USER_ID
WHERE ORDERS.ORDER_ID IS NULL;
--Find total quantity sold for each product.
SELECT 
    PRODUCT.PRODUCT_NAME,
    SUM(ORDER_ITEM.QUANTITY)
FROM ORDER_ITEM
JOIN PRODUCT
    ON PRODUCT.PRODUCT_ID=ORDER_ITEM.PRODUCT_ID
GROUP BY PRODUCT.PRODUCT_NAME;
--Show order details (product name, quantity, price).
SELECT 
    PRODUCT.PRODUCT_NAME,
    PRODUCT.PRICE,
    ORDER_ITEM.QUANTITY
FROM ORDER_ITEM
JOIN PRODUCT
    ON PRODUCT.PRODUCT_ID=ORDER_ITEM.PRODUCT_ID
   ;
 

--Display all orders with their payment status.
SELECT ORDER_ID,PAYMENT_STATUS
FROM PAYMENT;
    
--Find the top 5 most sold products.
SELECT 
    PRODUCT.PRODUCT_NAME,
    SUM(ORDER_ITEM.QUANTITY) AS TOTAL_SOLD
FROM ORDER_ITEM
JOIN PRODUCT 
    ON PRODUCT.PRODUCT_ID = ORDER_ITEM.PRODUCT_ID
GROUP BY PRODUCT.PRODUCT_NAME
ORDER BY TOTAL_SOLD DESC
LIMIT 5;

--Calculate total revenue generated.
SELECT SUM(AMOUNT) AS TOTAL_REVENUE FROM PAYMENT;

--Find average order value.
SELECT AVG(AMOUNT) AS AVG_ORDER_VALUE FROM PAYMENT;

--Find the user who spent the most money.
--List products that have never been ordered.
SELECT PRODUCT.PRODUCT_NAME
FROM PRODUCT
LEFT JOIN ORDER_ITEM
    ON PRODUCT.PRODUCT_ID = ORDER_ITEM.PRODUCT_ID
WHERE ORDER_ITEM.PRODUCT_ID IS NULL;

--Find the highest value order.
SELECT ORDER_ID, MAX(AMOUNT) AS HIGHEST_ORDER
FROM PAYMENT;

--Display monthly revenue (group by month).
SELECT 
    MONTH(ORDER_DATE) AS MONTH,
    SUM(AMOUNT) AS REVENUE
FROM ORDERS
JOIN PAYMENT
    ON ORDERS.ORDER_ID = PAYMENT.ORDER_ID
GROUP BY MONTH(ORDER_DATE);
