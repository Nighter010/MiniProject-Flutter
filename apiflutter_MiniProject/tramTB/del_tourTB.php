<?php
header('Access-Control-Allow-Origin: *');
include("../conn.php");

// Check if request method is POST
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Retrieve POST parameters
    $No_tram = isset($_POST['No_tram']) ? $_POST['No_tram'] : '';

    // Delete data from the tram table using parameterized query
    $sql = "DELETE FROM table_tram WHERE No_tram = ?";

    // Prepare the statement
    $stmt = mysqli_prepare($conn, $sql);

    // Bind the parameter
    mysqli_stmt_bind_param($stmt, 'i', $No_tram);

    // Execute the statement
    mysqli_stmt_execute($stmt);

    // Check for success
    if (mysqli_stmt_affected_rows($stmt) > 0) {
        // Successful deletion
        http_response_code(200);
        echo json_encode(['status' => 'success', 'message' => 'tram deleted successfully']);
    } else {
        // No rows affected, meaning No matching No found
        http_response_code(404);
        echo json_encode(['status' => 'error', 'message' => 'tram Not found or No changes made']);
    }

    // Close the statement
    mysqli_stmt_close($stmt);
} else {
    // Invalid request method
    http_response_code(405); // Method No_tramt Allowed
    echo json_encode(['status' => 'error', 'message' => 'Method No_tramt allowed']);
}

// Close database connection
mysqli_close($conn);
?>