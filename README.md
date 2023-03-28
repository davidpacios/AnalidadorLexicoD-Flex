# Analizador Léxico con FLEX para el lenguaje D

Analizador léxico para el lenguaje D programado en C, diseñado para la materia de 3º año de la carrera de  Ingeniería Informática de la Universidad de Santiago de Compostela. 

## Descripción
El analizador obtiene los lexemas del lenguaje D a través del uso de la herramienta de software *FLEX*, algunos de los lexememas menos comunes no están contemplados en el analizador, como por ejemplo los número en octal o algunos símbolos especiales. Cuenta con una breve gestión de errores, donde si encuentra un error al generar un lexema, dice la línea donde el analizador ha detectado el error.

## Ejecución
Para la ejecución debes tener el compilador de C, gcc, y flex instalados en tu sistema operativo. Posteriormente, debes ejecuar el siguiente comando en la terminal:

```make```

Esto compilará el programa y generará un ejecutable llamado ```Compilador_cmd```. Para ejecutarlo, debes ejecutar el siguiente comando:

```./Compilador_cmd```

En caso de modificar lexycalAnalysis.l, debes ejecutar el siguiente comando para actualizar el analizador léxico:

```flex lexicalAnalysis.l```

Este comando generará el archivo source-file ```lex.yy.c``` en la carpeta ```src``` y header-file ```lex.yy.h``` en la carptea ```include```. Cuando generamos un nuevo header-file, debemos añadirle las cabeceras de las funciones que se van a llamar, en este caso son únicamente tres:

```void openFile(char *fileName);```

```void closeFile();```

```void sendTokenToParser(TablaHash TS, token *t);```

Una vez ejecutado el comando, se debe volver a compilar el programa con el comando ```make```, previamente puedes limpiar el ejecutable anterior con el comando ```make clean```.

## Opciones
Si quieres analiziar otro fichero distinto al regression.d, debes modificar la variable ```FILE_NAME``` en el archivo ```symbolsTable.h``` y recompilar el programa. El fichero debe estar en la misma carpeta que el ejecutable.

## Analisis con Valgrind
Para analizar el programa con Valgrind, debes ejecutar el siguiente comando:

```valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose ./Compilador_cmd``` o ```valgrind -s ./Compilador_cmd```

La salida de Valgrind con respecto a la memoria del HEAP es la siguiente:

```==4906==
==4906== HEAP SUMMARY:
==4906==     in use at exit: 0 bytes in 0 blocks
==4906==   total heap usage: 311 allocs, 311 frees, 23,170 bytes allocated
==4906==
==4906== All heap blocks were freed -- no leaks are possible
==4906==
==4906== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
```

## Autor
* **David Pacios** - [davidpacios]
