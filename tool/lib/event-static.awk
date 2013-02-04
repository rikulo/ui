BEGIN {
	FS = ", "
	print "// DO NOT EDIT"
	print "// Auto-generated"
	print "// Copyright (C) 2013 Potix Corporation. All Rights Reserved."
	print "part of rikulo_event;"
	print
}

/^[A-Za-z]/ {
	if ($3 == "")
		$3 = $2
	printf "const ViewEventStreamProvider<%s> %sEvent = const ViewEventStreamProvider<%s>('%s');\n", $1, $3, $1, $2
}

/^[^A-Za-z]/ {
	print $0
}