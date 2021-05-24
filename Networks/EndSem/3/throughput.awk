BEGIN{
    bytesReceived = 0;

}
{
    eventType = $1;
    time = $2;

    packetSize = $8;

    if( $4 == "AGT" && $1 == "r")
        bytesReceived = bytesReceived + packetSize;
    
    printf("%f %f\n" , time , bytesReceived/time);

}
END{

}