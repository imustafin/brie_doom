note
	description: "ammotype_t enum from doomdef.h"
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
	AMMOTYPE_T

feature -- ammotype_t

	am_clip: INTEGER = 0 -- Pistol / chaingun ammo

	am_shell: INTEGER = 1 -- Shotgun / double barreled shotgun

	am_cell: INTEGER = 2 -- Plasma rifle, BFG.

	am_misl: INTEGER = 3 -- Missile launcher

	NUMAMMO: INTEGER = 4

	am_noammo: INTEGER = 5 -- Unlimited for chainsaw / fist.

end
