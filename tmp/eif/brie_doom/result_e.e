note
	description: "result_e from p_spec.h"
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

expanded class
	RESULT_E

inherit

	ANY
		redefine
			default_create
		end

feature {NONE} -- Creation

	default_create
		do
			make (0)
		end

feature {RESULT_E} -- Initialization

	make (a_value: like item)
		do
			item := a_value
		end

feature -- Enumeration

	ok: RESULT_E
		once
			Result.make (0)
		ensure
			instance_free: class
		end

	crushed: RESULT_E
		once
			Result.make (1)
		ensure
			instance_free: class
		end

	pastdest: RESULT_E
		once
			Result.make (2)
		ensure
			instance_free: class
		end

feature -- Access

	item: INTEGER

end
