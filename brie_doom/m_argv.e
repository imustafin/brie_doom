note
	description: "[
		m_argv.c
	]"

class
	M_ARGV

create
	make

feature

	make (a_myargv: like myargv)
		do
			myargv := a_myargv
		end

feature

	myargv: ARRAY [IMMUTABLE_STRING_32]

	M_CheckParm (ch: STRING): INTEGER
			-- Checks for the given parameter
			-- in the program's command line arguments.
			-- Returns the argument number (1 to argc - 1)
			-- or 0 if not present
		do
			from
				Result := 1
			until
				Result > myargv.upper or else myargv [Result].as_upper ~ ch.as_upper
			loop
				Result := Result + 1
			end
			if Result > myargv.upper then
				Result := 0
			end
		ensure
			Result = 0 implies across myargv.subarray (1, myargv.upper) as mi all mi.item.as_upper /~ ch.as_upper end
			Result /= 0 implies myargv [Result].as_upper ~ ch.as_upper
		end

invariant
	myargv.lower = 0

end
