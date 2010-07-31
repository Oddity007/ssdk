include stddef, stdlib, stdio, ctype, stdint, stdbool, string
include float

include ./array

printf: extern func(String,...)->Int

version(gc){
	include gc/gc
}

Object: abstract class {

    class: Class

    /// Instance initializer: set default values for a new instance of this class
    __defaults__: func {}
    
    /// Finalizer: cleans up any objects belonging to this instance
    __destroy__: func {}
    
    /** return true if *class* is a subclass of *T*. */
    instanceOf: final func (T: Class) -> Bool {
        if(!this) return false
        class inheritsFrom(T)
    }
    

    // Memory management
    __refcount: SizeT
    retain: func ~refcount -> This{
        __refcount+=1
        return this
    }
    release: func ~refcount{
        __refcount -=1
        if(__refcount) return
        __destroy__()
    }
}

Class: abstract class {
    
    /// Number of octets to allocate for a new instance of this class 
    instanceSize: SizeT
    
    /** Number of octets to allocate to hold an instance of this class
        it's different because for classes, instanceSize may greatly
        vary, but size will always be equal to the size of a Pointer.
        for basic types (e.g. Int, Char, Pointer), size == instanceSize
    */
    size: SizeT

    /// Human readable representation of the name of this class
    name: String
    
    /// Pointer to instance of super-class
    super: const Class

    /// Create a new instance of the object of type defined by this class
    alloc: final func ~_class -> Object {
        object := gc_malloc(This instanceSize) as Object
        object = object retain()
        if(object) {
            object class = this
        }
        return object
    }

    inheritsFrom: final func ~_class (T: Class) -> Bool {
        if(this == T) return true
        return (super ? super inheritsFrom(T) : false)
    }
}

Array: cover from _lang_array__Array {
    length: extern Int
    data: extern Pointer

    free: extern(_lang_array__Array_free) func
}

None: class {init: func {}}

Void: cover from void
Pointer: cover from Void*
Size_t: cover from size_t

Char: cover from char
SChar: cover from signed char extends Char
UChar: cover from unsigned char extends Char
WChar: cover from wchar_t

String: cover from Char*{
	println: extern(puts) func
}

Comparable: interface {
    compareTo: func<T>(other: T) -> Int
}

LLong: cover from signed long long
Long:  cover from signed long  extends LLong
Int:   cover from signed int   extends LLong
Short: cover from signed short extends LLong

ULLong: cover from unsigned long long extends LLong

ULong:  cover from unsigned long  extends ULLong
UInt:   cover from unsigned int   extends ULLong
UShort: cover from unsigned short extends ULLong

INT_MAX := 2147483647
INT_MIN := -INT_MAX - 1

Int8:  cover from int8_t  extends LLong
Int16: cover from int16_t extends LLong
Int32: cover from int32_t extends LLong
Int64: cover from int64_t extends LLong

UInt8:  cover from uint8_t  extends ULLong
UInt16: cover from uint16_t extends ULLong
UInt32: cover from uint32_t extends ULLong
UInt64: cover from uint64_t extends ULLong

//Octet: cover from UInt8
Octet:  cover from uint8_t
SizeT:  cover from size_t extends LLong
Bool:   cover from bool

LDouble: cover from long double
Float: cover from float extends LDouble
Double: cover from double extends LDouble

DBL_MIN,  DBL_MAX : extern static const Double
FLT_MIN,  FLT_MAX : extern static const Float
LDBL_MIN, LDBL_MAX: extern static const LDouble

/**
 * custom types
 */
Range: cover {
    min, max: Int
    init: func@(=min,=max){}
}

/**
 * exceptions
 */

ExceptionMessageBuffer: Char[1024]

Exception: cover {

    origin: Class
    msg : String

    init: func@ ~originMsg (=origin, =msg) {}
    init: func@ ~noOrigin (=msg) {}

    crash: func {
        fflush(stdout)
        abort()
    }

    getMessage: func -> String {
        buffer := ExceptionMessageBuffer as String
        if(origin) snprintf(buffer, 1024, "[%s in %s]: %s\n", this class name, origin name, msg)
        else snprintf(buffer, 1024, "[%s]: %s\n", this class name, msg)
        return buffer
    }

    print: func {
        fprintf(stderr, "%s", getMessage())
    }

    throw: func {
        print()
        crash()
    }

}