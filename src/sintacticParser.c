#include <stdio.h>
#include <stdlib.h>
#include "../includes/sintacticParser.h"
#include "../includes/lex.yy.h"

void startParser(TablaHash TS){
    short indexStack = 0;
    token tokenAux;
    tokenAux.stringToken = NULL;
    sendTokenToParser(TS, &tokenAux);

    while (tokenAux.codeToken != EOF){
        indexStack++;

        printf("<%s, %d>\n", tokenAux.stringToken, tokenAux.codeToken);

        sendTokenToParser(TS, &tokenAux);
    }

    free (tokenAux.stringToken);

    printf("Fin del analisis sintactico.\n");
}
