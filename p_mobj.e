note
	description: "[
		p_mobj.c
		Moving object handling. Spawn functions.
	]"

class
	P_MOBJ

inherit

	MOBJFLAG_T

	STATENUM_T

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
					x := mthing.x.to_integer_32 |<< {M_FIXED}.FRACBITS
					y := mthing.y.to_integer_32 |<< {M_FIXED}.FRACBITS
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
			after_p_set_thing_position(mobj, z)

			mobj.thinker.function := agent P_MobjThinker(mobj)
			i_main.p_tick.P_AddThinker (mobj)
			Result := mobj
		end

	after_p_set_thing_position (mobj: MOBJ_T; z: FIXED_T)
		-- Part of P_SpawnMobj for updating coords from subsector info
		do
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

		end

	P_MobjThinker (mobj: MOBJ_T)
		local
			returned: BOOLEAN
		do
				-- momentum movement
			if mobj.momx /= 0 or mobj.momy /= 0 or mobj.flags & MF_SKULLFLY /= 0 then
				P_XYMovement (mobj)
				if mobj.thinker.function = Void then
					returned := True -- mobj was removed
				end
			end
			if not returned then
				if mobj.z /= mobj.floorz or mobj.momz /= 0 then
					P_ZMovement (mobj)
					if mobj.thinker.function = Void then
						returned := True
					end
				end
			end
			if not returned then
					-- cycle through states,
					-- calling action functions at transitions
				if mobj.tics /= -1 then
					mobj.tics := mobj.tics - 1

						-- you can cycle through multiple states in a tic
					if mobj.tics = 0 then
						check attached mobj.state as state then
							if not P_SetMobjState (mobj, state.nextstate) then
								returned := True -- freed itself
							end
						end
					end
				else
						-- check for nightmare respawn
					if mobj.flags & MF_COUNTKILL = 0 then
						returned := True
					end
					if not returned then
						if not i_main.g_game.respawnmonsters then
							returned := True
						end
					end
					if not returned then
						mobj.movecount := mobj.movecount + 1
						if mobj.movecount < 12 * 35 then
							returned := True
						end
					end
					if not returned then
						if i_main.p_tick.leveltime & 31 /= 0 then
							returned := True
						end
					end
					if not returned then
						if i_main.m_random.p_random > 4 then
							returned := True
						end
					end
					if not returned then
						P_NightmareRespawn (mobj)
					end
				end
			end
		end

	STOPSPEED: INTEGER = 0x1000

	FRICTION: INTEGER = 0xe800

	P_XYMovement (mo: MOBJ_T)
		local
			ptryx: FIXED_T
			ptryy: FIXED_T
			xmove: FIXED_T
			ymove: FIXED_T
			returned: BOOLEAN
			did_once: BOOLEAN
		do
			if mo.momx = 0 and mo.momy = 0 then
				if mo.flags & MF_SKULLFLY /= 0 then
						-- the skull slammed into something
					mo.flags := mo.flags & MF_SKULLFLY.bit_not
					mo.momx := 0
					mo.momy := 0
					mo.momz := 0
					check attached mo.info as info then
						if P_SetMobjState (mo, info.spawnstate) then
								-- do nothing
						end
					end
				end
				returned := True
			end
			if not returned then
				if mo.momx > {P_LOCAL}.MAXMOVE then
					mo.momx := {P_LOCAL}.MAXMOVE
				elseif mo.momx < - {P_LOCAL}.MAXMOVE then
					mo.momx := - {P_LOCAL}.MAXMOVE
				end
				if mo.momy > {P_LOCAL}.MAXMOVE then
					mo.momy := {P_LOCAL}.MAXMOVE
				elseif mo.momy < - {P_LOCAL}.MAXMOVE then
					mo.momy := - {P_LOCAL}.MAXMOVE
				end
				xmove := mo.momx
				ymove := mo.momy
			end
			from
			until
				returned or (did_once and xmove = 0 and ymove = 0)
			loop
				did_once := True
				if xmove > {P_LOCAL}.MAXMOVE // 2 or ymove > {P_LOCAL}.MAXMOVE // 2 then
					ptryx := mo.x + xmove // 2
					ptryy := mo.y + ymove // 2
					xmove := xmove |>> 1
					ymove := ymove |>> 1
				else
					ptryx := mo.x + xmove
					ptryy := mo.y + ymove
					xmove := 0
					ymove := 0
				end
				if not i_main.p_map.P_TryMove (mo, ptryx, ptryy) then
						-- blocked move
					if attached mo.player then
							-- try to slide along it
						i_main.p_map.P_SlideMove (mo)
					elseif mo.flags & MF_MISSILE /= 0 then
							-- explode a missile
						if attached i_main.p_map.ceilingline as cl and then attached cl.backsector as bs and then bs.ceilingpic = i_main.r_sky.skyflatnum then
								-- Hack to prevent missiles exploding
								-- against the sky.
								-- Does not handle sky floors
							P_RemoveMobj (mo)
							returned := True
						else
							P_ExplodeMissile (mo)
						end
					else
						mo.momx := 0
						mo.momy := 0
					end
				end
			end
			if not returned then
					-- slow down
				if attached mo.player as player and then player.cheats & {CHEAT_T}.CF_NOMOMENTUM /= 0 then
						-- debug option for no sliding at all
					mo.momx := 0
					mo.momy := 0
					returned := True
				end
			end
			if not returned then
				if mo.flags & (MF_MISSILE | MF_SKULLFLY) /= 0 then
					returned := True -- no friction for missiles ever
				end
			end
			if not returned then
				if mo.z > mo.floorz then
					returned := True -- no friction when airborne
				end
			end
			if not returned then
				if mo.flags & MF_CORPSE /= 0 then
						-- do not stop sliding
						-- if halfway off a step with some momentum
					if mo.momx > {M_FIXED}.FRACUNIT // 4 or mo.momx < - {M_FIXED}.FRACUNIT // 4 or mo.momy > {M_FIXED}.FRACUNIT // 4 or mo.momy < - {M_FIXED}.FRACUNIT // 4 then
						check attached mo.subsector as sub and then attached sub.sector as sector then
							if mo.floorz /= sector.floorheight then
								returned := True
							end
						end
					end
				end
			end
			if not returned then
				if mo.momx > - STOPSPEED and mo.momx < STOPSPEED and mo.momy > - STOPSPEED and mo.momy < STOPSPEED and (mo.player = Void or (attached mo.player as player and then player.cmd.forwardmove = 0 and then player.cmd.sidemove = 0)) then
						-- if in a walking frame, stop moving
					if attached mo.player as player and then attached player.mo as pmo and then attached pmo.state as st and then st.is_player_run then
						if P_SetMobjState (pmo, S_PLAY) then
								-- Do nothing
						end
					end
					mo.momx := 0
					mo.momy := 0
				else
					mo.momx := {M_FIXED}.FixedMul (mo.momx, FRICTION)
					mo.momy := {M_FIXED}.FixedMul (mo.momy, FRICTION)
				end
			end
		end

	P_ExplodeMissile (mo: MOBJ_T)
		do
				-- Stub
		end

	P_ZMovement (mo: MOBJ_T)
		local
			dist: FIXED_T
			delta: FIXED_T
			returned: BOOLEAN
		do
				-- check for smooth step up
			if attached mo.player as player and then mo.z < mo.floorz then
				player.viewheight := player.viewheight - (mo.floorz - mo.z)
				player.deltaviewheight := ({P_LOCAL}.VIEWHEIGHT - player.viewheight) |>> 3
			end

				-- adjust height
			mo.z := mo.z + mo.momz
			if mo.flags & MF_FLOAT /= 0 and attached mo.target as target then
					-- float down towards target if too close
				dist := i_main.p_maputl.P_AproxDistance (mo.x - target.x, mo.y - target.y)
				delta := (target.z + (mo.height |>> 1)) - mo.z
				if delta < 0 and dist < - (delta * 3) then
					mo.z := mo.z - {P_LOCAL}.FLOATSPEED
				elseif delta > 0 and dist < (delta * 3) then
					mo.z := mo.z + {P_LOCAL}.FLOATSPEED
				end
			end

				-- clip movement
			if mo.z <= mo.floorz then
					-- hit the floor

					-- Note (id):
					-- somebody left this after setting momz to 0,
					-- kinda useless there.
				if mo.flags & MF_SKULLFLY /= 0 then
						-- the skull slammed into something
					mo.momz := - mo.momz
				end
				if mo.momz < 0 then
					if attached mo.player as player and mo.momz < - {P_LOCAL}.GRAVITY * 8 then
							-- Squat down.
							-- Decrease viewheight for a moment
							-- after hitting the ground (hard),
							-- and utter appropriate sound.
						player.deltaviewheight := mo.momz |>> 3
						i_main.s_sound.s_startsound (mo, {SFXENUM_T}.sfx_oof)
					end
					mo.momz := 0
				end
				mo.z := mo.floorz
				if mo.flags & MF_MISSILE /= 0 and mo.flags & MF_NOCLIP = 0 then
					P_ExplodeMissile (mo)
					returned := True
				end
			elseif not returned and mo.flags & MF_NOGRAVITY = 0 then
				if mo.momz = 0 then
					mo.momz := - {P_LOCAL}.GRAVITY * 2
				else
					mo.momz := mo.momz - {P_LOCAL}.GRAVITY
				end
			end
			if not returned then
				if mo.z + mo.height > mo.ceilingz then
						-- hit the ceiling
					if mo.momz > 0 then
						mo.momz := 0
					end
					mo.z := mo.ceilingz - mo.height
					if mo.flags & MF_SKULLFLY /= 0 then
							-- the skull slammed into something
						mo.momz := - mo.momz
					end
					if mo.flags & MF_MISSILE /= 0 and mo.flags & MF_NOCLIP = 0 then
						P_ExplodeMissile (mo)
					end
				end
			end
		end

	P_NightmareRespawn (mo: MOBJ_T)
		do
				-- Stub
		end

	P_RespawnSpecials
		do
				-- Stub
		end

	P_SetMobjState (mobj: MOBJ_T; a_state: INTEGER): BOOLEAN
			-- Returns true if the mobj is still present
		local
			st: STATE_T
			state: INTEGER
			did_once: BOOLEAN
		do
			state := a_state
			from
				Result := True
				did_once := False
			until
				did_once and (not Result or mobj.tics /= 0)
			loop
				did_once := True
				if state = S_NULL then
					mobj.state := Void
					P_RemoveMobj (mobj)
					Result := False
				else
					st := {INFO}.states [state]
					mobj.state := st
					mobj.tics := st.tics.to_integer_32
					mobj.sprite := st.sprite
					mobj.frame := st.frame.to_integer_32

						-- Modified handling.
						-- Call action functions when the state is set
					if attached st.action as action then
						action.call (i_main.p_enemy, mobj)
					end
					state := st.nextstate
				end
			end
		end

feature -- P_RemoveMobj

	P_RemoveMobj (mobj: MOBJ_T)
		do
			{I_MAIN}.i_error ("P_RemoveMobj is not implemented yet")
		end

end
