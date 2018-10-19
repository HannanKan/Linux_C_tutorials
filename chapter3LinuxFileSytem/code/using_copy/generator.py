#!/bin/bash
import random
f=open("file.in","w")
word_list=["a",'b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];

def generate_word():
    len=random.randint(0,10);
    word=""
    for x in range(len):
        word=word+word_list[random.randint(0,25)];
    return word

def generate_file():
    len=random.randint(1000000,9000000)
    n=0
    for x in range(len):
        f.write(generate_word()+" ")
        n=n+1
        r=random.randint(0,10)
        if(r>5):
            f.write("\n");
        if(n==20):
            f.write("\n")
            n=0

generate_file()
f.close()
