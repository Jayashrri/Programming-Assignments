#include<stdio.h>
#include<stdlib.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h> 
#include<unistd.h> 
#include<string.h> 

#define PORT 8000

void sm(char *message, int clientfd){
	send(clientfd, message, strlen(message), 0);
	printf("Message sent\n");
}

void rm(char buffer[1024], int clientfd){
	read(clientfd, buffer, 1024);
	printf("Message received: %s\n", buffer);
}

int main(){
	int socketfd, opt = 1;
	if( (socketfd = socket(AF_INET, SOCK_STREAM, 0)) == 0){
		perror("Socket creation failed.");
		exit(1);
	}
	
	if( setsockopt(socketfd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &opt, sizeof(opt)) ){
		perror("Socket options failed.");
		exit(1);
	}
	
	struct sockaddr_in saddr;
	saddr.sin_family = AF_INET;
	saddr.sin_addr.s_addr = INADDR_ANY; 
	saddr.sin_port = htons(PORT);
	int addrlen = sizeof(saddr);
	
	if( bind(socketfd, (struct sockaddr *) &saddr, addrlen) < 0){
		perror("Socket bind failed.");
		exit(1);
	}
	
	if( listen(socketfd, 5) < 0){
		perror("Socket listen failed.");
		exit(1);
	}
	
	int clientfd;
	if( (clientfd = accept(socketfd, (struct sockaddr *) &saddr, (socklen_t *) &addrlen)) < 0){
		perror("Socket accept failed.");
		exit(1);
	}
	
	char buffer[1024] = "";
	rm(buffer, clientfd);
	
	char *message = "Welcome";
	sm(message, clientfd);
	
	close(socketfd);
	
	return 0;
}
