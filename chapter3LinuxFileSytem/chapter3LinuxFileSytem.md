# chapter 3 linux 文件系统
### 代码请看过来
[github欢迎点个 star](https://github.com/HannanKan/Linux_C_tutorials/tree/master/chapter3LinuxFileSytem)

## 文件结构
1. 5大基本函数：open close read write ioctl
2. 常用文件目录：
    1. / 根目录
    2. /bin 系统程序的可执行文件
    3. /etc 系统配置文件
    4. /lib 系统函数库
    5. /dev 物理设备以及设备借口
3. 重要的设备文件
    1. /dev/console 系统控制台
    2. /dev/tty /dev/tty0 /dev/tty1 ... 进程的控制终端,/dev/tty 是当前的shell
    ```bash
    echo “xxx” > /dev/tty ##将显示在当前的shell中
    ``` 
    3. /dev/null 是空设备，所有写向这个设备的输出都会被丢弃,读取这个设备会立即返回一个文件结尾标志
    ```bash
    cp /dev/null empty_file.txt ##复制空文件
    ```

## 系统调用和设备驱动程序
> 操作系统的核心部分，即内核，是一组<b>设备驱动程序</b>. 它们是一组对系统硬件进行控制的底层借口.

open: 打开文件或设备
read：从文件或设备里读数据
write：向文件或设备里写数据
close：关闭文件或设备
ioctl：把控制信息传递给设备驱动信息 

## 库函数
1. 针对输入输出操作直接使用底层的系统调用，使得效率十分低：内核切换+数据读取限制
2. 使用标准库函数

文件、用户、内核、硬件、驱动关系
关系图
![关系图](./UserDriverKernelHardware.png)

## 底层文件的访问
1. 进程自带3个文件描述符：0-标准输入，1-标准输出，2-标准错误
### write 系统调用
头文件#include<unistd.h>
size_t write(int fildes,const void *buf ,size_t nbytes);
1. 将缓冲区buf的钱nbytes写入与文件描述符fildes 相关的文件种，返回实际写入的字节数目，遇到错误或其他原因，返回值小于nbytes。
2. 返回0表示没有写入
3. 返回-1 表示调用出错，，错误代码保存在全局变量errno里面
4. 标准输入、标准输出、标准错误在程序退出时会自动关闭，不用明确关闭，而在处理缓冲文件时则要显示声明关闭
5. 返回的字节少于期望字节不一定是错误，需要检查 errno来发现错误，然后继续调用写入剩余数据

### read 系统调用
头文件\#include<unistd.h>
size_t read(int fildes,void*buf,size_t nybtes);
1. 从fildes 读取nbytes个字节到buf中，返回读取字节数
2. 返回0表示没有读取字节，已达到文件末尾
3. 返回-1 表示调用出现错误
4. 可以通过重定向、管道为程序提供输入
```bash
echo hello there | ./using_read
./using_read < draft1.txt
```

### open() 系统调用
头文件：
\#include<fcntl.h>
\#include<sys/types.h>
\#include<sys/stat.h>

int open(const char *path,int oflags);
int open(const char *path, int oflags,mode_t mode);

1. 得到唯一的文件描述符,不会和其他进程共享
2. 两个进程同时操作一个文件，将会相互覆盖，需要提供文件锁来防止
3. oflags是指定文件访问模式

|文件访问模式|说明|
|------|------|
|O_RDONLY|以只读方式打开|
|O_WRONLY|以只写方式打开|
|O_RDWR|以读写方式打开|

|文件访问可选模式oflags|说明|
|------|------|
|O_APPEND|把写入数据追加在文件末尾|
|O_TRUNC|丢弃已有内容|
|O_CREAT|如有需要，按mode进行创建|
|O_EXCL|与O_CREAT一起确保不会创建出同名文件|

使用O_CTEAT标志的的open调用来创建文件，使用三个参数的open调用，第三个参数mode几个标志按位或后得到的，标志在sys/stat.h中定义
访问权限初始值
|标志|含义|
|------|-------|
|S_IRUSR|开启文件拥有者执行权限|
|S_IWUSR|开启文件拥有者写权限|
|S_IXUSR|开启文件拥有者执行权限|
|S_IRGRP|开启文件所属用户组读权限|
|S_IWGRP|开启文件所属用户组写权限|
|S_IXGRP|开启文件所属用户组执行权限|
|S_IROTH|开启文件其他用户读权限|
|S_IWOTH|开启文件其他用户写权限|
|S_IXOTH|开启文件其他用户执行权限|

例子：
```C
//文件拥有者拥有读权限，非用户非群组用户拥有执行权限
open("myfile",O_CREAT,S_IRUSR|S_IXOTH);
```

4. umask: 当文件被创建时，为文件的访问权限设定一个掩码。如果在umask中被置位，那么即便被创建时设定了该权限，最终也不会有该权限。但是用户可以用chmod进行改变权限
用法见书

### close() 系统调用
```c
#include<unistd.h>
int close(int fildes);
```
终止 文件描述符 fildes和 文件之间的关联关系
调用成功返回0，失败返回-1
<b>检查close()返回码，因为，有些网络文件系统的错误只有在关闭文件时才会被确认</b>

### ioctl() 系统调用
控制设备及其描述行为和配置底层服务的借口
```c
#include<unistd.h>
int ioctl(int fildes,int cmd,...);
```
对描述符引用的对象执行cmd参数中给出的操作，

### \#include<unistd.h> 必须放在行首，与POSIX标准有关，可能会影响到其他头文件

### 其他文件读写的系统调用
#### lseek()系统调用
头文件：
    \#include<unistd.h>
    \#include<sys/types.h>
格式
off_t lseek(int fildes,off_t offset, int whence);
返回值：正确时，返回被设置后的指针相对于文件开头的偏移量；失败时，返回-1
offset: 指定位置
whence：指定偏移用法，
|取值|含义|
|------|------|
|SEEK_SET|绝对位置|
|SEEK_CUR|相对当前的偏移位置|
|SEEK_END|相对文件尾的相对位置|

#### fstat(),stat(),lstat() 系统调用
函数原型
```c
#include<unistd.h>
#include<sys/stat.h>
#include<sys/types.h>
//buf 存储返回信息
int fstat(int fildes,struct stat *buf);
int stat(const char*path,struct stat *buf);
int lstat(const char*path,struct stat*buf);
```
stat()和lstat() 是通过文件名返回文件信息，但是当文件一个符号链接时，lstat() 返回符号链接本身信息，stat()返回符号链接指向的文件的信息
<b>通过struct stat *buf 查看文件信息</b>
具体使用方法参考书和实例代码

#### dup 和dup2系统调用
```c
#include<unistd.h>
int dup(int fildes); // 返回指向同一个文件的文件描述符
int dup(int fildes,int fildes2); //将fildes 复制到fildes2 
```

## 标准I/O 库
头文件
```c
#include<stdio.h>
```
### fopen()
```c
#include<stdio.h>
//成功返回一个 FILE* 指针，失败返回NULL值
FILE* fopen(const char* filename, const char* mode);
// mode 是字符串，而不是字符
```
1. mode中 b代表二进制文件
2. r+ 和w+ 都代表可读可写，但是w+会将原文件内容清空，r+不会；r+返回文件开头的指针，a+返回文件结尾指针。mode具体细节请参考[这里](https://www.cnblogs.com/kangjianwei101/p/5220021.html)

### rewind(FILE* fptr)
```c
#include<stdio.h>
FILE* fptr=open("filename","r");
//move fptr
rewind(fptr); //reset fptr to the beginning of file
```

### ftell(FILE* fptr);
```c
#include<stdio.h>
FILE* fptr=open("filename","r");
fseek(fptr,0,SEEK_END); //set fptr to be the end of file
long lsize=ftell(fptr);//返回fptr相对于文件开头的位移
rewind(fptr);
fclose(fptr);
```

### fread(), fwrite(),fclose()
```c
size_t fread(void *ptr,size_t size,size_t nitem,FILE*stream);//从stream文件指针处，读取nitem个 size字节长的数据记录，放到ptr处

size_t fwrite(const viod*ptr, size_t size, size_t nitems, FILE* stream);
//从ptr指针处读取nitem个 size 长的数据记录到stream处

int fclose(FILE* stream);
```

### int fflush(FIle* fptr)
将文件流中还未来得及写到文件的数据全部写出
fclose(ftpr) 会隐性调用fflush()，所以不用额外调用

### fseek()
```c
int fseek(FILE* STREAM, long int offset, int whence);
//对应lseek(),成功返回0，失败返回-1，失败时设置errno指出错误
```

### fgetc(), getc(),getchar()
```c
#include<stdio.h>
//下面两个函数用处相同
//从文件流读出下一个字符并返回， 如果到达文件结尾或者发生错误，返回EOF，需要通过ferror 或者 feof来区分
int fgetc(FILE* stream);
int getc(FILE* STREAM);
//从标准输入中读取一个字符并返回
int getchar();

```
### fputc() putc() putchar()
```c
#include<stdio.h>
// 以下两个函数功能相同，把一个字符写入到文件流，如果失败，返回EOF
int fputc(int c ,FILE* STREAM);
int putc(int c, FILE* stream);
//将字符输出到标准输出
int putchar(int c)
```

### fgets() 和 gets()函数
```c
#include<stdio.h>
char* fgets(char* s,int n,FILE*stream);
char* gets(char*s);
```
char* fgets(char*s,int n,FILE\* stream);
把从文件中读到的字符写到s指向的字符串中，，直到遇到以下情况之一：
1. 遇到换行符
2. 已经传递了n-1个字符
3. 达到文件尾部
fgets()会把换行符也放到s中，再加上一个\0,一次最多传递n-1个字符
返回s指针，如果stream读到文件结尾，或者遇到错误，返回EOF，遇到错误时候，会设置errno

gets() 从标准输入读取，放到s中，丢弃遇到的换行符，在接收到的字符串后面加\0
> 由于gets() 对输入的长度没有限制，因此可能存在缓冲区溢出的问题


## 格式化输入和输出
```c
#include<stdio.h>
int printf(const char* format,...); //// 输出到标准输出，返回输出字符个数
int sprintf(char* s,const char* format,...); /// 输出到字符串 s，在结尾加上 \0,注意s长度
int fprintf(FILE* stream, const char* format,...); /// 输出到文件stream
```
### 格式控制符
|格式控制符|含义|助记|
|-----|------|------|
|%d 或者 %i |十进制输出整数|decimal，int|
|%hd|十进制输出 short int||
|%ld|十进制输出 长整数|long double|
|%o |八进制输出整数|Octal|
|%x| 十六进制输出整数|hex|
|%c|一个字符|character|
|%s|字符串|string|
|%f|单进度浮点数|float|
|%e|科学计数法输出 双进度| |
|%g 或者 %lf|通用格式输出双进度| giant, long float|
|%10s|右对齐输出10个长度的字符串，不够补空格，超过10个不会截断|
|%-10s|左对齐输出10个长度字符串，空格来补，超过10个不会截断|
|%10d 或者%-10d|同上|
|%010d|存在空格就在前面补0|
|%10.4f|总共长度为10,4位小数，一个小数点|
|%%|输出一个%|

如果使用gcc 进行编译， 加 -Wformat 进行警告

### 格式化输入与格式化输出类似
```c
#include<stdio.h>
scanf(const char* format,...);
sscanf(char* s,const char* format,...);
fscanf(FILE* stream, const char* format,...);

// 使用实例
int num;
char s[100];
scanf("hello %d",&num);//&num 需要变量地址，而非变量
scanf("hello %s",s);
```
scanf 中特别的控制
%[],读取一个字符集合
```c
scanf("%[,]",&s);//只能读取 含 逗号的字符串
scanf("%[^,]",&s);//只能读取逗号以外的所有字符
scanf("%[A-Z]",&S);//只能读取由大写字母组成的字符串
```
scanf 广受diss，因为安全性以及可理解性很低，一般用fread和fgets替代。
分析一波scanf() 奇葩用法：
```c
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
```
键盘输入（行末回车用\n表示）：
```bash
,,,,\n
afada,ABCD
FALDFK
```
那么x，y，z分别时什么呢？
x=",,,,"
y="\nafada"
z=""
why？
x容易理解，y由于只是不读入逗号，所以会读入上一行的回车，遇到第二行的逗号之后结束（注意，此时逗号并没有被抛弃，而是留在了缓冲区），z读取时遇到逗号自然结束并且为空。
事实上，在这里，z永远为空。why：因为y输入以遇到逗号结束，否则y会一直读取，而当遇到逗号之后y不会读取，逗号会被z读取，而z只能读取A-Z，因此z为空

### 其他流函数
fgetpos(): 获取当前流读/写位置
fsetpos()：设置当前流读/写位置
freopen(): 重新使用一个文件流
setvbuf(): 设置文件流的缓冲机制

### 查看c代码执行时间

```bash
TIMEFORMAT="" time ./executable
```

###文件流错误
```c
#include<errno.h>
extern int errno;
int ferror(FILE* stream);//文件流发生错误时，返回非零值
int feof(FILE*stream);//文件指针到达末尾时，返回非零值，否则返回0
void clearerr(FILE*stream);//清除原有的errno

if(feof(stream))
    // we are at the end
```

### 文件描述符，和文件流
文件描述符属于底层概念，文件流属于高层（库）概念。由于缓存机制，最好两者不要混用
```c
#include<stdio.h>
int fileno(FILE* stream);//返回stream对应的文件描述符
FILE* fdopen(int fildes,const char*mode);//利用一个已经打开的文件描述符创建一个新的文件流，提供stdio的缓冲区
```

```c
printf("如果对您有用，欢迎随手点个赞");
```