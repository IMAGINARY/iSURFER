//
//  parser.h
//  
//
//  Created by Daniel Jose Azar on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef _parser_h
#define _parser_h
expressionT ParseExp( scannerADT scanner);
booleano IsVariable(char * token);
int EsNumero(char* strNumero, double* valor);
#endif
