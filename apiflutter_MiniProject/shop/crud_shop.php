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
        $sql = "SELECT * FROM shop";
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
        $shopName = sanitize_input($data['shopName']);

        // Query เพื่อหา shopCode ล่าสุด
        $query = "SELECT MAX(shopCode) as maxshopCode FROM shop";
        $result = mysqli_query($conn, $query);
        $row = mysqli_fetch_assoc($result);
        $maxshopCode = $row['maxshopCode'];

        // ถ้าไม่มีข้อมูลในตารางเลยให้กำหนด shopCode เป็น 1
        // ถ้ามีข้อมูลในตารางให้กำหนด shopCode เป็นค่าล่าสุด + 1
        $newshopCode = ($maxshopCode == null) ? 1 : $maxshopCode + 1;

        // เพิ่มข้อมูลใหม่
        $sql = "INSERT INTO shop (shopCode, shopName) VALUES ('$newshopCode', '$shopName')";

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
        $shopCode = sanitize_input($data['shopCode']);
        $shopName = sanitize_input($data['shopName']);

        $sql = "UPDATE shop SET shopName='$shopName' WHERE shopCode='$shopCode'";

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
        $shopCode = sanitize_input($data['shopCode']);

        $sql = "DELETE FROM shop WHERE shopCode='$shopCode'";

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