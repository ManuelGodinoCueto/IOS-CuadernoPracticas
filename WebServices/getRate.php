<?php
/*
 * @author Manuel Godino Cueto
 * @date(dd/mm/yy) 22/08/2013
 * @version 1.0
 */

require('ftpConfiguration.php');

/*
 * Returns the rate of a user if has been evaluated, else return an error message.
 */
function searchJson($obj, $field, $folder, $twitterUsername, $errorMessage) {
    if (isset($obj[$folder][$twitterUsername])) {
        return $obj[$folder][$twitterUsername];
    } else {
        return $errorMessage;
    }
}

/*
 * Return contents of a FTP file and returns it as string
 */
function ftp_get_contents ($conn_id, $filename) {
    //Create temp handler:
    $tempHandle = fopen('php://temp', 'r+');

    //Get file from FTP:
    if (ftp_fget($conn_id, $tempHandle, $filename, FTP_ASCII, 0)) {
        rewind($tempHandle);
        return stream_get_contents($tempHandle);
    } else {
        return false;
    }
}

// Practice and Twitter username from wich get the rate
$practice        = $_GET["toPractice"];
$twitterUsername = $_GET["toTwitterUsername"];

// Set connection
$conn_id = ftp_connect($ftp_server);
// Begin session
$login_result = ftp_login($conn_id, $ftp_user_name, $ftp_user_pass);
// Check connection
if (!$conn_id) {
    // If there is a connection error return a connection error message
    echo json_encode(array("Response" => "Connection error."));
    exit;
} elseif (!$login_result) {
    // If there is a login error return a login error message
    echo json_encode(array("Response" => "Login error."));
    exit;
} elseif (!ftp_chdir($conn_id, "home/configuration")) {
    // If there is an error accessing to the JSON file directory return an error message
    echo json_encode(array("Response" => "JSON file directory not found."));
    exit;
} else {
    $json = json_decode(ftp_get_contents ($conn_id, "rates.json"), true );
    $userRate = (searchJson($json, "Twitter", $practice, $twitterUsername, "La práctica no ha sido calificada."));
    echo json_encode(array("Response" => $userRate));
}

// Close FTP connection
ftp_close($conn_id);

?>