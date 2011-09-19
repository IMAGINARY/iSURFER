//
//  exp.h
//  
//
//  Created by Daniel Jose Azar on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef _exp_h
#define _exp_h

/*  Contrato para Árbol de Expresiones  */

#include "genlib.h"
/* Tipo que define al arbol de expresiones para el caso aritmetico  */
typedef struct nodeT
{
    char valor[10];
    struct nodeT * left, *right;
} *expressionT;
/* Funcion: crea de un arbol vacio
 * Uso: expressionT myTree;
 * myTree= NewTree();
 * --------------------------------
 * Inicializa la estructura interna
 */
expressionT NewTree(void);
/* Funcion: imprime un arbol en preorder
 * Uso: PreOrder( myTree );
 * --------------------------------
 */
void PreOrder( expressionT tree);
/* Funcion: crea de un subarbol
 * Uso: expressionT myTree;
 * myTree= SubTree( "10", NULL, NULL);
 * --------------------------------
 * Crea un arbol a partir de la raiz y de sus
 * hijos izquierdo y derecho previamente creados
 * Notar que en un arbol de expresiones no se
 * puede usar un algoritmo de insercion, ya que
 * el unico orden es el que el usuario decide
 * (la forma está decidida por el usuario)
 */
expressionT SubTree( char* raiz, expressionT left, expressionT right);
/* Funcion: evalua un arbol de expresiones
 * Uso: printf("valor= %d\n", EvalExp( myTree));
 * --------------------------------
 * Evalua un arbol de expresiones aritmeticas
 */

void EvalExp( expressionT exp, int where);
char * getCode(void);
int EvalDegree( expressionT exp);
int getCodeLeng(void);
void clearExp(void);
char * getCodeDerivate(void);
void EvalDerivate( expressionT exp);
void EvalDerivateNoCode( expressionT exp);
 /* Funcion: libera la informacion
 * Uso: FreeTree( tree );
 * --------------------------------
 * Usarlo una sola vez para libera los nodos
 */
void FreeTree( expressionT tree);
#endif
