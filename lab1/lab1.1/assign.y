%{
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<string.h>
union YYSTYPE{
    double dbval;
    int intval;
    char stringval[500];
};

int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
int ischar(char c);
typedef struct{
    char type[100];
    char id[100];
    int val;
}symbol;
void insert(symbol a);
void find_do(symbol a);
int find(symbol a);
%}
%code{
static int num=0;
 static symbol symboltable[100];
 static symbol a_new;
}
%define api.value.type {union YYSTYPE}
%type <intval> expr
%type <stringval> stmt
%type <stringval> decl
%type <stringval> lines
%token ADD SUB MUL DIV 
%token <intval> NUMBER 
%token  EQU 
%token <stringval> TYPE
%token <stringval> ID
%left rb
%left ADD SUB
%left MUL DIV
%right lb 
%right EQU
%right UMINUS         
%start lines
%%
lines   :       lines expr ';' { printf("result=%d\n", $2); }
        |       lines ';'       { printf("line2 %s\n", $1); }
        |       lines decl ';'  { printf("line3 %s\n", $2); }
        |       lines stmt ';'  { printf("line4 %s\n", $2); }
        |
        ;
decl    :       TYPE ID {
                    strcpy(a_new.type,$1);
                    strcpy(a_new.id,$2);
                    a_new.val = 0;//初始化为0
                    find_do(a_new);
                    sprintf($$,"%s %s",$1,$2); 
                    }
        |       TYPE ID EQU expr {
                strcpy(a_new.type,$1);
                strcpy(a_new.id,$2);
                a_new.val=$4;
                find_do(a_new);
                sprintf($$,"%s %s = %d",$1,$2,$4);
                }
        ;       
stmt    :       ID EQU expr    {
                                    
                                   
                                    a_new.val=$3;
                                    strcpy(a_new.id,$1);
                                    int sign = find(a_new);
                                   if(sign==-1){yyerror("this identifier doesn't be decl before!!!");}
                                   else{
                                    assignval(sign,a_new);
                                    sprintf($$,"%s = %d",$1,$3);
                                    for(int j=0;j<num;j++)
                                    {printf("%d: %s %s = %d\n",j,symboltable[j].type,symboltable[j].id,symboltable[j].val);}
                                    }
                                    
                                    
                                }
        ;


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
int ischar(char c){
    if((c>='a'&&c<='z')||(c>='A'&&c<='Z'))return 1;
    else return 0;
}
int yydebug=1;
void insert(symbol a){
    symboltable[num]=a;
    num=num+1;
    
}
void find_do(symbol a){
    for(int i=0;i<num;i++){
        if(strcmp(a.id,symboltable[i].id)==0){
            symboltable[i].val = a.val;
            return;
        }
    }
    insert(a);
}
void assignval(int i,symbol a){
     symboltable[i].val = a.val;
}
int find(symbol a){
    for(int i=0;i<num;i++){
        if(strcmp(a.id,symboltable[i].id)==0){
            symboltable[i].val = a.val;
            return i;
        }
    }
    return -1;
}
int yylex()
{
    
        char t;
        
        while(1){
            t=getchar();
        if(t==' '||t=='\t'||t=='\n'){
            //do noting
        }else if(ischar(t)||t=='_'){
            //TODO: 
           char a[100];
           int i=0;
    a[i]=t;
    i++;
    t=getchar();
    while(ischar(t)||isdigit(t)||t=='_'){
    a[i]=t;
    i++;
    t=getchar();
    }
    a[i]='\0';
            strcpy(yylval.stringval,a);
           ungetc(t,stdin);
           if(strcmp(a,"int")==0){
           
            return TYPE;
            }
            else {
                return ID;}
        }
        else if(isdigit(t)){
            
            //TODO: 
           int v=0;
            while(isdigit(t)){v=v*10+(t-48);t=getchar();}
            yylval.intval = v;
           ungetc(t,stdin);
            return NUMBER;
        }
        else if(t=='+'){
             
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
        else if(t=='='){
             
            return EQU;
        }
        else{
            
            return t;
        }
    
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