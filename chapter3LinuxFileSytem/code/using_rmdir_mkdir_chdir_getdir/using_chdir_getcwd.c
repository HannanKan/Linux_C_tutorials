#include<unistd.h>
#include<stdio.h>
int main(){

    char path[1000];
    getcwd(path,1000);
    printf("current work dir is %s\n",path);
    chdir("dir4test");
    getcwd(path,1000);
    printf("after chdir() sys call, current directory is %s\n",path);
    chdir("..");
    getcwd(path,1000);
    printf("after chidr, cwd is %s\n",path);
    return 0;
}
