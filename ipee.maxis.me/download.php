<?php
$file = "iPee.zip";
header('Content-type:  application/zip');
header('Content-Length: ' . filesize($file));
header('Content-Disposition: attachment; filename="'.$file.'"');
readfile($file);
header("Location: /");
?> 