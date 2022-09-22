<?php 

	//PDO or MySQLI to connect

	$connect = mysqli_connect('127.0.0.1', 'root', '', 'supermarketdb');

	// check connection

	if (!$connect) {
		echo "Connection error: " . msqli_connect_error();
	}

 ?>