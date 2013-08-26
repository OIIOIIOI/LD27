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
function printLink ($ss, $ll, $txt = "", $class = "", $title = "") {
	global $difficulty;
	if ($txt == "")			$txt = $ss;
	else if ($txt == "#")	$txt = $difficulty[$ll];
	return '<a class="playLink '.$class.'" href="http://01101101.fr/ld27/?s='.$ss.'&l='.$ll.'" title="'.$title.'">'.$txt.'</a>';
}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
	<meta charset="utf-8"/>
	<title>LD27</title>
	<meta name="description" content="" />
	<link rel="stylesheet" href="style.min.css" />
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
	
	<div id="wrapper">
	
	<a href="http://01101101.fr/ld27/"><img src="banner.png" alt="banner"/></a>
	
	<div id="leftCol">
		<?php
		if (isset($_GET['s'])) {
			echo '<div id="altContent"></div>';
		} else {
			// Display HTML UI to choose a seed
			echo '<h2>Compete against others in the HOURLY CHALLENGE</h2>';
			echo '<h3>(next one in '.$timeLeft.' min)</h3>';
			echo '<strong>Select the difficulty:</strong><br/><br/>';
			echo printLink($commonSeed, 0, "#");
			echo '&nbsp;&nbsp;';
			echo printLink($commonSeed, 1, "#");
			echo '&nbsp;&nbsp;';
			echo printLink($commonSeed, 2, "#");
			echo '&nbsp;&nbsp;';
			echo printLink($commonSeed, 3, "#");
			echo '<br/>';
			echo '<br/>';
			echo '<br/>';
			echo '<h2>Play a RANDOM LEVEL</h2>';
			echo '<strong>Select the difficulty:</strong><br/><br/>';
			echo printLink($randSeed, 0, "#");
			echo '&nbsp;&nbsp;';
			echo printLink($randSeed, 1, "#");
			echo '&nbsp;&nbsp;';
			echo printLink($randSeed, 2, "#");
			echo '&nbsp;&nbsp;';
			echo printLink($randSeed, 3, "#");
			echo '<br/>';
			echo '<br/>';
			echo '<br/>';
			echo '<h2>Choose a CUSTOM LEVEL ID</h2>';
			echo '<strong>Choose a number between 0 and 999 999 999:</strong><br/>';
			echo '<input id="customSeed" type="text" maxlength="9" name="customSeed" value="0"><br/>';
			echo '<strong>Select the difficulty:</strong><br/><br/>';
			echo printLink($randSeed, 0, "#", "customLink");
			echo '&nbsp;&nbsp;';
			echo printLink($randSeed, 1, "#", "customLink");
			echo '&nbsp;&nbsp;';
			echo printLink($randSeed, 2, "#", "customLink");
			echo '&nbsp;&nbsp;';
			echo printLink($randSeed, 3, "#", "customLink");
		}
		?>
		
	</div>
	
	<div id="rightCol">
	
<?php

require_once "db.php";

if (isset($_GET['s'])) {
	
	
	echo "<h1>Level ID: ".$_GET['s']."</h1>";
	echo "<h2>Leaderboard</h2>";
	
	?>
					
	<?php
	for ($i = 3; $i >= 0; $i--) {
		if ($i == $l)	echo "<h3 class='boardHeader'>".$difficulty[$i]."<span class='playLink'>Currently selected</span></h3>";//no link if current diff
		else			echo "<h3 class='boardHeader'>".$difficulty[$i]."".printLink($_GET['s'], $i, "Select", "", "Click to change the difficulty")."</h3>";// link to select this diff
		?>
				<table class="leaderboard" cellpadding="6px" cellspacing="0px">
		<?php
		
		// Prepare and execute statement
		$stmt = mysqli_prepare($db, "SELECT name, time, moves FROM LD27 WHERE seed = ? AND level = ? ORDER BY time, moves LIMIT 10");
		mysqli_stmt_bind_param($stmt, 'ii', $_GET['s'], $i);
		mysqli_stmt_execute($stmt);
		
		mysqli_stmt_bind_result($stmt, $r_name, $r_time, $r_moves);
		$init = false;
		while (mysqli_stmt_fetch($stmt)) {
			if (!$init) {
				echo '
					<tr>
						<th class="name" align="left">NAME</th>
						<th class="time" align="right">TIME</th>
						<th class="moves" align="right">MOVES</th>
					</tr>
				';
				$init = true;
			}
			echo '
				<tr>
					<td class="name" align="left">'.$r_name.'</td>
					<td class="time" align="right">'.$r_time.'</td>
					<td class="moves" align="right">'.$r_moves."/".$moves[$i].'</td>
				</tr>
			';
		}
		if (!$init) {
			echo '
				<tr>
					<th colspan="3" align="left">Nothing here for now. Will your name be the first?</th>
				</tr>
			';
		}
		
		mysqli_stmt_close($stmt);
		?>
				</table>
		<?php
	}
}
else {
	echo "<h1>Main leaderboard</h1>";
	echo "<h2>The best times across all levels</h2>";
	
	for ($i = 3; $i >= 0; $i--) {
		echo "<h3 class='boardHeader'>".$difficulty[$i]."</h3>";
		?>
				<table class="leaderboard" cellpadding="6px" cellspacing="0px">
		<?php
		
		// Prepare and execute statement
		$stmt = mysqli_prepare($db, "SELECT name, time, moves, seed FROM LD27 WHERE level = ? ORDER BY time, moves LIMIT 10");
		mysqli_stmt_bind_param($stmt, 'i', $i);
		mysqli_stmt_execute($stmt);
		
		mysqli_stmt_bind_result($stmt, $r_name, $r_time, $r_moves, $r_seed);
		$init = false;
		while (mysqli_stmt_fetch($stmt)) {
			if (!$init) {
				echo '
					<tr>
						<th class="name" align="left">NAME</th>
						<th class="time" align="right">TIME</th>
						<th class="moves" align="right">MOVES</th>
						<th class="seed" align="right">LEVEL ID</th>
					</tr>
				';
				$init = true;
			}
			echo '
				<tr>
					<td class="name" align="left">'.$r_name.'</td>
					<td class="time" align="right">'.$r_time.'</td>
					<td class="moves" align="right">'.$r_moves."/".$moves[$i].'</td>
					<td class="seed" align="right">'.printLink($r_seed, $i, "", "", "Play this level").'</td>
				</tr>
			';
		}
		if (!$init) {
			echo '
				<tr>
					<th colspan="3" align="left">Nothing here for now.</th>
				</tr>
			';
		}
		
		mysqli_stmt_close($stmt);
		
		?>
				</table>
		<?php
	}
}

mysqli_close($db);


?>
				</div>
				<div class="clear"></div>
				
				</div>
				
			</td>
		</tr>
	</table>
</body>
</html>