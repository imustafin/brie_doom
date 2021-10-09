note
	description: "[
		doomdef.h
		Internally used data structures for virtually everything,
		 key definitions, lots of other stuff.
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
	DOOMDEF_H

feature

	VERSION: INTEGER = 110

feature

	SCREENWIDTH: INTEGER = 320

	SCREENHEIGHT: INTEGER = 200

	MAXPLAYERS: INTEGER = 4

	TICRATE: INTEGER = 35 -- State updates, number of tics / second.

feature -- skill_t

	sk_baby: INTEGER = 0

	sk_easy: INTEGER = 1

	sk_medium: INTEGER = 2

	sk_hard: INTEGER = 3

	sk_nightmare: INTEGER = 4

feature -- DOOM keyboard definition

	KEY_RIGHTARROW: INTEGER = 0xae

	KEY_LEFTARROW: INTEGER = 0xac

	KEY_UPARROW: INTEGER = 0xad

	KEY_DOWNARROW: INTEGER = 0xaf

	KEY_RCTRL: INTEGER
		once
			Result := 0x80 + 0x1d
		ensure
			instance_free: class
		end

	KEY_RALT: INTEGER
		once
			Result := 0x80 + 0x38
		end

	KEY_RSHIFT: INTEGER
		once
			Result := 0x80 + 0x36
		end

	KEY_F12: INTEGER
		once
			Result := 0x80 + 0x58
		ensure
			instance_free: class
		end

	KEY_PAUSE: INTEGER = 0xff

	KEY_ENTER: INTEGER = 13

feature -- gamestate_t

	GS_LEVEL: INTEGER = 0

	GS_INTERMISSION: INTEGER = 1

	GS_FINALE: INTEGER = 2

	GS_DEMOSCREEN: INTEGER = 3

feature

	MTF_AMBUSH: INTEGER = 8
			-- Deaf monsters/do not react to sound

feature

	english: INTEGER = 0

	french: INTEGER = 1

	german: INTEGER = 2

	unknown: INTEGER = 3

feature -- powerduration_t
	-- Power up durations,
	-- how many seconds till expiration,
	-- assuming TICRATE is 35 ticks/second

	INVULNTICS: INTEGER
		once
			Result := 30 * TICRATE
		ensure
			instance_free: class
		end

	INVISTICS: INTEGER
		once
			Result := 60 * TICRATE
		ensure
			instance_free: class
		end

	INFRATICS: INTEGER
		once
			Result := 120 * TICRATE
		ensure
			instance_free: class
		end

	IRONTICS: INTEGER
		once
			Result := 60 * TICRATE
		ensure
			instance_free: class
		end

end
