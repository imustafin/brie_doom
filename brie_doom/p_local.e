note
	description: "[
		p_local.h
		Play functions, animation, global header.
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
	P_LOCAL

feature

	FLOATSPEED: INTEGER
		once
			Result := 4 * {M_FIXED}.fracunit
		ensure
			instance_free: class
		end

	MAXRADIUS: INTEGER
			-- MAXRADIUS is for precalculated sector block boxes
			-- the spider demon is larger,
			-- but we do not have any moving sectors nearby
		once
			Result := 32 * {M_FIXED}.FRACUNIT
		ensure
			instance_free: class
		end

	GRAVITY: INTEGER
		once
			Result := {M_FIXED}.fracunit
		ensure
			instance_free: class
		end

	MAXMOVE: INTEGER
		once
			Result := 30 * {M_FIXED}.fracunit
		ensure
			instance_free: class
		end

	MAPBLOCKSHIFT: INTEGER
		once
			Result := {M_FIXED}.fracbits + 7
		ensure
			instance_free: class
		end

	ONFLOORZ: INTEGER
		once
			Result := {DOOMTYPE_H}.MININT
		ensure
			instance_free: class
		end

	ONCEILINGZ: INTEGER
		once
			Result := {DOOMTYPE_H}.MAXINT
		ensure
			instance_free: class
		end

	VIEWHEIGHT: INTEGER
		once
			Result := 41 * {M_FIXED}.FRACUNIT
		ensure
			instance_free: class
		end

	MAXHEALTH: INTEGER = 100

	USERANGE: INTEGER
		once
			Result := 64 * {M_FIXED}.fracunit
		ensure
			instance_free: class
		end

	PT_ADDLINES: INTEGER = 1

	PT_ADDTHINGS: INTEGER = 2

	PT_EARLYOUT: INTEGER = 4

	MAPBLOCKUNITS: INTEGER = 128

	MAPBLOCKSIZE: INTEGER
		once
			Result := MAPBLOCKUNITS * {M_FIXED}.FRACUNIT
		ensure
			instance_free: class
		end

	MAPBTOFRAC: INTEGER
		once
			Result := MAPBLOCKSHIFT - {M_FIXED}.FRACBITS
		ensure
			instance_free: class
		end

	MAXINTERCEPTS: INTEGER = 128

	MISSILERANGE: INTEGER
		once
			Result := 32 * 64 * {M_FIXED}.FRACUNIT
		ensure
			instance_free: class
		end

	MELEERANGE: INTEGER
		once
			Result := 64 * {M_FIXED}.fracunit
		ensure
			instance_free: class
		end

	ITEMQUESIZE: INTEGER = 128

	BASETHRESHOLD: INTEGER = 100
			-- follow a player exlusively for 3 seconds

end
