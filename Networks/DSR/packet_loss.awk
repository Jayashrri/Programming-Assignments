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
    if(packetType == "tcp")
    {
        if(event == "+")
        {
            TCPSent++;
        }
        else if(event == "r")
        {
            TCPRecieved++;
        }
        else if(event == "d")
        {
            TCPLost++; 
        }
    }
    printf("%f %f\n" , time , TCPLost);
}
END{
    
    
       
    
    
    
    
}
