<?php
header('Access-Control-Allow-Origin: *');
include("../conn.php");

// Fetch the maximum shopCode from the user table
$max_shopCode_query = "SELECT MAX(shopCode) AS max_shopCode FROM shop";
$max_shopCode_result = mysqli_query($conn, $max_shopCode_query);

if ($max_shopCode_result) {
    $row = mysqli_fetch_assoc($max_shopCode_result);
    $max_shopCode = $row['max_shopCode'];
    $shopCode = $max_shopCode + 1;
} else {
    // Error handling if fetching maximum shopCode fails
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Error fetching maximum shopCode']);
    exit(); // Exit the script
}

$shopName = isset($_REQUEST['shopName']) ? $_REQUEST['shopName'] : '';


// Insert data into the user table using parameterized query
$sql = "INSERT INTO shop (shopCode, shopName)
        VALUES (?, ?)";

// Prepare the statement
$stmt = mysqli_prepare($conn, $sql);

// Bind the parameters
mysqli_stmt_bind_param($stmt, 'is', $shopCode, $shopName);

// Execute the statement
mysqli_stmt_execute($stmt);

// Check for success
if (mysqli_stmt_affected_rows($stmt) > 0) {
    // Successful insertion
    http_response_code(200);
    echo json_encode(['status' => 'success', 'message' => 'shop added successfully']);
} else {
    // Error in insertion
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Error adding user']);
}

// Close the statement and connection
mysqli_stmt_close($stmt);
mysqli_close($conn);
?>