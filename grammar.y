%{

#include <string>
#include <fstream>
#include <iostream>
#include <set>
#include <map>
#include <cstring>
#include <vector>

#include <stdio.h>
#include <unistd.h>

#include "bytecode_inst.h"

extern int yylex(void);
extern int yyparse(void);
extern FILE* yyin;


std::ofstream fout("output.j");

void yyerror(const char* s);

%}

%code requires {
    #include <vector>
}

%union {
    int ival;
    float fval;
    char * idval;
    char * aopval;
    int bval;

    struct {
        int sType;
    } expr_type;

    struct {
        std::vector<int> *trueList, *falseList;
    } bexpr_type;

    struct {
        std::vector<int> *nextList;
    } stmt_type;
    
    struct {
        int returnMarker;
        std::vector<int> *nextList;
    } ret_stmt_type;
    
    struct {
        int load_var;
        std::vector<int> *returnList;
    } swt_type;
    
    struct {
        int initMarker;
        int endMarker;
        std::vector<int> *nextList;
    } func_stmt_type;
    
    struct {
        int initMarker;
        int midMarker;
        int endMarker;
        std::vector<int> *trueList;
        std::vector<int> *falseList;
    } fcm_stmt_type;

    int sType;
}

/* Declaração dos tokens... */

%token<ival> INT
%token<fval> FLOAT
%token <bval> BOOL
%left <aopval> T_ARITH_OP
%left <aopval> T_BOOL_OP
%left <aopval> T_LOGIC_OPERATOR
%token <idval> T_ID
%token <idval> T_STRING
%token <ival> T_INCREMENT
%token <idval> T_SELF_ASSIGN

%token T_INT
%token T_BOOL
%token T_DEFINE T_INCLUDE T_LIBRARY
%token T_PLUS T_MINUS T_MULTIPLY T_DIVIDE T_LEFT T_RIGHT
%token T_NEWLINE T_QUIT
%token T_PRIMITIVO T_RESERVED T_CONST
%token T_SEPARATOR T_EXPR_SEPARATOR;
%token T_LEFT_BLOCK T_RIGHT_BLOCK 
%token T_LEFT_PARENTHESES T_RIGHT_PARENTHESES
%token T_SWITCH T_FOR T_WHILE T_DO
%token T_PRINT
%token T_CONDICIONAL
%right T_CONT_CONDICIONAL
%token T_ASSIGN T_RETURN T_ARROW_RIGHT
%token T_LEFT_POINTER T_RIGHT_POINTER
%left T_OP_SUM T_OP_SUB T_OP_MUL T_OP_DIV
%token T_MLC_START T_MLC_END T_EMPTY
%token T_TAB T_CARRIER T_UNKNOWN
%token T_COMMENT_C T_SLC

%type <sType> primitive_type
%type <expr_type> expression
%type <bexpr_type> b_expression

%type <stmt_type> logico_if
%type <ret_stmt_type> if_else
%type <stmt_type> loop_while
%type <stmt_type> loop_do
%type <stmt_type> loop_for
%type <stmt_type> loop_for_dec
%type <stmt_type> loop_for_inc
%type <fcm_stmt_type> loop_for_cond
%type <swt_type> when
%type <stmt_type> switch_statement
%type <stmt_type> switch_statement_set
%type <stmt_type> print

%type <stmt_type> statement
%type <stmt_type> statement_set
%type <func_stmt_type> function_block
%type <stmt_type> declaracao
%type <stmt_type> declaracao_funcao
%type <stmt_type> incremento
%type <stmt_type> chamada_funcao
%type <stmt_type> comentario
%type <stmt_type> assign

%type <ival> marker
%type <ival> goto
//%type <ival> codesize

%start start_

%%

start_: 
    {createHeader();} 
    statement_set
	marker
    {
        backpatch($2.nextList,$3);
        createFooter();
    };

statement_set: statement {
    $$.nextList = $1.nextList;
} | statement marker statement_set {
    backpatch($1.nextList,$2);
    $$.nextList = $3.nextList;
};

