import cstd/stdlib
import cstd/stdlio

Exception: class {

	origin: Class
	msg : String

	init: func ~originMsg (=origin, =msg) {}
	init: func ~noOrigin (=msg) {}

	crash: func {
		abort()
	}

	writeMessageToBuffer: func(buffer: String, length: SizeT) {
		if(origin) snprintf(buffer, length-1, "[%s in %s]: %s\n", this class name, origin name, msg)
		else snprintf(buffer, length-1, "[%s]: %s\n", this class name, msg)
	}

	print: func {
		buffer: Char[1024]
		writeMessageToBuffer(buffer as String,1024)
		fprintf(stderr, "%s", buffer)
	}

	throw: func {
		print()
		crash()
	}
}
