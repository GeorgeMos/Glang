# Glang
The Glang Programming Language

Glang is a compiled language

Currently the language is under development.

Everyone willing to give positive feedback and contribute to the project is welcome!!

To compile the compiler run: 
flex glc.l && bison -d glc.y && gcc lex.yy.c glc.tab.c -o glc