statement: 
    logico_if {
        $$.nextList = $1.nextList;
    }
    | when{
        std::vector<int> * v = new std::vector<int>();
        $$.nextList =v;
    }
    | declaracao T_SEPARATOR {
        std::vector<int> * v = new std::vector<int>();
        $$.nextList =v;
    }
    | declaracao_funcao
    | comentario {
        std::vector<int> * v = new std::vector<int>();
        $$.nextList =v;
    }
    | chamada_funcao 
    | incremento T_SEPARATOR {
        std::vector<int> * v = new std::vector<int>();
        $$.nextList =v;
    }
    | loop_while
    | loop_for
    | loop_do
    | print T_SEPARATOR {
        std::vector<int> * v = new std::vector<int>();
        $$.nextList=v;
    }
    | assign T_SEPARATOR {
        std::vector<int> * v = new std::vector<int>();
        $$.nextList =v;
    }
    ;

marker:{
    $$ = labelsCount;
    writeCode(genLabel() + ":");
};

/* codesize: {
    $$ = codeList.size()-1;
}; */

goto:{
    $$ = codeList.size();
    writeCode("goto ");
};


print: T_PRINT T_LEFT_PARENTHESES expression T_RIGHT_PARENTHESES
    {
        printf("\033[0;34mSintático Print\033[0m\n");
        if($3.sType == E_INT){
            writeCode("istore " + std::to_string(lista_simbolos["int_expr"].first));
            writeCode("getstatic      java/lang/System/out Ljava/io/PrintStream;");
            writeCode("iload " + std::to_string(lista_simbolos["int_expr"].first ));
            writeCode("invokevirtual java/io/PrintStream/println(I)V");
        }else if($3.sType == E_STR){
            writeCode("putstatic      test/message Ljava/lang/String;");
            writeCode("getstatic      java/lang/System/out Ljava/io/PrintStream;");
            writeCode("getstatic      test/message Ljava/lang/String;");
            writeCode("invokevirtual  java/io/PrintStream/println(Ljava/lang/String;)V");
            //writeCode("pop");
            
            /*writeCode("aastore " + std::to_string(lista_simbolos["int_expr"].first));
            writeCode("getstatic java/lang/System/out Ljava/io/PrintStream;");
            writeCode("aaload " + std::to_string(lista_simbolos["int_expr"].first ));
            writeCode("invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V");*/
        }else if($3.sType == E_CONCAT){
            writeCode("getstatic      java/lang/System/out Ljava/io/PrintStream;");
            writeCode("getstatic      test/message Ljava/lang/String;");
            writeCode("invokevirtual  java/io/PrintStream/println(Ljava/lang/String;)V");
            writeCode("pop");
        }
    };





function_block: T_LEFT_BLOCK {
        printf("\033[0;34mBloco de função\033[0m\n");
    } marker statement_set goto T_RIGHT_BLOCK{
        $$.initMarker = $3;
        $$.endMarker = $5;
        $$.nextList = $4.nextList;
    }
    | marker statement goto {
        printf("\033[0;34mFunção sem bloco\033[0m\n");
        $$.initMarker = $1;
        $$.endMarker = $3;
        $$.nextList = $2.nextList;
    }
    ;


declaracao_funcao: primitive_type funcao_scope T_LEFT_PARENTHESES funcao_args T_RIGHT_PARENTHESES function_block {printf("\033[0;34mSintático declara de funcao\033[0m\n");};
funcao_scope: T_RESERVED | T_ID;
funcao_args: declaracao T_EXPR_SEPARATOR funcao_args
	                      | declaracao;


chamada_funcao: funcao_scope T_LEFT_PARENTHESES funcao_args T_RIGHT_PARENTHESES T_SEPARATOR {printf("\033[0;34mSintático chamada de funcao\033[0m\n");};






when: {
    if(!varExists(std::string("switch_temp"))){defineVariable(std::string("switch_temp"),E_INT,0);}
    else{
        writeCode("ldc 0");
        writeCode("istore " + std::to_string(lista_simbolos[std::string("switch_temp")].first));
    }
    }
    T_SWITCH T_LEFT_PARENTHESES expression {
        printf("\033[0;34mSintático When/Switch\033[0m\n");
    } T_RIGHT_PARENTHESES T_LEFT_BLOCK switch_statement_set T_RIGHT_BLOCK {
        
    };

