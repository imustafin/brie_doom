note
	description: "[
		p_setup.c
		Do all the WAD I/O, get map description,
		set up initial state and misc. LUTs.
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
	P_SETUP

inherit

	DOOMDATA_H

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		local
			i: INTEGER
		do
			i_main := a_i_main
			create deathmatchstarts.make_filled (create {MAPTHING_T}, 0, MAX_DEATHMATCH_STARTS - 1)
			create nodes.make_empty
			create subsectors.make_empty
			create segs.make_empty
			create blocklinks.make_empty
			create blockmaplump.make_empty
			create vertexes.make_empty
			create sectors.make_empty
			create sides.make_empty
			create lines.make_empty
			create playerstarts.make_filled (create {MAPTHING_T}, 0, {DOOMDEF_H}.MAXPLAYERS - 1)
			from
				i := 0
			until
				i > playerstarts.upper
			loop
				playerstarts [i] := create {MAPTHING_T}
				i := i + 1
			end
		end

feature

	rejectmatrix: detachable ARRAY [NATURAL_8]

	MAX_DEATHMATCH_STARTS: INTEGER = 10

	deathmatchstarts: ARRAY [MAPTHING_T]

	deathmatch_p: INTEGER assign set_deathmatch_p -- index in deathmatchstarts

	set_deathmatch_p (a_deathmatch_p: like deathmatch_p)
		do
			deathmatch_p := a_deathmatch_p
		end

	numnodes: INTEGER

	nodes: ARRAY [NODE_T]

	subsectors: ARRAY [SUBSECTOR_T]

	numsegs: INTEGER

	segs: ARRAY [SEG_T]

	numvertexes: INTEGER

	vertexes: ARRAY [VERTEX_T]

	numsectors: INTEGER

	sectors: ARRAY [SECTOR_T]

	numsides: INTEGER

	sides: ARRAY [SIDE_T]

	numlines: INTEGER

	lines: ARRAY [LINE_T]

	playerstarts: ARRAY [MAPTHING_T]

