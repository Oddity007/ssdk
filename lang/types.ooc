include stddef, stdlib, stdio, ctype, stdint, stdbool, string
include float

include ./array

NULL: extern Pointer

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
	retain: func ~_object -> Pointer{
		__refcount+=1
		return this
	}
	
	release: func ~_object{
		__refcount -=1
		if(__refcount) return
		__destroy__()
		gc_free(this)
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
		object := gc_malloc(instanceSize) as Object
		if(object) {
			object class = this
			object = object retain~_object()
		}
		return object
	}

	allocWith: final func(allocator: Func(SizeT)->Pointer) -> Object{
		object := allocator(instanceSize) as Object
		if(object){
			object class = this
			object = object retain~_object()
		}
		return object
	}


	inheritsFrom: final func ~_class (T: Class) -> Bool {
		if(this == T) return true
		return (super ? super inheritsFrom(T) : false)
	}
}

Array: cover from _lang_array__Array {
	length: extern SizeT
	data: extern Pointer
	
	free: extern(_lang_array__Array_free) func
}

Void: cover from void
Pointer: cover from void*

Long: cover from signed long
Int: cover from signed int
Short: cover from signed short
Char: cover from char

Float: cover from float
Double: cover from double
LDouble: cover from long double


SizeT: cover from size_t
SSizeT: cover from ssize_t
PtrDiff: cover from ptrdiff_t
Bool: cover from bool

Closure: cover {
	thunk: Pointer
	context: Pointer
}

Range: cover {
	min, max: SSizeT
	init: func@(=min,=max){}
	
	each: func(fn: Func(SSizeT)){
		for(i: SSizeT in min..max) fn(i)
	}
}