switch_statement_set: switch_statement {
    $$.nextList = $1.nextList;
} | switch_statement marker switch_statement_set {
    backpatch($1.nextList,$2);
    $$.nextList = merge($1.nextList,$3.nextList);
} | T_CONT_CONDICIONAL {
        writeCode("pop");
        writeCode("iload " + std::to_string(lista_simbolos[std::string("switch_temp")].first));
        writeCode("ldc 0");
        writeCode(getOp("==")+ " "+getLabel());
        writeCode("goto "+getLabel(labelsCount+1));
    } T_ARROW_RIGHT function_block {
    //writeCode(getOp("==")+ " "+getLabel());
    std::vector<int> * v = new std::vector<int> ();
    $$.nextList = v;
    $$.nextList->push_back($4.endMarker);
    backpatch(v,labelsCount);
    $$.nextList = merge($$.nextList,$4.nextList);
};

switch_statement: {
        writeCode("dup");
    }
    expression {
        writeCode(getOp("==")+ " "+getLabel());
        writeCode("goto "+getLabel(labelsCount+2));
    }marker T_ARROW_RIGHT {
        writeCode("ldc 1");
        writeCode("istore " + std::to_string(lista_simbolos[std::string("switch_temp")].first));
    } function_block {
        
        std::vector<int> * v = new std::vector<int> ();
        $$.nextList = v;
        $$.nextList->push_back($7.endMarker);
        $$.nextList = merge($$.nextList,$7.nextList);
    };




//             1         2            3                4         5                      6                7         8
//          marker  WHILE_WORD LEFT_BRACKET       b_expression RIGHT_BRACKET       LEFT_BRACKET_CURLY  marker statement_list RIGHT_BRACKET_CURLY
loop_while: T_WHILE marker     T_LEFT_PARENTHESES b_expression T_RIGHT_PARENTHESES function_block{
    printf("\033[0;34mSintático While\033[0m\n");
    writeCode("goto " + getLabel($2));
    backpatch($6.nextList,$2);
    backpatch($4.trueList,$6.initMarker);
    $$.nextList = $4.falseList;
    deleteCode(1);
    //$$.nextList->push_back($6.endMarker);
};



primitive_type: T_INT { $$ = E_INT;} ;
primitive_type: T_BOOL{ $$= E_BOOL;};

//          1          2                3             4                   5             6         7        8        9     10             11              12       13          14    15
//        FOR_WORD LEFT_BRACKET       assignment    marker              b_expression SEMI_COLON marker assignment goto RIGHT_BRACKET LEFT_BRACKET_CURLY marker statement_list goto RIGHT_BRACKET_CURLY
loop_for: T_FOR    T_LEFT_PARENTHESES loop_for_cond T_RIGHT_PARENTHESES function_block {
    printf("\033[0;34mSintático For\033[0m\n");
    backpatch($3.trueList,$5.initMarker);
    std::vector<int> * v = new std::vector<int> ();
    v->push_back($3.endMarker);
    backpatch(v,$3.initMarker);
    v = new std::vector<int>();
    v->push_back($5.endMarker);
    backpatch(v,$3.midMarker);
    backpatch($5.nextList,$3.midMarker);
    $$.nextList = $3.falseList;
    };


loop_for_cond: loop_for_dec T_SEPARATOR marker b_expression T_SEPARATOR marker loop_for_inc goto {
    $$.trueList = $4.trueList;
    $$.falseList = $4.falseList;
    $$.initMarker = $3;
    $$.midMarker = $6;
    $$.endMarker = $8;
};
loop_for_dec: 
    declaracao { $$.nextList = $1.nextList; } 
    | assign { $$.nextList = $1.nextList; }
    | {std::vector<int> * v = new std::vector<int> ();$$.nextList = v;};
loop_for_inc: 
    incremento { $$.nextList = $1.nextList; }
    | assign { $$.nextList = $1.nextList; }
    | {std::vector<int> * v = new std::vector<int> ();$$.nextList = v;};



        // 1        2            4            5         6              7                8             9
