<?php
include '../conn.php';

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");

function sanitize_input($data)
{
    return htmlspecialchars(strip_tags(trim($data)));
}

$response = array();
$request_method = $_SERVER["REQUEST_METHOD"];

switch ($request_method) {
    case 'GET':
        $sql = "SELECT * FROM tram";
        $result = mysqli_query($conn, $sql);

        if ($result) {
            $rows = array();
            while ($row = mysqli_fetch_assoc($result)) {
                $rows[] = $row;
            }
            $response['status'] = 200;
            $response['data'] = $rows;
        } else {
            $response['status'] = 500;
            $response['message'] = "Failed to fetch store types: " . mysqli_error($conn);
        }
        break;

    case 'POST':
        $data = json_decode(file_get_contents("php://input"), true);
        $tramNo = sanitize_input($data['tramNo']);

        // Query เพื่อหา tramCode ล่าสุด
        $query = "SELECT MAX(tramCode) as maxtramCode FROM tram";
        $result = mysqli_query($conn, $query);
        $row = mysqli_fetch_assoc($result);
        $maxtramCode = $row['maxtramCode'];

        // ถ้าไม่มีข้อมูลในตารางเลยให้กำหนด tramCode เป็น 1
        // ถ้ามีข้อมูลในตารางให้กำหนด tramCode เป็นค่าล่าสุด + 1
        $newtramCode = ($maxtramCode == null) ? 1 : $maxtramCode + 1;

        // เพิ่มข้อมูลใหม่
        $sql = "INSERT INTO tram (tramCode, tramNo) VALUES ('$newtramCode', '$tramNo')";

        if (mysqli_query($conn, $sql)) {
            $response['status'] = 201;
            $response['message'] = "Store type added successfully";
        } else {
            $response['status'] = 500;
            $response['message'] = "Failed to add store type: " . mysqli_error($conn);
        }
        break;

    case 'PUT':
        $data = json_decode(file_get_contents("php://input"), true);
        $tramCode = sanitize_input($data['tramCode']);
        $tramNo = sanitize_input($data['tramNo']);

        $sql = "UPDATE tram SET tramNo='$tramNo' WHERE tramCode='$tramCode'";

        if (mysqli_query($conn, $sql)) {
            $response['status'] = 200;
            $response['message'] = "Store type updated successfully";
        } else {
            $response['status'] = 500;
            $response['message'] = "Failed to update store type: " . mysqli_error($conn);
        }
        break;

    case 'DELETE':
        $data = json_decode(file_get_contents("php://input"), true);
        $tramCode = sanitize_input($data['tramCode']);

        $sql = "DELETE FROM tram WHERE tramCode='$tramCode'";

        if (mysqli_query($conn, $sql)) {
            $response['status'] = 200;
            $response['message'] = "Store type deleted successfully";
        } else {
            $response['status'] = 500;
            $response['message'] = "Failed to delete store type: " . mysqli_error($conn);
        }
        break;

    default:
        $response['status'] = 400;
        $response['message'] = "Invalid request method";
        break;
}

echo json_encode($response);
mysqli_close($conn);