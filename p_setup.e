note
	description: "[
		p_setup.c
		Do all the WAD I/O, get map description,
		set up initial state and misc. LUTs.
	]"

class
	P_SETUP

inherit

	DOOMDATA_H

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			create deathmatchstarts.make_empty
			create nodes.make_empty
		end

feature

	rejectmatrix: detachable MANAGED_POINTER

	deathmatchstarts: ARRAY [MAPTHING_T]

	deathmatch_p: INTEGER -- index in deathmatchstarts

	nodes: ARRAY [NODE_T]

feature

	P_Init
		do
			i_main.p_switch.P_InitSwitchList
			i_main.p_spec.P_InitPicAnims
			i_main.r_things.R_InitSprites (i_main.info.sprnames)
		end

	P_SetupLevel (episode, map, playermask, skill: INTEGER)
		local
			i: INTEGER
			lumpname: STRING
			lumpnum: INTEGER
		do
			i_main.g_game.totalkills := 0
			i_main.g_game.totalitems := 0
			i_main.g_game.totalsecret := 0
			i_main.g_game.wminfo.maxfrags := 0
			i_main.g_game.wminfo.partime := 180
			from
				i := 0
			until
				i >= {DOOMDEF_H}.MAXPLAYERS
			loop
				i_main.g_game.players [i].killcount := 0
				i_main.g_game.players [i].secretcount := 0
				i_main.g_game.players [i].itemcount := 0
				i := i + 1
			end

				-- Initial height of PointOfView
				-- will be set by player think.
			i_main.g_game.players [i_main.g_game.consoleplayer].viewz := 1

				-- Make sure all sounds are stopped before Z_FreeTags
			i_main.s_sound.S_Start
			i_main.z_zone.Z_FreeTags ({Z_ZONE}.PU_LEVEL, {Z_ZONE}.PU_PURGELEVEL - 1)
			i_main.p_tick.P_InitThinkers

				-- if working with a devlopment map, reload it
			i_main.w_wad.W_Reload

				-- find map name
			if i_main.doomstat_h.gamemode = {GAME_MODE_T}.commercial then
				if map < 10 then
					lumpname := "map0" + map.out
				else
					lumpname := "map" + map.out
				end
			else
				lumpname := "E" + episode.out + "M" + map.out
			end
			lumpnum := i_main.w_wad.W_GetNumForName (lumpname)
			i_main.p_tick.leveltime := 0

				-- note: most of this ordering is important
			P_LoadBlockMap (lumpnum + ML_BLOCKMAP)
			P_LoadVertexes (lumpnum + ML_VERTEXES)
			P_LoadSectors (lumpnum + ML_SECTORS)
			P_LoadSideDefs (lumpnum + ML_SIDEDEFS)
			P_LoadLineDefs (lumpnum + ML_LINEDEFS)
			P_LoadSubsectors (lumpnum + ML_SSECTORS)
			P_LoadNodes (lumpnum + ML_NODES)
			P_LoadSegs (lumpnum + ML_SEGS)
			rejectmatrix := i_main.w_wad.W_CacheLumpNum (lumpnum + ML_REJECT, {Z_ZONE}.PU_LEVEL)
			P_GroupLines
			i_main.g_game.bodyqueslot := 0
			deathmatch_p := deathmatchstarts.lower
			P_LoadThings (lumpnum + ML_THINGS)

				-- if deathmatch, randomly spawn the active players
			if i_main.g_game.deathmatch then
				from
					i := 0
				until
					i >= {DOOMDEF_H}.MAXPLAYERS
				loop
					i_main.g_game.players [i].mo := Void
					i_main.g_game.G_DeathMatchSpawnPlayer (i)
					i := i + 1
				end
			end

				-- clear special respawning que
			i_main.p_mobj.iquehead := 0
			i_main.p_mobj.iquetail := 0

				-- set up world state
			i_main.p_spec.P_SpawnSpecials

				-- preload graphics
			if i_main.doomstat_h.precache then
				i_main.r_data.R_PrecacheLevel
			end
		end

	P_LoadBlockMap (lump: INTEGER)
		do
				-- Stub
		end

	P_LoadVertexes (lump: INTEGER)
		do
				-- Stub
		end

	P_LoadSectors (lump: INTEGER)
		do
				-- Stub
		end

	P_LoadSideDefs (lump: INTEGER)
		do
				-- Stub
		end

	P_LoadLineDefs (lump: INTEGER)
		do
				-- Stub
		end

	P_LoadSubSectors (lump: INTEGER)
		do
				-- Stub
		end

	P_LoadNodes (lump: INTEGER)
		do
				-- Stub
		end

	P_LoadSegs (lump: INTEGER)
		do
				-- Stub
		end

	P_GroupLines
			-- Builds sector line lists and subsector sector numbers.
			-- Finds block bounding boxes for sectors.
		do
				-- Stub

		end

	P_LoadThings (lump: INTEGER)
		do
				-- Stub
		end

end
