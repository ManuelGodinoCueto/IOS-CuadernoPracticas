<?php
/*
 * @author Manuel Godino Cueto
 * @date(dd/mm/yy) 30/07/2013
 * @version 1.0
 */

require('ftpConfiguration.php');

// Folder to check
$folder = basename($_GET["fromFolder"]);
$file = 'ftp://'.$ftp_user_name.':'.$ftp_user_pass.'@'.$ftp_server.'/'.'home/www/IOS-CuadernoPracticas/'.$folder.'/Enunciado.pdf';

// Set connection
$conn_id = ftp_connect($ftp_server);
// Begin session
$login_result = ftp_login($conn_id, $ftp_user_name, $ftp_user_pass);
// Check connection
if (!$conn_id) {
        // If there is a connection error return a connection error message
        echo "Connection error.";
        exit;
    } elseif (!$login_result) {
        // If there is a login error return a login error message
        echo "Login error.";
        exit;
    } elseif (!ftp_chdir($conn_id, "home/www/IOS-CuadernoPracticas/" . $folder)) {
        // If there is an error accessing to IOS-CuadernoPracticas directory return an error message
        echo "IOS-CuadernoPracticas directory not found.";
        exit;
    } elseif (file_exists($file) && filesize($file)) {
        header('Content-Description: application/pdf');
        header('Content-Type: application/octet-stream');
        header('Content-Disposition: inline; filename='.'Enunciado.pdf');
        header('Content-Transfer-Encoding: binary');
        header('Expires: 0');
        header('Cache-Control: must-revalidate');
        header('Pragma: public');
        header('Content-Length: ' . filesize($file));
        ob_clean();
        flush();
        readfile($file);
        exit;
    }

    // Close FTP connection
    ftp_close($conn_id);
?>