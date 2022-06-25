#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*   Variables   */
/*               */


typedef union Data{
    int integerValue;
    char characterValue;
    char *stringValue;
    float floatValue;
}Data;


typedef int (*Create)(Data* data);
typedef void (*Destroy)(Data* data);
typedef void (*SetInt)(Data* data, int value);
typedef void (*SetChar)(Data* data, char value);
typedef void (*SetString)(Data* data, char* value);
typedef void (*SetFloat)(Data* data, float value);

typedef struct variable{
    char* name;
    Data* data;
    //Functions
    Create create;
    Destroy destroy;
    SetInt setInt;
    SetChar setChar;
    SetString setString;
    SetFloat setFloat;
}variable;

int create(Data* data){
        data = (Data*)malloc(sizeof(Data));
        if(data){ //malloc sucess
            return 0;
        }
        else{//malloc fail
            return 1;
        }
    }

    void destroy(Data* data){
        free(data);
    }


    void setInt(Data* data, int value){
        data->integerValue = value;
    }

    void setChar(Data* data, char value){
        data->characterValue = value;
    }

    void setString(Data* data, char *value){
        data->stringValue = value;
    }

    void setFloat(Data* data, float value){
        data->floatValue = value;
    }


typedef struct varArray{
    variable *array;
    size_t used;
    size_t size;
}varArray;



int varArray_init(varArray *arr){
    arr->array = (variable*)malloc(sizeof(variable));
    arr->used = 0;
    arr->size = 0;
    if(arr->array){//malloc sucess
        return 0;
    }
    else{//malloc fail
        return 1;
    }
}

void varArray_append(varArray *arr, variable var){
    if(arr->used == arr->size){
        arr->size++;
        arr->array = (variable*)realloc(arr->array, arr->size * sizeof(variable));
    }
    arr->array[arr->used++] = var;
}

void varArray_destroy(varArray *arr){
    free(arr->array);
    arr->array = NULL;
    arr->used = 0;
    arr->size = 0;
}




