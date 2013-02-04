BEGIN {
	FS = ", "
	print
	print "///A map of [ViewEvent] streams"
	print "class ViewEvents {"
	print "  final CapturableStreamTarget<ViewEvent> _owner;"
	print "  ViewEvents(this._owner);"
	print
}

/^[A-Za-z]/ {
	if ($3 == "")
		$3 = $2
	printf "  Stream<%s> get %s => %sEvent.forTarget(_owner);\n", $1, $3, $3
}

END {
	print "}"
}