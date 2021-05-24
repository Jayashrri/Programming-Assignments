#include <stdio.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <string.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <poll.h>

#define SIZE 4
int main()
{
	int TCPSocket, ClientSocket, length, status;
	int i = 0, j;
	char message[20], frame[20], temp[20], ack[20];

	struct sockaddr_in SAddr, CAddr;
	TCPSocket = socket(AF_INET, SOCK_STREAM, 0);
	if (TCPSocket < 0)
	{
		perror("Socket Creation Error");
	}

	bzero(&SAddr, sizeof(SAddr));
	SAddr.sin_family = AF_INET;
	SAddr.sin_addr.s_addr = htonl(INADDR_ANY);
	SAddr.sin_port = htons(5000);

	if (bind(TCPSocket, (struct sockaddr *)&SAddr, sizeof(SAddr)) < 0)
	{
		perror("Bind Error");
	}
	listen(TCPSocket, 5);

	length = sizeof(&CAddr);
	ClientSocket = accept(TCPSocket, (struct sockaddr *)&CAddr, &length);
	
	struct pollfd fd;
	int rv;
	
	fd.fd = ClientSocket;
	fd.events = POLLIN;
	
	printf("Enter message: ");
	scanf("%s", message);
	printf("\n\n");

	while (i < strlen(message))
	{
		memset(frame, 0, 20);
		strncpy(frame, message + i, SIZE);
		length = strlen(frame);
		for (j = 0; j < length; j++)
		{
			sprintf(temp, " %d", i + j);
			strcat(frame, temp);
		}
		printf("Frame transmitted : %s\n", frame);
		write(ClientSocket, frame, sizeof(frame));
		
		rv = poll(&fd, 1, 5000);
				
		if(rv > 0)
		{
			read(ClientSocket, ack, 20);
			sscanf(ack, "%d", &status);

			if (status == -1)
			{
				printf(" - Successful Transmission\n");
				i = i + SIZE;
			}
			else
			{
				printf(" - Error in %d. \n", status);
				i = status;
			}
			printf("\n");
		}
	}

	write(ClientSocket, "exit", sizeof("exit"));
	printf("Exiting\n");
	sleep(2);
	close(ClientSocket);
	close(TCPSocket);
}
