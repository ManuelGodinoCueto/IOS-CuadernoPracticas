<?php
/*
 * @author Manuel Godino Cueto
 * @date(dd/mm/yy) 19/07/2013
 * @version 1.0
 */

require('ftpConfiguration.php');

function listDirectory($resource, $directory = '.') {
    if (is_array($children = @ftp_rawlist($resource, $directory))) {
        $items = array();
        foreach ($children as $child) {
            $chunks = preg_split("/\s+/", $child);
            $fileName = implode(" ", array_splice($chunks, 8));
            if ($chunks[0]{0} === 'd') {
                $item = ftp_nlist($resource, $fileName);
            }
            $items[$fileName] = $item;
        }
        return $items;
    } else {
    return null;
    }
}

// Twitter account to log
$twitterAccount = $_GET["withTwitterUsername"];
// Log data
$logFile = "Control.log";

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
    // If there is an error accessing to the JSON file directory return an error message
    echo "JSON file directory not found.";
    exit;
} else {
    echo json_encode(listDirectory($conn_id, "."));
    // Log
    // date_default_timezone_set("Europe/Madrid");
    // $content = date("Y-m-d H:i:s") . " - " . $twitterAccount . "\n";
    // file_put_contents($logFile, $content, FILE_APPEND | LOCK_EX);
}

// Close FTP connection
ftp_close($conn_id);

?>