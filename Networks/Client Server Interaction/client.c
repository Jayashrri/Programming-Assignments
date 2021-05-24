#include<stdio.h>
#include<stdlib.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<arpa/inet.h> 
#include<unistd.h> 
#include<string.h> 

#define PORT 8000

int main(){
	int socketfd;
	if( (socketfd = socket(AF_INET, SOCK_STREAM, 0)) < 0){
		perror("Socket creation failed.");
		exit(1);
	}
	
	struct sockaddr_in saddr;
	saddr.sin_family = AF_INET;
	saddr.sin_port = htons(PORT);
	
	int addrlen = sizeof(saddr);
	
	if( inet_pton(AF_INET, "127.0.0.1", &saddr.sin_addr) <= 0){
		perror("Socket addressing failed.");
		exit(1);
	}
	
	if( connect(socketfd, (struct sockaddr *) &saddr, sizeof(saddr)) < 0){
		perror("Socket connect failed.");
		exit(1);
	}
	
	char *message = "Hello";
	send(socketfd, message, strlen(message), 0);
	printf("Message sent\n");
	
	char buffer[1024] = "";
	read(socketfd, buffer, 1024);
	printf("Message received: %s\n", buffer);
		
	return 0;
}
