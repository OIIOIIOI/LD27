<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8"/>
	<title>LD27</title>
	<meta name="description" content="" />
	
	<?php
	// Get or set the difficulty level
	if (isset($_GET['l']))				$l = $_GET['l'];
	else								$l = 1;
	if ($l != 0 && $l != 1 && $l != 2)	$l = 1;
	
	// If the seed is set
	if (isset($_GET['s'])) {
		// Load the game with the specified seed
		$s = $_GET['s'];
	?>
		<script src="js/swfobject.js"></script>
		<script>
			var flashvars = {};
			flashvars.s = "<?php echo $s; ?>";
			flashvars.l = "<?php echo $l; ?>";
			var params = {
				menu: "false",
				scale: "noScale",
				allowFullscreen: "true",
				allowScriptAccess: "always",
				bgcolor: "",
				wmode: "direct"
			};
			var attributes = {
				id:"LD27"
			};
			swfobject.embedSWF(
				"LD27.swf", 
				"altContent", "600px", "600px", "11.3.0", 
				"expressInstall.swf", 
				flashvars, params, attributes);
		</script>
	<?php
	// If the seed is not seed
	} else {
		// Display HTML UI to choose a seed
		
	}
	?>
</head>
<body>
	<table>
		<tr>
			<td><div id="altContent"></div></td>
			<td valign="top">
<?php

if (isset($_GET['l']))				$l = $_GET['l'];
else								$l = 1;
if ($l != 0 && $l != 1 && $l != 2)	$l = 1;

require_once "db.php";

if (isset($_GET['s'])) {
	echo "<p>LEADERBOARD for seed ".$_GET['s']." AND LEVEL ".$l."</p>";
	
	$q = "SELECT * FROM LD27 WHERE seed = ".$_GET['s']." AND level = $l ORDER BY time";
	
	$result = mysqli_query($db, $q);
	while ($row = mysqli_fetch_assoc($result)) {
		echo $row["name"]." - ".$row["seed"]."<br/>";
	}
	if (mysqli_num_rows($result) == 0) {
		echo "No score yet";
	}
	
	mysqli_free_result($result);
}
else {
	echo "<p>BEST TIMES FOR LEVEL ".$l."</p>";
	
	$q = "SELECT * FROM LD27 WHERE level = $l ORDER BY time";
	
	$result = mysqli_query($db, $q);
	while ($row = mysqli_fetch_assoc($result)) {
		echo $row["name"]." - ".$row["seed"]."<br/>";
	}
	if (mysqli_num_rows($result) == 0) {
		echo "No score yet";
	}
	
	mysqli_free_result($result);
}

mysqli_close($db);


?>
			</td>
		</tr>
	</table>
</body>
</html>