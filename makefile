go: lex.yy.c a8.tab.c
        gcc a8.tab.c lex.yy.c -lfl -ly -o go

lex.yy.c: a8.l
        flex a8.l

a8.tab.c: a8.y
        bison -dv a8.y

clean:
        rm -f lex.yy.c
        rm -f a8.output
        rm -f a8.tab.h
        rm -f a8.tab.c
