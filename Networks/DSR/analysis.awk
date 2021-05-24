BEGIN{
    TCPSent = 0;
    TCPRecieved = 0;
    TCPLost = 0;
    UDPSent = 0;
    UDPRecieved = 0;
    UDPLost = 0;
    totalSent = 0;
    totalRecieved = 0; 
    totalLost = 0;
    TCPBytesReceived = 0.0;
    UDPBytesReceived = 0.0;
    TCPThroughput = 0.0;
    UDPThroughput = 0.0;
    TCPDelay = 0;
    UDPDelay = 0;
    highest_packet_id_tcp = 0;
    highest_packet_id_udp = 0;
}
{
    packetType = $5
    packetSize = $6
    packet_id = $12;
    event = $1
    time = $2;
    if(packetType == "tcp")
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
            TCPBytesReceived = TCPBytesReceived + packetSize;
            end_time_TCP[packet_id] = time;
        }
        else if(event == "d")
        {
            TCPLost++;
            end_time_TCP[packet_id] = -1; 
        }
    }
    
    TCPThroughput = TCPBytesReceived/10;
}
END{
    
    if(TCPSent>0){
        totalSent = TCPSent + UDPSent;
        totalLost = TCPLost + UDPLost;
        printf("TCP packets sent : %d\n",TCPSent);
        printf("TCP packets recieved : %d\n",TCPRecieved);
        printf("TCP packets dropped: %d\n", TCPLost);
        printf("TCP Throughput : %f\n" , TCPThroughput); 
        total = 0;
        for ( packet_id = 0; packet_id <= highest_packet_id_tcp; packet_id++ ) {        
            start = start_time_TCP[packet_id];        
            end = end_time_TCP[packet_id];        
            packet_duration = end - start;       
            if ( start < end ) TCPDelay += packet_duration;   
            if ( start < end ) total++;  
        } 
        printf("Average delay of TCP : %f\n", TCPDelay/total);    
        printf("PDR  %d\n", (TCPRecieved/TCPSent)*100);
    }
    
    
    
   
}
