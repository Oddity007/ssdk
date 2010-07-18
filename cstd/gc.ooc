import cstd/stdlib

version(!gc) {
    // GC_MALLOC zeroes the memory, so in the non-gc version, we prefer to use calloc
    // to the expense of some performance. If you want to use malloc instead - do so
    // at your own risks. Some sdk classes may not zero their every field.

    //gc_malloc: extern(malloc) func (size: SizeT) -> Pointer
    gc_malloc: func (size: SizeT) -> Pointer {
        gc_calloc(1, size)
    }
    gc_malloc_atomic: extern(malloc) func (size: SizeT) -> Pointer
    gc_realloc: extern(realloc) func (ptr: Pointer, size: SizeT) -> Pointer
    gc_calloc: extern(calloc) func (nmemb: SizeT, size: SizeT) -> Pointer
    gc_free: func(ptr:Pointer){
        free(ptr)
    }
}

version(gc) {
    include gc/gc
    _gc_malloc: extern(GC_MALLOC) func (size: SizeT) -> Pointer
    _gc_malloc_atomic: extern(GC_MALLOC_ATOMIC) func (size: SizeT) -> Pointer
    _gc_realloc: extern(GC_REALLOC) func (ptr: Pointer, size: SizeT) -> Pointer

    gc_malloc: func (size: SizeT) -> Pointer{
        _gc_malloc(size)
    }
    gc_malloc_atomic: func (size: SizeT) -> Pointer{
        gc_malloc_atomic(size)
    }
    gc_realloc: func (ptr: Pointer, size: SizeT) -> Pointer{
        _gc_realloc(ptr,size)
    }
    gc_calloc: func (nmemb: SizeT, size: SizeT) -> Pointer {
        gc_malloc(nmemb * size)
    }
    gc_free: func(ptr:Pointer){}//A no-op
}