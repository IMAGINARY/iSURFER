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
char derivate[10000];
char errorMsg[1000];
int errorPointer = 0;
int degreee;
int codePointer = 0;
int derivatePointer = 0;

char * getCode(void){
    return code;
}

int getCodeLeng(void){
    return codePointer;
}

char * getCodeDerivate(void){
    return derivate;
}

int getDegree(void){
    return degreee;
}



void clearExp(void){
    for(int i=0;i<codePointer;i++)
        code[i] = 0;
    codePointer= 0;

    for(int i=0;i<errorPointer;i++)
        errorMsg[i] = 0;
    errorPointer = 0;
    
    for(int i=0;i<derivatePointer;i++)
        derivate[i] = 0;
    derivatePointer= 0;
    
}



booleano ErrorExist(){
    return errorPointer != 0;
}
void ParseError(char * msg){
    errorPointer = strlen(msg);
	memcpy(errorMsg , msg , errorPointer);
    free(msg);
}

char * getErrorMsg(void)
{
    return errorMsg;
}


int EvalDegreeX( expressionT exp);
int EvalDegreeY( expressionT exp);
int EvalDegreeZ( expressionT exp);
void EvalExpMacro( expressionT exp, int where);

void printCode(char * message, int where);
void printCodeNum(double nro, int where);
void printChar(char var, int where);
void printCodeInt(double nro, int where);
void
EvalDerivateExp( expressionT exp, char var);


void printCode(char * message, int where){
    if(where == 0)
    {
        codePointer += sprintf(code + codePointer,"%s",  message);
    }else{
        derivatePointer += sprintf(derivate + derivatePointer, "%s", message);
        
    }
    
}

void printChar(char var, int where){
    if(where == 0)
    {
        code[codePointer] = var;
        codePointer++;
    }else
    {
        derivate[derivatePointer] = var;
        derivatePointer++;
    }   
}

void printCodeNum(double nro, int where){
    if(where == 0)
    {
        codePointer += sprintf(code + codePointer, "%f", nro);
    }else
    {
        derivatePointer += sprintf(derivate + derivatePointer, "%f", nro);
        
    }
    
}

void printCodeInt(double nro, int where){
    if(where == 0)
    {
        codePointer += sprintf(code + codePointer, "%d", (int)nro);
    }else
    {
        derivatePointer += sprintf(derivate + derivatePointer, "%d", (int)nro);
        
    }
    
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
    free(raiz);
    root->left= left;
    root->right= right;
    return root;
}

void
EvalDerivate( expressionT exp) {
    printCode("= vec3(eval_p(shiftStretch(", 1);
    EvalDerivateExp( exp, 'x');
    printCode(",min,max-min,px), hit_point.x), eval_p(shiftStretch(  ", 1);
    EvalDerivateExp( exp, 'y');
    printCode(",min,max-min,py), hit_point.y), eval_p(shiftStretch(  ", 1);
    EvalDerivateExp( exp, 'z');
    printCode(",min,max-min,pz), hit_point.z));", 1);
}


void
EvalExpNoCode( expressionT exp, int where) {
    if ( exp == NULL )
        return ;
	double nro;
    
    switch( exp->valor[0] )
    {
        case '+':  printChar('(', where); EvalExpNoCode(exp->left, where); printChar('+', where); EvalExpNoCode(exp->right, where); printChar(')', where); return;
        case '-':  printChar('(', where); EvalExpNoCode(exp->left, where); printChar('-', where); EvalExpNoCode(exp->right, where); printChar(')', where); return;
            
        case '!':  printChar('-', where); EvalExpNoCode(exp->right, where); return;
        case '*':  printChar('(', where); EvalExpNoCode(exp->left, where); printChar('*', where); EvalExpNoCode(exp->right, where); printChar(')', where); return;

        case '^': 
            printChar('(', where);
            EvalExpNoCode(exp->left,where); 
            printChar(')', where);

            EsNumero(exp->right->valor, &nro); 
            
            for (int i=1; i<nro; i++) {
                printChar('*', where);
                EvalExpNoCode(exp->left,where); 
            }

    }
    if(IsVariable(exp->valor))
        printChar(exp->valor[0],where);
    if(EsNumero(exp->valor, &nro))
        printCodeNum(nro,where);
    
    
}





