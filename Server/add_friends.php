<?php
    include 'sql_interface.php';

    $access_token = $_GET['access_token'];

    $max = 10;
    for($i = 0; $i < $max && isset($_GET["friend_username$i"]); $i++)
    {
        $friend_username = $_GET["friend_username$i"];
        $add_friends_query = "insert into friends values((select id from user where access_token = '$access_token'), (select id from user where username = '$friend_username'))";
        $add_friends_result = query_database($add_friends_query);
    }

    echo "done.";
?>