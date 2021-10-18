note
	description: "[
		i_timer.c
		from chocolate-doom/rum-and-raisin-doom
		
		Timer functions.
	]"
	license: "[
		Copyright (C) 1993-1996 by id Software, Inc.
		Copyright (C) 2005-2014 Simon Howard
		Copyright (C) 2020 Ethan Watson
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
	I_TIMER

create
	make

feature

	make
			-- I_InitTimer
		do
			{SDL_FUNCTIONS_API}.sdl_init ({SDL_CONSTANT_API}.sdl_init_timer.as_natural_32).do_nothing
			basefreq := {SDL_TIMER}.sdl_get_performance_frequency
			create perfframes.make (0)
		end

feature

	basefreq: NATURAL_64

	basecounter: NATURAL_64

	perfframes: ARRAYED_LIST [PERFFRAME_T]

feature

	i_get_time_ms: NATURAL_64
		local
			counter: NATURAL_64
		do
			counter := {SDL_TIMER}.sdl_get_performance_counter
			if basecounter = 0 then
				basecounter := counter
			end
			Result := ((counter - basecounter) * {NATURAL_64} 1000) // basefreq
		end

	i_get_time_us: NATURAL_64
		local
			counter: NATURAL_64
		do
			counter := {SDL_TIMER}.sdl_get_performance_counter
			if basecounter = 0 then
				basecounter := counter
			end
			Result := ((counter - basecounter) * {NATURAL_64} 1000000) // basefreq
		end

	i_log_perf_frame (microseconds: NATURAL_64; reason: STRING)
		local
			frame: PERFFRAME_T
		do
			frame.microseconds := microseconds
			frame.description := reason
			perfframes.extend (frame)
		end

end
