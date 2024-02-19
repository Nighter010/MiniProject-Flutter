<?php
$server = "localhost"; // หรือ IP address ของ MySQL Server ถ้ามีการกำหนดให้แตกต่าง
$port = "4310";
$username = "root"; // ชื่อผู้ใช้ของ MySQL
$password = ""; // รหัสผ่านของ MySQL (ปล่อยว่างไว้ถ้าคุณไม่ได้กำหนดรหัสผ่าน)
$database = "flutter-miniproject"; // ชื่อฐานข้อมูลที่คุณต้องการเชื่อมต่อ

// ทำการเชื่อมต่อกับ MySQL
$conn = new mysqli($server, $username, $password, $database, $port);

// ตรวจสอบการเชื่อมต่อ
if ($conn->connect_error) {
    die("เชื่อมต่อกับ MySQL ไม่สำเร็จ: " . $conn->connect_error);
} 

// ตั้งค่าภาษาในการสื่อสารกับ MySQL เป็น UTF-8
$conn->set_charset("utf8");

// ตอนนี้คุณสามารถใช้ $connection เพื่อสื่อสารกับฐานข้อมูล MySQL ของคุณได้
?>

