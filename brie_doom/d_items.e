note
	description: "d_items.c"
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
	D_ITEMS

inherit

	STATENUM_T

	AMMOTYPE_T

	WEAPONTYPE_T

feature

	weaponinfo: ARRAY [WEAPONINFO_T]
		once
			create Result.make_filled (create {WEAPONINFO_T}, 0, NUMWEAPONS - 1)
			Result [0] := create {WEAPONINFO_T}.make (am_noammo, S_PUNCHUP, S_PUNCHDOWN, S_PUNCH, S_PUNCH1, S_NULL)
			Result [1] := create {WEAPONINFO_T}.make (am_clip, S_PISTOLUP, S_PISTOLDOWN, S_PISTOL, S_PISTOL1, S_PISTOLFLASH)
			Result [2] := create {WEAPONINFO_T}.make (am_shell, S_SGUNUP, S_SGUNDOWN, S_SGUN, S_SGUN1, S_SGUNFLASH1)
			Result [3] := create {WEAPONINFO_T}.make (am_clip, S_CHAINUP, S_CHAINDOWN, S_CHAIN, S_CHAIN1, S_CHAINFLASH1)
			Result [4] := create {WEAPONINFO_T}.make (am_misl, S_MISSILEUP, S_MISSILEDOWN, S_MISSILE, S_MISSILE1, S_MISSILEFLASH1)
			Result [5] := create {WEAPONINFO_T}.make (am_cell, S_PLASMAUP, S_PLASMADOWN, S_PLASMA, S_PLASMA1, S_PLASMAFLASH1)
			Result [6] := create {WEAPONINFO_T}.make (am_cell, S_BFGUP, S_BFGDOWN, S_BFG, S_BFG1, S_BFGFLASH1)
			Result [7] := create {WEAPONINFO_T}.make (am_noammo, S_SAWUP, S_SAWDOWN, S_SAW, S_SAW1, S_NULL)
			Result [8] := create {WEAPONINFO_T}.make (am_shell, S_DSGUNUP, S_DSGUNDOWN, S_DSGUN, S_DSGUN1, S_DSGUNFLASH1)
		ensure
			Result.lower = 0
			Result.count = NUMWEAPONS
			instance_free: class
		end

end
