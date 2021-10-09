note
	description: "intercept_t from p_local.h"
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
	INTERCEPT_T

feature

	frac: FIXED_T assign set_frac
			-- along trace line

	set_frac (a_frac: like frac)
		do
			frac := a_frac
		end

	isaline: BOOLEAN assign set_isaline

	set_isaline (a_isaline: like isaline)
		do
			isaline := a_isaline
		end

feature -- union d

	thing: detachable MOBJ_T assign set_thing

	set_thing (a_thing: like thing)
		do
			thing := a_thing
		end

	line: detachable LINE_T assign set_line

	set_line (a_line: like line)
		do
			line := a_line
		end

end
