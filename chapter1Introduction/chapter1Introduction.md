# Introduction
### 代码请看过来
[github欢迎点个 star](https://github.com/HannanKan/Linux_C_tutorials/tree/master/chapter1Introduction)
## Unix, Linux, GNU
...

## Unix's philosophy
1. KISS(keep it small and simple)
2. Concerntrated(one program focuses on one function rather than plenty of functions)
3. Re-usable(make core program a library with detailed documents) </br>
<b>...</b>

## What is Linux
可自由发布的类Unix内核实现，是一个操作系统底层核心

## Linux programming
1. 2 kinds of program: executable, script
2. shell程序（通常是bash)交互：在一组指定的目录路径下按照用户给出的程序名搜索与之同名的文件（当成可执行文件处理），搜索路径存储在shell 变量path中，path可以配置。一些常用的存储系统程序的标准路径：（usr-unix system resources，bin-binary，）
    1. /bin 二进制文件目录，存放系统启动时的程序
    2. /usr/bin 用户二进制文件，存放用户存放的标准程序
    3. /usr/local/bin bending二进制文件，存放软件安装程序
3. / 文件分隔符，
4. 使用冒号（：）分割path里面的文件夹条目
5. 文本编辑器emacs、vim
6. c语言编译器 cc、gcc：gcc -o name file.c  如果忘记-o name 选项，会生成 a.out 文件，a.out->assembler output（汇编输出）。 一些Unix系统会定期删除所有名为a.out 的文件

## Important directories and files
1. 应用程序
    1. 系统常用的程序如 echo/python 等系统自带常用程序都在/usr/bin中,这里程序也可能是一个link
    2. <b>自己安装的系统级程序存放在/opt或者 /usr/local 目录下</b>，其他放在家目录下
2. 头文件and 库文件
    1. <b>头文件</b>与<b>库文件</b>区别联系：头文件提供对常量的定义、对系统函数和库函数（调用）<b>声明</b>，库文件是一组预先编译好的函数集合<b>（定义）</b>。库文件一般以二进制形式提供给用户，而不是源码。[参考链接点这里](https://zhidao.baidu.com/question/179038902.html)
    2. 标准头文件在目录/usr/include 目录下
    3. -I  选项来指定非标准头文件位置（大写的i）： gcc -I/usr/openwin/include fred.c  在/usr/openwin/include 目录种查找程序fred.c 中包含的头文件。
    4. 标准库文件在/lib 和/usr/lib 目录中，c语言编译器/链接器 默认只会所有c语言库。库文件必须尊姓特定的命名规范并且需要在命令行中明确指定。
        1. 库文件名字以lib开头，后面部分指定是什么库，如libm.a 是静态数学库
        2. 库文件类型：
            1. .a 代表传统的静态函数库，
            2. .so 代表共享函数库
        3. 使用库文件的三种方法
            1. gcc -o fred fred.c /usr/lib/libm.a  编译fred.c 文件，并且使用静态函数库 /usr/lib/libm.a
            2. gcc -o fred fred.c -lm  (在字母l和m之间没有空格)，表示在标准库目录中（/usr/lib)引用名为libm.a 的函数库。 默认情况下，优先使用共享库，比如同时存在 libm.a 和libm.so 该命令会优先选择libm.so
            3. gcc -o x11fred -L/usr/openwin/lib x11fred.c -lX11  其中-L 标志添加库的搜索路径， -lX11 指明在标准库以及添加的库下面选择 libX11.a 或者 libX11.so 的共享库文件
    5. 静态库
        1. 当程序需要使用函数库种的某个函数时，它包含一个声明该函数的头文件。编译器和链接器负责将程序代码和函数库结合在一起以组成一个单独的可执行文件。必须使用 -l(小写的L)选项指明除标准C语言运行库外还需要使用的库
        2. 静态库，也叫归档文件(archive),以.a 结尾
        3. 制作静态库
            1. 编写 库文件的源文件（不包含main函数）：fred.c, bill.c
            2. 编写头文件:声明库文件中对外的接口函数
            3. 将头文件 #include“” 到所有相关库文件
            4. 头文件包含到调用程序program.c中 #include"libx.h"
            5. gcc -c program.c fred.c bill.c  (-c选项只编译，不链接，因此可以没有main函数)
            6. 测试库函数， gcc -o program program.o bill.o  （利用所有相关的目标文件生成可执行文件）。./program  测试库函数是否正确
            7. 制作静态库： ar crv libfoo.a bill.o fred.o (将所有的目标文件放到静态库libfoo.a中)
            8. 为库函数生成一个内容表： ranlib libfoo.a 
            9. 使用库函数的三种方法见之前
        4. 几个重要的参数 -I -l -L
    6. 动态库
        1. 运行ldd 来查看一个程序需要的共享库
        2. libc.so.N N指定版本号
3. 帮助 man、info
    1. man gcc
    2. info gcc


```c
printf("如果对您有用，欢迎随手点个赞");
```

