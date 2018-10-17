#include<stdio.h>
#include<stdlib.h>
int main(){
    FILE* file=fopen("test.txt","r+");
    long lSize;
    char* buffer;
    size_t result;
    if(file==NULL) {
        fputs("File error",stderr);
        exit(1);
    }
    //obstain file size;
    fseek(file,0,SEEK_END);
    lSize=ftell(file);
    rewind(file);

    //allocate memory to contain the whole file
    buffer= (char*) malloc(sizeof(char)*lSize);
    if(buffer==NULL) {
        fputs("Memory error",stderr);
        exit(2);
    }

    //copy the file into the buffer
    result=fread(buffer,1,lSize,file);
    if(result!=lSize) {
        fputs("Reading error",stderr);
        exit(3);
    }else{
        printf("%s",buffer);
    }

    /*the whole file is now loaded in the memory buffer*/

    //terminate

    fclose(file);
    free(buffer);
    return 0;
}
