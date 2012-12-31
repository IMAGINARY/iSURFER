//
//  parser.h
//  
//
//  Created by Daniel Jose Azar on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef _parser_h
#define _parser_h

/**
 * File: parser.h
 * Version: 1.0
 * @module Parser
 */

/** 
 *Last modified on FRY June 12 2012 by dazar
 * -----------------------------------------------------
 * This interface provides access to a simple package of
 * functions that simplify the parser of equations from the file exp.
 * 
 * @class parser
 */


/**
 * Usage: exp = ParseExp(scanner);
 * ----------------------------
 * Reads the scanner and generates an expression tree with the equation.
 * The tree is formed with the correct precedence considering "(" and ")".
 * Returns Null in case of error.
 * @method ParseExp
 * @param scanner {scannerADT} a scanner with the equation formula.
 * @return {expressionT} an expression tree. 
 */

expressionT ParseExp( scannerADT scanner);

/**
 * Usage: b = IsVariable(token);
 * ----------------------------
 * IsVariable reads a char of text from the pointer and
 * returns a boolean indicating if it is a variable or not.
 * that terminates the input is not stored as part of the
 * A variable can be x, y ,z.
 * @method IsVariable
 * @param token {char *} pointer to the char to analize.
 * @return {booleano} 
 */
booleano IsVariable(char * token);

/**
 * Usage: b = EsNumero(token);
 * ----------------------------
 * IsVariable reads a number from the pointer and
 * returns a boolean indicating if it is a number or not.
 * The number is left in valor.
 * @method EsNumero
 * @param token {char *} pointer to the char to analize.
 * @param valor {double *} pointer where we place the number read.
 * @return {booleano} if it can read the number 
 *  */

booleano EsNumero(char* strNumero, double* valor);
#endif
