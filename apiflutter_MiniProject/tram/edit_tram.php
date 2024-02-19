<?php
header('Access-Control-Allow-Origin: *');
include("../conn.php");

// Check if request method is POST
if ($_SERVER["REQUEST_METHOD"] == "PUT") {
    // Retrieve POST parameters
    $tramCode = isset($_REQUEST['tramCode']) ? $_REQUEST['tramCode'] : '';
    $tramNo = isset($_REQUEST['tramNo']) ? $_REQUEST['tramNo'] : '';

    // Update data in the tram table using parameterized query
    $sql = "UPDATE tram SET tramNo = ? WHERE tramCode = ?";

    // Prepare the statement
    $stmt = mysqli_prepare($conn, $sql);

    // Bind the parameters
    mysqli_stmt_bind_param($stmt, 'si', $tramNo, $tramCode);

    // Execute the statement
    mysqli_stmt_execute($stmt);

    // Check for success
    if (mysqli_stmt_affected_rows($stmt) > 0) {
        // Successful update
        http_response_code(200);
        echo json_encode(['status' => 'success', 'message' => 'tram updated successfully']);
    } else {
        // No rows affected, meaning no matching tramCode found
        http_response_code(404);
        echo json_encode(['status' => 'error', 'message' => 'tram not found or no changes made']);
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
<?php
// Include database connection
include_once 'db_connect.php';

// Check if POST data is not empty
if (!empty($_POST)) {
    // Extract POST data
    $tramCode = $_POST['tramCode'];
    $newTramNo = $_POST['newTramNo'];

    // Prepare and execute SQL update statement
    $sql = "UPDATE tram SET tramNo = '$newTramNo' WHERE tramCode = '$tramCode'";
    if ($conn->query($sql) === TRUE) {
        // Update successful
        echo json_encode(array("message" => "Tram updated successfully"));
    } else {
        // Update failed
        echo json_encode(array("error" => "Error updating tram: " . $conn->error));
    }
} else {
    // No POST data received
    echo json_encode(array("error" => "No data received"));
}

// Close database connection
$conn->close();
?>