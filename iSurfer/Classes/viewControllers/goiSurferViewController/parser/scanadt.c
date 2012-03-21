/*
 * File: scanadt.c by eroberts
 * ---------------
 * This file implements the scanadt.h interface.
 */

#include <stdio.h>
#include <ctype.h>
#include "genlib.h"
#include "strlib.h"
#include "scanadt.h"

/*
 * Type: scannerCDT
 * ----------------
 * This structure is the concrete representation of the type
 * scannerADT, which is exported by this interface.  Its purpose
 * is to maintain the state of the scanner between calls.  The
 * details of the representation are invisible to the client,
 * but consist of the following fields:
 *
 * str          -- Copy of string passed to SetScannerString
 * len          -- Length of string, saved for efficiency
 * cp           -- Current character position in the string
 * savedToken   -- String saved by SaveToken (NULL indicates none)
 * spaceOption  -- Setting of the space option extension
 */

struct scannerCDT {
    char * str;
    int len;
    int cp;
    char * savedToken;
    spaceOptionT spaceOption;
};

/* Private function prototypes */

static void SkipSpaces(scannerADT scanner);
static int ScanToEndOfIdentifier(scannerADT scanner, int quote);

/* Exported entries */

scannerADT NewScanner(void)
{
    scannerADT scanner;

    scanner = New(scannerADT);
    scanner->str = NULL;
    scanner->spaceOption = PreserveSpaces;
    return (scanner);
}

void FreeScanner(scannerADT scanner)
{
    if (scanner->str != NULL)
		FreeBlock(scanner->str);
    FreeBlock(scanner);
}

void SetScannerString(scannerADT scanner, char * str)
{
    if (scanner->str != NULL) FreeBlock(scanner->str);
    scanner->str = CopyString(str);
    scanner->len = StringLength(str);
    scanner->cp = 0;
    scanner->savedToken = NULL;
}

char * ReadToken(scannerADT scanner)
{
    char * token;
    int quote = 0, start, finish;

    if (scanner->str == NULL) {
        Error("SetScannerString has not been called");
    }
    if (scanner->savedToken != NULL) {
        token = scanner->savedToken;
        scanner->savedToken = NULL;
        return (token);
    }
    if (scanner->spaceOption == IgnoreSpaces) SkipSpaces(scanner);
    while (scanner->str[scanner->cp] == ' ' || scanner->str[scanner->cp] == '\t') {
	scanner->cp++;
    }
    if (scanner->str[scanner->cp] == '"') {
	quote = 1;
	scanner->cp++;
    }
    start = scanner->cp;
    if (start >= scanner->len) return (CopyString(""));
    finish = ScanToEndOfIdentifier(scanner, quote);
    return (SubString(scanner->str, start, finish));
}

booleano MoreTokensExist(scannerADT scanner)
{
    if (scanner->str == NULL) {
        Error("SetScannerString has not been called");
    }
    if (scanner->savedToken != NULL) {
        return (!StringEqual(scanner->savedToken, ""));
    }
    if (scanner->spaceOption == IgnoreSpaces) SkipSpaces(scanner);
    while (scanner->str[scanner->cp] == ' ' || scanner->str[scanner->cp] == '\t'
    		 || (scanner->str[scanner->cp] == '"' && 
    		 		scanner->str[scanner->cp+1] == '"')) {
	if (scanner->str[scanner->cp] == '"')
	   scanner->cp++;
	scanner->cp++;
    }
    return (scanner->cp < scanner->len-1);
}

void SaveToken(scannerADT scanner, char * token)
{
    if (scanner->str == NULL) {
        Error("SetScannerString has not been called");
    }
    if (scanner->savedToken != NULL) {
        Error("Token has already been saved");
    }
    scanner->savedToken = token;
}

void SetScannerSpaceOption(scannerADT scanner, spaceOptionT option)
{
    scanner->spaceOption = option;
}

spaceOptionT GetScannerSpaceOption(scannerADT scanner)
{
    return (scanner->spaceOption);
}

/* Private functions */

/*
 * Function: SkipSpaces
 * Usage: SkipSpaces(scanner);
 * ---------------------------
 * This function advances the position of the scanner until the
 * current character is not a whitespace character.
 */

static void SkipSpaces(scannerADT scanner)
{
    while (isspace(scanner->str[scanner->cp])) {
        scanner->cp++;
    }
}

/*
 * Function: ScanToEndOfIdentifier
 * Usage: finish = ScanToEndOfIdentifier(scanner);
 * -----------------------------------------------
 * This function advances the position of the scanner until it
 * reaches the end of a sequence of letters or digits that make
 * up an identifier.  The return value is the index of the last
 * character in the identifier; the value of the stored index
 * cp is the first character after that.
 */

static int ScanToEndOfIdentifier(scannerADT scanner, int quote)
{
    if (!quote)
        switch (scanner->str[scanner->cp]) {
            case '+':
            case '-':
            case '*':
            case '^':
            case 'x':
            case 'y':
            case 'z':
            case 'a':
            case 'b':
            case 'c':
            case 'd':
            case '(':
            case ')':
            case '!':
                scanner->cp++;
           return (scanner->cp - 1);                
            default:
                break;
        }    
        switch (scanner->str[scanner->cp]) {
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
            case '.':
                while (1) {
                    switch (scanner->str[scanner->cp]) {
                        case '0':
                        case '1':
                        case '2':
                        case '3':
                        case '4':
                        case '5':
                        case '6':
                        case '7':
                        case '8':
                        case '9':
                        case '.':
                            scanner->cp++;                            
                            break;
                            
                            default:
                            return (scanner->cp - 1);                
                            break;
                    }
                }
            default:
                break;
        }
    
    return 0;    
}
