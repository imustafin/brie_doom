note
	description: "button_t from p_spec.h"
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
	BUTTON_T

feature

	line: detachable LINE_T assign set_line

	set_line (a_line: like line)
		do
			line := a_line
		end

	where: INTEGER assign set_where

	set_where (a_where: like where)
		do
			where := a_where
		end

	btexture: INTEGER assign set_btexture

	set_btexture (a_btexture: like btexture)
		do
			btexture := a_btexture
		end

	btimer: INTEGER assign set_btimer

	set_btimer (a_btimer: like btimer)
		do
			btimer := a_btimer
		end

	soundorg: detachable DEGENMOBJ_T assign set_soundorg

	set_soundorg (a_soundorg: like soundorg)
		do
			soundorg := a_soundorg
		end

feature -- bwhere_e

	top: INTEGER = 0

	middle: INTEGER = 1

	bottom: INTEGER = 2

end
