note
	description: "powertype_t from doomdef.h"
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
	POWERTYPE_T

feature

	pw_invulnerability: INTEGER = 0

	pw_strength: INTEGER = 1

	pw_invisibility: INTEGER = 2

	pw_ironfeet: INTEGER = 3

	pw_allmap: INTEGER = 4

	pw_infrared: INTEGER = 5

	NUMPOWERS: INTEGER = 6

end
