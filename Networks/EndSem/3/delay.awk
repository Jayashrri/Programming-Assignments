BEGIN{

    total = 0;
    totalDelay = 0;
    highest_packet_id = 0;

}
{

    eventType = $1;
    time = $2;
    packetType  = $7;
    packetSize = $8;
    packetID = $6;
    layer = $4;

    if( $4 == "AGT" && $1 == "s")
    {
        if(start_time[packetID] == 0)
            start_time[packetID] = time;
        if(packetID > highest_packet_id)
            highest_packet_id = packetID;
    }
    else if( $4 == "AGT" && $1 == "r")
        end_time[packetID] = time;
    else if ( $4 == "AGT" && $1 == "D")
        end_time[packetID] = -1;





}
END{
    
    
    
        for ( packet_id = 0; packet_id <= highest_packet_id; packet_id++ ) {        
            start = start_time[packet_id];        
            end = end_time[packet_id];        
            if( end > start && end_time[packet_id]!=-1)
            {
                total++;
                totalDelay += end - start;
                printf( "%f %f\n" ,  packet_id , totalDelay/total );
            }
        } 
       
    


}