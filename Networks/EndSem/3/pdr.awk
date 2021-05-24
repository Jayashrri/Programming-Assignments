BEGIN{
    sent = 1;
    recv = 1;
}
{
    eventType = $1;
    time = $2;
    packetType  = $7;
    packetSize = $8;
    packetID = $6;
    
    if( $4 == "AGT"  && $1 == "s")
        sent++;
    else if ( $4 == "AGT" && $1 == "r")
        recv++;
    
    printf("%f %f\n" , time , recv/sent *100);
}
END{



}