void
EvalDerivateExpNoCode( expressionT exp, char var) {
    if ( exp == NULL )
        return ;
	double nro;
    
    switch( exp->valor[0] )
    {
        case '+': printChar('(', 1);  EvalDerivateExpNoCode(exp->left, var); printChar('+', 1); EvalDerivateExpNoCode(exp->right, var);  printChar(')', 1);return;
            
            
        case '*': 
            printChar('(', 1);
            
            EvalExpNoCode(exp->left,1);
            printChar('*', 1);
            EvalDerivateExpNoCode(exp->right, var);
            printChar('+', 1);           
            EvalExpNoCode(exp->right,1);
            printChar('*', 1);
            EvalDerivateExpNoCode(exp->left, var);
            printChar(')', 1);
            
            return;
            
        case '-':  printChar('(', 1); EvalDerivateExpNoCode(exp->left, var); printChar('-', 1); EvalDerivateExpNoCode(exp->right, var); printChar(')', 1); return;
            
        case '^': EsNumero(exp->right->valor, &nro);
            
                    printCodeNum(nro, 1); 

                    for (int i=1; i<nro; i++) {
                        printChar('*', 1);
                        if(i==1)
                            printChar('(', 1);

                        EvalExpNoCode(exp->left,1); 
                        if(i==nro -1)
                            printChar(')', 1);
    
                    }
                    
                    printChar('*', 1);
                    printChar('(', 1);
            
                    EvalDerivateExpNoCode(exp->left, var);                   
                    printChar(')', 1);
            
            return;
            
            
        case '!':  printChar('-', 1); EvalDerivateExpNoCode(exp->right, var); return;
    }
    if(IsVariable(exp->valor))
    {
        if(*(exp->valor) == var)
            printCode("1.0",1);
        else
            printCode("0.0",1);
    }
    if(EsNumero(exp->valor, &nro))
        printCode("0.0",1);
}

void
EvalDerivateExp( expressionT exp, char var) {
    if ( exp == NULL )
        return ;
	double nro;
    
    switch( exp->valor[0] )
    {
        case '+': printCode("add(", 1);  EvalDerivateExp(exp->left, var); printChar(',', 1); EvalDerivateExp(exp->right, var); printChar(',',1); 
            printCodeInt(MAX(EvalDegree(exp) -1 , 0),1); printChar(')',1); return;
            
            
        case '*': 
            printCode("add(mult(", 1);
            EvalExpMacro(exp->left,1);
            printChar(',', 1);
            EvalDerivateExp(exp->right, var);
            printChar(',', 1);
            printCodeInt( MAX(EvalDegree(exp) -1 , 0),1);
            
            printCode("),mult(", 1);
            EvalExpMacro(exp->right,1);
            printChar(',', 1);
            EvalDerivateExp(exp->left, var);
            printChar(',', 1);
            printCodeInt( MAX(EvalDegree(exp) -1 , 0),1);
            printCode("),", 1);
            printCodeInt(MAX(EvalDegree(exp) -1 , 0),1); 
            printChar(')',1);
            return;
            
            
            
            
        case '-': printCode("sub(", 1);  EvalDerivateExp(exp->left, var); printChar(',', 1); EvalDerivateExp(exp->right, var); printChar(',',1);printCodeInt(MAX(EvalDegree(exp) -1 , 0),1); printChar(')',1); return;
            
        case '^': EsNumero(exp->right->valor, &nro);
            
            if(nro != 2)
            {
                if(*(exp->left->valor) == var)
                {
                    printCode("mult(create_poly_0(", 1);
                    printCodeInt(nro, 1); 
                    printCode("),power(",1);
                    EvalExpMacro(exp->left,1); 
                    printChar(',', 1);
                    printCodeInt(nro-1,1);
                    printChar(',',1);
                    printCodeInt(EvalDegree(exp->left),1);
                    printCode("),", 1);
                    printCodeInt( MAX(EvalDegree(exp) -1 , 0),1);
                    printChar(')', 1);
                    
                    
                }else
                {
                    printCode("mult(mult(create_poly_0(", 1); printCodeInt(nro, 1); 
                    
                    printCodeInt(nro, 1); 
                    printCode("),power(",1);
                    EvalExpMacro(exp->left,1); 
                    printChar(',', 1);
                    printCodeInt(nro-1,1);
                    printChar(',',1);
                    printCodeInt(EvalDegree(exp->left),1);
                    printCode("),", 1);
                    printCodeInt( MAX(EvalDegree(exp) -1 , 0),1);
                    printCode("),", 1);
                    EvalDerivateExp(exp->left, var);
                    printChar(',',1);
                    printCodeInt(EvalDegree(exp->left),1);
                    printChar(')', 1);
                    
                }
                
                
            }else{
                if(*(exp->left->valor) ==  var)
                {
                    printCode("mult(create_poly_0(2.0),", 1); 
                    EvalExpMacro(exp->left,1); 
                    printChar(',', 1);
                    printCodeInt(EvalDegree(exp->left),1);
                    printChar(')', 1);
                    
                    
                }else
                {
                    printCode("mult(mult(create_poly_0(2.0),", 1);
                    EvalExpMacro(exp->left,1); 
                    printChar(',', 1);
                    printCodeInt(EvalDegree(exp->left),1);
                    printCode("),", 1);
                    
                    EvalDerivateExp(exp->left, var);
                    printChar(',',1);
                    printCodeInt(EvalDegree(exp->left),1);
                    printChar(')', 1);
                    
                }
                
                
                
            }
            return;
            
            
        case '!': printCode("neg(", 1);  EvalDerivateExp(exp->right, var); printChar(',', 1); printCodeInt( MAX(EvalDegree(exp) -1 , 0) ,1); printChar(')',1); return;
    }
    if(IsVariable(exp->valor))
    {
        if(*(exp->valor) == var)
            printCode("create_poly_0(1.0)",1);
        else
            printCode("create_poly_0(0.0)",1);
    }
    if(EsNumero(exp->valor, &nro))
        printCode("create_poly_0(0.0)",1);
}


