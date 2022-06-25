#ifndef LIBS
#define LIBS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#endif

//Data Flow
typedef struct operation_node{
  char *operator; //If operator is '=' Then only the right operand is used. The left operand is the Data that holds the pointer to this object
  struct operation_node *leftOperand; //the operation happens between the 2 operands.
  struct operation_node *rightOperand; 
}operationNode;

struct char_node{
  char val;
  int index;
  int isStart;
  struct char_node **childArray;

};
typedef struct char_node charNode;

typedef struct{
    int integerValue;
    char *stringValue;
    float floatValue;
    char type[10];
    operationNode *operation; //Operation result = value (integer, float or string)
}Data;


typedef struct{
    Data *array;
    char *type;
    size_t used;
    size_t size;
}varArray;



/*Extern Variables*/
extern charNode *startNode;

extern Data varData;
extern varArray variableArray;

void addTreePath(charNode *startNode, char *name, int index){
  charNode *currentNode = startNode;
  charNode *nextNode;
  for(int i = 0; i < strlen(name); i++){
      for(int j = 0; j < sizeof(currentNode->childArray)/sizeof(charNode*); j++){
        if(currentNode->childArray[j] != 0){ //If the pointer s not null
          if(currentNode->childArray[j]->val == name[i]){ //Follow the name characters down the tree
            nextNode = currentNode->childArray[j];
            currentNode = nextNode;
          }
        }
      for(int k = 0; k < sizeof(currentNode->childArray)/sizeof(charNode*); k++){//Add a node to the next available entry
        if(currentNode->childArray[k] == 0){ //Find the next NULL pointer
          //Initialise new Node
          currentNode->childArray = (charNode**)realloc(currentNode->childArray, (k+1)*sizeof(charNode*)); //Grow the child array by 1
          currentNode->childArray[k] = (charNode*)malloc(sizeof(charNode)); //Initialize child node
          currentNode = currentNode->childArray[k];
          currentNode->val = name[i];
          currentNode->isStart = 0;
          currentNode->index = index;
          currentNode->childArray = (charNode**)malloc(sizeof(charNode*)); //Initialise the child's childArray
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
    for(int j = 0; j < sizeof(currentNode->childArray)/sizeof(charNode*); j++){
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
