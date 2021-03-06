%e  1019
%p  2807
%n  371
%k  284
%a  1213
%o  1117



D   [0-9]
NZ  [1-9]
L   [a-zA-Z_]
A   [a-zA-Z_0-9]
WS  [ \t\v\n\f]

%option yylineno

%{
#define ifprint 0

#include <stdio.h>
#include <stdlib.h>
#include <string.h> 
#include "y.tab.h"
//extern char* yylval;

extern void yyerror(const char *);  /* prints grammar violation message */

extern int sym_type(const char *);  /* returns type from symbol table */

#define sym_type(identifier) IDENTIFIER /* with no symbol table, fake it */

static void comment(void);

//if (ifprint) {ECHO;fprintf(yyout, "  ");}
%}

%%
"/*"                                    { comment(); }
"//".*                                    { /* consume //-comment */ }

"for"                   {if (ifprint) {ECHO;fprintf(yyout, "  ");}; return(FOR); }
"if"					{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return(IF); }
"else"					{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return(ELSE); }
"while"					{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return(WHILE); }
"return"					{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return(RETURN); }
"void"					{yylval.str = strdup(yytext); 
                         return(VOID); }
"int"					{yylval.str = strdup(yytext); 
                        return(INT); }
"float"					{yylval.str = strdup(yytext); 
                        return(FLOAT); }

"++"				{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return INC_OP; }
"--"				{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return DEC_OP; }
"+"				{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return PLUS; }
"-"				{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return MINUS; }
"*"				{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return STAR; }
"/"				{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return SLASH; }
"<"				{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return LT; }
"<="				{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return LTEQ; }
">"				{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return GT; }
">="				{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return GTEQ; }
"=="				{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return EQ; }
"!="				{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return NEQ; }
"="				{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return ASSIGN; }

("[")				{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return LSQUAR; }
("]")				{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return RSQUAR; }
("{")				{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return LBRACE; }
("}")				{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return RBRACE; }
";"				{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return SEMI; }
","				{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return COMMA; }
"("				{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return LPAREN; }
")"				{if (ifprint) {ECHO;fprintf(yyout, "  ");}; return RPAREN; }

{L}{A}*					{ yylval.str = strdup(yytext); return ID; }
{D}+			{if (ifprint) {ECHO;fprintf(yyout, "  ");};yylval.str = strdup(yytext); return NUM; }


{WS}+					{if (ifprint) {ECHO;fprintf(yyout, "  ");};  /* whitespace separates tokens */ }
.					{if (ifprint) {ECHO;fprintf(yyout, "  ");}; /* discard bad characters */ }

%%

int yywrap(void)        /* called at end of input */
{
    return 1;           /* terminate now */
}

static void comment(void)
{
    int c;
    while ((c = input()) != 0)
        if (c == '*')
        {
            while ((c = input()) == '*');
            if (c == '/')
                return;
            if (c == 0)
                break;
        }
    yyerror("unterminated comment");
}
