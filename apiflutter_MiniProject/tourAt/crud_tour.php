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
        $sql = "SELECT * FROM tourist_at";
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
        $tourName = sanitize_input($data['tourName']);

        // Query เพื่อหา tourCode ล่าสุด
        $query = "SELECT MAX(tourCode) as maxtourCode FROM tourist_at";
        $result = mysqli_query($conn, $query);
        $row = mysqli_fetch_assoc($result);
        $maxtourCode = $row['maxtourCode'];

        // ถ้าไม่มีข้อมูลในตารางเลยให้กำหนด tourCode เป็น 1
        // ถ้ามีข้อมูลในตารางให้กำหนด tourCode เป็นค่าล่าสุด + 1
        $newtourCode = ($maxtourCode == null) ? 1 : $maxtourCode + 1;

        // เพิ่มข้อมูลใหม่
        $sql = "INSERT INTO tourist_at (tourCode, tourName) VALUES ('$newtourCode', '$tourName')";

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
        $tourCode = sanitize_input($data['tourCode']);
        $tourName = sanitize_input($data['tourName']);
        $latitude = sanitize_input($data['latitude']);
        $longtitude = sanitize_input($data['longtitude']);

        $sql = "UPDATE tourist_at SET tourName='$tourName', latitude='$latitude' , longtitude='$longtitude' WHERE tourCode='$tourCode'";

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
        $tourCode = sanitize_input($data['tourCode']);

        $sql = "DELETE FROM tourist_at WHERE tourCode='$tourCode'";

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