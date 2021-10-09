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
	EVENT_T

create
	make

feature

	make
		do
		end

feature -- evtype_t

	ev_keydown: INTEGER = 0

	ev_keyup: INTEGER = 1

	ev_mouse: INTEGER = 2

	ev_joystick: INTEGER = 3

feature -- Fields

	type: INTEGER assign set_type

	set_type (a_type: like type)
		do
			type := a_type
		end

	data1: INTEGER assign set_data1 -- keys / mouse/joystick buttons

	set_data1 (a_data1: like data1)
		do
			data1 := a_data1
		end

	data2: INTEGER -- mouse/joystick x move

	data3: INTEGER -- mouse/joystick y move

end
