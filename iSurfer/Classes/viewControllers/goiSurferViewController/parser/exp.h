//
//  exp.h
//  
//
//  Created by Daniel Jose Azar on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef _exp_h
#define _exp_h

/**
 * File: exp.h
 * Version: 1.0
 * @module Parser
 */

/** 
 *Last modified on November 12 2011 by dazar
 * -----------------------------------------------------
 * This interface provides access to an expression tree designed to parse algebraic surface equations.
 * This tree has methods to dinamicaly generate shader code, derivate the expresion, etc.
 * 
 * @class expressionT
 */


/*  TAD Árbol de Expresiones  */

#include "genlib.h"
/* Tipo que define al arbol de expresiones para el caso aritmetico  */
typedef struct nodeT
{
    char valor[10];
    struct nodeT * left, *right;
} *expressionT;

/**
 * Usage: expressionT myTree; myTree= NewTree(); 
 * --------------------------------------
 * This function creates a new tree.
 * @method NewTree
 * @return {expressionT} a new tree.
 
 */
expressionT NewTree(void);

/**
 * Usage: expressionT myTree; PreOrder( myTree );
 * --------------------------------------
 * prints the tree in PreOrder.
 * @method PreOrder
 * @param tree {expressionT} an instance of expressionT.
 * @return {expressionT} a new tree.
 */
void PreOrder( expressionT tree);
/**
 * Usage: expressionT myTree; myTree= SubTree( "10", NULL, NULL);
 * --------------------------------------
 * Creates a Tree. Using raiz as the root and left and right as both childs.
 * Left and Right should be created before. If they are Null it is a leaf, a number or variable.
 * @method SubTree
 * @param raiz {char *} the text of this node.
 * @param left {expressionT} the left child of the new tree.
 * @param right {expressionT} the right child of the new tree.
 * @return {expressionT} a new tree.
 */

expressionT SubTree( char* raiz, expressionT left, expressionT right);
/**
 * Usage: EvalExp( myTree, 0);
 * --------------------------------------
 * Creates the shader code for the surface.
 * @method EvalExp
 * @param exp {expressionT} the tree to analize.
 * @param where {int} where to print the result. 
 *
 * 0 Means it is the algebraic surface. 
 *
 * 1 Means it is the algebraic surface derivate. 
 */
void EvalExp( expressionT exp, int where);

/**
 * Usage: EvalExpNoCode( myTree, 0);
 * --------------------------------------
 * Creates the expression for the surface.
 * @method EvalExpNoCode
 * @param exp {expressionT} the tree to analize.
 * @param where {int} where to print the result. 
 *
 * 0 Means it is the algebraic surface. 
 *
 * 1 Means it is the algebraic surface derivate. 
 */
void EvalExpNoCode( expressionT exp, int where);

/**
 * Usage: string = getCode();
 * --------------------------------------
 * Returns a string with the  algebraic surface generated.
 * It can be shader code or the expression.
 * @method getCode
 * @return {char *} The algebraic surface generated.
 */
char * getCode(void);

/**
 * Usage: EvalDegree(myTree);
 * --------------------------------------
 * returns the degree of the algebraic surface.
 * @method EvalDegree
 * @param exp {expressionT} the tree to analize.
 * @return {int} the degree. 
 */

int EvalDegree( expressionT exp);

/**
 * Usage: i = getCodeLeng();
 * --------------------------------------
 * Returns the length of  the algebraic surface generated.
 * @method getCodeLeng
 * @return {int} The length of the algebraic surface generated.
 */
int getCodeLeng(void);

/**
 * Usage: clearExp();
 * --------------------------------------
 * clears all the memory to parse a new expression.
 * This method should be called before using any other method.
 * @method clearExp
 * @return void
 */
void clearExp(void);

/**
 * Usage: string = getCodeDerivate();
 * --------------------------------------
 * Returns a string with the  algebraic surface derivative generated.
 * It can be shader code or the expression.
 * @method getCodeDerivate
 * @return {char *} The algebraic surface derivative generated.
 */
char * getCodeDerivate(void);

/**
 * Usage: EvalDerivate( myTree);
 * --------------------------------------
 * Creates shader code for the algebraic surface partial derivatives.
 * @method EvalDerivate
 * @param exp {expressionT} the tree to analize.
 */

void EvalDerivate( expressionT exp);

/**
 * Usage: EvalDerivateNoCode( myTree);
 * --------------------------------------
 * Creates the expression for the algebraic surface partial derivatives.
 * @method EvalDerivateNoCode
 * @param exp {expressionT} the tree to analize.
 */

void EvalDerivateNoCode( expressionT exp);


/**
 * Usage: getDegree();
 * --------------------------------------
 * returns the degree of the algebraic surface.
 * @method getDegree
 * @return {int} the degree. 
 */

int getDegree(void);
/**
 * Usage: FreeTree();
 * --------------------------------------
 * Delete all the tree info and free the memory.
 * It should be called once and only on the root node of a tree.
 * @method FreeTree
 * @param exp {expressionT} the tree to delete.
 * @return {int} the degree. 
 */
void FreeTree( expressionT tree);

/**
 * Usage: if(ErrorExist())
 * --------------------------------------
 * This should be called to look if there was an error in any of the methods of this class.
 * @method ErrorExist
 * @return {boolean} if there was an error. 
 */

booleano ErrorExist(void);

/**
 * Usage: if(ErrorExist()) string = getErrorMsg();
 * --------------------------------------
 * if there was an error call this to get the message.
 * @method getErrorMsg
 * @return {char *} error message. 
 */

char * getErrorMsg(void);

/**
 * Usage: ParseError(msg);
 * --------------------------------------
 * To be call to raise an error.
 * @method ParseError
 * @param msg {char *} error message. 
 */

void ParseError(char * msg);


#endif
