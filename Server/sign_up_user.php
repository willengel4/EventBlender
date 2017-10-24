<?php
    /* This script will sign up a user if given a unique userName and 
     * a valid password, firstName, and lastName 
     * returns error code 1 if the given username already exists 
     * returns error code 0 if a query error occurs */

    include 'sql_interface.php';   
    
    $userName = $_GET["userName"];
    $password = $_GET["password"];
    $firstName = $_GET["firstName"];
    $lastName = $_GET["lastName"];

    /* Check if the userName already exists */
    $checkUserNameCommand = "select id from user where username = '$userName'";
    $userNameResult = query_database($checkUserNameCommand);

    /* Username is unique */
    if($userNameResult->num_rows == 0)
    {
        /* Give the user an new access token */
        $access_token = "";
        for($i = 0; $i < 25; $i++) 
        {
            do
            {
                $random_ascii = rand(48, 122);
            } while(!(($random_ascii >= 48 && $random_ascii <= 57) || ($random_ascii >= 65 && $random_ascii <= 90) || ($random_ascii >= 97 && $random_ascii <= 122)));

            $access_token .= chr($random_ascii);   
        }

        $insertCommand = "insert into user values(0, '$userName', '$password', '$access_token', '$firstName', '$lastName')";

        $addUserResult = query_database($insertCommand);

        /* There was an error */
        if($addUserResult == 0)
        {
            echo "error, 0";
        }

        /* No error */
        else 
        {
            echo "$access_token";
        }
    }

    /* Not unique */
    else 
    {
        echo "error,1";
    }
?>  