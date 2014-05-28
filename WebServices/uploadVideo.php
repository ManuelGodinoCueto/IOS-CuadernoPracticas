<?php
/*
 * @author Manuel Godino Cueto
 * @date(dd/mm/yy) 30/07/2013
 * @version 1.0
 */

require('ftpConfiguration.php');

if (is_uploaded_file($_FILES['userfile']['tmp_name'])) {
    // Folder where video goes
    $folder = $_GET["toFolder"];
    // Video filename
    $fileName = basename($_FILES['userfile']['name']);
    // Path where video goes
    $uploadPath = $folder . "/" . $fileName;

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
    } elseif (!ftp_chdir($conn_id, "home/www/IOS-CuadernoPracticas")) {
        // If there is an error accessing to IOS-CuadernoPracticas directory return an error message
        echo "IOS-CuadernoPracticas directory not found.";
        exit;
    } elseif (ftp_put($conn_id, $uploadPath, $_FILES['userfile']['tmp_name'], FTP_BINARY, 0)) {
        echo "Video uploaded. \r\n";
    } else {
        echo "Video upload error";
    }

    // Close FTP connection
    ftp_close($conn_id);
} else {
    echo "Video not uploaded. \r\n";
}

?>