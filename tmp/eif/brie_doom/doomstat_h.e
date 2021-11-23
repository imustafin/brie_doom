note
	description: "[
		doomstat.h
		All the global variables that store the internal state.
		 Theoretically speaking, the internal state of the engie
		 should be found by looking at the variables collected
		 here, and every relevant module will have to include
		 this header file.
		In practice, things are a bit messy.
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
	DOOMSTAT_H

create
	make

feature

	gamemode: GAME_MODE_T assign set_gamemode

	precache: BOOLEAN

	modifiedgame: BOOLEAN
			-- Set if homebrew PWAD stuff has been added.

feature

	make
		do
			gamemode := {GAME_MODE_T}.shareware
		end

feature -- Setters

	set_gamemode (a_new: like gamemode)
		do
			gamemode := a_new
		end

end
