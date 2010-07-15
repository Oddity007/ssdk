
#ifndef ___lang_array___
#define ___lang_array___

#include <stdint.h>

#define _lang_array__Array_new(type, size) ((_lang_array__Array) { size, calloc(size,sizeof(type)) });

#define _lang_array__Array_get(array, index, type) (((type* restrict) array.data)[index])
    
#define _lang_array__Array_set(array, index, type, value) ((type* restrict) array.data)[index] = value;

typedef struct {
    size_t length;
    void* restrict data;
} _lang_array__Array;

#endif // ___lang_array___

