<?php
    include 'sql_interface.php';

    $access_token = $_GET['access_token'];

    /* SQL Query that gets the users meetings */
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