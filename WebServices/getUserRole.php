<?php
/*
 * @author Manuel Godino Cueto
 * @date(dd/mm/yy) 17/07/2013
 * @version 1.0
 */

require('ftpConfiguration.php');

/*
 * Search for a value in the field of an object and return it's parent key, else return an error message.
 */
function searchJson($obj, $field, $value, $errorMessage) {
    foreach($obj as $itemKey => $itemValue) {
        foreach($itemValue as $childKey => $childValue) {
            if($childValue[$field] == $value) {
                return $itemKey;
            }
        }
    }
    return $errorMessage;
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

// Twitter account to check
$twitterAccount = $_GET["withTwitterUsername"];

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
} elseif (!ftp_chdir($conn_id, "home/configuration")) {
    // If there is an error accessing to the JSON file directory return an error message
    echo "JSON file directory not found.";
    exit;
} else {
    $json = json_decode(ftp_get_contents ($conn_id, "users.json"), true );
    $typeOfAccount = (searchJson($json, "Twitter", $twitterAccount, "You are not a professor or student."));
    echo json_encode(array("Response" => $typeOfAccount));
}

// Close FTP connection
ftp_close($conn_id);

?>