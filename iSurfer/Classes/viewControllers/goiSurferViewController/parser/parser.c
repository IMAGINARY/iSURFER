/*  Archivo: parser.c */
#include <stdio.h>
#include <string.h>
#include "strlib.h"
#include "scanadt.h"
#include "exp.h"
#include "parser.h"
static booleano IsOperator(char * token); 
static expressionT ReadE(scannerADT scanner, int prec); 
static expressionT ReadT(scannerADT scanner);
static int Precedence(char * token);

static booleano IsOperator(char * token) {
    if (StringLength(token) == 0)
        return FALSE;
    switch(token[0])
    {
        case '+': case '-': case '*': case '^': case '=':
            return TRUE;
        default:
            return FALSE;
    } 
}

booleano IsVariable(char * token) {
    if (StringLength(token) == 0)
        return FALSE;
    switch(token[0])
    {
        case 'x': case 'y': case 'z': case 'a': case 'b':
            return TRUE;
        default:
            return FALSE;
    } 
}


int
EsNumero(char* strNumero, double* valor) {
    return sscanf( strNumero, "%lg", valor) == 1;
}

expressionT
ParseExp( scannerADT scanner) {
    expressionT exp;
    exp= ReadE(scanner, 0);
    if (MoreTokensExist(scanner))
        Error("ParseExp: %s unexpected", ReadToken(scanner));
    return exp; 
}

static int Precedence(char * token) {
    if (StringLength(token) > 1)
        return 0;
    switch (token[0])
    {
        case '=': return 1;
        case '+': case '-': return 2;
        case '*': case '/': return 3;
        case '^': return 4;     
        default: return 0;
    } }
static expressionT
ReadE(scannerADT scanner, int prec)
{
    expressionT exp, rhs;
    char * token;
    int newPrec;
    exp= ReadT(scanner);
    while (TRUE)
    {
        token= ReadToken(scanner);
        newPrec= Precedence(token);
        if (newPrec <= prec )
            break;
        rhs= ReadE(scanner, newPrec);
        exp= SubTree(token, exp, rhs);
    }
    SaveToken(scanner, token);
    return exp;
}

static expressionT ReadT(scannerADT scanner) {
    expressionT exp;
    char * token;
    double nro;
    token= ReadToken(scanner);
    if (StringEqual(token, "(") )
    {
        exp= ReadE(scanner, 0);
        if (! StringEqual( ReadToken(scanner), ")"))
            Error("Unbalanced parentheses");
    } else
        if(token[0]=='!'){
            exp= SubTree(token ,NULL, NULL);
            exp->right = ReadE(scanner, 0);
        }
        else
        if (EsNumero(token, &nro))
            exp= SubTree(token ,NULL, NULL);
        else
        if (IsVariable(token))
            exp= SubTree(token ,NULL, NULL);    
        else
            Error("Illegal term in expression");
    return exp; 
}
