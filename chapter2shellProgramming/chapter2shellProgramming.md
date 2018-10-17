# Shell Programming
## 代码请看过来
[github欢迎点个 star](https://github.com/HannanKan/Linux_C_tutorials/tree/master/chapter2shellProgramming)

## What is shell
用户与Linux 系统间接口的程序，允许用户向操作系统输入需要执行的命令

###各种shell程序：
sh
csh,tcsh,zsh
ksh,pdksh
bash
### 使用哲学
1. 多个bash命令组合使用
2. 如果需要优化则需要自己重新实现


## 管道和重定向
1. 文件描述符0代表程序的标准输入，1代表程序的标准输出，2 代表标准错误输出
2.  \> 是重定向的符号，如 ls -l > output.txt  将内容重定向到output.txt中， 如果output.txt 已存在，那么将文件覆盖
3.  \>> 以追加的方式重定向。
4.  kill 1234 >killout.txt 2>killerr.txt 将标准错误输出重定向到killerr.txt中。
5.  kill 1234 > killout.txt 2>&1 将标准错误输出输出到与文件描述符1相同的输出地方(>& 是一个整体)
6.  使用/dev/null 通用回收站来丢弃所有输出信息 kill 1234 >/dev/null 2>&1
7. 使用管道操作符（|）来连接进程，命令执行的顺序时从左到右的，如： ps -xo comm|sort|uniq|grep -v sh|more  &nbsp; &nbsp; &nbsp;该命令用来查询所有进程，并按照字母顺序进行排序，去除名字相同的进程，去除名字为sh的进程，并且以分页的形式显示
8. 同一行命令中，同一个文件不能被既写又读，这种情况下会返回空文件（在读取文件之前该文件被覆盖了）

## 作为程序设计语言的shell
``` bash
#!/bin/bash

#first
#This file looks through all the files in the current 
#directory for the string POSIX, and then prints the 
#names of those files to the standard output
for file in *
do
    if grep -q POSIX &file
    then
        echo $file
    fi
done
exit 0
```
1. \# 单行注释
2. #！ 用来提示系统 紧跟其的使用来执行脚本的程序，如#!/bin/bash 告诉系统， /bin/bash 来执行当前程序
3. 设置合理的退出码：以便于其他程序查看当前脚本是否成功执行，或者被其他程序调用—— 0代表成功（错误为0）
4. file 文件名  可以用来查看文件类型
5. 编写完成bash文件，chmod +x first.sh 将bash文件设为可执行

## shell 语法
### 变量
1. 直接使用，不需定义
2. shell程序种所有的变量都被看成时字符串，如果要看成数值，需要手动转换
3. 区分大小写
4. ```bash 
    var=hello world ##var变量名可以用于赋值
    echo $var       ## 显示var内容需要$
    var=7+5
    echo $var       ##显示 7+5 一切皆为字符串
    ```
5. 等号（=）两边不能有空格， 字符串内不能有空格（如果有就用“” 括起来）。bash 用空白字符作为分隔符
6. ```bash
    read var ## 终端等待输入
    ## 输入：hello world
    echo $var   #终端显示 hello world
    ```
7. 单引号与双引号作用不同
    1. 单引号仅仅用来扩住字符串，防止因为空格存在而被分割。
    2. 双引号具有单引号的功能，同时 （$变量）在双引号中会被扩展成变量内容

### 环境变量
|环境变量|意思|
| ------ |------|
|$HOME|当前用户的家目录|
|$PATH|冒号分割的默认搜索目录|
|$PS1|命令提示符，一般是$|
|$IFS|输入域分隔符，通常是空格、制表符、换行符|
|$0|脚本的名字|
|$1|第一个参数内容|
|$#|传递给脚本的参数个数|
|$$|脚本的进程号|
|$*|以IFS中第一个字符作为分隔符，输出所有的参数|
|$@|所有参数分开输出|

### 条件
test或者[ ] 命令<br>
``` bash
if test -d .. ## test -d .. 就是条件
then 
    echo true
fi
```
或者也可以这样写
```bash
if [ -d .. ] ## 注意[的后面要有空格，]的前面也要有空格
then
    echo true
fi
```
test命令可以使用的条件类型包括：字符串比较，算术比较，文件有关的条件测试<br>
#### 字符串比较
|字符串比较|结果|
|------|------|
|string1=string2|相等为真|
|string1!=string2|不等为真|
|-n string|不为空时为真|
|-z string|为空时为真|

#### 算术比较
|算术比较|结果|
|------|------|
|expr1 -eq expr2|等于|
|expr1 -ne expr2|不等于|
|expr1 -gt expr2|大于|
|expr1 -ge expr2|大于等于|
|expr1 -lt expr2|小于|
|expr1 -le expr2|小于等于|
|! expr1|原表达式为假时，为真|

#### 文件测试
|文件测试|结果|
|------|------|
|-d file|file是目录时，为真|
|-e file|file存在时，为真|
|-f file|普通文件，为真|
|-g file|文件的set-group-id位被设置为真|
|-r file|可读时为真|
|-s file|文件大小不为0，为真|
|-u file|文件的set-user-id 被设置，为真|
|-w file|可写，为真|
|-x file|可执行，为真|
<br><br><br>
### 控制结构
#### if 语句
```bash
    if condition
    then
        statement
    elif
        statement
    else
        statement
    fi
```
#### 一个与变量有关的问题
```bash
    read var
    if test $var='yes';then
        echo yes
    else
        echo no
    fi
```
如果直接回车，使得var为空变量，这时 test 后面表达式不合法，所以一个更加robust 写法是 
```bash 
test "$var"='yes' 
```

#### for 循环
``` bash
#!/bin/bash
for variable in values;do
    statements
done

## 实例
for file in $(ls f*.sh);do
    lpr $file
done
exit 0
```
$(command) 返回所有结果，for循环遍历所有结果

#### while循环
```bash
    while condition do
        statements
    done
    ##例子
    while [ "$trythis" != "secrete" ];do
        echo "sorry, try again"
        read trythis
    done
    exit 0
```

#### until 循环
```bash
until conditon
do
    statements
done
```
符合条件就不执行了

#### case 语句
示例程序
```bash
    #!/bin/bash
    case variable in
        pattern [| pattern]...) statements;;
        patern [|pattern]...) statements;; ## )是必选的的，每个判定条件可以有多个 condition
    esac

```
实验程序
```bash
#!/bin/bash
echo "Is it morning ? Please answer yes or no"
read timeofday
case "$timeofday" in 
    [Yy]|[Yy][eE][Ss] ) 
        echo "Good morning"
        echo "Up bright and early this morning"
        ;;
    [nN]*)
        echo "Good Afternoo"
        ;;
    *)
        echo "Sorry,answer not recognized"
        echo "PLease answer yes or no"
        exit 1
        ;;
esac

exit 0
```
注释：
1. 精确的匹配放在前面，模糊的匹配放在后面
2. 靠近esac的最后一个;; 可以省略

#### 命令列表
可以用嵌套的if 语句判定多个条件，但为了简化，可以用 AND列表和OR列表。

##### AND列表
``` bash
statement1 && statement2 && statement3 && ...
```
1. 从左到右执行，短路执行
2. echo 命令总是返回true
3. 使用echo 命令定位那个判定条件错误如：[ -f file_one ] && echo "statement1 true" && statement2 && ...

##### OR 列表
```bash
statement1 || statement2 || ...
```
1. 短路执行，当前命令为真之后，后面的命令不会被执行

##### AND OR 经典用法
[ -f file_one ] && command for true || command for false  判定条件是否正确，并输出结果

### 函数
> 在一个脚本中调用函数比调用另一个脚本更加快捷
函数定义格式
```bash
function_name(){
    statements
}
```
1. 函数返回值：如果有return 语句，那么执行的return语句就是返回值，如果没有return 语句（return 命令返回的是数字值），那么 函数执行的最后一条语句的返回值就是函数的返回值
2. 返回值：
    1. 声明一个全局变量，将函数结果存在全局变量中
    2. 将结果存在一个局部变量part中，最后echo \$part， 调用函数的时候捕获结果。 x="$(foo)"即可
3. local 关键字在函数中定义局部变量
4. 函数调用： 函数名 参数1 参数2 参数3
5. 在函数内部，\$*,\$@, \$# , \$1,\$2 将变成函数参数

### 命令
1. break 跳出循环
2.  冒号（：） 是一条空命令
3.  continue命令， 类似C语言
4.  点命令( . ) 将脚本在当前shell 下执行：通常在shell 中执行脚本的时候，shell 会fork出一个子shell去执行脚本，然后将结果返回给调用脚本的shell(父shell) 中间结果不会被保存， 点命令 则是强行是 脚本在当前shell 下执行。以chapter2shellProgramming/code/using_dot_command 为例，当执行
```bash
./classic_version
```
的时候，命令行提示符并没有改变，理由是：当前的shell调用子shell运行脚本，改变了子shell命令行提示符，当shell执行完毕，子shell被丢弃，回到父shell，所以命令行提示符没有变。
当执行
```bash
. ./classic_version   ##第一个点时点命令，第二个指示当前目录，中间空格
```
此时会改变当前命令行提示符，因为第一个点号强迫shell脚本在当前shell下执行
5. echo 命令：默认换行，如果想要解决换行问题，同时又希望脚本能够兼容所有unix系统，那么使用printf 命令
```bash
printf 'hello world'
```
只会输出hello world 不会换行。用法同c语言，只是不用括号

6. eval 命令，对参数进行求值
```bash
foo=10
x=foo
eval y='$'$x
echo $y
```
返回10

7. exec 命令：执行exec命令，然后关闭当前的shell
```bash
exec gedit hello.c
gcc -o hello hello.c 
## 上面这条命令不会执行，因为exec执行完gedit hello.c 之后会关闭shell
```
8. export命令，导出变量，使得导出的变量能够被当前shell以及所有的子孙shell看见
```bash
#!/bin/bash
#export2.sh
echo "$foo"
echo "$bar"
```
```bash
#!/bin/bash
#export1.sh
foo="first"
export bar="second"

epxort2.sh
```
执行命令 ./export1.sh 输出
```bash
            ##输出空格，因为 foo变量并没有被导出，export2.sh中无法访问 foo变量
second
```
9. 表达式求值 $$(()):
```bash
x=$((1+2+3))
echo $x  #显示6
```
可以进行算数、逻辑判定等计算

10. set 命令，为shell 设置参数变量
```bash
#!/bin/bash
echo the date is $(date)
set $(date)## 将日期(date 输出)设为该脚本的参数（输出被空格隔开）
ech the month is $2
exit 0
````
set $(...) set命令将$()中的内容设为脚本的参数了

11. shift 命令，将脚本参数依次左移，$1内变量被丢弃，$2内变量移到$1中，$3中变量移到$2中，以此类推，$0中变量不变
```bash
#!/bin/bash
while [ "$1"!="" ] ; do
    echo "$1"
    shift
done
exit 0
```
以上脚本用来扫描所有参数

11. trap 命令
```bash
trap 'command' signal
```
当遇到signal信号时，执行command。 这类似一个守护线程，当运行了这一条命令之后，当程序遇到了该signal，就会执行command，除非改变trap 命令。取消某个信号的方法
```bash
trap signal
```
重置某个信号的command
```bash
trap - signal
```
12.unset foo ： 从环境变量种删除变量或者函数 
## 重要&&常用命令
> find 在系统种搜索文件，grep在文件种搜索字符串
### find 命令
命令格式如下
```bash
find [path] [options] [tests] [actions]
```
常用命令及解释：
```bash
find . -name "test" -print
## 在当前目录下，查找所有名字为test 的文件，并输出完整文件路径
find . \(-name "_*" -or -newer file1 \) -type f -print
## 在当前目录下，查找（名字为“_*”模式的或者比file1更新的）普通文件，并打印它们的完整路径
```

1. 注意，-name 后面的参数可以是完整名字/正则匹配，最好用""将名字/匹配模式括起来
2. 测试条件可以进行逻辑组合，-not, -and,  -or (多个测试条件空格连接默认为 -and). 用()来表示优先级，但是需要转义 \(, \)


### grep 命令
命令格式
```bash
grep [options] PATTERN [FILES]

grep -E -c "^[[:digit:]]*$" file ##匹配空白行，返回数目
grep -E [a-z]\{10\} word.txt ##匹配只有10个字符的单词
```
|option|concept|
|------|------|
|-c |输出匹配行的数目，而不是匹配行|
|-E|启用扩展的正则表达式|
|-i|忽略大小写|
|-l|只列出匹配的文件名，不输出匹配行|
|-v|对模式取反，搜索不匹配行|
<br>

table-常用的匹配模式
|匹配模式|含义|
|------|-----|
|\[\[:alnum:]]|字母或数字|
|\[[:alpha:]]|字母|
|\[[:blank:]]|空格或制表符|
|\[[:digit:]]|数字|
|...||

<br>

table-扩展的正则匹配
|选项|含义|
|------|------|
|？|0次或1次|
|+|1次或多次|
|*|0次或多次|
|{n}|恰好匹配n次|
|{n,}|匹配>= n次|
|{n,m}|最少匹配n次，最多匹配m次|

##命令的执行
### 命令结果的输出
```bash
$(command)  ##将命令执行结果的输出
##或者
`command` ##使用反引号
```
### 算术扩展
```bash
$((1+1))  #返回2
```

### 参数扩展
为了保护变量名中的部分扩展，将需要扩展的部分放到{}中
```bash
#!/bin/bash
for i in 1 2
do
    echo ${i}_tmp #仅仅扩展i
done
```
### 参数替换的方法
用示例的方法讲解
```bash
unset foo
echo ${foo:-bar} ##如果foo为空，输出bar值，否则输出foo的值
foo=fud
echo ${foo:=bar}##如果foo为空，给foo赋值为bar，同时返回bar值
```
|参数扩展|说明|
|------|------|
|${param:-default}|如果param为空，则返回default变量的值，param变量值没变|
|${#param}|返回param值的长度|
|${param%RegExp}|从尾部删除与RegExp匹配的最小的部分|
|${param%%RegExp}|从尾部开始删除与RegExp匹配的最大的部分|
|${param#RegExp}|从头部开始删除与RegExp匹配的最小的部分|
|${param##word}|从头部开始删除与RegExp匹配的最大的部分|
<b>应用</b>
```bash
#!/bin/bash
for image in *.gif
do
    cjpeg $image > ${image%%gif}jpg
done
```
上面的脚本为当前目录种的每个gif文件创建一个对应的jpeg文件

## 奇怪的 here 文档
> reference yourself.
> I think it may be seldom used

## 调试shell程序
1. 通过在shell程序中写各种 echo语句
2. 设置各种shell选项/或者在脚本中添加相应的命令


## dialog(ubuntu 中等价的使用 gdialog)

```c
printf("如果对您有用，欢迎随手点个赞");
```