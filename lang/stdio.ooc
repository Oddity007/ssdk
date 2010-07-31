include stdio

FILE: extern cover

stdout, stderr, stdin: extern FILE*

println: func ~withStr (str: Char*) {
	printf("%s\n", str)
}
println: func {
	printf("\n")
}

// input/output
printf: extern func (Char*, ...) -> Int

fprintf: extern func (FILE*, Char*, ...) -> Int
sprintf: extern func (Char*, Char*, ...) -> Int
snprintf: extern func (Char*, Int, Char*, ...) -> Int

vprintf: extern func (Char*, VaList) -> Int
vfprintf: extern func (FILE*, Char*, VaList) -> Int
vsprintf: extern func (Char*, Char*, VaList) -> Int
vsnprintf: extern func (Char*, Int, Char*, VaList) -> Int

fread: extern func (ptr: Pointer, size: SizeT, nmemb: SizeT, stream: FILE*) -> SizeT
fwrite: extern func (ptr: Pointer, size: SizeT, nmemb: SizeT, stream: FILE*) -> SizeT
feof: extern func (stream: FILE*) -> Int

fopen: extern func (Char*, Char*) -> FILE*
fclose: extern func (file: FILE*) -> Int
fflush: extern func (file: FILE*)

fputc: extern func (Char, FILE*)
fputs: extern func (Char*, FILE*)

scanf: extern func (format: Char*, ...) -> Int
fscanf: extern func (stream: FILE*, format: Char*, ...) -> Int
sscanf: extern func (str: Char*, format: Char*, ...) -> Int

vscanf: extern func (format: Char*, ap: VaList) -> Int
vfscanf: extern func (file: FILE*, format: Char*, ap: VaList) -> Int
vsscanf: extern func (str: Char*, format: Char*, ap: VaList) -> Int

fgets: extern func (str: Char*, length: SizeT, stream: FILE*) -> Char*
fgetc: extern func (stream: FILE*) -> Int