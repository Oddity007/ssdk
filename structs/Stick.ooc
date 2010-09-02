Stick: cover{
	data: Pointer
	length, allocated: SizeT //In bytes
	
	check: func(size: SizeT){
		if((length+size) < allocated) return
		allocated += size * 4
		data = gc_realloc(data, allocated)
	}

	push: func<T>(value: T){
		check(T size)
		memcpy(data + length, value, T size)
		length += T size
	}

	pop: func<T>(T: Class) -> T{
		length -= T size
		result: T
		memcpy(result&, data + length, T size)
		return result
	}
}

operator [] <T> (list: Stick, i: SizeT) -> T { (list data as T*)[i] }
operator []= <T> (list: Stick, i: SizeT, element: T) { (list data as T*)[i]=element }