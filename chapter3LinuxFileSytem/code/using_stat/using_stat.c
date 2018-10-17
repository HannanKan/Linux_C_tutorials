#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<stdio.h>
#include<stdlib.h>
int main(){
    struct stat statbuf;
    mode_t modes;
    stat("file_fortest.txt",&statbuf);
    modes=statbuf.st_mode;
    if(!S_ISDIR(modes))
        printf("this file is not a directory\n");
    else
        printf("this file is directory\n");
    if((modes & S_IRWXU)==S_IXUSR)
        printf("this file can be eXecuted by user\n");
    else printf("this file cannot be eXecuted by user\n");

    if((modes&S_IRWXU)==(S_IRUSR|S_IWUSR))
        printf("file can be written and read by user\n");
    else printf("this file cannot be written or read by user\n");
    
    printf("%lu linkage to this file\n",statbuf.st_nlink);
    exit(0);
}
