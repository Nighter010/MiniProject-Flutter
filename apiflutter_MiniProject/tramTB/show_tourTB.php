<?php
include '../conn.php';
header("Access-Control-Allow-Origin: *");
$xok = 401;
$result = mysqli_query($conn, "SELECT * FROM table_tram");
if ($result) {
    while ($row = mysqli_fetch_assoc($result)) {
        $output[] = $row;
        $xok = 200;

    }
    http_response_code($xok);
    echo json_encode($output);
}
mysqli_close($conn);
?>