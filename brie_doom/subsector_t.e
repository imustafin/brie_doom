note
	description: "[
		subsector_t from r_defs.h
		
		A SubSector.
		References a Sector.
		Basically, this is a list of LineSegs,
		indicating the visible walls that define
		(all or some) sides of a convex BSP leaf.
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
	SUBSECTOR_T

create
	default_create, from_pointer

feature

	sector: detachable SECTOR_T assign set_sector

	set_sector (a_sector: like sector)
		do
			sector := a_sector
		end

	numlines: INTEGER_16

	firstline: INTEGER_16

feature

	from_pointer (m: MANAGED_POINTER; offset: INTEGER)
		do
			numlines := m.read_integer_16_le (offset)
			firstline := m.read_integer_16_le (offset + 2)
		end

	structure_size: INTEGER = 4

end