feature -- Blockmap

		-- Created from axis aligned bounding box
		-- of the map, a rectangular array of
		-- blocks of size ...
		-- Used to speed up collision detection
		-- by spatial subdivision in 2D.

	bmapwidth: INTEGER

	bmapheight: INTEGER -- size in mapblocks

	blockmap: detachable INDEX_IN_ARRAY [INTEGER_16] -- int for larger maps

	blockmaplump: ARRAY [INTEGER_16]

		-- offsets in blockmap are from here

	bmaporgx: FIXED_T
			-- origin of block map

	bmaporgy: FIXED_T
			-- origin of block map

	blocklinks: ARRAY [detachable MOBJ_T]
			-- for thing chains

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
			reject_mp: MANAGED_POINTER
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
				-- read rejectmatrix
			reject_mp := i_main.w_wad.W_CacheLumpNum (lumpnum + ML_REJECT)
			rejectmatrix := reject_mp.read_array (0, reject_mp.count)
			check attached rejectmatrix as rm then
				rm.rebase (0)
			end
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
			blockmaplump := {WAD_READER}.read_array_integer_16 (i_main.w_wad.W_CacheLumpNum (lump))
			create blockmap.make (4, blockmaplump)
			bmaporgx := blockmaplump [0].to_integer_32 |<< {M_FIXED}.FRACBITS
			bmaporgy := blockmaplump [1].to_integer_32 |<< {M_FIXED}.FRACBITS
			bmapwidth := blockmaplump [2]
			bmapheight := blockmaplump [3]

				-- clear out mobj chains
			create blocklinks.make_filled (Void, 0, bmapwidth * bmapheight)
		end

	P_LoadVertexes (lump: INTEGER)
		local
			data: MANAGED_POINTER
			i: INTEGER
		do
			numvertexes := i_main.w_wad.W_LumpLength (lump) // {VERTEX_T}.structure_size
			create vertexes.make_filled (create {VERTEX_T}.default_create, 0, numvertexes - 1)
			data := i_main.w_wad.W_CacheLumpNum (lump)
			from
				i := 0
			until
				i >= vertexes.upper
			loop
				vertexes [i] := create {VERTEX_T}.from_pointer (data, i * {VERTEX_T}.structure_size)
				i := i + 1
			end
		end

	P_LoadSectors (lump: INTEGER)
		local
			data: MANAGED_POINTER
			i: INTEGER
		do
			numsectors := i_main.w_wad.w_lumplength (lump) // {SECTOR_T}.structure_size
			create sectors.make_filled (create {SECTOR_T}.make, 0, numsectors - 1)
			data := i_main.w_wad.w_cachelumpnum (lump)
			from
				i := 0
			until
				i > sectors.upper
			loop
				sectors [i] := create {SECTOR_T}.from_pointer (data, i * {SECTOR_T}.structure_size, i_main)
				i := i + 1
			end
		end

	P_LoadSideDefs (lump: INTEGER)
		local
			data: MANAGED_POINTER
			i: INTEGER
		do
			numsides := i_main.w_wad.w_lumplength (lump) // {SIDE_T}.structure_size
			create sides.make_filled (create {SIDE_T}, 0, numsides - 1)
			data := i_main.w_wad.w_cachelumpnum (lump)
			from
				i := 0
			until
				i >= numsides
			loop
				sides [i] := create {SIDE_T}.from_pointer (data, i * {SIDE_T}.structure_size, i_main)
				i := i + 1
			end
		end

	P_LoadLineDefs (lump: INTEGER)
			-- Also counts secret lines for intermissions.
		local
			data: MANAGED_POINTER
			i: INTEGER
		do
			numlines := i_main.w_wad.w_lumplength (lump) // {LINE_T}.structure_size
			create lines.make_filled (create {LINE_T}.make, 0, numlines - 1)
			data := i_main.w_wad.w_cachelumpnum (lump)
			from
				i := 0
			until
				i >= numlines
			loop
				lines [i] := create {LINE_T}.from_pointer (data, i * {LINE_T}.structure_size, i_main)
				i := i + 1
			end
		end

	P_LoadSubSectors (lump: INTEGER)
		local
			data: MANAGED_POINTER
			i: INTEGER
			numsubsectors: INTEGER
		do
			numsubsectors := i_main.w_wad.w_lumplength (lump) // {SUBSECTOR_T}.structure_size
			create subsectors.make_filled (create {SUBSECTOR_T}, 0, numsubsectors - 1)
			data := i_main.w_wad.w_cachelumpnum (lump)
			from
				i := 0
			until
				i >= numsubsectors
			loop
				subsectors [i] := create {SUBSECTOR_T}.from_pointer (data, i * {SUBSECTOR_T}.structure_size)
				i := i + 1
			end
		end

	P_LoadNodes (lump: INTEGER)
		local
			data: MANAGED_POINTER
			i: INTEGER
		do
			numnodes := i_main.w_wad.w_lumplength (lump) // {NODE_T}.structure_size
			create nodes.make_filled (create {NODE_T}.make, 0, numnodes - 1)
			data := i_main.w_wad.w_cachelumpnum (lump)
			from
				i := 0
			until
				i >= numnodes
			loop
				nodes [i] := create {NODE_T}.from_pointer (data, i * {NODE_T}.structure_size)
				i := i + 1
			end
		end

	P_LoadSegs (lump: INTEGER)
		local
			data: MANAGED_POINTER
			i: INTEGER
		do
			numsegs := i_main.w_wad.w_lumplength (lump) // {SEG_T}.structure_size
			create segs.make_filled (create {SEG_T}.make, 0, numsegs - 1)
			data := i_main.w_wad.w_cachelumpnum (lump)
			from
				i := 0
			until
				i >= numsegs
			loop
				segs [i] := create {SEG_T}.from_pointer (data, i * {SEG_T}.structure_size, i_main)
				i := i + 1
			end
		end

	P_GroupLines
			-- Builds sector line lists and subsector sector numbers.
			-- Finds block bounding boxes for sectors.
		local
			linebuffer: ARRAY [LINE_T]
			i, j: INTEGER
			total: INTEGER
			seg: SEG_T
			bbox: ARRAY [FIXED_T]
			block: INTEGER
		do
			create bbox.make_filled (0, 0, 3)
				-- look up sector number for each subsector
			from
				i := subsectors.lower
			until
				i > subsectors.upper
			loop
				seg := segs [subsectors [i].firstline]
				subsectors [i].sector := seg.sidedef.sector
				i := i + 1
			end

				-- count number of lines in each sector
			total := 0
			from
				i := 0
			until
				i >= numlines
			loop
				total := total + 1
				check attached lines [i].frontsector as frontsector then
						-- Very sus, check https://www.doomworld.com/forum/topic/85702-eureka-111-released/?tab=comments#comment-1551735
						-- in theory, frontsector can't be Void but who knows...
					frontsector.linecount := frontsector.linecount + 1
				end
				if attached lines [i].backsector as bs and then bs /= lines [i].frontsector then
					bs.linecount := bs.linecount + 1
				end
				i := i + 1
			end

				-- build line tables for each sector
			create linebuffer.make_filled (create {LINE_T}.make, 0, total - 1)
			from
				i := 0
			until
				i >= numsectors
			loop
				{M_BBOX}.M_ClearBox (bbox)
				from
					j := 0
				until
					j >= numlines
				loop
					if lines [j].frontsector = sectors [i] or lines [j].backsector = sectors [i] then
						sectors [i].lines.extend (lines [j])
						{M_BBOX}.M_AddToBox (bbox, lines [j].v1.x, lines [j].v1.y)
						{M_BBOX}.M_AddToBox (bbox, lines [j].v2.x, lines [j].v2.y)
					end
					j := j + 1
				end
				check
					sectors [i].lines.count = sectors [i].linecount
				end

					-- set the degenmobj_t to the middle of the bounding box
				sectors [i].soundorg.x := (bbox [{M_BBOX}.BOXRIGHT] + bbox [{M_BBOX}.BOXLEFT]) // 2
				sectors [i].soundorg.y := (bbox [{M_BBOX}.BOXTOP] + bbox [{M_BBOX}.BOXBOTTOM]) // 2

					-- adjust bounding box to map blocks
				block := ((bbox [{M_BBOX}.BOXTOP] - bmaporgy + {P_LOCAL}.MAXRADIUS) |>> {P_LOCAL}.MAPBLOCKSHIFT).to_integer_32
				block := if block >= bmapheight then bmapheight - 1 else block end
				sectors [i].blockbox [{M_BBOX}.BOXTOP] := block

					--
				block := ((bbox [{M_BBOX}.BOXBOTTOM] - bmaporgy - {P_LOCAL}.MAXRADIUS) |>> {P_LOCAL}.MAPBLOCKSHIFT).to_integer_32
				block := if block < 0 then 0 else block end
				sectors [i].blockbox [{M_BBOX}.BOXBOTTOM] := block

					--
				block := ((bbox [{M_BBOX}.BOXRIGHT] - bmaporgx + {P_LOCAL}.MAXRADIUS) |>> {P_LOCAL}.MAPBLOCKSHIFT).to_integer_32
				block := if block >= bmapwidth then bmapwidth - 1 else block end
				sectors [i].blockbox [{M_BBOX}.BOXRIGHT] := block

					--
				block := ((bbox [{M_BBOX}.BOXLEFT] - bmaporgx - {P_LOCAL}.MAXRADIUS) |>> {P_LOCAL}.MAPBLOCKSHIFT).to_integer_32
				block := if block < 0 then 0 else block end
				sectors [i].blockbox [{M_BBOX}.BOXLEFT] := block
				i := i + 1
			end
		end

