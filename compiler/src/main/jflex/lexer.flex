/**
 *  This code is part of the lab exercises for the Compilers course
 *  at Harokopio University of Athens, Dept. of Informatics and Telematics.
 */

import static java.lang.System.out;

%%

%class Lexer
%unicode
%public
%final
%integer
%line
%column

%{
    // user custom code 

    private StringBuffer sb = new StringBuffer();

%}

LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f] 
Comment        = "/*" [^*] ~"*/" | "/*" "*"+ "/"

Identifier     = [:jletter:] [:jletterdigit:]*
IntegerLiteral = 0 | [1-9][0-9]*

Exponent = [eE][\+\-]?[0-9]+
Float1   = [0-9]+ \. [0-9]+ {Exponent}?
Float2   = \. [0-9]+ {Exponent}?
Float3   = [0-9]+ \. {Exponent}?
Float4   = [0-9]+ {Exponent}

FloatLiteral = {Float1} | {Float2} | {Float3} | {Float4}

%state STRING

%%

<YYINITIAL> {
    /* reserved keywords */
    "print"                        { out.println("PRINT"); }

    /* identifiers */ 
    {Identifier}                   { out.println("id:" + yytext()); }

    /* literals */
    {IntegerLiteral}               { out.println("integer:" + yytext()); }
    {FloatLiteral}               { out.println("float:" + yytext()); }

    \"                             { sb.setLength(0); yybegin(STRING); }

    /* operators */
    "="                            { out.println("ASSIGN"); }
    ">"                            { out.println("GREATER_THAN"); }
    "<"                            { out.println("LESS_THAN"); }
    "!="                           { out.println("NOT_EQUAL"); }
    "<="                           { out.println("LESS_THAN_OR_EQUAL_TO"); }
    ">="                           { out.println("GREATER_THAN_OR_EQUAL_TO"); }
    "=="                           { out.println("EQUAL_TO"); }
    
    "+"                            { out.println("PLUS"); }  
    "-"                            { out.println("MINUS"); }    
    "*"                            { out.println("MULTIPLY"); }    
    "/"                            { out.println("DIVIDE"); }   
    "%"                            { out.println("MODULUS"); }
    
    "&&"                           { out.println("LOGICAL_AND"); }    
    "||"                           { out.println("LOGICAL_OR"); }   
    "!"                            { out.println("LOGICAL_NOT"); }
        
    "("                            { out.println("LEFT_PARENTHESES"); }
    ")"                            { out.println("RIGHT_PARENTHESES"); }
    "{"                            { out.println("LEFT_BRACE"); }
    "}"                            { out.println("RIGHT_BRACE"); }
    "["                            { out.println("LEFT_BRACKETS"); }
    "]"                            { out.println("RIGHT_BRACKETS"); }
    ";"                            { out.println("SEMICOLON"); }
    ","                            { out.println("COMMA"); }
    "."                            { out.println("PERIOD"); }

    /* comments */
    {Comment}                      { /* ignore */ }

    /* whitespace */
    {WhiteSpace}                   { /* ignore */ }
}

<STRING> {
    \"                             { yybegin(YYINITIAL);
                                     out.println("string:" + sb.toString()); 
                                   }

    [^\n\r\"\\]+                   { sb.append(yytext()); }
    \\t                            { sb.append('\t'); }
    \\n                            { sb.append('\n'); }

    \\r                            { sb.append('\r'); }
    \\\"                           { sb.append('\"'); }
    \\                             { sb.append('\\'); }
}

/* error fallback */
[^]                                { throw new RuntimeException((yyline+1) + ":" + (yycolumn+1) + ": illegal character <"+ yytext()+">"); }
