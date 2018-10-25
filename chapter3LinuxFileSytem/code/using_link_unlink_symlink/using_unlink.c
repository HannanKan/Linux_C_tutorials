#include<unistd.h>
#include<stdlib.h>
#include<stdio.h>
int main(){
    FILE* f=fopen("file4test","w+");
    if(f==NULL){
        printf("create file fail, exit\n");
        exit(1);
    }
    unlink("file4test.link");
    unlink("file4test.symlink");
    int lx=link("file4test","file4test.link");
    if(lx==-1){
        printf("cannot link\nexit\n");
        exit(1);
    }
    int sx=symlink("file4test","file4test.symlink");
    if(sx==-1){
        printf("cannot symlink\nexit\n");
        exit(1);
    }

    if(f!=NULL){
        int x=unlink("file4test.link");
        int y=unlink("file4test");    
    if(x==-1||y==-1){
        printf("unlink fail\n");
        exit(1);
    }else{
        printf("unlink successfully and you will find symlink invalid\n");
        exit(0);
    }
    }
    return 0;
}
