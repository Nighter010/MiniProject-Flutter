<?php
header('Access-Control-Allow-Origin: *');
include("../conn.php");

// Fetch the maximum tramCode from the user table
$max_tramCode_query = "SELECT MAX(tramCode) AS max_tramCode FROM tram";
$max_tramCode_result = mysqli_query($conn, $max_tramCode_query);

if ($max_tramCode_result) {
    $row = mysqli_fetch_assoc($max_tramCode_result);
    $max_tramCode = $row['max_tramCode'];
    $tramCode = $max_tramCode + 1;
} else {
    // Error handling if fetching maximum tramCode fails
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Error fetching maximum tramCode']);
    exit(); // Exit the script
}

$tramNo = isset($_REQUEST['tramNo']) ? $_REQUEST['tramNo'] : '';


// Insert data into the user table using parameterized query
$sql = "INSERT INTO tram (tramCode, tramNo)
        VALUES (?, ?)";

// Prepare the statement
$stmt = mysqli_prepare($conn, $sql);

// Bind the parameters
mysqli_stmt_bind_param($stmt, 'is', $tramCode, $tramNo);

// Execute the statement
mysqli_stmt_execute($stmt);

// Check for success
if (mysqli_stmt_affected_rows($stmt) > 0) {
    // Successful insertion
    http_response_code(200);
    echo json_encode(['status' => 'success', 'message' => 'tram added successfully']);
} else {
    // Error in insertion
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Error adding user']);
}

// Close the statement and connection
mysqli_stmt_close($stmt);
mysqli_close($conn);
?>