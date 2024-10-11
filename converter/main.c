#include "stdio.h"
#include "clang-c/CXString.h"
#include "clang-c/Index.h"
#include <stdint.h>
#include "stdint.h"
#include "stdbool.h"
#include "stdlib.h"
#include "string.h"


int numtoskip = 0;
int litcount=0;
bool skipcomma = false;

typedef struct  {
 char* definition;
 struct xliteral* next;
} xliteral;

xliteral* literals;
void makestrliteral(const char* decl) {
  xliteral* newlit = (xliteral*)malloc(sizeof(xliteral));
  newlit->definition=(char*)malloc(strlen(decl)+26+12+1);
  sprintf(newlit->definition,"_G.lit_%i = _G.smemstring(%s)",litcount,decl);
  newlit->next = literals;
  literals = newlit;
};
void make32literal(int decl) {
  xliteral* newlit = (xliteral*)malloc(sizeof(xliteral));
  newlit->definition=(char*)malloc(26+12+12);
  sprintf(newlit->definition,"_G.lit_%i = _G.smemint(%i)",litcount,decl);
  newlit->next = literals;
  literals = newlit;
};
void make16literal(int decl) {
  xliteral* newlit = (xliteral*)malloc(sizeof(xliteral));
  newlit->definition=(char*)malloc(26+12+12);
  sprintf(newlit->definition,"_G.lit_%i = _G.smemshort(%i)",litcount,decl);
  newlit->next = literals;
  literals = newlit;
};
void make8literal(int decl) {
  xliteral* newlit = (xliteral*)malloc(sizeof(xliteral));
  newlit->definition=(char*)malloc(26+12+12);
  sprintf(newlit->definition,"_G.lit_%i = _G.smembyte(%i)",litcount,decl);
  newlit->next = literals;
  literals = newlit;
};
bool isCompounded = false;
enum CXChildVisitResult compound( CXCursor cursor, CXCursor parent, CXClientData clientData) {
  enum CXCursorKind kind = clang_getCursorKind(cursor);
  isCompounded = false;
  if (kind==CXCursor_CompoundStmt) {
    isCompounded = true;
  }
  if (kind==CXCursor_ParmDecl) {
    return CXChildVisit_Continue;
  }
  return CXChildVisit_Break;
}

FILE* fout;
enum CXChildVisitResult visitor( CXCursor cursor, CXCursor parent, CXClientData clientData)
{
  if (numtoskip) {
    numtoskip--;
    return CXChildVisit_Recurse; 
  } 

  
  CXSourceLocation location = clang_getCursorLocation( cursor );

  CXString sname = clang_getCursorSpelling(cursor);
  CXString skind = clang_getCursorKindSpelling(cursor.kind);
  enum CXCursorKind kind = clang_getCursorKind(cursor);
  
  for(int i = 0;i<(int)clientData;i++) {
    printf("  ");
  } 
  printf("%i, %s: %s\n",clientData, clang_getCString(skind), clang_getCString(sname));

  
  int num_args = clang_Cursor_getNumArguments(cursor);
  CXEvalResult res = clang_Cursor_Evaluate(cursor);

  int cd = (int)clientData;

