#!/usr/bin/env php
<?php
$HOST = "10.0.2.15";
$USER = "domjudge_jury";
$PASS = "vagrant";
$DB   = "domjudge";

$conn=mysqli_init();
if (!mysqli_real_connect($conn, $HOST, $USER, $PASS, $DB, NULL, NULL, MYSQLI_CLIENT_SSL)) { die(); }
$res = mysqli_query($conn, 'SHOW STATUS like "Ssl_cipher"');
print_r(mysqli_fetch_row($res));
mysqli_close($conn);
?>
