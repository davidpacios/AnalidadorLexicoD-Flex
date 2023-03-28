%{
#include "../includes/symbolsTable.h"
#include "../includes/errorHandler.h"

void openFile(char *fileName);
void closeFile();
void generateToken(TablaHash TS, token *t);
void sendTokenToParser(TablaHash TS, token *t);

%}

/* OPTIONS */
/*No se genera la función yywrap*/
%option noyywrap 
/*Se cuenta el número de línea*/
%option yylineno
/*No usar yyunput*/
%option nounput
/*Añadir las funciones al .h en la carpeta include*/
%option header-file="../includes/lex.yy.h"
/*Añadir las funciones al .c en la carpeta src*/
%option outfile="./lex.yy.c"


/*NO TOKEN*/
NEWLINE \n
SPACE [ ]
SEPARATOR [\t|\r{SPACE}]+
LETTER [a-zA-Z]
COUNTER_SLASH [\\]

/*TOKEN*/

/*KEYWORDS*/

/*SPECIAL SYMBOLS*/
POINT [.]
TWO_POINTS [:]
POINT_COMMA [;]
COMMA [,]
MULTIPLICATION [*]
ASSIGNMENT [=]
DIVISION [/]
ADDITION [+]
SUBTRACTION [-]
GREATER [>]
LESS [<]
EXCLAMATION_MARK [!]
AND [&]
OR [|]
PAR_OPEN [(]
PAR_CLOSE [)]
CURLY_BRACKET_OPEN [{]
CURLY_BRACKET_CLOSE [}]
SQUARE_BRACKET_OPEN [[]
SQUARE_BRACKET_CLOSE []]
SIMPLE_SPECIAL_SYMBOL {COMMA}|{POINT}|{POINT_COMMA}|{MULTIPLICATION}|{ASSIGNMENT}|{DIVISION}|{ADDITION}|{SUBTRACTION}|{GREATER}|{LESS}|{EXCLAMATION_MARK}|{AND}|{OR}|{PAR_OPEN}|{PAR_CLOSE}|{CURLY_BRACKET_OPEN}|{CURLY_BRACKET_CLOSE}|{SQUARE_BRACKET_OPEN}|{SQUARE_BRACKET_CLOSE}

SPECIAL_SYMBOL_EQUAL_EQUAL {ASSIGNMENT}{ASSIGNMENT}
SPECIAL_SYMBOL_NOT_EQUAL {EXCLAMATION_MARK}{ASSIGNMENT}

SPECIAL_SYMBOL_ADDITION {ADDITION}{ADDITION}
SPECIAL_SYMBOL_ADDITION_EQUAL {ADDITION}{ASSIGNMENT}

SPECIAL_SYMBOL_SUBTRACTION {SUBTRACTION}{SUBTRACTION}
SPECIAL_SYMBOL_SUBTRACTION_EQUAL {SUBTRACTION}{ASSIGNMENT}

SPECIAL_SYMBOL_AND {AND}{AND}
SPECIAL_SYMBOL_OR {OR}{OR}

SPECIAL_SYMBOL_GREATER_GREATER {GREATER}{GREATER}
SPECIAL_SYMBOL_GREATER_EQUAL {ASSIGNMENT}{GREATER}

SPECIAL_SYMBOL_LESS_EQUAL {ASSIGNMENT}{LESS}
SPECIAL_SYMBOL_LESS_LESS {LESS}{LESS}

SPECIAL_SYMBOL {POINT_COMMA}|{MULTIPLICATION}|{ASSIGNMENT}|{DIVISION}|{ADDITION}|{SUBTRACTION}|{GREATER}|{LESS}|{EXCLAMATION_MARK}|{AND}|{OR}|{SPECIAL_SYMBOL_EQUAL_EQUAL}|{SPECIAL_SYMBOL_NOT_EQUAL}|{SPECIAL_SYMBOL_ADDITION}|{SPECIAL_SYMBOL_ADDITION_EQUAL}|{SPECIAL_SYMBOL_SUBTRACTION}|{SPECIAL_SYMBOL_SUBTRACTION_EQUAL}|{SPECIAL_SYMBOL_AND}|{SPECIAL_SYMBOL_OR}|{SPECIAL_SYMBOL_GREATER_GREATER}|{SPECIAL_SYMBOL_GREATER_EQUAL}|{SPECIAL_SYMBOL_LESS_EQUAL}|{SPECIAL_SYMBOL_LESS_LESS}


/*IDENTIFIERS*/
START_ID ([_]|{LETTER})

ID {START_ID}([_]|{LETTER}|{DIGIT})*


/*NUMBERS*/
DIGIT [0-9]
BINARY [0-1]

DECIMAL_DIGIT {DIGIT}(([_])?{DIGIT})*
FLOAT_DECIMAL {DECIMAL_DIGIT}[.]{DECIMAL_DIGIT}

DECIMAL {DECIMAL_DIGIT}|{FLOAT_DECIMAL}

DECIMAL_EXPONENT {DECIMAL}([eE][+-]?{DECIMAL_DIGIT})?

BINARY_DIGIT [0][bB]{BINARY}(([_])?{BINARY})*

NUMBER {DECIMAL}|{DECIMAL_EXPONENT}|{BINARY_DIGIT}


