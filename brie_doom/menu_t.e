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
	MENU_T

create
	make

feature

	numitems: INTEGER assign set_numitems

	prevMenu: detachable MENU_T assign set_prevmenu

	menuitems: ARRAY [MENUITEM_T]

	routine: PROCEDURE assign set_routine

	x: INTEGER assign set_x

	y: INTEGER assign set_y

	lastOn: INTEGER assign set_laston

feature

	make (a_numitems: like numitems; a_prevmenu: like prevmenu; a_menuitems: like menuitems; a_routine: like routine; a_x: like x; a_y: like y; a_laston: like laston)
		do
			numitems := a_numitems
			prevmenu := a_prevmenu
			menuitems := a_menuitems
			routine := a_routine
			x := a_x
			y := a_y
			laston := a_laston
		end

feature

	set_numitems (a_numitems: like numitems)
		do
			numitems := a_numitems
		end

	set_x (a_x: like x)
		do
			x := a_x
		end

	set_y (a_y: like y)
		do
			y := a_y
		end

	set_prevmenu (a_prevmenu: like prevmenu)
		do
			prevmenu := a_prevmenu
		end

	set_routine (a_routine: like routine)
		do
			routine := a_routine
		end

	set_laston (a_laston: like laston)
		do
			laston := a_laston
		end

invariant
	menuitems.lower = 1
	menuitems.valid_index (lastOn)

end
