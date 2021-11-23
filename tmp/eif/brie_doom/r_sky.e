note
	description: "[
		r_sky.c
		Sky renderng. The DOOM sky is a texture map like any
		wall, wrapping around. A 1024 columns equal 360 degrees.
		The default sky map is 256 columns and repeats 4 times
		on a 320 screen?
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
	R_SKY

create
	make

feature

	make
		do
		end

feature

	SKYFLATNAME: STRING = "F_SKY1"

	ANGLETOSKYSHIFT: INTEGER = 22
			-- The sky map is 256*128*4 maps

feature -- sky mapping

	skyflatnum: INTEGER assign set_skyflatnum

	set_skyflatnum (a_skyflatnum: like skyflatnum)
		do
			skyflatnum := a_skyflatnum
		end

	skytexture: INTEGER assign set_skytexture

	set_skytexture (a_skytexture: like skytexture)
		do
			skytexture := a_skytexture
		end

	skytexturemid: INTEGER

feature

	R_InitSkyMap
		do
			skytexturemid := 100 * {M_FIXED}.FRACUNIT
		end

end
