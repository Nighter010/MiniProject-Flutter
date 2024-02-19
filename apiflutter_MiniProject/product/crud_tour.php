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
        $sql = "SELECT * FROM product";
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
        $shopCode = sanitize_input($data['shopCode']);

        // Query เพื่อหา proCode ล่าสุด
        $query = "SELECT MAX(proCode) as maxproCode FROM product";
        $result = mysqli_query($conn, $query);
        $row = mysqli_fetch_assoc($result);
        $maxproCode = $row['maxproCode'];

        // ถ้าไม่มีข้อมูลในตารางเลยให้กำหนด proCode เป็น 1
        // ถ้ามีข้อมูลในตารางให้กำหนด proCode เป็นค่าล่าสุด + 1
        $newproCode = ($maxproCode == null) ? 1 : $maxproCode + 1;

        // เพิ่มข้อมูลใหม่
        $sql = "INSERT INTO product (proCode, shopCode) VALUES ('$newproCode', '$shopCode')";

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
        $proCode = sanitize_input($data['proCode']);
        $shopCode = sanitize_input($data['shopCode']);
        $proName = sanitize_input($data['proName']);
        $unti = sanitize_input($data['unti']);
        $price = sanitize_input($data['price']);

        $sql = "UPDATE product SET shopCode='$shopCode', proName='$proName' , unti='$unti' , price='$price' WHERE proCode='$proCode'";

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
        $proCode = sanitize_input($data['proCode']);

        $sql = "DELETE FROM product WHERE proCode='$proCode'";

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

http://localhost:88/apiflutter_MiniProject/product/crud_tour.php