include setjmp

JmpBuf: cover from jmp_buf{
	save: extern(setjmp) func -> Int
	restore: extern(longjmp) func(Int)
}

setjmp: extern func(JmpBuf) -> Int
longjmp: extern func(JmpBuf, Int)