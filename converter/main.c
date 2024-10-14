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
  newlit->definition=(char*)malloc(strlen(decl)+128);
  sprintf(newlit->definition,"_G.lit_%i = _G.smemstring(%s)",litcount,decl);
  newlit->next = literals;
  literals = newlit;
};
void makeintliteral(int decl, int size) {
  xliteral* newlit = (xliteral*)malloc(sizeof(xliteral));
  newlit->definition=(char*)malloc(128);
  sprintf(newlit->definition,"_G.lit_%i = _G.push(%i,%i)",litcount,decl,size);
  newlit->next = literals;
  literals = newlit;
};


bool found=0;
int bytesa=0;
int bytesb=0;
int totaltofind=0;
enum CXChildVisitResult traverseany( CXCursor cursor, CXCursor parent, CXClientData clientData);


FILE* fout;
enum CXChildVisitResult traverseifchild( CXCursor cursor, CXCursor parent, CXClientData clientData) {
  clang_visitChildren(cursor,traverseany,clientData);
  return CXChildVisit_Break;
}

enum CXChildVisitResult getsizes( CXCursor cursor, CXCursor parent, CXClientData clientData) {
  CXType type = clang_getCursorType(cursor);
  int sz = clang_Type_getSizeOf(type);
  if (totaltofind==2) {
    bytesa = sz;
  } else if (totaltofind==1) {
    bytesb = sz;
  }
  totaltofind--;
  return CXChildVisit_Continue;
}

enum CXChildVisitResult lookforcompound( CXCursor cursor, CXCursor parent, CXClientData clientData) {
  enum CXCursorKind kind = clang_getCursorKind(cursor);
  found = 0;
  if (kind==CXCursor_CompoundStmt) {
    found = 1;
    return CXChildVisit_Break;
  }
  
  return CXChildVisit_Continue;

}

enum CXChildVisitResult lookforbinaryop( CXCursor cursor, CXCursor parent, CXClientData clientData) {
  enum CXCursorKind kind = clang_getCursorKind(cursor);
  found = 0;
  if (kind==CXCursor_BinaryOperator) {
    found = 1;
    return CXChildVisit_Break;
  }
  return CXChildVisit_Continue;
}
char* rs = 0;
enum CXChildVisitResult lookfordeclref( CXCursor cursor, CXCursor parent, CXClientData clientData) {
  enum CXCursorKind kind = clang_getCursorKind(cursor);
  CXString sname = clang_getCursorSpelling(cursor);

  found = 0;
  if (kind==CXCursor_DeclRefExpr) {
    found = 1;
    rs=clang_getCString(sname);
  }
}
int mode = 0;

CXCursor lastCursor;

enum CXChildVisitResult traverseany( CXCursor cursor, CXCursor parent, CXClientData clientData)
{
  CXSourceLocation location = clang_getCursorLocation( cursor );

  CXString sname = clang_getCursorSpelling(cursor);
  CXString skind = clang_getCursorKindSpelling(cursor.kind);
  enum CXCursorKind kind = clang_getCursorKind(cursor);

  if (kind==CXCursor_UnexposedExpr) return CXChildVisit_Recurse;
  if (numtoskip>0) {
    numtoskip--;
    return CXChildVisit_Continue;
    //goto cont;
  }

  if ((int)clientData==-1) {
    if (mode == 0) {
      fprintf(fout, ", ");
    }
    if (mode == 1) {
      mode = 0;
    }
  }
  int lastmode = mode;
  mode = lastmode;
  printf("%i\n",lastmode);

  int next = (int)clientData+1;
  
  //for(int i = 0;i<(int)clientData;i++) {printf("  ");};


  printf("%s\n", clang_getCString(skind));

  if (kind==CXCursor_CompoundStmt) {
    clang_visitChildren(cursor,traverseany,(CXClientData)next);
    goto cont; 
  }

  if (kind==CXCursor_VarDecl) {
    CXType type = clang_getCursorType(cursor);
    int sz = clang_Type_getSizeOf(type);


    fprintf(fout,"local %s = _G.lit_%i\n",clang_getCString(sname),litcount);
    makeintliteral(0,sz);
    //clang_visitChildren(cursor,traverseany,(CXClientData)next);
    litcount++;

    goto cont;
  }
  if (kind==CXCursor_DeclStmt) {
    clang_visitChildren(cursor,traverseany,(CXClientData)next);
    goto cont;
  }
  if (kind==CXCursor_DeclRefExpr) {

    fprintf(fout,"%s",clang_getCString(sname));
    clang_visitChildren(cursor,traverseany,(CXClientData)next);
    goto cont;
  }


  if (kind==CXCursor_FunctionDecl) {


    found = 0;
    clang_visitChildren(cursor,lookforcompound, (CXClientData)next);
    if (!found) {
      goto cont; 
    }


    fprintf(fout,"function _G.%s(",clang_getCString(sname));
    int num_args = clang_Cursor_getNumArguments(cursor);
    for (int i = 0; i < num_args; ++i) {
      CXCursor arg_cursor = clang_Cursor_getArgument(cursor, i);
      CXString arg_name = clang_getCursorSpelling(arg_cursor);
      CXType arg_type = clang_getCursorType(arg_cursor);

      printf("  Arg %d: %s (%s)\n", i + 1, 
      clang_getCString(arg_name),
      clang_getCString(clang_getTypeSpelling(arg_type)));

      clang_disposeString(arg_name);
      clang_disposeString(clang_getTypeSpelling(arg_type));
    }
    fprintf(fout, ")\n");
    clang_visitChildren(cursor,traverseany,(CXClientData)next);
    fprintf(fout, "\nend\n");

    goto cont; 
  };

