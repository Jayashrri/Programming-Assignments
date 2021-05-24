#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <unistd.h>
#include <poll.h>

int main()
{
	int TCPSocket, length, choice;
	char message[20], error[20];

	struct sockaddr_in SAddr;
	TCPSocket = socket(AF_INET, SOCK_STREAM, 0);
	if (TCPSocket < 0)
	{
		perror("Socket Creation Error");
	}

	bzero(&SAddr, sizeof(SAddr));
	SAddr.sin_family = AF_INET;
	SAddr.sin_addr.s_addr = INADDR_ANY;
	SAddr.sin_port = htons(5000);
	
	struct pollfd mypoll = { STDIN_FILENO, POLLIN|POLLPRI };

	connect(TCPSocket, (struct sockaddr *)&SAddr, sizeof(SAddr));

	for (;;)
	{
		read(TCPSocket, message, 20);
		if (!strcmp(message, "exit"))
		{
			printf("Exiting\n");
			break;
		}
		printf("\n\nReceived: %s \n0. Successful, 1. Report Error, 2. Lost Acknowledgement: ", message);
		fflush(stdout);
		
		if( poll(&mypoll, 1, 5000) )
		{
			scanf("%d", &choice);
			if (choice == 0)
				write(TCPSocket, "-1", sizeof("-1"));
			else if(choice == 1)
			{
				printf("Frame in which error occurred: ");
				scanf("%s", error);
				write(TCPSocket, error, sizeof(error));
			}
			printf("\n");
		}
		else
		{
			printf("\nAcknowledgement or Frame Lost\n");
		}
	}
}