/*STRINGS*/
DOUBLE_QUOTE ["]
SINGLE_QUOTE [']

STRING_DOUBLE_QUOTE {DOUBLE_QUOTE}([^"]|({COUNTER_SLASH}{DOUBLE_QUOTE}))*{DOUBLE_QUOTE}
STRING_SINGLE_QUOTE {SINGLE_QUOTE}([^']|({COUNTER_SLASH}{SINGLE_QUOTE}))*{SINGLE_QUOTE}

STRING_LITERAL {STRING_DOUBLE_QUOTE}|{STRING_SINGLE_QUOTE}

/*COMMENTS*/
START_COMMENT_LINE {DIVISION}{DIVISION}
COMMENT_LINE {START_COMMENT_LINE}([^\n])*{NEWLINE}

COMMENT_BLOCK {DIVISION}{MULTIPLICATION}([^*]|{MULTIPLICATION}[^/])*{MULTIPLICATION}{DIVISION}

COMMENT_NESTED {DIVISION}{ADDITION}

COMMENT {COMMENT_LINE}|{COMMENT_BLOCK}

%%
{SPACE}                                         {/*Do nothing*/}
{NEWLINE}                                       {/*Do nothing*/}

{ID}                                            {return (ID);}

{NUMBER}                                        {return (NUMBER);}

{STRING_LITERAL}                                {return (STRING_LITERAL);}

{SIMPLE_SPECIAL_SYMBOL}                         {return ((int)*yytext);}
{SPECIAL_SYMBOL_EQUAL_EQUAL}                    {return (SPECIAL_SYMBOL_EQUAL_EQUAL);}
{SPECIAL_SYMBOL_NOT_EQUAL}                      {return (SPECIAL_SYMBOL_NOT_EQUAL);}
{SPECIAL_SYMBOL_ADDITION}                       {return (SPECIAL_SYMBOL_ADDITION);}
{SPECIAL_SYMBOL_ADDITION_EQUAL}                 {return (SPECIAL_SYMBOL_ADDITION_EQUAL);}
{SPECIAL_SYMBOL_SUBTRACTION}                    {return (SPECIAL_SYMBOL_SUBTRACTION);}
{SPECIAL_SYMBOL_SUBTRACTION_EQUAL}              {return (SPECIAL_SYMBOL_SUBTRACTION_EQUAL);}
{SPECIAL_SYMBOL_AND}                            {return (SPECIAL_SYMBOL_AND);}
{SPECIAL_SYMBOL_GREATER_GREATER}                {return (SPECIAL_SYMBOL_GREATER_GREATER);}
{SPECIAL_SYMBOL_GREATER_EQUAL}                  {return (SPECIAL_SYMBOL_GREATER_EQUAL);}
{SPECIAL_SYMBOL_LESS_EQUAL}                     {return (SPECIAL_SYMBOL_LESS_EQUAL);}
{SPECIAL_SYMBOL_LESS_LESS}                      {return (SPECIAL_SYMBOL_LESS_LESS);}

{COMMENT}                                       {/*Do nothing*/}
{COMMENT_NESTED}                                {
                                                int nestedComments = 1;
                                                char state = 0;
                                                char character;
                                                while(nestedComments){
                                                    character = input();
                                                        switch (state) {
                                                            //Estado 0 -> Comienza con +/, se espera un / para anidar un comentario o un + para salir de un comentario anidado
                                                            case 0:
                                                                switch (character) {
                                                                    case '/':
                                                                        state = 1;
                                                                        break;
                                                                    case '+':
                                                                        state = 2;
                                                                        break;
                                                                }
                                                                break;

                                                             //Estado 1 -> Tenemos un /, se espera un + para anidar un comentario
                                                            case 1:
                                                                if(character == '+') nestedComments++;
                                                                state = 0;
                                                                break;

                                                             //Estado 2 -> Tenemos un +, se espera un / para salir de un comentario anidado
                                                            case 2:
                                                                if(character == '/') nestedComments--;
                                                                state = 0;
                                                                break;
                                                        }
                                                }
}

.                                               {return (LEXICAL_ERROR);}
<<EOF>>                                         {return (EOF);}

%%

void openFile(char *fileName) {
    FILE* f = fopen(fileName, "r");
    if (f == NULL) {
        printf("Error opening file %s", fileName);
        exit(1);
    }
    yyin = f;
}

void closeFile() {
    fclose(yyin);
    yylex_destroy();
}

void generateToken(TablaHash TS, token *t) {
    token aux;
    t->codeToken = yylex();
    if(t->stringToken!=NULL){
        free(t->stringToken);
        t->stringToken = NULL;
    }
    t->stringToken = strdup(yytext);

    if(t->codeToken == ID) {

        if(!searchHashElement(TS, t->stringToken, &aux)){
            aux.codeToken = ID;
            aux.stringToken = strdup(t->stringToken);
            insertHashElement(TS, aux);
            return;
        }

        t->codeToken = aux.codeToken;
        return;
    }

    if(t->codeToken == LEXICAL_ERROR) {
        errorHandler(yylineno);
    }
}

void sendTokenToParser(TablaHash TS, token *t) {
    generateToken(TS, t);
}