  if (kind==CXCursor_ReturnStmt) {
    fprintf(fout,"return ");
    clang_visitChildren(cursor,traverseany,(CXClientData)next);
    fprintf(fout,"\n");
    goto cont; 
  }
  if (kind==CXCursor_ParenExpr) {
    clang_visitChildren(cursor,traverseany,(CXClientData)next);
    goto cont; 
  }

  if (kind==CXCursor_IfStmt) {
    fprintf(fout,"if (_G.getnum(");
    mode = 2;
    clang_visitChildren(cursor,traverseany,(CXClientData)-1);
    
    totaltofind=1;
    clang_visitChildren(cursor,getsizes,0);
    fprintf(fout,", %i)~=0) then\n",bytesb);
    numtoskip=1;

    mode = 2;
    clang_visitChildren(cursor,traverseany,(CXClientData)-1);
    fprintf(fout,"else\n");

    numtoskip=2;
    mode = 2;
    clang_visitChildren(cursor,traverseany,(CXClientData)-1);

    fprintf(fout,"end\n");
    mode = 0;
    goto cont; 

  }
  if (kind==CXCursor_WhileStmt) {
    totaltofind=1;
    clang_visitChildren(cursor,getsizes,0);


    fprintf(fout,"while(_G.getnum(");
    mode = 2;
    clang_visitChildren(cursor,traverseany,(CXClientData)-1);
    mode = 0;
    fprintf(fout,", %i)~=0) do\n",bytesb);
    numtoskip=1;
    mode = 2;
    clang_visitChildren(cursor,traverseany,(CXClientData)-1);

    mode = 0;
    fprintf(fout,"end\n");
    goto cont; 
  }

  if (kind==CXCursor_BinaryOperator) {
    enum CXBinaryOperatorKind kind = clang_getCursorBinaryOperatorKind(cursor);
    totaltofind=2;
    clang_visitChildren(cursor,getsizes,(CXClientData)-1);

    int biggestsz = bytesa>bytesa ? bytesa : bytesb;

    if (kind==CXBinaryOperator_Assign) {
       fprintf(fout,"_G.mov(",litcount);
       //litcount++;
       mode = 1;
       clang_visitChildren(cursor,traverseany,(CXClientData)-1);
       fprintf(fout, ", %i, %i)\n", bytesa,bytesb);
    }

    if (kind==CXBinaryOperator_Sub) {
      fprintf(fout,"_G.sub(");
      mode = 1;
      clang_visitChildren(cursor,traverseany,(CXClientData)-1);
      mode = 0;
      fprintf(fout,", %i, %i)",biggestsz,bytesa,bytesb);
    }
    else if (kind==CXBinaryOperator_Mul) {
      fprintf(fout,"_G.mul(");
      mode = 1;
      clang_visitChildren(cursor,traverseany,(CXClientData)-1);
      mode = 0;
      fprintf(fout,", %i, %i)",biggestsz,bytesa,bytesb);
    }
    else if (kind==CXBinaryOperator_Add) {
      fprintf(fout,"_G.add(");
      mode = 1;
      clang_visitChildren(cursor,traverseany,(CXClientData)-1);
      mode = 0;
      fprintf(fout,", %i, %i)",biggestsz,bytesa,bytesb);
    } 


    goto cont; 
  }
  if (kind==CXCursor_UnaryOperator) {
    enum CXUnaryOperatorKind kind = clang_getCursorUnaryOperatorKind(cursor);
    CXString opname = clang_getUnaryOperatorKindSpelling(kind);
    //printf("%s\n",clang_getCString(opname));

    if (kind==CXUnaryOperator_AddrOf) {
      fprintf(fout,"_G.addr(");
      clang_visitChildren(cursor,traverseany,(CXClientData)next);
      fprintf(fout,")");
    }
    if (kind==CXUnaryOperator_Deref) {
      fprintf(fout,"_G.deref(");
      clang_visitChildren(cursor,traverseany,(CXClientData)next);
      fprintf(fout,")");
    }
    goto cont;  
  }
  if (kind==CXCursor_IntegerLiteral) {
    CXType type = clang_getCursorType(cursor);
    int sz = clang_Type_getSizeOf(type);
    CXEvalResult res = clang_Cursor_Evaluate(cursor);
    int value = clang_EvalResult_getAsInt(res);
    makeintliteral(value,sz);
    fprintf(fout, "_G.lit_%i", litcount);
    litcount++;
    goto cont;  
  }
  return CXChildVisit_Recurse;
cont:
  mode = lastmode; 
  if (mode==2&&(int)clientData==-1) {
      lastCursor = cursor;
      return CXChildVisit_Break;
  }
  return CXChildVisit_Continue;

}

//#define TESTING
int main(int argc, char** argv) {


  if (argc<2) {
    printf("argc is less than 2\n");
    return -2;
  }
  const char* outputfile = "out/compiled.client.lua";
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
    clang_visitChildren(root,traverseany,0);
    clang_disposeTranslationUnit(unit);
  }


  fprintf(fout, "wait() -- data:\n");
  for(xliteral* lit = literals; lit;lit=lit->next) {
    fprintf(fout, "%s\n",lit->definition);
  }
  fprintf(fout,
"print(\"started\")\n"
"local out = _G.main()\n"
"print(\"ended\")\n"
"local num = 0\n"
"for i=0, 4-1 do\n"
"num=num+_G.mem[out+i]*math.pow(256,i)\n"
"end\n"
"print(num)\n"
  );

  fclose(fout);

  clang_disposeIndex(index);
  return 0;
}
