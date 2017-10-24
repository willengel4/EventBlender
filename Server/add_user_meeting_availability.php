<?php
    /* This script is responsible for taking the meeting_id, user access token, and a
     * list of (start_date_time, end_date_time) intervals. When the script recieves this 
     * data, it will clear out the user's availability data for that meeting, and overwrite
     * it with the new availability data taken in */

     include 'sql_interface.php';

     /* Take in the meeting_id and user access token */
     $meeting_id = $_GET['meeting_id'];
     $access_token = $_GET['access_token'];

     /* This is where the user's current availability for the meeting should be cleared */
     $clear_user_meeting_cmd = "delete from availability where user_id = (select id from user where access_token = '$access_token') and meeting_id = $meeting_id";
     $clear_user_meeting_result = query_database($clear_user_meeting_cmd);

     /* Go through all of the arguments until there are none left
      * Add a record in availability table for each time period in the args */
     $more_args = TRUE;
     $current_index = 0;
     while($more_args)
     {
         /* If there are more args */
         if(isset($_GET["start_date_time_$current_index"]))
         {
             /* Retrieve the start and end times */
             $start_date_time = $_GET["start_date_time_$current_index"];
             $end_date_time = $_GET["end_date_time_$current_index"];

             /* Insert into the database the start and end times */
             $new_availability_cmd = "insert into availability values((select id from user where access_token = '$access_token'),  $meeting_id, '$start_date_time', '$end_date_time')";
             $new_availability_result = query_database($new_availability_cmd);
         }

         /* If there aren't any more args left */
         else
         {
             $more_args = FALSE;
         }

         /* Increment the arg index */
         $current_index += 1;
     }

     echo "done"
?>