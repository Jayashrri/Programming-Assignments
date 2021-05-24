BEGIN{
    TCPSent = 0;
    TCPRecieved = 0;
    TCPLost = 0;
    totalSent = 0;
    totalRecieved = 0;
    totalLost = 0;
    TCPBytesReceived = 0.0;
    TCPThroughput = 0.0;
    UDPThroughput = 0.0;
    total = 0;
    highest_packet_id_tcp = 0;
    highest_packet_id_udp = 0;
}
{
    packetType = $5
    packetSize = $6
    packet_id = $12;
    event = $1
    time = $2;
    if(packetType != "rtproto")
    {
        if(event == "+")
        {
            TCPSent++;
            if ( packet_id > highest_packet_id ) highest_packet_id_tcp = packet_id;
            if ( start_time_TCP[packet_id] == 0 )  start_time_TCP[packet_id] = time; 
        }
        else if(event == "r")
        {
            TCPRecieved++;
            end_time_TCP[packet_id] = time;
        }
        else if(event == "d")
        {
            TCPLost++;
            end_time_TCP[packet_id] = -1; 
        }
    }
   
}
END{
    
    
        for ( packet_id = 0; packet_id <= highest_packet_id_tcp; packet_id++ ) {        
            start = start_time_TCP[packet_id];        
            end = end_time_TCP[packet_id];        
            if( end > start && end_time_TCP[packet_id]!=-1)
            {
                total++;
                totalDelay += end - start;
                printf( "%f %f\n" ,  packet_id , totalDelay/total );
            }
        } 
       
    
    
    
    
}
