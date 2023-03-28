#include <stdio.h>
#include "../includes/symbolsTable.h"
#include "../includes/sintacticParser.h"


void init(TablaHash TS);
void freeMemory(TablaHash TS);


int main() {

    TablaHash TS;
    openFile(FILE_NAME);
    init(TS);

    startParser(TS);

    freeMemory(TS);
}

//Inicializar la tabla de simbolos
void init(TablaHash TS){
    initSymbolsTable(TS);
    printf("Tabla de simbolos inicializada correctamente.\n");
}

void freeMemory(TablaHash TS){
    destroySymbolsTable(TS);
    closeFile();
    printf("Memoria liberada correctamente.\n");
}
