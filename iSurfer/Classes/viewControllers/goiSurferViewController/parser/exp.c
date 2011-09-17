//
//  exp.c
//  
//
//  Created by Daniel Jose Azar on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
* Archivo: exp.c
*/
#include <stdio.h>
#include "genlib.h"
#include "strlib.h"
#include "simpio.h"
#include "exp.h"
#include "scanadt.h"
#include "parser.h"
#include <string.h>



#define MAX(x, y) (((x) > (y)) ? (x) : (y))
#define MIN(x, y) (((x) < (y)) ? (x) : (y))

char code[10000];
int codePointer = 0;


char * getCode(void){
    return code;
}

int getCodeLeng(void){
    return codePointer;
}


void clearExp(void){
    for(int i=0;i<codePointer;i++)
        code[i] = 0;
    codePointer= 0;
}


int EvalDegreeX( expressionT exp);
int EvalDegreeY( expressionT exp);
int EvalDegreeZ( expressionT exp);
void EvalExpMacro( expressionT exp);

void printCode(char * message);
void printCodeNum(double nro);
void printChar(char var);
void printCodeInt(double nro);
void printCode(char * message){
    codePointer += sprintf(code + codePointer, message);
    
}

void printChar(char var){
    code[codePointer] = var;
    codePointer++;
}

void printCodeNum(double nro){
    codePointer += sprintf(code + codePointer, "%f", nro);
    
}

void printCodeInt(double nro){
    codePointer += sprintf(code + codePointer, "%d", (int)nro);
    
}


expressionT NewTree(void) {
    return NULL;
}
void
PreOrder( expressionT tree) {
    if ( tree != NULL )
    {
        printf("%s\n", tree->valor);
        PreOrder(tree->left);
        PreOrder(tree->right);
    } }
expressionT
SubTree( char* raiz, expressionT left, expressionT right) {
    expressionT root;
    root= malloc( sizeof (struct nodeT ) );
    strcpy(root->valor, raiz);
    root->left= left;
    root->right= right;
    return root;
}

void
EvalExp( expressionT exp) {
    if ( exp == NULL )
        return ;
    /*if ( exp->left == NULL && exp->right == NULL )
    {
        printf(" %d " , atoi(exp->valor));
        return ;
    }*/
	double nro;

    switch( exp->valor[0] )
    {
        case '+': printCode("add(");  EvalExpMacro(exp->left); printChar(','); EvalExpMacro(exp->right); printChar(',');printCodeInt(EvalDegree(exp)); printChar(')'); return;
        case '*': printCode("mult(");  EvalExpMacro(exp->left); printChar(','); EvalExpMacro(exp->right);printChar(',');printCodeInt( EvalDegree(exp)); printChar(')'); return;
        case '-': printCode("sub(");  EvalExpMacro(exp->left); printChar(','); EvalExpMacro(exp->right); printChar(',');printCodeInt( EvalDegree(exp)); printChar(')'); return;
        case '^': printCode("power(");  EvalExpMacro(exp->left); printChar(','); EsNumero(exp->right->valor, &nro); printCodeInt(nro); printChar(',');printCodeInt(EvalDegree(exp->left));printChar(')'); return;
        case '!': printCode("neg(");  EvalExpMacro(exp->right); printChar(','); printCodeNum(EvalDegree(exp)); printChar(')'); return;
    }
    if(IsVariable(exp->valor))
        printChar(exp->valor[0]);
    if(EsNumero(exp->valor, &nro))
        printCodeNum(nro);
    
    
}

void
EvalExpMacro( expressionT exp) {
    double nro;
    if(EsNumero(exp->valor, &nro)){
        printCode("create_poly_0(");
        printCodeNum(nro);
        printChar(')');
    }else{
        EvalExp(exp);
    }
}
int 
EvalDegreeX( expressionT exp) {
    if ( exp == NULL )
        return 0;
    /*if ( exp->left == NULL && exp->right == NULL )
     {
     printf(" %d " , atoi(exp->valor));
     return ;
     }*/
    double nro;
    switch( exp->valor[0] )
    {
        case '+': return MAX( EvalDegreeX(exp->left) , EvalDegreeX(exp->right));
        case '*': return EvalDegreeX(exp->left) + EvalDegreeX(exp->right);
        case '-': return MAX( EvalDegreeX(exp->left) , EvalDegreeX(exp->right));
        case '^': 
            EsNumero(exp->right->valor , &nro);
            return EvalDegreeX(exp->left) * nro;
        case '!':   return EvalDegreeX(exp->right);
    }
    if(exp->valor[0]=='x')
        return 1;
    return 0;
}

int 
EvalDegreeY( expressionT exp) {
    if ( exp == NULL )
        return 0;
    /*if ( exp->left == NULL && exp->right == NULL )
     {
     printf(" %d " , atoi(exp->valor));
     return ;
     }*/
    double nro;
    switch( exp->valor[0] )
    {
        case '+': return MAX( EvalDegreeY(exp->left) , EvalDegreeY(exp->right));
        case '*': return EvalDegreeY(exp->left) + EvalDegreeY(exp->right);
        case '-': return MAX( EvalDegreeY(exp->left) , EvalDegreeY(exp->right));
        case '^': 
            EsNumero(exp->right->valor , &nro);
            return EvalDegreeY(exp->left) * nro;
        case '!':   return EvalDegreeY(exp->right);
    }
    if(exp->valor[0]=='y')
        return 1;
    return 0;
}

int 
EvalDegreeZ( expressionT exp) {
    if ( exp == NULL )
        return 0;
    /*if ( exp->left == NULL && exp->right == NULL )
     {
     printf(" %d " , atoi(exp->valor));
     return ;
     }*/
    double nro;
    switch( exp->valor[0] )
    {
        case '+': return MAX( EvalDegreeZ(exp->left) , EvalDegreeZ(exp->right));
        case '*': return EvalDegreeZ(exp->left) + EvalDegreeZ(exp->right);
        case '-': return MAX( EvalDegreeZ(exp->left) , EvalDegreeZ(exp->right));
        case '^': 
            EsNumero(exp->right->valor , &nro);
            return EvalDegreeZ(exp->left) * nro;
        case '!':   return EvalDegreeZ(exp->right);
    
    }
    if(exp->valor[0]=='z')
        return 1;

    return 0;
}




int EvalDegree( expressionT exp) {

    return MAX(MAX( EvalDegreeX(exp), EvalDegreeY(exp)), EvalDegreeZ(exp) );
    }
void
FreeTree( expressionT tree) {
    if ( tree != NULL )
    {
        FreeTree(tree->left);
        FreeTree(tree->right);
        free(tree);
    } }