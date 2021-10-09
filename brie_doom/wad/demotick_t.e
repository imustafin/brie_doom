note
	description: "Structure of a tick for `DEMOLUMP_T`"
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
	DEMOTICK_T

create
	default_create, from_ticcmd

feature

	forwardmove: NATURAL_8 assign set_forwardmove

	set_forwardmove (a_forwardmove: like forwardmove)
		do
			forwardmove := a_forwardmove
		end

	sidemove: NATURAL_8 assign set_sidemove

	set_sidemove (a_sidemove: like sidemove)
		do
			sidemove := a_sidemove
		end

	angleturn: NATURAL_8 assign set_angleturn

	set_angleturn (a_angleturn: like angleturn)
		do
			angleturn := a_angleturn
		end

	buttons: NATURAL_8 assign set_buttons

	set_buttons (a_buttons: like buttons)
		do
			buttons := a_buttons
		end

feature

	to_ticcmd: TICCMD_T
		do
			create Result
			Result.forwardmove := forwardmove.as_integer_8
			Result.sidemove := sidemove.as_integer_8
			Result.angleturn := angleturn.as_integer_32 |<< 8
			Result.buttons := buttons
		end

	from_ticcmd (cmd: TICCMD_T)
		do
			forwardmove := cmd.forwardmove.as_natural_8
			sidemove := cmd.sidemove.as_natural_8
			angleturn := ((cmd.angleturn + 128) |>> 8).as_natural_8
			buttons := cmd.buttons.as_natural_8
		end

end
