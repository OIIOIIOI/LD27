<?php

$seed = $_POST['seed'];
$level = $_POST['level'];
$time = $_POST['time'];
$moves = $_POST['moves'];
$name = $_POST['name'];

require_once "db.php";

$q = "INSERT INTO LD27 (seed, level, time, moves, name) VALUES ('$seed', '$level', '$time', '$moves', '$name')";

if (mysqli_query($db, $q)) {
	print("r=ok");
} else {
	print("r=error");
}

?>