void cleanDeriv(void ){
    char *p = derivate;

    while ( (p=strstr(p,"--")) != NULL )
    {
        memcpy(p, "+ ", sizeof(char)* 2);
        p++;
    }
    
}


void
EvalDerivateNoCode( expressionT exp) {
    printCode("= vec3( ", 1);
    EvalDerivateExpNoCode( exp, 'x');
    printChar(',', 1);
    EvalDerivateExpNoCode( exp, 'y');
    printChar(',', 1);
    EvalDerivateExpNoCode( exp, 'z');
    printCode(");", 1);
    
    cleanDeriv();
}



void
EvalExp( expressionT exp, int where) {
    if ( exp == NULL )
        return ;
	double nro;

    switch( exp->valor[0] )
    {
        case '+': printCode("add(",where);  EvalExpMacro(exp->left, where); printChar(',',where); EvalExpMacro(exp->right, where); printChar(',',where);printCodeInt(EvalDegree(exp),where); printChar(')',where); return;
        case '*': printCode("mult(",where);  EvalExpMacro(exp->left, where); printChar(',',where); EvalExpMacro(exp->right, where);printChar(',',where);printCodeInt( EvalDegree(exp),where); printChar(')',where); return;
        case '-': printCode("sub(",where);  EvalExpMacro(exp->left, where); printChar(',',where); EvalExpMacro(exp->right, where); printChar(',',where);printCodeInt( EvalDegree(exp),where); printChar(')',where); return;
        case '^': printCode("power(",where);  EvalExpMacro(exp->left, where); printChar(',',where); EsNumero(exp->right->valor, &nro); printCodeInt(nro,where); printChar(',',where);printCodeInt(EvalDegree(exp->left),where);printChar(')',where); return;
        case '!': printCode("neg(",where);  EvalExpMacro(exp->right, where); printChar(',',where); printCodeInt(EvalDegree(exp),where); printChar(')',where); return;
    }
    if(IsVariable(exp->valor))
        printChar(exp->valor[0],where);
    if(EsNumero(exp->valor, &nro))
        printCodeNum(nro,where);
    
    
}

void
EvalExpMacro( expressionT exp, int where ) {
    double nro;
    if(EsNumero(exp->valor, &nro)){
        printCode("create_poly_0(",where);
        printCodeNum(nro,where);
        printChar(')',where);
    }else{
        EvalExp(exp, where);
    }
}
int 
EvalDegreeX( expressionT exp) {
    if ( exp == NULL )
        return 0;
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


int 
EvalDegreeSuper( expressionT exp) {
    if ( exp == NULL )
        return 0;

    double nro;
    switch( exp->valor[0] )
    {
        case '+': return MAX( EvalDegreeSuper(exp->left) , EvalDegreeSuper(exp->right));
        case '*': return EvalDegreeSuper(exp->left) + EvalDegreeSuper(exp->right);
        case '-': return MAX( EvalDegreeSuper(exp->left) , EvalDegreeSuper(exp->right));
        case '^': 
            EsNumero(exp->right->valor , &nro);
            return EvalDegreeSuper(exp->left) * nro;
        case '!':   return EvalDegreeSuper(exp->right);
            
    }
    if(exp->valor[0]=='z' || exp->valor[0]=='y' || exp->valor[0]=='x')
        return 1;
    
    return 0;
}


int EvalDegree( expressionT exp) {

    return degreee =  EvalDegreeSuper(exp);
    }
void
FreeTree( expressionT tree) {
    if ( tree != NULL )
    {
        FreeTree(tree->left);
        FreeTree(tree->right);
        free(tree);
    } }