note
	description: "[
		p_plats.c
		
		Plats (i.e. elevator platforms) code, raising/lowering
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
	P_PLATS

feature

	EV_DoPlat (line: LINE_T; type: INTEGER; amount: INTEGER): BOOLEAN
			-- Do Platforms
			-- `amount` is only used for SOME platforms.
		do
			{NOT_IMPLEMENTED}.not_implemented ("EV_DoPlat", true)
		ensure
			instance_free: class
		end

end
