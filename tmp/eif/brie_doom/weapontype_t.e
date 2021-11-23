note
	description: "weapontype_t enum from doomdef.h"
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
	WEAPONTYPE_T

feature -- weapontype_t

	wp_fist: INTEGER = 0

	wp_pistol: INTEGER = 1

	wp_shotgun: INTEGER = 2

	wp_chaingun: INTEGER = 3

	wp_missile: INTEGER = 4

	wp_plasma: INTEGER = 5

	wp_bfg: INTEGER = 6

	wp_chainsaw: INTEGER = 7

	wp_supershotgun: INTEGER = 8

	NUMWEAPONS: INTEGER = 9

	wp_nochange: INTEGER = 10

end
