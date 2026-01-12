Drop table IF EXISTS best_selling;
Drop table IF EXISTS revenue_by_month;
Drop table IF EXISTS revenue_by_state;
Drop table IF EXISTS avg_installments_by_category;
Drop table IF EXISTS frequently_bought_together;

Create table best_selling(
    product_category_name VARCHAR(255) PRIMARY KEY,
    revenue NUMERIC(15,2) NOT NULL
);

Create table revenue_by_month(
    month_name VARCHAR(255) NOT NULL,
    year INT NOT NULL,
    month INT NOT NULL,
    revenue NUMERIC(15,2) NOT NULL,
    PRIMARY KEY (year, month)
);

Create table revenue_by_state(
    customer_state VARCHAR(255) PRIMARY KEY,
    revenue NUMERIC(15,2) NOT NULL
);


create table avg_installments_by_category(
    product_category_name VARCHAR(255) PRIMARY KEY,
    avg_installments NUMERIC(10,2) NOT NULL
);


CREATE TABLE frequently_bought_together (
    product_category_a VARCHAR(255),
    product_category_b VARCHAR(255),
    pair_count INT NOT NULL,
    PRIMARY KEY (product_category_a, product_category_b)
);