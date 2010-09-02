CString: cover from Char*{
	length: extern(strlen) func -> SizeT
	println: extern(puts) func
	each: func (fn: Func(Char)){
		i := 0 as SizeT
		while(this[i]){
			fn(this[i])
			i += 1
		}
	}
}

String: cover from CString extends CString

makeStringLiteral: func (str: Char*, strLen: SizeT) -> String {
	str as String
}
