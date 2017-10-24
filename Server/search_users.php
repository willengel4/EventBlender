<?php
    /* Eventually, this will load all data for all events, we will 
     * just chip away at it for what we need for now. */
    include 'sql_interface.php';

    $search_str = $_GET['search_str'];
    $search_tokens = explode(" ", $search_str);
    $search_attributes = ["first_name", "last_name", "username"];
    $search_query = "select first_name, last_name, username from user where ";

    for($i = 0; $i < count($search_attributes); $i++)
    {
        for($f = 0; $f < count($search_tokens); $f++)
        {
            $attribute = $search_attributes[$i];
            $token = $search_tokens[$f];

            if($i == count($search_attributes) - 1 && $f == count($search_tokens) - 1)
            {
                $search_query .= "$attribute = '$token'";
            }
            else
            {
                $search_query .= "$attribute = '$token' or ";
            }
        }
    }

    $search_query_result = query_database($search_query);

    if($search_query_result->num_rows > 0)
    {
        while($row = $search_query_result->fetch_assoc())
        {
            $firstName = $row['first_name'];
            $lastName = $row['last_name'];
            $username = $row['username'];

            echo "$firstName^^^$lastName^^^$username\n";
        }
    }
?>