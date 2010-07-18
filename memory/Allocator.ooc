import cstd/[stdlib,gc,string]

Allocator: cover{
    mallocPtr: Func(SizeT)->Pointer
    callocPtr: Func(SizeT,SizeT)->Pointer
    reallocPtr: Func(Pointer,SizeT)->Pointer
    freePtr: Func(Pointer)->Void
    data: Pointer

    gc = This new(gc_malloc,gc_calloc,gc_realloc,null,null) : static const This
    manual = This new(malloc,calloc,realloc,free,null) : static const This

    init: func@{}
    init: func@~withReallocFreeAndData(=reallocPtr,=freePtr,=data){}
    init: func@~withAll(=mallocPtr,=callocPtr,=reallocPtr,=freePtr,=data){}

    isSane: func->Bool{
        return (mallocPtr || callocPtr || freePtr || reallocPtr) as Bool
    }

    sanityCheck: func@{
	//This is incase the user has a null allocator (i.e. backwards compatibility to code that is unaware of the Allocator system, and thus the allocator is set to all null because it was merely included into a class by inheritance)
	//Grr, going to need to explain this one :x
        if(isSane()==false) this= This gc
    }
    
    //These wrap the pointers and also implement behavior if a pointer is absent
    //So, if you are only given a malloc, it will derive calloc and realloc for you, and so forth

    allocate: func(size:SizeT)->Pointer{
        sanityCheck()

        if(mallocPtr==null){
            if(callocPtr) return callocPtr(1,size)
            if(reallocPtr) return reallocPtr(null,size)
            //We're screwed
            return null
        }
        return mallocPtr(size)
    }
    
    allocateZeroed: func(size:SizeT)->Pointer{
        sanityCheck()

        if(callocPtr==null){
            pointer:=allocate(size)
            memset(pointer,0,size)
            return pointer
        }
        return callocPtr(1,size)
    }
    
    reallocate: func(old:Pointer,size:SizeT)->Pointer{
        sanityCheck()

        if(reallocPtr==null){
            newPointer:=allocate(size)
            if(newPointer==null) return null
            if(old==null) return newPointer
            //bad access if you reallocate smaller than the original size
            //Unfortunately, there is no way to portably get the size of the old allocated block of memory
            memcpy(newPointer,old,size)
            return newPointer
        }
        return reallocPtr(old,size)
    }
    
    freeMemory: func(old:Pointer){
        if(freePtr==null) return//We don't always have to have a free-er
        return freePtr(old)
    }
}