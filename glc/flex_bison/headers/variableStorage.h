#ifndef LIBS
#define LIBS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#endif


struct char_node{
  char val;
  int index;
  int isStart;
  struct char_node **childArray;
  size_t size; //Size of child array

};
typedef struct char_node charNode;

typedef struct data_struct{
    int integerValue;
    char *stringValue;
    float floatValue;
    char type[10];
    struct operation_node *opNode;
}Data;


//Data Flow
//If an operator is a variable then Op is a pointer. If it is a literal it is a value.
typedef struct operation_node{
  char *operator; //Operator of the operation
  Data *leftOp;   //Points to the left operator Data object (Variable Data or Result of a previous operation)
  Data *rightOp;  //Points to the right operator Data object (Variable Data or Result of a previous operation)
  Data *result;   //Points to the variable or the next opNode Data object
  int priority;   //Determines the priority of operation 1->Highest
  int isFinal;    //Signals if the node points to the final variable (destination of all operations)  
}operationNode;

typedef struct op_array{
  operationNode *array;
  size_t size;
  size_t used;
}opArray;

typedef struct{
    Data *array;
    char *type;
    size_t used;
    size_t size;
}varArray;

//Tree start node
extern charNode *startNode;

//Variable List
extern Data varData;
extern varArray variableArray;

extern opArray opNodeArray;


//These are temporary stacks used for structuring the priority of operations.
//When all of the operations have been transfeded(copyed) to the main array(opNodeArray) the stacks are cleared for the next operation 
opArray opNodeStack;
opArray tempOpNodeStack;


void opNodeArray_init(){
  opNodeArray.array = (operationNode*)malloc(sizeof(operationNode));
  opNodeArray.size = 1;
  opNodeArray.used = 1;

  opNodeStack_init();
}


//-------------Operation Node Stack Functions-------------//
void opNodeStack_init(){
  //Init stack
  opNodeStack.array = (operationNode*)malloc(sizeof(operationNode));
  opNodeStack.size = 1;
  opNodeStack.used = 1;

  //Temp stack init
  tempOpNodeStack.array = (operationNode*)malloc(sizeof(operationNode));
  tempOpNodeStack.size = 1;
  tempOpNodeStack.used = 1;
}

void opNodeStack_destroy(){
  free(opNodeStack.array);
  opNodeStack.size = 0;
  opNodeStack.used = 0;
}

void tempOpNodeStack_push(){

}

void tempOpNodeStack_transfer(){

}

//Problem: In this current implementation the code works only with operations between variables and not literals
//TODO: Add a literal storage structure
operationNode opNode_create(Data leftVar, Data rightVar, char *leftVarName, char *rightVarName, char *operator, int isFinal, int priority){
  operationNode opNode;

  opNode.operator = (char*)malloc(sizeof(char)*strlen(operator));
  strcpy(opNode.operator, operator);

  opNode.isFinal = isFinal;
  opNode.priority = priority;

  //opNode.result = &variableArray.array[lookup(startNode, resultVar)];

  if(!strcmp(leftVarName, "")){
    opNode.leftOp = (Data*)malloc(sizeof(Data));
    opNode.leftOp = &leftVar;
  }
  else if(strcmp(leftVarName, "")){
    opNode.leftOp = &variableArray.array[lookup(startNode, leftVarName)];
  }

  if(!strcmp(rightVarName, "")){
    opNode.rightOp = (Data*)malloc(sizeof(Data));
    opNode.rightOp = &rightVar;
  }
  else if(strcmp(rightVarName, "")){
    opNode.rightOp = &variableArray.array[lookup(startNode, rightVarName)];
  }

  return opNode;

}


void opStack_push(operationNode opNode){
  if(opNodeStack.used == opNodeStack.used){
    opNodeStack.size++;
    opNodeStack.array = (operationNode*)realloc(opNodeStack.array, opNodeStack.size*sizeof(operationNode));
  }
  opNodeStack.array[opNodeStack.used] = opNode;
  opNodeStack.used++;

}

operationNode opStack_pop(){
  operationNode opNode = opNodeStack.array[opNodeStack.used];
  //Delete last element
  opNodeStack.used--;
  opNodeStack.size--;
  opNodeStack.array = (operationNode*)realloc(opNodeStack.array, opNodeStack.size*sizeof(operationNode));
  return opNode;
}
//--------------------------------------------------------//



