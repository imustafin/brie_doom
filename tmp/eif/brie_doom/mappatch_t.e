note
	description: "[
		mappatch_t from r_data.c
		
		Texture definition.
		Each texture is composed of one or more patches,
		with patches being lumps stored in the WAD.
		The lumps are referenced by number, and patched
		into the rectangular texture space using origin
		and possibly other attributes
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
	MAPPATCH_T

feature

	originx: INTEGER_16 assign set_originx

	set_originx (a_originx: like originx)
		do
			originx := a_originx
		end

	originy: INTEGER_16 assign set_originy

	set_originy (a_originy: like originy)
		do
			originy := a_originy
		end

	patch: INTEGER_16 assign set_patch

	set_patch (a_patch: like patch)
		do
			patch := a_patch
		end

	stepdir: INTEGER_16 assign set_stepdir

	set_stepdir (a_stepdir: like stepdir)
		do
			stepdir := a_stepdir
		end

	colormap: INTEGER_16 assign set_colormap

	set_colormap (a_colormap: like colormap)
		do
			colormap := a_colormap
		end

end
