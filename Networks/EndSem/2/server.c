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
	int sockfd,connfd,len;
        int bs,hra,da,pt,epf,net_total=0;
	struct sockaddr_in servaddr,cliaddr;
	bzero(&servaddr,sizeof(servaddr));
	bzero(&servaddr,sizeof(servaddr));
	sockfd=socket(AF_INET,SOCK_STREAM,0);
	servaddr.sin_family=AF_INET;
	servaddr.sin_port=htons(PORT);
	servaddr.sin_addr.s_addr=htonl(INADDR_ANY);
	bind(sockfd,(struct sockaddr*)&servaddr,sizeof(servaddr));
	listen(sockfd,2);
	len=sizeof(cliaddr);
	while(1)
	{
		connfd=accept(sockfd,(struct sockaddr*)&cliaddr,&len);
		read(connfd,&bs,sizeof(bs));
                read(connfd,&hra,sizeof(hra));
		read(connfd,&da,sizeof(da));
		read(connfd,&pt,sizeof(pt));
		read(connfd,&epf,sizeof(epf));
                net_total=bs+hra+da-pt-epf;
		printf("Net salary: %d\n",net_total);
		close(connfd);
		sleep(2);
	}
}