loop_do: T_DO function_block{
        deleteCode(0);      } T_WHILE T_LEFT_PARENTHESES marker b_expression T_RIGHT_PARENTHESES T_SEPARATOR {
        printf("\033[0;34mSintático Do while\033[0m\n");
        backpatch($2.nextList,$6);
        backpatch($7.trueList,$2.initMarker);
        $$.nextList = $7.falseList;
        //writeCode("goto " + getLabel($6));
    };

b_expression: BOOL {
		if($1){
			$$.trueList = new std::vector<int> ();
			$$.trueList->push_back(codeList.size());
			$$.falseList = new std::vector<int>();
			writeCode("goto ");
		}else{
			$$.trueList = new std::vector<int> ();
			$$.falseList= new std::vector<int>();
			$$.falseList->push_back(codeList.size());
			writeCode("goto ");
		}
	}
    | b_expression T_BOOL_OP marker b_expression {
		if(!strcmp($2, "and")) {
			backpatch($1.trueList, $3);
			$$.trueList = $4.trueList;
			$$.falseList = merge($1.falseList,$4.falseList);
		} else if (!strcmp($2,"or")){
			backpatch($1.falseList,$3);
			$$.trueList = merge($1.trueList, $4.trueList);
			$$.falseList = $4.falseList;
		}
	}
	| expression T_LOGIC_OPERATOR expression {
        if($1.sType == E_INT && $3.sType == E_INT){
            std::string op($2);
            $$.trueList = new std::vector<int>();
            $$.trueList ->push_back(codeList.size());
            $$.falseList = new std::vector<int>();
            $$.falseList->push_back(codeList.size()+1);
            writeCode(getOp(op)+ " ");
            writeCode("goto ");
        }else{
            std::string err = "Tipo incorreto na expressao";
            yyerror(err.c_str());
        }
	}
	;




//              1                 2              3              4                5          6          7        8
//                                                                           T_LEFT_BLOCK marker statement_set goto T_RIGHT_BLOCK
logico_if: T_CONDICIONAL T_LEFT_PARENTHESES b_expression T_RIGHT_PARENTHESES function_block if_else {
        if($6.returnMarker == labelsCount-1)
            printf("\033[0;34mSintático logico_if sem else\033[0m\n");
        backpatch($3.trueList,$5.initMarker);
        backpatch($3.falseList,$6.returnMarker);
        $$.nextList = merge($5.nextList, $6.nextList);
        $$.nextList->push_back($5.endMarker);
    };
if_else: T_CONT_CONDICIONAL function_block {
        printf("\033[0;34mSintático logico_if com else\033[0m\n");
        $$.returnMarker = $2.initMarker;
        $$.nextList = $2.nextList;
        popCode(1);
        //$$.nextList->push_back($8);
    } | {
        $$.returnMarker = labelsCount;
        std::vector<int> * v = new std::vector<int>();
        $$.nextList =v;
    }
    ;



assign: 
    T_ID T_ASSIGN expression {
        printf("\033[0;34mSintático atribuição\033[0m\n");
        std::string str($1);
        if(checkId(str)){
            if($3.sType == E_INT){
                writeCode("istore " + std::to_string(lista_simbolos[str].first));
            }
        }else{
            std::string err = "identifier: "+str+" isn't declared in this scope";
            yyerror(err.c_str());
        }
    };



declaracao: primitive_type T_ID T_ASSIGN expression {
        printf("\033[0;34mSintático atribuição com valor\033[0m\n");
        std::string str($2);
        if($1 == E_INT){
            defineVariable(str,E_INT,1);
            writeCode("istore " + std::to_string(lista_simbolos[str].first));
        }
    }
    | primitive_type T_ID {
        printf("\033[0;34mSintático atribuição\033[0m\n");
        std::string str($2);
        if($1 == E_INT){
            defineVariable(str,E_INT,0);
        }
    };