void addOpNode(char *resultVar, char *operator, int isFinal){
  int varIndex = lookup(startNode, resultVar);
  operationNode *opNode = (operationNode*)malloc(sizeof(operationNode));
  opNode->operator = (char*)malloc(sizeof(char)*strlen(operator));
  strcpy(opNode->operator, operator);

  //If isFinal the result pointer (Data *result) is pointing to the variable's data object.
  //If !isFinal the result pointer (Data *result) is allocated with malloc as it will be pointed to by an other opNode
  //Left and Right data are left un-allocated. Left free to be linked by the operation linker

  if(isFinal){
    opNode->result = &variableArray.array[varIndex]; //Linking the opNode result to the variable data
    variableArray.array[varIndex].opNode = opNode; //Linking the variables data to the operation
  }
  else{
    opNode->result = (Data*)malloc(sizeof(Data));
  }

}



void addTreePath(charNode *startNode, char *name, int index){
  charNode *currentNode = startNode;
  charNode *nextNode;
  for(int i = 0; i < strlen(name); i++){
      for(int j = 0; j < currentNode->size; j++){
        if(currentNode->childArray[j] != 0){ //If the pointer s not null
          if(currentNode->childArray[j]->val == name[i]){ //Follow the name characters down the tree
            nextNode = currentNode->childArray[j];
            currentNode = nextNode;
          }
        }
      for(int k = 0; k < currentNode->size; k++){//Add a node to the next available entry
        if(currentNode->childArray[k] == 0){ //Find the next NULL pointer
          //Initialise new Node
          currentNode->childArray = (charNode**)realloc(currentNode->childArray, (currentNode->size+1)*sizeof(charNode*)); //Grow the child array by 1
          currentNode->size++;
          currentNode->childArray[k] = (charNode*)malloc(sizeof(charNode)); //Initialize child node
          currentNode = currentNode->childArray[k];
          currentNode->val = name[i];
          currentNode->isStart = 0;
          currentNode->index = index;
          currentNode->childArray = (charNode**)malloc(sizeof(charNode*)); //Initialise the child's childArray
          currentNode->size = 1;
          break;
        }
      }
    }
  }
}


int lookup(charNode *startNode, char *name){ //Returns the index of a variable in the variableArray
  charNode *currentNode = startNode;
  charNode *nextNode;
  int found = 0;

  for(int i = 0; i < strlen(name); i++){
    for(int j = 0; j < currentNode->size; j++){
      found = 0;
      if(currentNode->childArray[j] != 0){ //If the pointer s not null
          if(currentNode->childArray[j]->val == name[i]){ //Follow the name characters down the tree
            nextNode = currentNode->childArray[j];
            currentNode = nextNode;
            found = 1;
          }
        }
    }
  }
  if(found){
    return currentNode->index;
  }
  else{
    exit(0);
    return 0;
  }
}

int varArray_init(){
    //variableArray = (varArray*)malloc(sizeof(varArray));
    variableArray.array = (Data*)malloc(sizeof(Data));
    variableArray.used = 1;
    variableArray.size = 1;

    startNode = (charNode*)malloc(sizeof(charNode));
    startNode->isStart = 1;
    startNode->index = 0;
    startNode->childArray = (charNode**)malloc(sizeof(charNode*));
    startNode->size = 1;

    opNodeArray_init();
}

void varArray_append(varArray *arr, Data data, char *name){
    if(arr->used == arr->size){
        arr->size++;
        arr->array = (Data*)realloc(arr->array, arr->size * sizeof(Data));
    }
    arr->array[arr->used].integerValue = data.integerValue;
    arr->array[arr->used].floatValue = data.floatValue;
    if(data.stringValue != NULL){
      arr->array[arr->used].stringValue = (char*)malloc(strlen(data.stringValue)*sizeof(char));
      strcpy(arr->array[arr->used++].stringValue, data.stringValue);
    }

    addTreePath(startNode, name, arr->used);
    arr->used++;
    


}
    
void varArray_destroy(varArray *arr){
    free(arr->array);
    arr->array = NULL;
    arr->used = 0;
    arr->size = 0;
}
