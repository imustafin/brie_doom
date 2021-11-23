note
	description: "[
		spriteframe_t from r_defs.h
		
		Sprites are patches with a special naming convention
		so they can be recognized by R_InitSprites.
		
		The base name is NNNNFx or NNNNFxFx, with
		x indicating the rotation, x = 0, 1-7.
		The sprite and frame specified by a thing_t
		is range checked at run time.
		A sprite is a patch_t that is assumed to represent
		a three dimensional object and may have multiple
		rotations pre drawn.
		Horizontal flipping is used to save space,
		thus NNNNF2F5 defines a mirrored patch.
		Some sprites will only have one picture used
		for all views: NNNNF0
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
	SPRITEFRAME_T

inherit

	ANY
		redefine
			default_create
		end

feature

	default_create
		do
				-- Initialize with -1 because {R_THINGS}.R_InstallSpriteLump checks initializedness like this:
				-- -1 means unset
			create lump.make_filled (-1, 0, 7)
			create flip.make_filled (False, 0, 7)
		end

feature

	initialized: BOOLEAN assign set_initialized
			-- Were any values written to this object

	set_initialized (a_initialized: like initialized)
		do
			initialized := a_initialized
		end

	rotate: BOOLEAN assign set_rotate
			-- If false use 0 for any position.
			-- Note: as eight entries are available,
			-- we might as well insert the same name eight times.

	set_rotate (a_rotate: like rotate)
		do
			rotate := a_rotate
		end

	lump: ARRAY [INTEGER_16]
			-- Lump to use for view angles 0-7.

	flip: ARRAY [BOOLEAN]
			-- Originally, flip bit (1 = flip) to use for view angles 0-7.

invariant
	lump.lower = 0 and lump.count = 8
	flip.lower = 0 and flip.count = 8

end
