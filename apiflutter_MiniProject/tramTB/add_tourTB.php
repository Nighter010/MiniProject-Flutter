<?php
header('Access-Control-Allow-Origin: *');
include("../conn.php");

// Fetch the maximum No_tram from the user table
$max_No_tram_query = "SELECT MAX(No_tram) AS max_No_tram FROM table_tram";
$max_No_tram_result = mysqli_query($conn, $max_No_tram_query);

if ($max_No_tram_result) {
    $row = mysqli_fetch_assoc($max_No_tram_result);
    $max_No_tram = $row['max_No_tram'];
    $No_tram = $max_No_tram + 1;
} else {
    // Error handling if fetching maximum No_tram fails
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Error fetching maximum No_tram']);
    exit(); // Exit the script
}

$tourCode = isset($_REQUEST['tourCode']) ? $_REQUEST['tourCode'] : '';
$time = isset($_REQUEST['time']) ? $_REQUEST['time'] : '';


// Insert data into the user table using parameterized query
$sql = "INSERT INTO table_tram (No_tram, tourCode,time)
        VALUES (?, ?,?)";

// Prepare the statement
$stmt = mysqli_prepare($conn, $sql);

// Bind the parameters
mysqli_stmt_bind_param($stmt, 'iss', $No_tram, $tourCode, $time);

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