  switch (kind) {
  case CXCursor_CallExpr:
  case CXCursor_DeclRefExpr:
  case CXCursor_StringLiteral:
  case CXCursor_FloatingLiteral:
  case CXCursor_IntegerLiteral:
    if (cd==-1) {
    if (!skipcomma) {
      fprintf(fout,", ");
    }
    skipcomma = false;
  }
  break;
  case CXCursor_CompoundStmt:
    printf("%i\n",cd);
    if (cd==-1) {
      fprintf(fout,") then \n");
    }
    break;
  default:
    break;
  }

   
  switch (kind) {
  case CXCursor_FunctionDecl:
    clang_visitChildren( cursor, compound, 0);
    //printf("func %s, num_args: %i\n",clang_getCString(sname),num_args);

    if (isCompounded) {
      //fprintf(fout, "if _G.%s==nil then\n",clang_getCString(sname));
      fprintf(fout,"function _G.%s(",clang_getCString(sname));


            for (int i = 0; i < num_args; ++i) {
        CXCursor arg_cursor = clang_Cursor_getArgument(cursor, i);
        CXString arg_name = clang_getCursorSpelling(arg_cursor);
        CXType arg_type = clang_getCursorType(arg_cursor);

        if (i!=0) {
          fprintf(fout, ", ");
        }
        fprintf(fout, "%s", clang_getCString(arg_name));
        clang_disposeString(arg_name);
      }
      fprintf(fout,")\n");
      clang_visitChildren( cursor, visitor, (void*)((int)clientData+1));
      //fprintf(fout,"end\n");
    }
    
    return CXChildVisit_Continue;
    

  case CXCursor_VarDecl:
    CXType type = clang_getCursorType(cursor);
    int sz = clang_Type_getSizeOf(type);
    if (sz==1) {
      make8literal(0);
      fprintf(fout, "_G.membyte(_G.lit_%i,_G.memgetbyte(",litcount);

    }
    if (sz==2) {
      make16literal(0);
      fprintf(fout, "_G.memshort(_G.lit_%i,_G.memgetshort(",litcount);
    }
    if (sz==4) {
      make32literal(0);
      fprintf(fout, "_G.memint(_G.lit_%i,_G.memgetint(",litcount);
    }
    litcount++;
    // get what it equals to
    clang_visitChildren( cursor, visitor, (void*)(int)clientData+1);

    fprintf(fout, "))\n"); 
    return CXChildVisit_Continue;

  case CXCursor_CallExpr:
    fprintf(fout, "_G.%s(",clang_getCString(sname)); 
    num_args = clang_Cursor_getNumArguments(cursor);
    // first 2 of them are garbage
    numtoskip=2;
    // idk how to make it not write a comma at first
    skipcomma = true;
    clang_visitChildren( cursor, visitor, (void*)(int)-1);

    fprintf(fout, ")\n"); 
    return CXChildVisit_Continue;

  case CXCursor_DeclRefExpr:
    fprintf(fout, "%s", clang_getCString(sname));
    break;


  case CXCursor_StringLiteral:
    fprintf(fout, "_G.lit_%i",litcount);
    makestrliteral(clang_getCString(sname));
    litcount++;
    break;
  case CXCursor_IntegerLiteral:
    int value = clang_EvalResult_getAsInt(res);
    make32literal(value);
    fprintf(fout,"_G.lit_%i",litcount);
    litcount++;
    clang_EvalResult_dispose(res);

    break;
  case CXCursor_CharacterLiteral:
    int valuec = clang_EvalResult_getAsInt(res);
    make8literal(valuec);
    fprintf(fout,"_G.lit_%i",litcount);
    litcount++;
    clang_EvalResult_dispose(res);
    break; 

  case CXCursor_FloatingLiteral:
    double value2 = clang_EvalResult_getAsDouble(res);
    int valuei = *(int*)&value2;
    fprintf(fout,"_G.lit_%i)",litcount);
    make32literal(valuei);
    litcount++;
    clang_EvalResult_dispose(res);
    break;

  case CXCursor_ReturnStmt:

    fprintf(fout, "\nreturn "); 
    clang_visitChildren( cursor, visitor, (void*)((int)clientData+1));

    return CXChildVisit_Continue;

  case CXCursor_CompoundStmt:
    clang_visitChildren( cursor, visitor, (void*)((int)clientData+1));
    fprintf(fout, "\nend\n"); 

    return CXChildVisit_Continue;

  case CXCursor_IfStmt:
    fprintf(fout,"if(");

    clang_visitChildren( cursor, visitor, (void*)(int)-1);
    return CXChildVisit_Continue;
  case CXCursor_BinaryOperator:
    enum CXBinaryOperatorKind bk = clang_getCursorBinaryOperatorKind(cursor);
    CXString bks = clang_getBinaryOperatorKindSpelling(bk);
    printf("%s\n",clang_getCString(bks));
    clang_visitChildren( cursor, visitor, (void*)((int)clientData+1));
    return CXChildVisit_Continue;



  default:
    break;
  }

  return CXChildVisit_Recurse; 
}

//#define TESTING
int main(int argc, char** argv) {


  if (argc<2) {
    printf("argc is less than 2\n");
    return -2;
  }
  const char* outputfile = "compiled.client.lua";
  fout = fopen(outputfile,"w");
  fclose(fout);

  fout = fopen(outputfile, "a");
  CXIndex index = clang_createIndex(0,1);
  

  // native scripts
  fprintf(fout, "--!native \n");
  // we are using module scripts for everything
  fprintf(fout, "wait() -- code:\n");

  for (int i = 1;i<argc;i++) {
    CXTranslationUnit unit = clang_parseTranslationUnit(index,
         argv[i],0,0,0,0,CXTranslationUnit_None);
      if (!unit) {
      clang_disposeIndex(index);
      printf("failed to open translation unit: %s\n", argv[i]);
      return -1;
    }

    CXCursor root = clang_getTranslationUnitCursor(unit);
    clang_visitChildren(root,visitor,0);
    clang_disposeTranslationUnit(unit);
  }


  fprintf(fout, "wait() -- data:\n");
  for(xliteral* lit = literals; lit;lit=lit->next) {
    fprintf(fout, "%s\n",lit->definition);
  }

  fclose(fout);

  clang_disposeIndex(index);
  return 0;
}
