BEGIN{
    TCPSent = 0;
    TCPRecieved = 0;
    TCPLost = 0;
    UDPSent  = 0;
    UDPRecieved = 0;
    UDPLost = 0;

    TCPBytesReceived = 0.0;
    UDPBytesReceived = 0.0;
}
{
    packetType = $5;
    event = $1;
    time = $2;
    packetSize = $6

    if(packetType == "tcp")
    {
        if(event == "+")
        {
            TCPSent++;
        }
        else if(event == "r")
        {
            TCPRecieved++;
            TCPBytesReceived = TCPBytesReceived +  packetSize;
           
        }
        else if(event == "d")
        {
            TCPLost++;
            
        }
         
    }
    else if(packetType == "cbr")
    {
        if(event == "+")
        {
            UDPSent++;
           
        }
        else if(event == "r")
        {
            UDPRecieved++;
          
        }
        else if(event == "d")
        {
            UDPLost++;
          
        }
    }

     printf("%f %f\n" ,time , TCPBytesReceived/time);

  
}
END{
    
}
