<?php
    /* This script will recieve a userName / password from the args. 
     * It will check if there is a record with this combo. 
     * If there is, it will return the access token, otherwise, it will return an error message */

     include 'sql_interface.php';

     $userName = $_GET['userName'];
     $password = $_GET['password'];

     $checkUserCommand = "select access_token from user where username = '$userName' and password = '$password'";
     $result = query_database($checkUserCommand);

     /* If the user doesn't exist */
     if($result->num_rows == 0)
     {
         echo "error, 0";
     }

     /* If the user does exist */
     else
     {
         /* Get the access token and print it */
         $row = $result->fetch_assoc();
         $accessToken = $row['access_token'];
         echo "$accessToken";
     }
?>