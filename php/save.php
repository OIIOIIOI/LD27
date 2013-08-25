<?php

$seed = $_POST['seed'];
$level = $_POST['level'];
$time = $_POST['time'];
$moves = $_POST['moves'];
$name = $_POST['name'];

require_once "db.php";

$stmt = mysqli_prepare($db, "INSERT INTO LD27 (seed, level, time, moves, name) VALUES (?, ?, ?, ?, ?)");
mysqli_stmt_bind_param($stmt, 'iisis', $seed, $level, $time, $moves, $name);
mysqli_stmt_execute($stmt);
mysqli_stmt_close($stmt);
mysqli_close($db);

?>