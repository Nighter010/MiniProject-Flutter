<?php
header('Access-Control-Allow-Origin: *');
include("../conn.php");

// Fetch the maximum tourCode from the user table
$max_tourCode_query = "SELECT MAX(tourCode) AS max_tourCode FROM tourist_at";
$max_tourCode_result = mysqli_query($conn, $max_tourCode_query);

if ($max_tourCode_result) {
    $row = mysqli_fetch_assoc($max_tourCode_result);
    $max_tourCode = $row['max_tourCode'];
    $tourCode = $max_tourCode + 1;
} else {
    // Error handling if fetching maximum tourCode fails
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Error fetching maximum tourCode']);
    exit(); // Exit the script
}

$tourName = isset($_REQUEST['tourName']) ? $_REQUEST['tourName'] : '';
$latitude = isset($_REQUEST['latitude']) ? $_REQUEST['latitude'] : '';
$longtitude = isset($_REQUEST['longtitude']) ? $_REQUEST['longtitude'] : '';


// Insert data into the user table using parameterized query
$sql = "INSERT INTO tourist_at (tourCode, tourName , latitude, longtitude)
        VALUES (?, ?, ?, ?)";

// Prepare the statement
$stmt = mysqli_prepare($conn, $sql);

// Bind the parameters
mysqli_stmt_bind_param($stmt, 'isss', $tourCode, $tourName, $latitude, $longtitude);

// Execute the statement
mysqli_stmt_execute($stmt);

// Check for success
if (mysqli_stmt_affected_rows($stmt) > 0) {
    // Successful insertion
    http_response_code(200);
    echo json_encode(['status' => 'success', 'message' => 'tourist_at added successfully']);
} else {
    // Error in insertion
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => 'Error adding user']);
}

// Close the statement and connection
mysqli_stmt_close($stmt);
mysqli_close($conn);
?>