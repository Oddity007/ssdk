include stdlib

rand: extern func -> Int
srand: extern func(Int)

SizeT: cover from size_t
NULL: extern Pointer
RAND_MAX: extern Int

malloc: extern(malloc) func (size: SizeT) -> Pointer
realloc: extern(realloc) func (ptr: Pointer, size: SizeT) -> Pointer
calloc: extern(calloc) func (nmemb: SizeT, size: SizeT) -> Pointer
free: extern func (Pointer)

sizeof: func~aClass(T: Class)->SizeT{
	return T size
}

sizeof: func~aVar<T>(var: T)->SizeT{
	return T size
}

abort: extern func
exit: extern func(Int)
atexit: extern func(Func)

system: extern func(String) -> Int
getenv: extern func(String) -> String

bsearch: extern func(key: Pointer, base: Pointer, nmemb: SizeT, size: SizeT,compare: Func(Pointer, Pointer) -> Int) -> Pointer

qsort: extern func(base: Pointer, nmemb: SizeT, size: SizeT,compare: Func(Pointer, Pointer) -> Int) -> Pointer

//abs, labs, div, and ldiv, ato* and strto* are left out becaus they are implemented better elsewhere