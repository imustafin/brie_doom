note
	description: "[
		perfframe_t from i_timer.c
		from chocolate-doom/rum-and-raisin-doom
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

expanded class
	PERFFRAME_T

inherit

	ANY
		redefine
			default_create
		end

feature

	default_create
		do
			description := "UNSET DESCRIPTION"
		end

feature

	microseconds: NATURAL_64 assign set_microseconds

	set_microseconds (a_microseconds: like microseconds)
		do
			microseconds := a_microseconds
		end

	description: STRING assign set_description

	set_description (a_description: like description)
		do
			description := a_description
		end

end
