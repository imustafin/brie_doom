note
	description: "m_menu.c"
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
	MENUITEM_T

create
	make

feature

	status: INTEGER

	name: STRING

	routine: PROCEDURE [TUPLE [INTEGER]] assign set_routine

	alphaKey: CHARACTER

feature

	make (a_status: like status; a_name: like name; a_routine: like routine; a_alphaKey: like alphaKey)
		do
			status := a_status
			name := a_name
			routine := a_routine
			alphaKey := a_alphaKey
		end

feature

	set_routine (a_routine: like routine)
		do
			routine := a_routine
		end

end
