#include<netdb.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<sys/socket.h>
#include<sys/types.h>
#include<arpa/inet.h>
#include<netinet/in.h>
#include<sys/ioctl.h>
#define MAXLINE 1024
#define PORT 8080
int main()
{
	int sockfd,n;
	//char buffer[MAXLINE];
	int bs,hra,da,pt,epf;
        struct sockaddr_in servaddr;
	sockfd=socket(AF_INET,SOCK_STREAM,0);
	bzero(&servaddr,sizeof(servaddr));
	servaddr.sin_port=htons(PORT);
	servaddr.sin_family=AF_INET;
	servaddr.sin_addr.s_addr=inet_addr("127.0.0.1");
	connect(sockfd,(struct sockaddr*)&servaddr,sizeof(servaddr));
	//while(1){
		//bzero(buffer,sizeof(buffer));
		//n=0;
		printf("Enter the basic salary\n");
		//fgets(buffer,MAXLINE,stdin);
		scanf("%d",&bs);
                write(sockfd,&bs,sizeof(bs));
                printf("Enter the hra\n");
		scanf("%d",&hra);
                write(sockfd,&hra,sizeof(hra));
		printf("Enter the da\n");
		scanf("%d",&da);
                write(sockfd,&da,sizeof(da));
		printf("Enter the pt\n");
		scanf("%d",&pt);
                write(sockfd,&pt,sizeof(pt));
		printf("Enter the epf\n");
		scanf("%d",&epf);
                write(sockfd,&epf,sizeof(epf));
		
		printf("Salary details sent to server\n");
	/*	if((strncmp("exit",buffer,4))==0){
			printf("Communication terminated\n");
			break;
		}
	}*/
	close(sockfd);
}
