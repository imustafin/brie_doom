note
	description: "thinker_t from d_think.h"
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
	THINKER_T

create
	make

feature

	make
		do
			prev := Current
			next := Current
		end

feature

	prev: THINKER_T assign set_prev

	set_prev (a_prev: like prev)
		do
			prev := a_prev
		end

	next: THINKER_T assign set_next

	set_next (a_next: like next)
		do
			next := a_next
		end

	function: detachable PROCEDURE assign set_function

	set_function (a_function: like function)
		do
			function := a_function
		end

invariant
	attached function as i_f implies i_f.open_count = 0

end
