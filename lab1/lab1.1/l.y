%{
   #include<stdio.h>
   #include<stdlib.h>
   int yylval;
   %}
%token number
%left '+' '-'
%left '*' '/'
%%
start: E '\n' {exit(1);}
      | 
      ;
E: E '+' E{printf("+ ");}
|E '-' E{printf("- ");}
|E '*' E{printf("* ");}
|E '/' E{printf("/ ");}
|'(' E ')'
|number {$$=$1;printf("%d ",$$);}
;
%%
yyerror(char const *s)
{
    printf("yyerror %s",s);
}
yylex(){
    char c;
    c = getchar();
    if(isdigit(c)){
      int v=0;
      while(isdigit(c)){
         v=v*10+c-'0';
         c=getchar();
      }
      yylval = v;
      ungetc(c,stdin);
        return number;
    }
    else if(c == ' '){
        yylex();         /*This is to ignore whitespaces in the input*/
    }
    else {
        return c;
    }
}
main()
{
	yyparse();
	return 1;
}