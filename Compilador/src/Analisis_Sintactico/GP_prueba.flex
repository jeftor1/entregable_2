package Analisis_Sintactico;

import java_cup.runtime.*;
%%

%class Scanner
%unicode
%cup
%line
%column
%function next_token

%{
  StringBuffer string = new StringBuffer();

  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment} 

TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}

Identifier = [a-zA-Z\_][^\$][a-zA-Z_0-9]* | "\$"+[a-zA-Z_0-9][a-zA-Z_0-9]*

//[:jletter:] [:jletterdigit:]*  

DecIntegerLiteral = 0 | [1-9][0-9]*

CharConst = \'+[:jletter:]+\' 

SChar = [^\"\\\n\r] | {EscChar}
EscChar = \\[ntbrf\\\'\"]

Decimales = {DecIntegerLiteral}+\.[0-9]*

%state STRING

%%

/* Palabras reservadas */

<YYINITIAL> "int"          { return symbol(sym.TInt); }
<YYINITIAL> "String"            { return symbol(sym.TString); }
<YYINITIAL> "boolean"           { return symbol(sym.TBoolean); }
<YYINITIAL> "float"             { return symbol(sym.TFloat); }
<YYINITIAL> "char"              { return symbol(sym.TChar); }
<YYINITIAL> "true"              { return symbol(sym.TTrue); }
<YYINITIAL> "false"             { return symbol(sym.TFalse); }

<YYINITIAL> "class"          { return symbol(sym.TClass); }
<YYINITIAL> "void"              { return symbol(sym.TVoid); }
<YYINITIAL> "main"          { return symbol(sym.TMain); }
<YYINITIAL> "static"     { return symbol(sym.TStatic); }
<YYINITIAL> "extends"           { return symbol(sym.TExtends); }
<YYINITIAL> "return"     { return symbol(sym.TReturn); }

<YYINITIAL> "while"          { return symbol(sym.TWhile); }
<YYINITIAL> "System"            { return symbol(sym.TSystem); }
<YYINITIAL> "out"          { return symbol(sym.TOut); }
<YYINITIAL> "println"           { return symbol(sym.TPrintln); }
<YYINITIAL> "length"     { return symbol(sym.TLength); }
<YYINITIAL> "this"              { return symbol(sym.TThis); }
<YYINITIAL> "new"          { return symbol(sym.TNew); }
<YYINITIAL> "if"                { return symbol(sym.TIf); }
<YYINITIAL> "else"              { return symbol(sym.TElse); }
<YYINITIAL> "!"                 { return symbol(sym.TNegacion); }

<YYINITIAL> "import"            { return symbol(sym.TImport); }
<YYINITIAL> "implements"        { return symbol(sym.TImplements); }
<YYINITIAL> "exit"                 { return symbol(sym.TExit); }
<YYINITIAL> "in"                 { return symbol(sym.TIn); }
<YYINITIAL> "read"                 { return symbol(sym.TRead); }




<YYINITIAL> {
  /* identificadores */ 
  {Identifier}                   { return symbol(sym.TID,yytext()); }
 
  /* literales enteros positivos */
  {DecIntegerLiteral}            { return symbol(sym.TIntegerLiteral); }
 /* \"                 { string.setLength(0); yybegin(TStringLiteral); } */

  {CharConst}                    { return symbol(sym.TStringConst,yytext()); }

  {Decimales}                    { return symbol(sym.TDecimales,yytext()); }

  /* operadores */
  "="                            { return symbol(sym.TAsig); }
  "*"                            { return symbol(sym.TMult); }
  "+"                            { return symbol(sym.TSuma); }
  "-"                            { return symbol(sym.TResta); }
  "/"                            { return symbol(sym.TDivision); }

  "<"                            { return symbol(sym.TMenor); }
  "<="                           { return symbol(sym.TMenorIgual); }
  ">"                            { return symbol(sym.TMayor); }
  ">="                           { return symbol(sym.TMayorIgual); }
  "=="                           { return symbol(sym.TIgual); }
  "!="                           { return symbol(sym.TDiferente); }
  "||"                           { return symbol(sym.TO); }
  "&&"                           { return symbol(sym.TY); }
  

  /* otros simbolos v�lidos */
  "("                            { return symbol(sym.TParIzq); }
  ")"                            { return symbol(sym.TParDer); }
  "{"                            { return symbol(sym.TLlaveIzq); }
  "}"                            { return symbol(sym.TLlaveDer); }
  "["                            { return symbol(sym.TCorIzq); }
  "]"                            { return symbol(sym.TCorDer); }

  ";"                            { return symbol(sym.TPyComa); }
  ","                            { return symbol(sym.TComa); }
  "."                            { return symbol(sym.TPunto); }

  \"{SChar}*\"      { return symbol(sym.TStringLiteral,yytext());}
  
  /* commentarios */
  {Comment}                      { /* ignore */ }
 
  /* espacios en blanco */
  {WhiteSpace}                   { /* ignore */ }
}

<STRING> {
  \"                             { yybegin(YYINITIAL); 
                                   return symbol(sym.TStringLiteral, string.toString()); }
  [^\n\r\"\\]+                   { string.append( yytext() ); }
  \\t                            { string.append('\t'); }
  \\n                            { string.append('\n'); }

  \\r                            { string.append('\r'); }
  \\\"                           { string.append('\"'); }
  \\                             { string.append('\\'); }
}

/* caracteres no v�lidos */
.|\n                             { throw new RuntimeException("Error caracter inv�lido: <" + yytext() + "> en fila: " + yyline + " columna: " + yycolumn );
       /*throw new Error("Caracter no permitido <"+
                                                    yytext()+">");*/ }

