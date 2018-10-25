#include<unistd.h>
#include<stdio.h>
int main(){
    FILE* f=fopen("file4test","w+");
    if(f!=NULL){
        int x=link("file4test","file4test.link");
        int y=symlink("file4test","file4test.symlink");
        if(x==0)printf("create link successfully\n");
        else printf("create link failed\n");
        if(y==0)printf("create symlink successfully\n");
        else printf("create symlink failed\n");
    }else{
        printf("cannot create file\n");
    }
    return 0;
}
