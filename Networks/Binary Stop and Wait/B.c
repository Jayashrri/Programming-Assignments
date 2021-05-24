#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>

struct frame{
	int type;
	int sno;
	int data;
};

int createTCP(int port, struct sockaddr_in *serverAddr){
	int TCPSocket = socket(AF_INET, SOCK_STREAM, 0);
	
	serverAddr->sin_addr.s_addr = htonl(INADDR_ANY);
	serverAddr->sin_family = AF_INET;
	serverAddr->sin_port = htons(port);
	
	bind(TCPSocket, (struct sockaddr *)serverAddr, sizeof(struct sockaddr_in));
	listen(TCPSocket, 3);
	return TCPSocket;
}

int createUDP(int port, struct sockaddr_in *serverAddr){
	int UDPSocket = socket(AF_INET, SOCK_DGRAM, 0);
	
	serverAddr->sin_addr.s_addr = htonl(INADDR_ANY);
	serverAddr->sin_family = AF_INET;
	serverAddr->sin_port = htons(port);
	
	bind(UDPSocket, (struct sockaddr *)serverAddr, sizeof(struct sockaddr_in));
	return UDPSocket;
}
	
int recvTCP(int TCPSocket, struct sockaddr_in *serverAddr){
	while(1){
		int addr_size = sizeof(struct sockaddr_in);
		int TCPClient;
		
		TCPClient = accept(TCPSocket, (struct sockaddr *)serverAddr, (socklen_t *)&addr_size);
	
		struct frame sent;
		struct frame received;
		
		recv(TCPClient, &received, sizeof(struct frame), 0);
		
		printf("Packet %d received: %d\n", received.sno, received.data);
		
		sent.sno = received.sno;
		sent.type = 1;
		
		send(TCPClient, &sent, sizeof(struct frame), 0);
		printf("ACK %d sent\n", sent.sno);
		
		close(TCPClient);
	}
	
	return 1;
}

int recvUDP(int UDPSocket, struct sockaddr_in *serverAddr){
	while(1){
		struct frame sent;
		struct frame received;
		
		int addr_size = sizeof(struct sockaddr_in);
		recvfrom(UDPSocket, &received, sizeof(struct frame), 0 ,(struct sockaddr*)serverAddr, &addr_size);
		
		printf("Packet %d received: %d\n", received.sno, received.data);
		
		sent.sno = received.sno;
		sent.type = 1;
		
		sendto(UDPSocket, &sent, sizeof(struct frame), 0, (struct sockaddr *)serverAddr, sizeof(struct sockaddr_in));
		printf("ACK %d sent\n", sent.sno);
	}
	
	return 1;
}

int main(int argc, char *argv[]){
	if (argc != 3){
		printf("Usage: %s <Port> <Protocol>\n", argv[0]);
		printf("Protocol: 1 - TCP, 2 - UDP\n");
		exit(0);	
	}
	
	int port = atoi(argv[1]);
	int protocol = atoi(argv[2]);
	
	struct sockaddr_in serverAddr;
	
	if(protocol == 1){
		int TCPSocket = createTCP(port, &serverAddr);
		recvTCP(TCPSocket, &serverAddr);
	} else {
		int UDPSocket = createUDP(port, &serverAddr);
		recvUDP(UDPSocket, &serverAddr);
	}
	
	return 0;
}
