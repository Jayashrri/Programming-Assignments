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
	
	serverAddr->sin_addr.s_addr = inet_addr("127.0.0.1");
	serverAddr->sin_family = AF_INET;
	serverAddr->sin_port = htons(port);
	
	return TCPSocket;
}

int createUDP(int port, struct sockaddr_in *serverAddr){
	int UDPSocket = socket(AF_INET, SOCK_DGRAM, 0);
	
	serverAddr->sin_addr.s_addr = inet_addr("127.0.0.1");
	serverAddr->sin_family = AF_INET;
	serverAddr->sin_port = htons(port);
	
	return UDPSocket;
}
	
int sendTCP(int port, struct sockaddr_in *serverAddr, int sno, int timeout){
	struct frame sent;
	struct frame received;
	
	printf("Enter data: ");
	scanf("%d", &sent.data);
	
	sent.sno = sno;
	sent.type = 0;
	
	int TCPSocket = createTCP(port, serverAddr);
	
	connect(TCPSocket, (struct sockaddr *)serverAddr, sizeof(struct sockaddr_in));
	
	send(TCPSocket, &sent, sizeof(struct frame), 0);
	printf("Packet %d sent\n", sent.sno);
	
	struct timeval tv;
	tv.tv_sec = timeout;
	tv.tv_usec = 0;
	
	if(setsockopt(TCPSocket, SOL_SOCKET, SO_RCVTIMEO, (char*)&tv, sizeof(tv)) < 0){
		printf("ACK %d not received\n", sent.sno);
		return 0;
	}
	
	recv(TCPSocket, &received, sizeof(struct frame), 0);
	
	if(received.sno != sent.sno){
		printf("ACK %d not received\n", sent.sno);
		return 0;
	}
	
	printf("ACK %d received\n", received.sno);
	close(TCPSocket);
	sleep(1);
	return 1;
}

int sendUDP(int port, struct sockaddr_in *serverAddr, int sno, int timeout){
	struct frame sent;
	struct frame received;
	
	printf("Enter data: ");
	scanf("%d", &sent.data);
	
	sent.sno = sno;
	sent.type = 0;
	
	int UDPSocket = createUDP(port, serverAddr);
	
	sendto(UDPSocket, &sent, sizeof(struct frame), 0, (struct sockaddr *)serverAddr, sizeof(struct sockaddr_in));
	printf("Packet %d sent\n", sent.sno);
	
	struct timeval tv;
	tv.tv_sec = timeout;
	tv.tv_usec = 0;
	
	if(setsockopt(UDPSocket, SOL_SOCKET, SO_RCVTIMEO, (char*)&tv, sizeof(tv)) < 0){
		printf("ACK %d not received - Timed Out\n", sent.sno);
		return 0;
	}
	
	int addr_size = sizeof(struct sockaddr_in);
	recvfrom(UDPSocket, &received, sizeof(struct frame), 0 ,(struct sockaddr*)serverAddr, &addr_size);
	
	if(received.sno != sent.sno){
		printf("ACK %d not received - ACK %d received instead\n", sent.sno, received.sno);
		return 0;
	}
	
	printf("ACK %d received\n", received.sno);
	sleep(1);
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
		int status = 0;
		while(!status) status = sendTCP(port, &serverAddr, 0, 5);
		status = 0;
		while(!status) status = sendTCP(port, &serverAddr, 1, 5);
	} else {
		int status = 0;
		while(!status) status = sendUDP(port, &serverAddr, 0, 5);
		status = 0;
		while(!status) status = sendUDP(port, &serverAddr, 1, 5);
	}
	
	return 0;
}
	

