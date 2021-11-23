note
	description: "i_system.c"
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
	I_SYSTEM

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

feature

	I_Init
		do
			if {SDL_FUNCTIONS_API}.sdl_init ({SDL_CONSTANT_API}.sdl_init_video.to_natural_32 | {SDL_CONSTANT_API}.sdl_init_audio.to_natural_32) < 0 then
				i_main.i_error ("Could not initialze SDL: " + {SDL_ERROR}.sdl_get_error)
			end
			i_main.i_sound.I_InitSound (true)
		end

feature

	I_Quit
		note
			source: "chocolate doom i_system.c"
		do
			{NOT_IMPLEMENTED}.not_implemented ("I_Quit", false)
				-- skip Run through all exit functions

			{SDL_FUNCTIONS_API}.sdl_quit
			{EXCEPTIONS}.die (0)
		end

feature

	I_BaseTiccmd: TICCMD_T
		once
			create Result
		end

feature

	I_GetTime: INTEGER
		do
			Result := ({SDL_TIMER_FUNCTIONS_API}.sdl_get_ticks.as_integer_32 * {DOOMDEF_H}.TICRATE) // 1000
		end

	I_Sleep (ms: NATURAL_32)
			-- Sleep for a specified number of ms
		do
			{SDL_TIMER_FUNCTIONS_API}.sdl_delay (ms)
		end

	I_Tactile (on, off, total: INTEGER)
		do
				-- UNUSED.
		end

end
