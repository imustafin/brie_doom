note
	description: "d_items.c"

class
	D_ITEMS

inherit
	STATENUM_T

feature

	weaponinfo: ARRAY [WEAPONINFO_T]
		once
			create Result.make_filled (create {WEAPONINFO_T}, 0, {DOOMDEF_H}.NUMWEAPONS - 1)
			Result [0] := create {WEAPONINFO_T}.make ({DOOMDEF_H}.am_noammo, S_PUNCHUP, S_PUNCHDOWN, S_PUNCH, S_PUNCH1, S_NULL)
			Result [1] := create {WEAPONINFO_T}.make ({DOOMDEF_H}.am_clip, S_PISTOLUP, S_PISTOLDOWN, S_PISTOL, S_PISTOL1, S_PISTOLFLASH)
			Result [2] := create {WEAPONINFO_T}.make ({DOOMDEF_H}.am_shell, S_SGUNUP, S_SGUNDOWN, S_SGUN, S_SGUN1, S_SGUNFLASH1)
			Result [3] := create {WEAPONINFO_T}.make ({DOOMDEF_H}.am_clip, S_CHAINUP, S_CHAINDOWN, S_CHAIN, S_CHAIN1, S_CHAINFLASH1)
			Result [4] := create {WEAPONINFO_T}.make ({DOOMDEF_H}.am_misl, S_MISSILEUP, S_MISSILEDOWN, S_MISSILE, S_MISSILE1, S_MISSILEFLASH1)
			Result [5] := create {WEAPONINFO_T}.make ({DOOMDEF_H}.am_cell, S_PLASMAUP, S_PLASMADOWN, S_PLASMA, S_PLASMA1, S_PLASMAFLASH1)
			Result [6] := create {WEAPONINFO_T}.make ({DOOMDEF_H}.am_cell, S_BFGUP, S_BFGDOWN, S_BFG, S_BFG1, S_BFGFLASH1)
			Result [7] := create {WEAPONINFO_T}.make ({DOOMDEF_H}.am_noammo, S_SAWUP, S_SAWDOWN, S_SAW, S_SAW1, S_NULL)
			Result [8] := create {WEAPONINFO_T}.make ({DOOMDEF_H}.am_shell, S_DSGUNUP, S_DSGUNDOWN, S_DSGUN, S_DSGUN1, S_DSGUNFLASH1)
		ensure
			Result.lower = 0
			Result.count = {DOOMDEF_H}.NUMWEAPONS
			instance_free: class
		end

end
