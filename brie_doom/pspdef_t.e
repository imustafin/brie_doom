note
	description: "pspdef_t from p_spr.h"
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
	PSPDEF_T

feature

	state: detachable STATE_T assign set_state

	set_state (a_state: like state)
		do
			state := a_state
		end

	tics: INTEGER assign set_tics

	set_tics (a_tics: like tics)
		do
			tics := a_tics
		end

	sx: FIXED_T assign set_sx

	set_sx (a_sx: like sx)
		do
			sx := a_sx
		end

	sy: FIXED_T assign set_sy

	set_sy (a_sy: like sy)
		do
			sy := a_sy
		end

end
