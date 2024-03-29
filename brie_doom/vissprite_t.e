note
	description: "[
		vissprite_t from r_defs.h
		
		A vissprite_t is a thing
		that will be drawn during a refresh.
		I.e. a sprite object that is partly visible.
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
	VISSPRITE_T

feature

	prev: detachable VISSPRITE_T assign set_prev

	set_prev (a_prev: like prev)
		do
			prev := a_prev
		end

	next: detachable VISSPRITE_T assign set_next

	set_next (a_next: like next)
		do
			next := a_next
		end

	x1: INTEGER assign set_x1

	set_x1 (a_x1: like x1)
		do
			x1 := a_x1
		end

	x2: INTEGER assign set_x2

	set_x2 (a_x2: like x2)
		do
			x2 := a_x2
		end

		-- for line side calculation

	gx: FIXED_T assign set_gx

	set_gx (a_gx: like gx)
		do
			gx := a_gx
		end

	gy: FIXED_T assign set_gy

	set_gy (a_gy: like gy)
		do
			gy := a_gy
		end

		-- global bottom/top for silhouette clipping

	gz: FIXED_T assign set_gz

	set_gz (a_gz: like gz)
		do
			gz := a_gz
		end

	gzt: FIXED_T assign set_gzt

		-- horizontal position of x1

	set_gzt (a_gzt: like gz)
		do
			gzt := a_gzt
		end

	startfrac: FIXED_T assign set_startfrac

	set_startfrac (a_startfrac: like startfrac)
		do
			startfrac := a_startfrac
		end

	scale: FIXED_T assign set_scale
			-- negative if flipped

	set_scale (a_scale: like scale)
		do
			scale := a_scale
		end

	xiscale: FIXED_T assign set_xiscale

	set_xiscale (a_xiscale: like xiscale)
		do
			xiscale := a_xiscale
		end

	texturemid: FIXED_T assign set_texturemid

	set_texturemid (a_texturemid: like texturemid)
		do
			texturemid := a_texturemid
		end

	patch: INTEGER assign set_patch

	set_patch (a_patch: like patch)
		do
			patch := a_patch
		end

		-- for color translation and shadow draw,
		-- maxbright frames as well

	colormap: detachable INDEX_IN_ARRAY [LIGHTTABLE_T] assign set_colormap

	set_colormap (a_colormap: like colormap)
		do
			colormap := a_colormap
		end

	mobjflags: INTEGER assign set_mobjflags

	set_mobjflags (a_mobjflags: like mobjflags)
		do
			mobjflags := a_mobjflags
		end

end