feature -- P_LoadThings

	commercial_monsters: ARRAY [INTEGER]
		once
			Result := <<68, -- Arachnotron
 64, -- Archvile
 88, -- Boss Brain
 89, -- Boss Shooter
 69, -- Hell Knight
 67, -- Mancubus
 71, -- Pain Elemental
 65, -- Former Human Commando
 66, -- Revenant
 84 -- Wolf SS
			>>
		ensure
			instance_free: class
		end

	P_LoadThings (lump: INTEGER)
		local
			data: MANAGED_POINTER
			i: INTEGER
			mt: MAPTHING_T
			numthings: INTEGER
			spawn: BOOLEAN
		do
			data := i_main.w_wad.w_cachelumpnum (lump)
			numthings := i_main.w_wad.w_lumplength (lump) // {MAPTHING_T}.structure_size
			from
				i := 0
				spawn := True
			until
				not spawn or i >= numthings
			loop
				spawn := True
					-- Do not spawn cool, new monsters if !commercial
				create mt.from_pointer (data, i * {MAPTHING_T}.structure_size)
				if i_main.doomstat_h.gamemode /= {GAME_MODE_T}.commercial then
					if commercial_monsters.has (mt.type) then
						spawn := False
					end
				end
				if spawn then
						-- Do spawn all other stuff
					i_main.p_mobj.P_SpawnMapThing (mt)
				end
				i := i + 1
			end
		end

invariant
	playerstarts.lower = 0
	playerstarts.count = {DOOMDEF_H}.MAXPLAYERS
	deathmatchstarts.lower = 0 and deathmatchstarts.count = MAX_DEATHMATCH_STARTS

end
