<?php
header('Access-Control-Allow-Origin: *');
include("../conn.php");

// Check if request method is POST
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Retrieve POST parameters
    $shopCode = isset($_POST['shopCode']) ? $_POST['shopCode'] : '';

    // Delete data from the shop table using parameterized query
    $sql = "DELETE FROM shop WHERE shopCode = ?";

    // Prepare the statement
    $stmt = mysqli_prepare($conn, $sql);

    // Bind the parameter
    mysqli_stmt_bind_param($stmt, 'i', $shopCode);

    // Execute the statement
    mysqli_stmt_execute($stmt);

    // Check for success
    if (mysqli_stmt_affected_rows($stmt) > 0) {
        // Successful deletion
        http_response_code(200);
        echo json_encode(['status' => 'success', 'message' => 'shop deleted successfully']);
    } else {
        // No rows affected, meaning no matching shopCode found
        http_response_code(404);
        echo json_encode(['status' => 'error', 'message' => 'shop not found or no changes made']);
    }

    // Close the statement
    mysqli_stmt_close($stmt);
} else {
    // Invalid request method
    http_response_code(405); // Method Not Allowed
    echo json_encode(['status' => 'error', 'message' => 'Method not allowed']);
}

// Close database connection
mysqli_close($conn);
?>