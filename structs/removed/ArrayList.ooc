ArrayList: class <T> {

	data: T*
	_length, allocated: SizeT
	
	check: func{
		if(_length < allocated) return
		allocated += 30
		data = gc_realloc(data, T size * allocated)
		if(data==null) Exception new(ArrayList,"Out of heap memory.") throw()
	}

	add: func(value: T){
		_length += 1
		check()
		data[_length]=value
	}

	length: func -> SizeT{
		return _length
	}

	__destroy__: func{
		gc_free(data)
	}
	
	init: func{
		allocated = 30
		data = gc_realloc(data, T size * allocated)
	}

	each: func (fn: Func(T)){
		len := this length()
		for(i in 0..len) fn(data[i])
	}
}

/* Operators */
//operator [] <T> (list: ArrayList<T>, i: SizeT) -> T { list data[i] }
//operator []= <T> (list: ArrayList<T>, i: SizeT, element: T) { list data[i]=element }