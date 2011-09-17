/*
 * File: strlib.c
 * Version: 1.0
 * Last modified on Fri Jul 15 14:10:41 1994 by eroberts
 * -----------------------------------------------------
 * This file implements the strlib.h interface.
 */

/*
 * General implementation notes:
 * -----------------------------
 * This module implements the strlib library by mapping all
 * functions into the appropriate calls to the ANSI <string.h>
 * interface.  The implementations of the individual functions
 * are all quite simple and do not require individual comments.
 * For descriptions of the behavior of each function, see the
 * interface.
 */

#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "genlib.h"
#include "strlib.h"

/*
 * Constant: MaxDigits
 * -------------------
 * This constant must be larger than the maximum
 * number of digits that can appear in a number.
 */

#define MaxDigits 30

/* Private function prototypes */

static char * CreateString(int len);

/* Section 1 -- Basic string operations */

char * Concat(char * s1, char * s2)
{
    char * s;
    int len1, len2;

    if (s1 == NULL || s2 == NULL) {
        Error("NULL string passed to Concat");
    }
    len1 = (int) strlen(s1);
    len2 = (int) strlen(s2);
    s = CreateString(len1 + len2);
    strcpy(s, s1);
    strcpy(s + len1, s2);
    return (s);
}

char IthChar(char * s, int i)
{
    int len;

    if (s == NULL) Error("NULL string passed to IthChar");
    len = (int) strlen(s);
    if (i < 0 || i > len) {
        Error("Index outside of string range in IthChar");
    }
    return (s[i]);
}

char * SubString(char * s, int p1, int p2)
{
    int len;
    char * result;

    if (s == NULL) Error("NULL string passed to SubString");
    len = (int) strlen(s);
    if (p1 < 0) p1 = 0;
    if (p2 >= len) p2 = len - 1;
    len = p2 - p1 + 1;
    if (len < 0) len = 0;
    result = CreateString(len);
    strncpy(result, s + p1, len);
    result[len] = '\0';
    return (result);
}

char * CharToString(char ch)
{
    char * result;

    result = CreateString(1);
    result[0] = ch;
    result[1] = '\0';
    return (result);
}

int StringLength(char * s)
{
    if (s == NULL) Error("NULL string passed to StringLength");
    return (int) (strlen(s));
}

char * CopyString(char * s)
{
    char * newstr;

    if (s == NULL) Error("NULL string passed to CopyString");
    newstr = CreateString((int) strlen(s));
    strcpy(newstr, s);
    return (newstr);
}

/* Section 2 -- String comparison functions */

booleano StringEqual(char * s1, char * s2)
{
    if (s1 == NULL || s2 == NULL) {
        Error("NULL string passed to StringEqual");
    }
    return (strcmp(s1, s2) == 0);
}

int StringCompare(char * s1, char * s2)
{
    if (s1 == NULL || s2 == NULL) {
        Error("NULL string passed to StringCompare");
    }
    return (strcmp(s1, s2));
}

/* Section 3 -- Search functions */

int FindChar(char ch, char * text, int start)
{
    char *cptr;

    if (text == NULL) Error("NULL string passed to FindChar");
    if (start < 0) start = 0;
    if (start > strlen(text)) return (-1);
    cptr = strchr(text + start, ch);
    if (cptr == NULL) return (-1);
    return ((int) (cptr - text));
}

int FindString(const char * str, char * text, int start)
{
    char *cptr;

    if (str == NULL) Error("NULL pattern string in FindString");
    if (text == NULL) Error("NULL text string in FindString");
    if (start < 0) start = 0;
    if (start > strlen(text)) return (-1);
    cptr = strstr(text + start, str);
    if (cptr == NULL) return (-1);
    return ((int) (cptr - text));
}

/* Section 4 -- Case-conversion functions */

char * ConvertToLowerCase(char * s)
{
    char * result;
    int i;

    if (s == NULL) {
        Error("NULL string passed to ConvertToLowerCase");
    }
    result = CreateString((int) strlen(s));
    for (i = 0; s[i] != '\0'; i++) result[i] = tolower(s[i]);
    result[i] = '\0';
    return (result);
}

char * ConvertToUpperCase(char * s)
{
    char * result;
    int i;

    if (s == NULL) {
        Error("NULL string passed to ConvertToUpperCase");
    }
    result = CreateString((int) strlen(s));
    for (i = 0; s[i] != '\0'; i++) result[i] = toupper(s[i]);
    result[i] = '\0';
    return (result);
}

/* Section 5 -- Functions for converting numbers to strings */

char * IntegerToString(int n)
{
    char buffer[MaxDigits];

    sprintf(buffer, "%d", n);
    return (CopyString(buffer));
}

int StringToInteger(char * s)
{
    int result;
    char dummy;

    if (s == NULL) {
        Error("NULL string passed to StringToInteger");
    }
    if (sscanf(s, " %d %c", &result, &dummy) != 1) {
        Error("StringToInteger called on illegal number %s", s);
    }
    return (result);
}

char * RealToString(double d)
{
    char buffer[MaxDigits];

    sprintf(buffer, "%G", d);
    return (CopyString(buffer));
}

double StringToReal(char * s)
{
    double result;
    char dummy;

    if (s == NULL) Error("NULL string passed to StringToReal");
    if (sscanf(s, " %lg %c", &result, &dummy) != 1) {
        Error("StringToReal called on illegal number %s", s);
    }
    return (result);
}

/* Private functions */

/*
 * Function: CreateString
 * Usage: s = CreateString(len);
 * -----------------------------
 * This function dynamically allocates space for a string of
 * len characters, leaving room for the null character at the
 * end.
 */

static char * CreateString(int len)
{
    return ((char *) GetBlock(len + 1));
}