incremento: T_ID T_INCREMENT {
        printf("\033[0;34mIncremento\033[0m\n");
        std::string str($1);
        if(checkId(str)){
            writeCode("iload " + std::to_string(lista_simbolos[str].first));
            writeCode("ldc 1");
            if($2 == 1){
                writeCode("iadd");
            }else if($2 == 0){
                writeCode("isub");
            }
            writeCode("istore "+std::to_string(lista_simbolos[str].first));
        }else{
            std::string err = "identifier: "+str+" isn't declared in this scope";
            yyerror(err.c_str());
        }
    } | T_ID T_SELF_ASSIGN expression {
        printf("\033[0;34mIncremento em numero\033[0m\n");
        std::string str($1);
        if(checkId(str)){
            writeCode("iload " + std::to_string(lista_simbolos[str].first));
            arithCast(std::string($2));
            writeCode("istore "+std::to_string(lista_simbolos[str].first));
        }else{
            std::string err = "identifier: "+str+" isn't declared in this scope";
            yyerror(err.c_str());
        }
    };




comentario: T_SLC {printf("\033[0;34mSintatico Comentário unica linha\033[0m\n");}
    | T_MLC_START comm_ml T_MLC_END {printf("\033[0;34mSintatico Comentário multi-linhas\033[0m\n");};

comm_ml: T_COMMENT_C comm_ml | ;

expression: INT {
        $$.sType = E_INT;
        writeCode("ldc "+std::to_string($1));
    }
    | T_STRING {
        $$.sType = E_STR;
        std::string str($1);
        writeCode("ldc "+str);
    }
    | BOOL {
        $$.sType = E_BOOL;
        writeCode("ldc "+std::to_string($1));
    }
    | T_ID {
        std::string str($1);
        if(checkId(str)){
            $$.sType = lista_simbolos[str].second;
            if(lista_simbolos[str].second == E_INT){
                writeCode("iload " + std::to_string(lista_simbolos[str].first));
            }
        }else{
            std::string err = "id: "+str+" fora do escopo";
            yyerror(err.c_str());
        }
    }
    | expression T_ARITH_OP expression {
        if($1.sType == E_INT && $3.sType == E_INT){
            $$.sType = E_INT;
            arithCast(std::string($2));
        }else{
            $$.sType = E_CONCAT;
            call_converter($1.sType,$3.sType);
        }
    }
    | T_LEFT expression T_RIGHT {
        $$.sType = $2.sType;
    }
    ;



%%

/*

| expr T_PLUS expression                { $$ = $1 + $3; }
    | expr T_MINUS expression                { $$ = $1 - $3; }
    | expr T_MULTIPLY expression            { $$ = $1 * $3; }
    | expr T_DIVIDE expression                { $$ = $1 / $3; }
    | expression T_PLUS expr                { $$ = $1 + $3; }
    | expression T_MINUS expr                { $$ = $1 - $3; }
    | expression T_MULTIPLY expr            { $$ = $1 * $3; }
    | expression T_DIVIDE expr                { $$ = $1 / $3; }
    | expr T_DIVIDE expr                        { $$ = $1 / (float)$3; }

expr: INT                                    { $$ = $1; }
    | expr T_PLUS expr                        { $$ = $1 + $3; }
    | expr T_MINUS expr                        { $$ = $1 - $3; }
    | expr T_MULTIPLY expr                    { $$ = $1 * $3; }
    | T_LEFT expr T_RIGHT                    { $$ = $2; }
    ;

line: T_NEWLINE
    | expression T_NEWLINE                    { printf("\tResultado: %f\n", $1);}
    | expr T_NEWLINE                            { printf("\tResultado: %i\n", $1); }
    | T_QUIT T_NEWLINE                        { printf("Até mais...\n"); exit(0); }
    ;

*/

/* int main( argc, argv )
int argc;
char **argv;
{ */


void printCode(void){
    for ( int i = 0 ; i < codeList.size() ; i++){
        fout<<codeList[i]<<std::endl;
    }
}

void yyerror(const char* s) {
    fprintf(stderr, "Erro de análise (sintática): -- %s --\n", s);
    exit(1);
}


int main (int argc, char * argv[]){
    --argc, ++argv;
    if ( argv > 0 ){
        yyin = fopen( argv[0], "r" );
        outfileName = std::string(argv[0]);
    }else{
        yyin = stdin;
        outfileName = "input_code.txt";
    }
    do {
        yyparse();
    } while(!feof(yyin));
    printCode();

    return 0;
}