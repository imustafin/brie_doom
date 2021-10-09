note
	description: "[
		degenmobj_t from r_defs.h
		
		Each sector has a degenmobj_t in its center
		for sound origin purposes.
		
		I suppose this does not handle sound from
		moving objects (doppler), because
		position is prolly just buffered, not updated
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
	DEGENMOBJ_T

feature

	x: FIXED_T assign set_x

	set_x (a_x: like x)
		do
			x := a_x
		end

	y: FIXED_T assign set_y

	set_y (a_y: like y)
		do
			y := a_y
		end

	z: FIXED_T assign set_z

	set_z (a_z: like z)
		do
			z := a_z
		end

end
