<?php
    /* This script will create a meeting record in the database 
     * given the access token of the user creating the meeting, 
     * the minimum date of the meeting, the maximum date of the meeting, 
     * and the title of the meeting. 
     * Then, it will add attendee's to the meeting through the attendee table 
     * given the usernames of each user to be added to the meeting */

    include 'sql_interface.php';

    $admin_access_token = $_GET['access_token'];
    $min_date = $_GET['min_date'];
    $max_date = $_GET['max_date'];
    $meeting_title = $_GET['meeting_title'];
    
    /* Adds the meeting */
    $create_meeting_command = "insert into meeting values(0, (select id from user where access_token = '$admin_access_token'), '$min_date', '$max_date', NULL, NULL, '$meeting_title')";    
    $create_meeting_result = query_database($create_meeting_command);

    echo "$create_meeting_command";

    /* Adds all of the users to the meeting. 
     * Checks at most $max_users worth of users. 
     * Checks username0,username1... until the 
     * parameter isn't in the query string */
    $max_users = 10;
    for($i = 0; $i < $max_users && isset($_GET["username$i"]); $i++)
    {
        /* Inserts new a record into the attendee 
         * table with the user with that username, 
         * and the most recently added meeting that 
         * has a matching $admin_access_token, $min_date, 
         * $max_date, and $meeting_title */
        $user_name = $_GET["username$i"];
        $add_user_to_meeting_command = "insert into attendee values((select id from user where username='$user_name'),(select max(id) from meeting where admin_user = (select id from user where access_token='$admin_access_token')and min_date='$min_date'and max_date='$max_date'))";
        $add_user_result = query_database($add_user_to_meeting_command);

        echo "$user_name";
    }

    /* The admin is an attendee too */
    $add_user_to_meeting_command = "insert into attendee values((select id from user where access_token='$admin_access_token'),(select max(id) from meeting where admin_user = (select id from user where access_token='$admin_access_token')and min_date='$min_date'and max_date='$max_date'))";
    $add_user_result = query_database($add_user_to_meeting_command);

    echo "Done."
?>