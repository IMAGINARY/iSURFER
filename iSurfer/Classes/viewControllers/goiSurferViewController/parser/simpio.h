//
//  simpio.h
//  
//
//  Created by Daniel Jose Azar on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/**
 * File: simpio.h
 * Version: 1.0
 * @module Parser
 */

 /** 
 *Last modified on Wed Apr 27 07:29:13 1994 by eroberts
 * -----------------------------------------------------
 * This interface provides access to a simple package of
 * functions that simplify the reading of input data.
 * @class simpio
 */

#ifndef _simpio_h
#define _simpio_h

#include "genlib.h"

/**
 * Usage: i = GetInteger();
 * ------------------------
 * GetInteger reads a line of text from standard input and scans
 * it as an integer.  The integer value is returned.  If an
 * integer cannot be scanned or if more characters follow the
 * number, the user is given a chance to retry.
 * @method GetInteger
 * @return {int} the number read.
 */

int GetInteger(void);

/**
 * Usage: l = GetLong();
 * ---------------------
 * GetLong reads a line of text from standard input and scans
 * it as a long integer.  The value is returned as a long.
 * If an integer cannot be scanned or if more characters follow
 * the number, the user is given a chance to retry.
 * @method GetLong
 * @return {long} the number read.
 */

long GetLong(void);

/**
 * Usage: x = GetReal();
 * ---------------------
 * GetReal reads a line of text from standard input and scans
 * it as a double.  If the number cannot be scanned or if extra
 * characters follow after the number ends, the user is given
 * a chance to reenter the value.
 * @method GetReal
 * @return {double} the number read.
 */

double GetReal(void);

/**
 * Usage: s = GetLine();
 * ---------------------
 * GetLine reads a line of text from standard input and returns
 * the line as a string.  The newline character that terminates
 * the input is not stored as part of the string.
 * @method GetLine
 * @return {char *} the string read.
 */

char * GetLine(void);

/**
 * Usage: s = ReadLine(infile);
 * ----------------------------
 * ReadLine reads a line of text from the input file and
 * returns the line as a string.  The newline character
 * that terminates the input is not stored as part of the
 * string.  The ReadLine function returns NULL if infile
 * is at the end-of-file position.
 * @method ReadLine
 * @param {FILE} infile
 * @return {char *} the string read.
 */

char * ReadLine(FILE *infile);

#endif