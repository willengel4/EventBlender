<?php
    /* Eventually, this will load all data for all events, we will 
     * just chip away at it for what we need for now. */
    include 'sql_interface.php';

    $access_token = $_GET['access_token'];

    /* SQL Query that gets the users meetings */
    $get_events = "select meeting.id, meeting.meeting_title, meeting.min_date, meeting.max_date from meeting join attendee on meeting.id = attendee.meeting_id where attendee.user_id = (select user.id from user where user.access_token = '$access_token')";
    $get_events_result = query_database($get_events);

    if($get_events_result->num_rows > 0)
    {
        while($row = $get_events_result->fetch_assoc())
        {
            $id = $row['id'];
            $title = $row['meeting_title'];
            $min_date = $row['min_date'];
            $max_date = $row['max_date'];

            echo "$id^^^$title^^^$min_date^^^$max_date\n";
        }
    }

    echo "<<<<<<";

    /* Query that gets the user's meetings attendees */
    $get_attendees_query = "select user.first_name, user.last_name, X.meeting_id from user join (select meeting.id as 'meeting_id', attendee.user_id from attendee join meeting on attendee.meeting_id = meeting.id where meeting.id in (select meeting.id from meeting join attendee on meeting.id where attendee.user_id = (select user.id from user where user.access_token = '$access_token'))) X on user.id = X.user_id";
    $get_attendees_result = query_database($get_attendees_query);

    if($get_attendees_result->num_rows > 0)
    {
        while($row = $get_attendees_result->fetch_assoc())
        {
            $firstName = $row['first_name'];
            $lastName = $row['last_name'];
            $meetingID = $row['meeting_id'];

            echo "$firstName^^^$lastName^^^$meetingID\n";
        }
    }

    echo "<<<<<<";

    $get_users_friends_query_1 = "select username, first_name, last_name from friends join user on friends.friend_2 = user.id where friend_1 = (select id from user where access_token = '$access_token')";
    $get_users_friends_result_1 = query_database($get_users_friends_query_1);
    $usernames = array();

    if($get_users_friends_result_1->num_rows > 0)
    {
        while($row = $get_users_friends_result_1->fetch_assoc())
        {
            $firstName = $row['first_name'];
            $lastName = $row['last_name'];
            $username = $row['username'];

            if(in_array($username, $usernames) == FALSE)
            {
                echo "$firstName^^^$lastName^^^$username\n";
                array_push($usernames, $username);
            }
        }
    }

    $get_users_friends_query_2 = "select username, first_name, last_name from friends join user on friends.friend_1 = user.id where friend_2 = (select id from user where access_token = '$access_token')";
    $get_users_friends_result_2 = query_database($get_users_friends_query_2);

    if($get_users_friends_result_2->num_rows > 0)
    {
        while($row = $get_users_friends_result_2->fetch_assoc())
        {
            $firstName = $row['first_name'];
            $lastName = $row['last_name'];
            $username = $row['username'];

            if(in_array($username, $usernames) == FALSE)
            {
                echo "$firstName^^^$lastName^^^$username\n";
                array_push($usernames, $username);
            }
        }
    }

    echo "<<<<<<";

    $get_availability_cmd = "select * from availability where user_id = (select id from user where access_token='$access_token') order by meeting_id, start_date_time";
    $get_availability_result = query_database($get_availability_cmd);

    if($get_availability_result->num_rows > 0)
    {
        while($row = $get_availability_result->fetch_assoc())
        {
            $start_date_time = $row['start_date_time'];
            $end_date_time = $row['end_date_time'];
            $meeting_id = $row['meeting_id'];

            echo "$meeting_id^^^$start_date_time^^^$end_date_time\n";
        }
    }

    echo "<<<<<<";

    $get_group_availability = "select meeting_id, user_id, start_date_time, end_date_time, date_format(start_date_time, '%h:%i %p') as start_standard, date_format(end_date_time, '%h:%i %p') as end_standard from availability where meeting_id in (select distinct meeting_id from attendee where user_id = (select id from user where access_token = '$access_token')) order by meeting_id, user_id, start_date_time";
    $get_group_availability_result = query_database($get_group_availability);

    if($get_group_availability_result->num_rows > 0)
    {
        while($row = $get_group_availability_result->fetch_assoc())
        {
            $meeting_id = $row['meeting_id'];
            $user_id = $row['user_id'];
            $start_time = $row['start_date_time'];
            $end_time = $row['end_date_time'];
            $start_standard = $row['start_standard'];
            $end_standard = $row['end_standard'];
            
            echo "$meeting_id^^^$user_id^^^$start_time^^^$end_time^^^$start_standard^^^$end_standard\n";
        }
    }
?>