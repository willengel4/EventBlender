<?php
    function query_database($statement)
    {
        /* Open a mysql database connection */
        $connection = new mysqli("localhost", "root", "", "event_blender", 3306, "") or die("couldn't connect" . mysqli_connect_error());

        try
        {
            $result = $connection->query($statement);
            $connection->close();
            return $result;
        }
        catch(Exception $e)
        {
            $connection->close();
            return 0;
        }
    }
?>
