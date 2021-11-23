note
	description: "[
		maptexture_t from r_data.c
		A DOOM wall texture is a list of patches
		which are to be combined in a predefined order.
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
	MAPTEXTURE_T

create
	make

feature

	make
		do
			name := ""
			create patches.make_empty
		end

feature

	name: STRING assign set_name

	set_name (a_name: like name)
		do
			name := a_name
		end

	masked: BOOLEAN assign set_masked

	set_masked (a_masked: like masked)
		do
			masked := a_masked
		end

	width: INTEGER_16 assign set_width

	set_width (a_width: like width)
		do
			width := a_width
		end

	height: INTEGER_16 assign set_height

	set_height (a_height: like height)
		do
			height := a_height
		end

	patches: ARRAY [MAPPATCH_T] assign set_patches

	set_patches (a_patches: like patches)
		do
			patches := a_patches
		end

invariant
	name.count <= 8

end
