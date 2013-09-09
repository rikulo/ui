BEGIN {
	FS = ", "
	print "// DO NOT EDIT"
	print "// Auto-generated"
	print "// Copyright (C) 2013 Potix Corporation. All Rights Reserved."
	print "part of rikulo_event;"
	print
	print "/** A map of [ViewEvent] stream providers."
	print " *"
	print " * This may be used to capture DOM events:"
	print " *"
	print " *     EventStreams.keyDown.forTarget(element).listen(...);"
	print " *"
	print " * Otherwise, you can use `view.on.keyDown.listen(...)` instead (see [View])."
	print " */"
	print "class EventStreams {"
}

/^[A-Za-z]/ {
	if ($3 == "")
		$3 = $2
	printf "  static const ViewEventStreamProvider<%s> %s\n", $1, $3
	printf "    = const ViewEventStreamProvider<%s>('%s');\n", $1, $2
}

/^[^A-Za-z]/ {
	printf "  %s\n", $0
}

END {
	print "}"
}
