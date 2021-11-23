note
	description: "[
		r_defs.h
		This could be wider for >8 bit display.
		Indeed, true color support is possible
		 precalculating 24bpp lightmap/colormap LUT.
		 from darkening PLAYPAL to all black.
		Could even us emore than 32 levels.
	]"
	license: "[
				Copyright (C) 1993-1996 by id Software, Inc.
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
	LIGHTTABLE_T

inherit

	NATURAL_8_REF

create
	default_create, from_natural_8

convert
	from_natural_8 ({NATURAL_8}),
	to_natural_8: {NATURAL_8}

feature

	from_natural_8 (a_val: NATURAL_8)
		do
			set_item (a_val)
		end

end
