BEGIN{
    TCPSent = 0;
    TCPRecieved = 0;
    TCPLost = 0;
    UDPSent  = 0;
    UDPRecieved = 0;
    UDPLost = 0;
}
{
    packetType = $5;
    event = $1;
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
          printf("%d %d\n" ,time , TCPRecieved/TCPSent * 100 );
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


  
}
END{
    
}
