BEGIN {
	FS = ", "
	print
	print "///A list of DOM events"
	printf "const List<String> domEvents = const ['change'"
}

/^[A-Za-z]/ {
	if ($1 == "DomEvent")
		printf ", '%s'", $2
}

END {
	print "];"
}