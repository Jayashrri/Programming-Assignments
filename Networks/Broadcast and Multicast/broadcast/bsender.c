#include <stdio.h>      
#include <sys/socket.h> 
#include <arpa/inet.h>  
#include <stdlib.h>     
#include <string.h>     
#include <unistd.h>     

int main(int argc, char *argv[])
{
    int sock;                         
    struct sockaddr_in broadcastAddr; 
    char *broadcastIP;                
    unsigned short broadcastPort;     
    char *sendString;                 
    int broadcastPermission;          
    unsigned int sendStringLen;       

    if (argc < 4)                     
    {
        fprintf(stderr,"Usage:  %s <Port> <Send String>\n", argv[0]);
        exit(1);
    }

    broadcastIP = "127.0.0.1";             
    broadcastPort = atoi(argv[1]);    
    sendString = argv[2];             

    if ((sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0)
        perror("socket() failed");

    broadcastPermission = 1;
    if (setsockopt(sock, SOL_SOCKET, SO_BROADCAST, (void *) &broadcastPermission, 
          sizeof(broadcastPermission)) < 0)
        perror("setsockopt() failed");

    memset(&broadcastAddr, 0, sizeof(broadcastAddr));   
    broadcastAddr.sin_family = AF_INET;                 
    broadcastAddr.sin_addr.s_addr = inet_addr(broadcastIP);
    broadcastAddr.sin_port = htons(broadcastPort);         

    sendStringLen = strlen(sendString);
    for (;;)
    {
         if (sendto(sock, sendString, sendStringLen, 0, (struct sockaddr *) 
               &broadcastAddr, sizeof(broadcastAddr)) != sendStringLen)
             perror("sendto() sent a different number of bytes than expected");

        sleep(3);
    }
}
