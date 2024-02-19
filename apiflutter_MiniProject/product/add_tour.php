<?php
header('Access-Control-Allow-Origin: *');
include("../conn.php");

// Fetch the maximum proCode for the given shopCode
$shopCode = isset($_REQUEST['shopCode']) ? $_REQUEST['shopCode'] : '';
$max_proCode_query = "SELECT MAX(proCode) AS max_proCode FROM product WHERE shopCode = ?";
$stmt_max_proCode = mysqli_prepare($conn, $max_proCode_query);
mysqli_stmt_bind_param($stmt_max_proCode, 'i', $shopCode);
mysqli_stmt_execute($stmt_max_proCode);
$max_proCode_result = mysqli_stmt_get_result($stmt_max_proCode);

if ($max_proCode_result) {
    $row = mysqli_fetch_assoc($max_proCode_result);
    $max_proCode = $row['max_proCode'];
    $proCode = $max_proCode + 1;
} else {
    // Error handling if fetching maximum proCode fails
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Error fetching maximum proCode']);
    exit(); // Exit the script
}

$proName = isset($_REQUEST['proName']) ? $_REQUEST['proName'] : '';
$unti = isset($_REQUEST['unti']) ? $_REQUEST['unti'] : '';
$price = isset($_REQUEST['price']) ? $_REQUEST['price'] : '';

// Insert data into the product table using parameterized query
$sql = "INSERT INTO product (shopCode, proCode, proName, unti, price)
        VALUES (?, ?, ?, ?, ?)";

// Prepare the statement
$stmt = mysqli_prepare($conn, $sql);

// Bind the parameters
mysqli_stmt_bind_param($stmt, 'iisss', $shopCode, $proCode, $proName, $unti, $price);

// Execute the statement
mysqli_stmt_execute($stmt);

// Check for success
if (mysqli_stmt_affected_rows($stmt) > 0) {
    // Successful insertion
    http_response_code(200);
    echo json_encode(['status' => 'success', 'message' => 'product added successfully']);
} else {
    // Error in insertion
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Error adding product']);
}

// Close the statement and connection
mysqli_stmt_close($stmt);
mysqli_close($conn);
?>