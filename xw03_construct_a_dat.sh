#!/bin/bash

# Project: Construct a Data-Driven Web App Simulator
# File: xw03_construct_a_dat.sh
# Description: A Bash script to simulate a data-driven web app using random data generation.

# Define variables
APP_NAME="WebAppSimulator"
DATA_DIR="./data"
TEMPLATE_DIR="./templates"
OUTPUT_DIR="./output"

# Create directories
mkdir -p "$DATA_DIR"
mkdir -p "$TEMPLATE_DIR"
mkdir -p "$OUTPUT_DIR"

# Generate random data (users, products, orders)
generate_random_data() {
  # Users
  for i in {1..100}; do
    username="user_${i}"
    email="${username}@example.com"
    password=$(openssl rand -base64 12)
    echo "${username},${email},${password}" >>"${DATA_DIR}/users.csv"
  done

  # Products
  for i in {1..50}; do
    product_name="Product ${i}"
    price=$(shuf -i 10-100 -n 1)
    echo "${product_name},${price}" >>"${DATA_DIR}/products.csv"
  done

  # Orders
  for i in {1..200}; do
    user_id=$(shuf -i 1-100 -n 1)
    product_id=$(shuf -i 1-50 -n 1)
    order_date=$(date -d "-${i} days" "+%Y-%m-%d")
    echo "${user_id},${product_id},${order_date}" >>"${DATA_DIR}/orders.csv"
  done
}

# Generate HTML templates
generate_html_templates() {
  # Index page
  echo "<html><body><h1>Welcome to ${APP_NAME}!</h1></body></html>" >"${TEMPLATE_DIR}/index.html"

  # User page
  echo "<html><body><h1>User Profile</h1><p>Name: {{ username }}</p><p>Email: {{ email }}</p></body></html>" >"${TEMPLATE_DIR}/user.html"

  # Product page
  echo "<html><body><h1>Product Details</h1><p>Name: {{ product_name }}</p><p>Price: {{ price }}</p></body></html>" >"${TEMPLATE_DIR}/product.html"
}

# Simulate web app
simulate_web_app() {
  # Serve HTML templates with random data
  while true; do
    user_id=$(shuf -i 1-100 -n 1)
    product_id=$(shuf -i 1-50 -n 1)
    username=$(awk -F, "NR==${user_id} {print \$1}" "${DATA_DIR}/users.csv")
    email=$(awk -F, "NR==${user_id} {print \$2}" "${DATA_DIR}/users.csv")
    product_name=$(awk -F, "NR==${product_id} {print \$1}" "${DATA_DIR}/products.csv")
    price=$(awk -F, "NR==${product_id} {print \$2}" "${DATA_DIR}/products.csv")

    # Generate HTML output
    echo "<html><body><h1>Web App Simulator</h1><p>User: ${username} (${email})</p><p>Product: ${product_name} (${price})</p></body></html>" >"${OUTPUT_DIR}/index.html"

    # Serve output
    echo "Serving ${OUTPUT_DIR}/index.html..."
    sleep 1
  done
}

# Run the simulator
generate_random_data
generate_html_templates
simulate_web_app