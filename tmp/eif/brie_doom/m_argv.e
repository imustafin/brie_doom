note
	description: "[
		m_argv.c
	]"
	license: "[
				Copyright (C) 1993-1996 by id Software, Inc.
				Copyright (C) 2005-2014 Simon Howard
				Copyright (C) 2021 Ilgiz Mustafin
		
				This program is free software; you can redistribute it and/or modify
				it under the terms of the GNU General Public License as published by
				the Free Software Foundation; either version 2 of the License, or
				(at your option) any later version.
		
				This program is distributed in the hope that it will be useful,
				but WITHOUT ANY WARRANTY; without even the implied warranty of
				MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
				GNU General Public License for more details.
		
				You should have received a copy of the GNU General Public License along
				with this program; if not, write to the Free Software Foundation, Inc.,
				51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
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
