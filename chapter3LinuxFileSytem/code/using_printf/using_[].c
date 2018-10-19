#include<stdio.h>
int main(){
    char x[100];
    char y[100];
    char z[100];
    printf("scanf(\" %%[,]\",x)\n");
    scanf("%[,]",x);
    printf("scanf(\" %%[^,]\",y)\n");
    scanf("%[^,]",y);
    printf("scanf(\" %%[A-Z]\",z)\n");
    scanf("%[A-Z]",z);
    printf("x is %s\ny is %s\nz is %s\n",x,y,z);
    return 0;
}
