#include "stdio.h"
#include "clang-c/CXString.h"
#include "clang-c/Index.h"
#include <stdint.h>
#include "stdint.h"
#include "stdbool.h"


int numtoskip = 0;
bool skipcomma = false;
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
  
  //for(int i = 0;i<(int)clientData;i++) {
  //  printf(" ");
  //} 
  //printf("%i, %s: %s\n",clientData, clang_getCString(skind), clang_getCString(sname));


  int num_args = clang_Cursor_getNumArguments(cursor);
  CXEvalResult res = clang_Cursor_Evaluate(cursor);

  switch (kind) {
  case CXCursor_CallExpr:
  case CXCursor_DeclRefExpr:
  case CXCursor_StringLiteral:
  case CXCursor_FloatingLiteral:
  case CXCursor_IntegerLiteral:
  int cd = (int)clientData;
  if (cd==-1) {
    if (!skipcomma) {
      fprintf(fout,", ");
    }
    skipcomma = false;
  }
  default:
    break;
  }


  switch (kind) {
  case CXCursor_FunctionDecl:
    fprintf(fout,"function module.%s(",clang_getCString(sname));
          //printf("func %s, num_args: %i\n",clang_getCString(sname),num_args);
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

    fprintf(fout,"\nend\n");
    return CXChildVisit_Continue;

  case CXCursor_VarDecl:
    fprintf(fout, "local %s = ",clang_getCString(sname)); 
    clang_visitChildren( cursor, visitor, (void*)(int)clientData+1);
    fprintf(fout, "\n"); 
    return CXChildVisit_Continue;

  case CXCursor_CallExpr:
    fprintf(fout, "%s(",clang_getCString(sname)); 
    num_args = clang_Cursor_getNumArguments(cursor);
    numtoskip=2;
    skipcomma = true;
    //printf("func %s, num_args: %i\n",clang_getCString(sname),num_args);
    clang_visitChildren( cursor, visitor, (void*)(int)-1);

    fprintf(fout, ")\n"); 
    return CXChildVisit_Continue;

  case CXCursor_DeclRefExpr:
    fprintf(fout, "%s", clang_getCString(sname));
    break;


  case CXCursor_StringLiteral:
    fprintf(fout, "%s", clang_getCString(sname));
    break;
  case CXCursor_IntegerLiteral:
    int value = clang_EvalResult_getAsInt(res);
    fprintf(fout,"%i",value);
    clang_EvalResult_dispose(res);
    break;

  case CXCursor_FloatingLiteral:
    double value2 = clang_EvalResult_getAsDouble(res);
    fprintf(fout,"%f",value2);
    clang_EvalResult_dispose(res);
    break;

  case CXCursor_ReturnStmt:

    fprintf(fout, "return "); 
    clang_visitChildren( cursor, visitor, (void*)((int)clientData+1));

    return CXChildVisit_Continue;

  default:
    break;
  }


  return CXChildVisit_Recurse; 
}

int main(int argc, char** argv) {
  fout = fopen("test.client.lua","w");
  fclose(fout);
  fout = fopen("test.client.lua", "a");
  CXIndex index = clang_createIndex(0,1);
  CXTranslationUnit unit = clang_parseTranslationUnit(index,
      "test.c",0,0,0,0,CXTranslationUnit_None);
  if (!unit) {
    return -1;
  }

  CXCursor root = clang_getTranslationUnitCursor(unit);


  // native scripts
  fprintf(fout, "--!native \n");
  // we are using module scripts for everything
  fprintf(fout, "local module = {}\n");
  clang_visitChildren(root,visitor,0);
  fprintf(fout, "return module\n");

  fclose(fout);
  printf("converted\n");

  clang_disposeTranslationUnit(unit);
  clang_disposeIndex(index);
  return 0;
}
