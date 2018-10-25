#include<sys/types.h>
#include<sys/stat.h>
#include<stdio.h>
int main(){
    int x=mkdir("dir4test",S_IRUSR|S_IWUSR|S_IXUSR);
    if(x==0) printf("create successfully\n");
    else printf("create failed\n");
    return 0;
}

