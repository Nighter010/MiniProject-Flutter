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
        $tourCode = sanitize_input($data['tourCode']);

        // Query เพื่อหา No_tram ล่าสุด
        $query = "SELECT MAX(No_tram) as maxNo_tram FROM tram";
        $result = mysqli_query($conn, $query);
        $row = mysqli_fetch_assoc($result);
        $maxNo_tram = $row['maxNo_tram'];

        // ถ้าไม่มีข้อมูลในตารางเลยให้กำหนด No_tram เป็น 1
        // ถ้ามีข้อมูลในตารางให้กำหนด No_tram เป็นค่าล่าสุด + 1
        $newNo_tram = ($maxNo_tram == null) ? 1 : $maxNo_tram + 1;

        // เพิ่มข้อมูลใหม่
        $sql = "INSERT INTO tram (No_tram, tourCode) VALUES ('$newNo_tram', '$tourCode')";

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
        $No_tram = sanitize_input($data['No_tram']);
        $tourCode = sanitize_input($data['tourCode']);
        $time = sanitize_input($data['time']);

        $sql = "UPDATE table_tram SET tourCode='$tourCode' ,time='$time' WHERE No_tram='$No_tram'";

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
        $No_tram = sanitize_input($data['No_tram']);

        $sql = "DELETE FROM tram WHERE No_tram='$No_tram'";

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