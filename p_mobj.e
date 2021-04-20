note
	description: "[
		p_mobj.c
		Moving object handling. Spawn functions.
	]"

class
	P_MOBJ

inherit

	MOBJFLAG_T

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

feature -- P_RemoveMobj

	iquehead: INTEGER assign set_iquehead

	set_iquehead (a_iquehead: like iquehead)
		do
			iquehead := a_iquehead
		end

	iquetail: INTEGER assign set_iquetail

	set_iquetail (a_iquetail: like iquetail)
		do
			iquetail := a_iquetail
		end

	P_SpawnPlayer (mthing: MAPTHING_T)
			-- Called when a player is spawned on the level.
			-- Most of the player structure stays unchanged
			-- between levels.
		local
			p: PLAYER_T
			x, y, z: FIXED_T
			mobj: MOBJ_T
			i: INTEGER
		do
				-- not playing?
			if not i_main.g_game.playeringame [mthing.type - 1] then
					-- return
			else
				p := i_main.g_game.players [mthing.type - 1]
				if p.playerstate = {PLAYER_T}.PST_REBORN then
					i_main.g_game.G_PlayerReborn (mthing.type - 1)
				end
				x := mthing.x.to_integer_32 |<< {M_FIXED}.FRACBITS
				y := mthing.y.to_integer_32 |<< {M_FIXED}.FRACBITS
				z := {P_LOCAL}.ONFLOORZ
				mobj := P_SpawnMobj (x, y, z, {INFO}.MT_PLAYER)

					-- set color translations for player sprites
				if mthing.type > 1 then
					mobj.flags := mobj.flags | (mthing.type - 1) |<< MF_TRANSSHIFT
				end
				mobj.angle := {R_MAIN}.ANG45 * (mthing.angle.to_natural_32 // 45)
				mobj.player := p
				mobj.health := p.health
				p.mo := mobj
				p.playerstate := {PLAYER_T}.PST_LIVE
				p.refire := 0
				p.message := Void
				p.damagecount := 0
				p.bonuscount := 0
				p.extralight := 0
				p.fixedcolormap := 0
				p.viewheight := {P_LOCAL}.VIEWHEIGHT

					-- setup gun psprite
				i_main.p_pspr.P_SetupPsprites (p)

					-- give all cards in death match mode
				if i_main.g_game.deathmatch then
					from
						i := 0
					until
						i >= {DOOMDEF_H}.NUMCARDS
					loop
						p.cards [i] := True
						i := i + 1
					end
				end
				if mthing.type - 1 = i_main.g_game.consoleplayer then
						-- wake up the status bar
					i_main.st_stuff.ST_Start
						-- wake up the heads up text
					i_main.hu_stuff.HU_Start
				end
			end
		end

	P_SpawnMapThing (mthing: MAPTHING_T)
		local
			i: INTEGER
			b: INTEGER -- originally called bit
			mobj: MOBJ_T
			x, y, z: FIXED_T
			returned: BOOLEAN
		do
				-- count deathmatch start positions
			if mthing.type = 11 then
				if i_main.p_setup.deathmatch_p < 10 then
					i_main.p_setup.deathmatchstarts [i_main.p_setup.deathmatch_p] := mthing
					i_main.p_setup.deathmatch_p := i_main.p_setup.deathmatch_p + 1
				end
			elseif mthing.type <= 4 then -- check for players specially
					-- save spots for respawning in network games
				i_main.p_setup.playerstarts [mthing.type - 1] := mthing
				if not i_main.g_game.deathmatch then
					P_SpawnPlayer (mthing)
				end
			elseif not i_main.g_game.netgame and mthing.options & 16 /= 0 then -- check for appropriate skill level
					-- do nothing
			else
				if i_main.g_game.gameskill = {G_GAME}.sk_baby then
					b := 1
				elseif i_main.g_game.gameskill = {G_GAME}.sk_nightmare then
					b := 4
				else
					b := 1 |<< (i_main.g_game.gameskill - 1)
				end
				if mthing.options & b = 0 then
					returned := True
				end
				if not returned then
						-- find which type to spawn
					from
						i := 0
					until
						i >= {INFO}.NUMMOBJTYPES or else mthing.type = {INFO}.mobjinfo [i].doomednum
					loop
						i := i + 1
					end
					if i = {INFO}.NUMMOBJTYPES then
						{I_MAIN}.i_error ("P_SpawnMapThing: Unknown type " + mthing.type.out + " at (" + mthing.x.out + ", " + mthing.y.out + ")")
					end

						-- don't spawn keycards and players in deathmatch
					if i_main.g_game.deathmatch and {INFO}.mobjinfo [i].flags & MF_NOTDMATCH /= 0 then
						returned := True
					end
				end
				if not returned then
						-- don't spawn any monsters if -nomonsters
					check attached i_main.d_doom_main as main then
						if main.nomonsters and (i = {INFO}.MT_SKULL or {INFO}.mobjinfo [i].flags & MF_COUNTKILL /= 0) then
							returned := True
						end
					end
				end
				if not returned then
						-- spawn it
					x := (mthing.x |<< {M_FIXED}.FRACBITS).to_integer_32
					y := (mthing.y |<< {M_FIXED}.FRACBITS).to_integer_32
					if {INFO}.mobjinfo [i].flags & MF_SPAWNCEILING /= 0 then
						z := {P_LOCAL}.ONCEILINGZ
					else
						z := {P_LOCAL}.ONFLOORZ
					end
					mobj := P_SpawnMobj (x, y, z, i)
					mobj.spawnpoint := mthing
					if mobj.tics > 0 then
						mobj.tics := 1 + (i_main.m_random.P_Random \\ mobj.tics)
					end
					if mobj.flags & MF_COUNTKILL /= 0 then
						i_main.g_game.totalkills := i_main.g_game.totalkills + 1
					end
					if mobj.flags & MF_COUNTITEM /= 0 then
						i_main.g_game.totalitems := i_main.g_game.totalitems + 1
					end
					mobj.angle := ({R_MAIN}.ANG45 * (mthing.angle.to_integer_32 // 45)).to_natural_32
					if mthing.options & {DOOMDEF_H}.MTF_AMBUSH /= 0 then
						mobj.flags := mobj.flags | MF_AMBUSH
					end
				end
			end
		end

	P_SpawnMobj (x, y, z: FIXED_T; type: INTEGER): MOBJ_T
		local
			mobj: MOBJ_T
			st: STATE_T
			info: MOBJINFO_T
		do
			create mobj.make
			info := {INFO}.mobjinfo [type]
			mobj.type := type
			mobj.info := info
			mobj.x := x
			mobj.y := y
			mobj.radius := info.radius
			mobj.height := info.height
			mobj.flags := info.flags
			mobj.health := info.spawnhealth
			if i_main.g_game.gameskill /= {DOOMDEF_H}.sk_nightmare then
				mobj.reactiontime := info.reactiontime
			end
			mobj.lastlook := i_main.m_random.p_random \\ {DOOMDEF_H}.MAXPLAYERS
				-- do not set the state with P_SetMobjState,
				-- because action routines can not be called yet
			st := {INFO}.states [info.spawnstate]
			mobj.state := st
			mobj.tics := st.tics.to_integer_32
			mobj.sprite := st.sprite
			mobj.frame := st.frame.to_integer_32

				-- set subsector and/or block links
			i_main.p_maputl.P_SetThingPosition (mobj)
			check attached mobj.subsector as subsector then
				check attached subsector.sector as sector then
					mobj.floorz := sector.floorheight
					mobj.ceilingz := sector.ceilingheight
				end
			end
			if z = {P_LOCAL}.ONFLOORZ then
				mobj.z := mobj.floorz
			elseif z = {P_LOCAL}.ONCEILINGZ then
				check attached mobj.info as attached_info then
					mobj.z := mobj.ceilingz - attached_info.height
				end
			else
				mobj.z := z
			end
			mobj.thinker.function.acp1 := agent P_MobjThinker
			i_main.p_tick.P_AddThinker (mobj.thinker)
			Result := mobj
		end

	P_MobjThinker (mobj: MOBJ_T)
		do
				-- STUB
		end

	P_RespawnSpecials
		do
				-- Stub
		end

end
