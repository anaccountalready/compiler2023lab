%{
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif
extern YYSTYPE yylval;
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

%token ADD SUB MUL DIV
%token NUMBER
%left rb
%left ADD SUB
%left MUL DIV
%right lb 

%right UMINUS         

%%


lines   :       lines expr ';' { printf("result=%f\n", $2); }
        |       lines ';'
        |
        ;
//TODO:
expr    :       expr ADD expr   { $$=$1+$3;}
        |       expr SUB expr   { $$=$1-$3; }
        |       expr MUL expr   { $$=$1*$3; }
        |       expr DIV expr   { $$=$1/$3; }
        |       SUB expr %prec UMINUS   {$$=-$2;}
        |       lb expr rb{$$=($2);}
        |       NUMBER  {$$=$1;}
        ;

%%

// programs section
int yydebug=1;
int yylex()
{
    char t;
        t=getchar();
        if(t==' '||t=='\t'||t=='\n'){
            //do noting
            yylex();
        }else if(isdigit(t)){
            
            //TODO: 
           int v=0;
            while(isdigit(t)){v=v*10+(t-48);t=getchar();}
            yylval = v;
           ungetc(t,stdin);
            return NUMBER;
        }else if(t=='+'){
            return ADD;
        }else if(t=='-'){
            return SUB;
        }//TODO:
        else if(t=='*'){
            return MUL;
        }
        else if(t=='/'){
            return DIV;
        }
        else if(t=='('){
            return lb;
        }
        else if(t==')'){
            return rb;
        }
        else{
            return t;
        }
    
}

int main(void)
{
    yyin=stdin;
    do{
        yyparse();
    }while(!feof(yyin));
    return 0;
}
void yyerror(const char* s){
    fprintf(stderr,"Parse error: %s\n",s);
    exit(1);
}