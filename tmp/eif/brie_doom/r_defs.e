note
	description: "[
		r_defs.h
		
		Refresh/rendering module, shared data struct definitions.
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
	R_DEFS

feature -- slopetype_t

	ST_HORIZONTAL: INTEGER = 0

	ST_VERTICAL: INTEGER = 1

	ST_POSITIVE: INTEGER = 2

	ST_NEGATIVE: INTEGER = 3

feature

	MAXDRAWSEGS: INTEGER = 256

feature -- Silhouette
	-- needed for clipping Segs (mainly)
	-- and sprites representing things.

	SIL_NONE: INTEGER = 0

	SIL_BOTTOM: INTEGER = 1

	SIL_TOP: INTEGER = 2

	SIL_BOTH: INTEGER = 3

end
