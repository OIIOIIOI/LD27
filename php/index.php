<?php
$difficulty = ["Not even fun", "Interesting", "Challenging", "Not for humans"];
$moves = [15, 35, 50, 60];
// Get or set the difficulty level
if (isset($_GET['l']))					$l = $_GET['l'];
else									$l = 1;
if ($l < 0 || $l >= count($difficulty))	$l = 1;
// Generate random seed
$randSeed = mt_rand(0, 999999999);
// Generate hourly seed
$commonSeed = date(ymdH);
$timeLeft = 60 - date(i);
// Generate link tag
function printLink ($ss, $ll, $txt = "", $class = "") {
	global $difficulty;
	if ($txt == "")			$txt = $ss;
	else if ($txt == "#")	$txt = $difficulty[$ll];
	return '<a class="playLink '.$class.'" href="http://01101101.fr/ld27/?s='.$ss.'&l='.$ll.'">'.$txt.'</a>';
}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
	<meta charset="utf-8"/>
	<title>LD27</title>
	<meta name="description" content="" />
	
	<?php
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
	<?php } ?>
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function () {
			$("#customSeed").keyup(function () {
				$("#customSeed").val($("#customSeed").val().replace(/[^\d]/g, ""));
				$(".customLink").each(function (i) {
					$(this).attr("href", "http://01101101.fr/ld27/?s=" + $("#customSeed").val() + "&l=" + i);
				});
				
			});
		});
	</script>
</head>
<body>
	<h1><a href="http://01101101.fr/ld27/">Home</a></h1>
	
	<table cellpadding="10px">
		<tr>
			<td valign="top">
				<?php
				if (isset($_GET['s'])) {
					echo '<div id="altContent"></div>';
				} else {
					// Display HTML UI to choose a seed
					echo '<h2>Compete against others in the HOURLY CHALLENGE</h2>';
					echo '<h3>(next one in '.$timeLeft.' min)</h3>';
					echo '<strong>Select the difficulty:</strong><br/>';
					echo printLink($commonSeed, 0, "#").' | '.printLink($commonSeed, 1, "#").' | '.printLink($commonSeed, 2, "#").' | '.printLink($commonSeed, 3, "#");
					echo '<br/>';
					echo '<h2>Play a RANDOM LEVEL</h2>';
					echo '<strong>Select the difficulty:</strong><br/>';
					echo printLink($randSeed, 0, "#").' | '.printLink($randSeed, 1, "#").' | '.printLink($randSeed, 2, "#").' | '.printLink($randSeed, 3, "#");
					echo '<br/>';
					echo '<h2>Choose a CUSTOM SEED</h2>';
					echo '<strong>Choose a number between 0 and 999 999 999:</strong><br/>';
					echo '<input id="customSeed" type="text" maxlength="9" name="customSeed" value="0"><br/>';
					echo '<strong>Select the difficulty:</strong><br/>';
					echo printLink($randSeed, 0, "#", "customLink").' | '.printLink($randSeed, 1, "#", "customLink").' | '.printLink($randSeed, 2, "#", "customLink").' | '.printLink($randSeed, 3, "#", "customLink");
				}
				?>
			</td>
			<td valign="top">
<?php

if (isset($_GET['l']))				$l = $_GET['l'];
else								$l = 1;
if ($l != 0 && $l != 1 && $l != 2)	$l = 1;

require_once "db.php";

if (isset($_GET['s'])) {
	echo "<h1>Best times for seed ".$_GET['s'].", ordered by difficulty</h1>";
	
	for ($i = 3; $i >= 0; $i--) {
		echo "<h2>".$difficulty[$i]."</h2>";
		
		// Prepare and execute statement
		$stmt = mysqli_prepare($db, "SELECT name, time, moves FROM LD27 WHERE seed = ? AND level = ? ORDER BY time LIMIT 10");
		mysqli_stmt_bind_param($stmt, 'ii', $_GET['s'], $i);
		mysqli_stmt_execute($stmt);
		
		mysqli_stmt_bind_result($stmt, $r_name, $r_time, $r_moves);
		$empty = true;
		while (mysqli_stmt_fetch($stmt)) {
			$empty = false;
			echo $r_name." | ".$r_time." | ".$r_moves."/".$moves[$i]." moves<br/>";
		}
		if ($empty) {
			echo 'No time yet<br/><a href="http://01101101.fr/ld27/?s='.$_GET['s'].'&l='.$i.'">Be the first!</a>';
		}
		
		mysqli_stmt_close($stmt);
	}
}
else {
	echo "<h1>Best times for all levels, ordered by difficulty</h1>";
	
	for ($i = 3; $i >= 0; $i--) {
		echo "<h2>".$difficulty[$i]."</h2>";
		
		// Prepare and execute statement
		$stmt = mysqli_prepare($db, "SELECT name, time, moves, seed FROM LD27 WHERE level = ? ORDER BY time LIMIT 10");
		mysqli_stmt_bind_param($stmt, 'i', $i);
		mysqli_stmt_execute($stmt);
		
		mysqli_stmt_bind_result($stmt, $r_name, $r_time, $r_moves, $r_seed);
		$empty = true;
		while (mysqli_stmt_fetch($stmt)) {
			$empty = false;
			echo $r_name." | ".$r_time." | ".$r_moves."/".$moves[$i]." moves | ".printLink(r_seed, $i)."<br/>";
		}
		if ($empty) {
			echo 'No time yet<br/>';
		}
		
		mysqli_stmt_close($stmt);
	}
}

mysqli_close($db);


?>
			</td>
		</tr>
	</table>
</body>
</html>