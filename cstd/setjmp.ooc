include setjmp

JmpBuf: cover from jmp_buf

setjump: extern func(JmpBuf) -> Int
longjmp: extern func(JmpBuf,Int)