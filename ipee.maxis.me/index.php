<?php
session_start();
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head> 
	<!-- meta stuff -->
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<meta name="description" content="An app to tell you your public IP address">
	<meta name="keywords" content="OSX, Mac, iPee, IP, what is my ip">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0"/>
	<!-- google fonts -->
	<link href='https://fonts.googleapis.com/css?family=Muli' rel='stylesheet' type='text/css'>
	<link href='https://fonts.googleapis.com/css?family=Montserrat' rel='stylesheet' type='text/css'>
	<!-- google recaptcha --> 
	<script src='https://www.google.com/recaptcha/api.js'></script>
	<!-- jquery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
	<!-- maxis.me css -->
	<link rel="stylesheet" type="text/css" href="https://maxis.me/template/css/style.css"/>
	<!-- maxis.me scripts -->
	<script type="text/javascript" src="https://maxis.me/template/scripts/jquery.easing.min.js"></script>
	<script type="text/javascript" src="https://maxis.me/template/scripts/scrolling-nav.js"></script>
	<script type="text/javascript" src="https://maxis.me/template/scripts/script.js"></script>

	<title>iPee</title>
</head>

<body>
	<!-- HOME -->
	<page>
		<div align="center">
			<br/><br/><img height="350" src="logo.png"><br/><br/><br/>
			<h1>iPee</h1>
			<div id="navMenu">
				<a class="page-scroll" href="#howitworks">How It Works</a> | <a class="page-scroll" href="#contact">Contact</a> | <a class="page-scroll" href="#tsandcs">Ts & Cs</a> 
			</div><br/><br/><br/>
			<a id="down" href="download">download</a><br/><br/>
		</div>
	</page>

	<!-- HOW IT WORKS -->
	<page id="howitworks">
		<h2>How It Works</h2>
		<div id="info">
			iPee is a minimal Mac App that sits in your menu bar and shows you your public IP address.
		</div>
	</page>

	<!-- Contact -->
	<page id="contact">
		<h2>contact</h2>
		<span id='info'>
        <span id="contactForm">
        <div align="center">
        <?php
		if($_SESSION["error"] > 0 && $_SESSION["error"] < 5){
			echo "<span class='box' style='color:#6C0207'>";
			if($_SESSION["error"] == 1){
				echo "Error: No Email Address";
			}else if($_SESSION["error"] == 2){
				echo "Error: No Name";
			}else if($_SESSION["error"] == 3){
				echo "Error: No Message";
			}else if($_SESSION["error"] == 4){
				echo "Error: Invalid Email";
			}
			echo "</span>
		"; $_SESSION["error"] = NULL; }else if($_SESSION["success"] == 1){ echo "<span class='box' style='color:#2A682E'>Success! We will get back to you as soon as possible!</span>"; $_SESSION["success"] = NULL; } ?>
		</div>
		<form action="email/send.php" method="post">
			Name<br/>
			<input name="name" type="text" required><br/><br/> Email
			<br/>
			<input name="email" type="email" required><br/><br/> Message
			<br/>
			<textarea style="resize: vertical;" name="message" required="required" rows="5"></textarea><br/><br/>
			<!--<div class="g-recaptcha" data-theme="dark" data-sitekey="6LfzGhITAAAAANBon7DeBgx2TSfch3i85zmxJOcw"></div><br /> -->
			<input id="sendEmail" value="Send" type="submit"/>
		</form>
		</span>
	</page>
	
	<!-- Ts & Cs -->
	<page id="tsandcs">
		<h2>Ts & Cs</h2>
		<div id="info">
			By using the Notifi application you are agreeing to these terms:<br /><br />
			Use of the Service is at your own risk. The Service is provided on an "AS IS" and "AS AVAILABLE" basis without any representation or endorsement made and without warranty of any kind whether expressed or implied, including but not limited to the implied warranties of satisfactory quality, fitness for a particular purpose, non-infringement, compatibility, security and accuracy.<br /><br />To the extent permitted by law, the Service, will not be liable for any indirect or consequential loss or damage whatsoever (including without limitation, loss of business, opportunity, data, profits) arising out of or in connection with the use of the Service. 
		</div>
	</page>
</body>

</html>