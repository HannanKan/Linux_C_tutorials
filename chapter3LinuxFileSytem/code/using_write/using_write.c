#include<unistd.h>
#include<stdlib.h>
//size_t  write(int fildes,const void *buf,size_t nbytes);
int main(){
    if ((write(1,"here is some data\n",18))!=18)
        write(2,"a write error has occurred on file descriptor 1\n",46);
    exit(0);
}
