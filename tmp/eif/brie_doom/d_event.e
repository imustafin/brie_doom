note
	description: "d_event.h"
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
	D_EVENT

create
	make

feature

	make
		do
		end

feature

	MAXEVENTS: INTEGER = 64

feature -- buttoncode_t

	BT_ATTACK: INTEGER = 1 -- Press "fire".

	BT_USE: INTEGER = 2 -- Use button, to open doors, activate switches.

		-- Flag: game events, not really buttons.

	BT_SPECIAL: INTEGER = 128

	BT_SPECIALMASK: INTEGER = 3

		-- Flag, weapon change pending.
		-- If true, the next 3 bits hold weapon num.

	BT_CHANGE: INTEGER = 4

		-- The 3bit weapon mask and shift, convenience.

	BT_WEAPONMASK: INTEGER = 56 -- originally (8+16+32)

	BT_WEAPONSHIFT: INTEGER = 3

	BTS_PAUSE: INTEGER = 1 -- Pause the game.

	BTS_SAVEGAME: INTEGER = 2 -- Save the game at each console.

		-- Savegame slot numbers
		--  occupy the second byte of buttons.

	BTS_SAVEMASK: INTEGER = 28 -- originally (4+8+16)

	BTS_SAVESHIFT: INTEGER = 2

end
