note
	description: "[
		g_game.c
		none
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
	G_GAME

inherit

	DOOMDEF_H

	WEAPONTYPE_T

	AMMOTYPE_T

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			create wminfo
			pars := <<<<30, 75, 120, 90, 165, 180, 180, 30, 165>>, <<90, 90, 90, 120, 90, 360, 240, 30, 170>>, <<90, 45, 90, 150, 90, 90, 165, 30, 135>>>>
			cpars := <<30, 90, 120, 120, 90, 150, 120, 120, 270, 90, --  1-10
 210, 150, 150, 150, 210, 150, 420, 150, 210, 150, -- 11-20
 240, 150, 180, 150, 150, 300, 330, 420, 300, 180, -- 21-30
 120, 30 -- 31-32
			>>
			cpars.rebase (0)
			precache := True
		end

feature

	TURBOTHRESHOLD: INTEGER = 0x32

feature

	nodrawers: BOOLEAN -- for comparative timing purposes

	noblit: BOOLEAN -- for comparative timing purposes

	timingdemo: BOOLEAN -- if true, exit with report on completion

feature

	viewactive: BOOLEAN

	singledemo: BOOLEAN -- quit after playing a demo from cmdline

	precache: BOOLEAN

	demoname: detachable STRING

	demoplayback: BOOLEAN

	demobuffer: detachable DEMOLUMP_T -- originally byte*

feature

	paused: BOOLEAN assign set_paused

	set_paused (a_paused: like paused)
		do
			paused := a_paused
		end

	sendpause: BOOLEAN -- send a pause event next tic

	sendsave: BOOLEAN -- send a save event next tic

	usergame: BOOLEAN assign set_usergame -- ok to save / end game

	set_usergame (a_usergame: like usergame)
		do
			usergame := a_usergame
		end

feature

	bodyqueslot: INTEGER assign set_bodyqueslot

	set_bodyqueslot (a_bodyqueslot: like bodyqueslot)
		do
			bodyqueslot := a_bodyqueslot
		end

feature

	levelstarttic: INTEGER -- gametic at level start

	starttime: INTEGER -- for comparative timing puroses

	totalkills: INTEGER assign set_totalkills

	set_totalkills (a_totalkills: like totalkills)
		do
			totalkills := a_totalkills
		end

	totalitems: INTEGER assign set_totalitems

	set_totalitems (a_totalitems: like totalitems)
		do
			totalitems := a_totalitems
		end

	totalsecret: INTEGER assign set_totalsecret

	set_totalsecret (a_totalsecret: like totalsecret)
		do
			totalsecret := a_totalsecret
		end

	wminfo: WBSTARTSTRUCT_T

feature -- controls (have defaults)

	key_right: INTEGER assign set_key_right

	set_key_right (a_key_right: like key_right)
		do
			key_right := a_key_right
		end

	key_left: INTEGER assign set_key_left

	set_key_left (a_key_left: like key_left)
		do
			key_left := a_key_left
		end

	key_up: INTEGER assign set_key_up

	set_key_up (a_key_up: like key_up)
		do
			key_up := a_key_up
		end

	key_down: INTEGER assign set_key_down

	set_key_down (a_key_down: like key_down)
		do
			key_down := a_key_down
		end

	key_strafeleft: INTEGER assign set_key_strafeleft

	set_key_strafeleft (a_key_strafeleft: like key_strafeleft)
		do
			key_strafeleft := a_key_strafeleft
		end

	key_straferight: INTEGER assign set_key_straferight

	set_key_straferight (a_key_straferight: like key_straferight)
		do
			key_straferight := a_key_straferight
		end

	key_fire: INTEGER assign set_key_fire

	set_key_fire (a_key_fire: like key_fire)
		do
			key_fire := a_key_fire
		end

	key_use: INTEGER assign set_key_use

	set_key_use (a_key_use: like key_use)
		do
			key_use := a_key_use
		end

	key_debug_a: INTEGER assign set_key_debug_a
			-- DEBUG

	set_key_debug_a (a_key_debug_a: like key_debug_a)
		do
			key_debug_a := a_key_debug_a
		end

	key_debug_b: INTEGER assign set_key_debug_b
			-- DEBUG

	set_key_debug_b (a_key_debug_b: like key_debug_b)
		do
			key_debug_b := a_key_debug_b
		end

	key_strafe: INTEGER assign set_key_strafe

	set_key_strafe (a_key_strafe: like key_strafe)
		do
			key_strafe := a_key_strafe
		end

	key_speed: INTEGER assign set_key_speed

	set_key_speed (a_key_speed: like key_speed)
		do
			key_speed := a_key_speed
		end

	mousebfire: INTEGER assign set_mousebfire

	set_mousebfire (a_mousebfire: like mousebfire)
		do
			mousebfire := a_mousebfire
		end

	mousebstrafe: INTEGER assign set_mousebstrafe

	set_mousebstrafe (a_mousebstrafe: like mousebstrafe)
		do
			mousebstrafe := a_mousebstrafe
		end

	mousebforward: INTEGER assign set_mousebforward

	set_mousebforward (a_mousebforward: like mousebforward)
		do
			mousebforward := a_mousebforward
		end

	joybfire: INTEGER assign set_joybfire

	set_joybfire (a_joybfire: like joybfire)
		do
			joybfire := a_joybfire
		end

	joybstrafe: INTEGER assign set_joybstrafe

	set_joybstrafe (a_joybstrafe: like joybstrafe)
		do
			joybstrafe := a_joybstrafe
		end

	joybuse: INTEGER assign set_joybuse

	set_joybuse (a_joybuse: like joybuse)
		do
			joybuse := a_joybuse
		end

	joybspeed: INTEGER assign set_joybspeed

	set_joybspeed (a_joybspeed: like joybspeed)
		do
			joybspeed := a_joybspeed
		end

	MAXPLMOVE: INTEGER
		once
			Result := forwardmove [1]
		end

	mousebuttons: ARRAY [BOOLEAN] -- originally `&mousearray[1]' with `boolean mousearray[4]'
		once
			create Result.make_filled (False, -1, {I_INPUT}.max_mouse_buttons - 1)
		end

		-- mouse values are used once

	mousex: INTEGER

	mousey: INTEGER

	dclicktime: INTEGER

	dclickstate: BOOLEAN -- originally int

	dclicks: INTEGER

	dclicktime2: INTEGER

	dclickstate2: BOOLEAN -- originally int

	dclicks2: INTEGER

		-- joystick values are repeated

	joyxmove: INTEGER

	joyymove: INTEGER

	joybuttons: ARRAY [BOOLEAN] -- originall `&joyarray[1]' with `boolean joyarray[5]'
		once
			create Result.make_filled (False, -1, 3)
		end

	savegameslot: INTEGER

	savedescription: detachable STRING

	turnheld: INTEGER

	SLOWTURNTICS: INTEGER = 6

	forwardmove: ARRAY [INTEGER]
		once
			create Result.make_filled (0, 0, 1)
			Result [0] := 0x19
			Result [1] := 0x32
		ensure
			Result.lower = 0 and Result.count = 2
		end

	sidemove: ARRAY [INTEGER]
		once
			create Result.make_filled (0, 0, 1)
			Result [0] := 0x18
			Result [1] := 0x28
		ensure
			Result.lower = 0 and Result.count = 2
		end

	angleturn: ARRAY [INTEGER] -- + slow turn
		once
			create Result.make_filled (0, 0, 2)
			Result [0] := 640
			Result [1] := 1280
			Result [2] := 320
		ensure
			Result.lower = 0 and Result.count = 3
		end

feature

	consistancy: ARRAY [ARRAY [INTEGER]]
		local
			i: INTEGER
		once
			create Result.make_filled (create {ARRAY [INTEGER]}.make_empty, 0, {DOOMDEF_H}.MAXPLAYERS - 1)
			from
				i := 0
			until
				i >= {DOOMDEF_H}.MAXPLAYERS
			loop
				Result [i] := create {ARRAY [INTEGER]}.make_filled (0, 0, {D_NET}.BACKUPTICS - 1)
				i := i + 1
			end
		end

	NUMKEYS: INTEGER = 256

	gamekeydown: ARRAY [BOOLEAN]
		once
			create Result.make_filled (False, 0, NUMKEYS - 1)
		end

feature -- gameaction_t

	ga_nothing: INTEGER = 0

	ga_loadlevel: INTEGER = 1

	ga_newgame: INTEGER = 2

	ga_loadgame: INTEGER = 3

	ga_savegame: INTEGER = 4

	ga_playdemo: INTEGER = 5

	ga_completed: INTEGER = 6

	ga_victory: INTEGER = 7

	ga_worlddone: INTEGER = 8

	ga_screenshot: INTEGER = 9

feature

	gameaction: INTEGER assign set_gameaction

	set_gameaction (a_gameaction: like gameaction)
		do
			gameaction := a_gameaction
		end

	gamestate: INTEGER assign set_gamestate

	set_gamestate (a_gamestate: like gamestate)
		do
			gamestate := a_gamestate
		end

	gameskill: INTEGER

	gameepisode: INTEGER

	gamemap: INTEGER

	respawnmonsters: BOOLEAN

feature

	demorecording: BOOLEAN

	netgame: BOOLEAN assign set_netgame

	set_netgame (a_netgame: like netgame)
		do
			netgame := a_netgame
		end

	deathmatch: BOOLEAN -- only if started as net death

	netdemo: BOOLEAN

feature -- G_InitNew

	d_skill: INTEGER

	d_episode: INTEGER

	d_map: INTEGER

	G_DeferedInitNew (skill, episode, map: INTEGER)
		do
			d_skill := skill
			d_episode := episode
			d_map := map
			gameaction := ga_newgame
		end

	G_InitNew (a_skill: INTEGER; a_episode: INTEGER; a_map: INTEGER)
		local
			i: INTEGER
			skill: INTEGER
			episode: INTEGER
			map: INTEGER
		do
			skill := a_skill
			episode := a_episode
			map := a_map
			if paused then
				paused := False
				i_main.s_sound.s_resumesound
			end
			if skill > sk_nightmare then
				skill := sk_nightmare
			end

				-- This was quite messy with SPECIAL and commented parts
				-- Supposedly hacks to make the latest edition work.
				-- It might not work properly
			if episode < 1 then
				episode := 1
			end
			if i_main.doomstat_h.gamemode = {GAME_MODE_T}.retail then
				if episode > 4 then
					episode := 4
				end
			elseif i_main.doomstat_h.gamemode = {GAME_MODE_T}.shareware then
				if episode > 1 then
					episode := 1 -- only start episode 1 on shareware
				end
			else
				if episode > 3 then
					episode := 3
				end
			end
			if map < 1 then
				map := 1
			end
			if map > 9 and i_main.doomstat_h.gamemode /= {GAME_MODE_T}.commercial then
				map := 9
			end
			i_main.m_random.m_clearrandom
			check attached i_main.d_main as main then
				if skill = sk_nightmare or main.respawnparm then
					respawnmonsters := True
				else
					respawnmonsters := False
				end
				if main.fastparm or (skill = sk_nightmare and gameskill /= sk_nightmare) then
					from
						i := {INFO}.S_SARG_RUN1
					until
						i > {INFO}.S_SARG_PAIN2
					loop
						{INFO}.states [i].tics := {INFO}.states [i].tics |>> 1
						i := i + 1
					end
					{INFO}.mobjinfo [{INFO}.MT_BRUISERSHOT].speed := 20 * {M_FIXED}.FRACUNIT
					{INFO}.mobjinfo [{INFO}.MT_HEADSHOT].speed := 20 * {M_FIXED}.FRACUNIT
					{INFO}.mobjinfo [{INFO}.MT_TROOPSHOT].speed := 20 * {M_FIXED}.FRACUNIT
				elseif skill /= sk_nightmare and gameskill = sk_nightmare then
					from
						i := {INFO}.S_SARG_RUN1
					until
						i > {INFO}.S_SARG_PAIN2
					loop
						{INFO}.states [i].tics := {INFO}.states [i].tics |<< 1
						i := i + 1
					end
					{INFO}.mobjinfo [{INFO}.MT_BRUISERSHOT].speed := 15 * {M_FIXED}.FRACUNIT
					{INFO}.mobjinfo [{INFO}.MT_HEADSHOT].speed := 10 * {M_FIXED}.FRACUNIT
					{INFO}.mobjinfo [{INFO}.MT_TROOPSHOT].speed := 10 * {M_FIXED}.FRACUNIT
				end
			end

				-- force players to be initialized upon first level load
			from
				i := 0
			until
				i >= MAXPLAYERS
			loop
				players [i].playerstate := {D_PLAYER}.PST_REBORN
				i := i + 1
			end
			usergame := True -- will be set false if a demo
			paused := False
			demoplayback := False
			i_main.am_map.automapactive := False
			viewactive := True
			gameepisode := episode
			gamemap := map
			gameskill := skill
			viewactive := True

				-- set sky map for the episode

			if i_main.doomstat_h.gamemode = {GAME_MODE_T}.commercial then
				i_main.r_sky.skytexture := i_main.r_data.r_texturenumforname ("SKY3")
				if gamemap < 12 then
					i_main.r_sky.skytexture := i_main.r_data.r_texturenumforname ("SKY1")
				elseif gamemap < 21 then
					i_main.r_sky.skytexture := i_main.r_data.r_texturenumforname ("SKY2")
				end
			else
				i_main.r_sky.skytexture := i_main.r_data.r_texturenumforname ("SKY" + episode.out)
			end
			G_DoLoadLevel
		end

feature -- G_DoCompleted

	secretexit: BOOLEAN

	G_ExitLevel
		do
			secretexit := False
			gameaction := ga_completed
		end

	G_SecretExitLevel
			-- Here's for the german edition
		do
				-- IF NO WOLF3D LEVELS, NO SECRET EXIT!
			if i_main.doomstat_h.gamemode = {GAME_MODE_T}.commercial and i_main.w_wad.W_CheckNumForName ("map31") < 0 then
				secretexit := False
			else
				secretexit := True
				gameaction := ga_completed
			end
		end

feature

	consoleplayer: INTEGER assign set_consoleplayer -- player taking events and displaying

	displayplayer: INTEGER assign set_displayplayer -- view being displayed

	gametic: INTEGER assign set_gametic

feature

	set_gametic (a_gametic: like gametic)
		do
			gametic := a_gametic
		end

	set_consoleplayer (a_consoleplayer: like consoleplayer)
		do
			consoleplayer := a_consoleplayer
		end

	set_displayplayer (a_displayplayer: like displayplayer)
		do
			displayplayer := a_displayplayer
		end

feature

	G_BeginRecording
		require
			attached demobuffer
		local
			i: INTEGER
		do
			check attached demobuffer as db then
				db.version := {DOOMDEF_H}.version.to_natural_8
				db.skill := gameskill
				db.episode := gameepisode
				db.map := gamemap
				db.deathmatch := deathmatch
				db.respawnparm := i_main.d_main.respawnparm
				db.fastparm := i_main.d_main.fastparm
				db.nomonsters := i_main.d_main.nomonsters
				db.consoleplayer := consoleplayer
				db.playeringame := playeringame.twin
			end
		end

	debug_a
		do
			if attached players [consoleplayer].mo as mo then
				print ("DEBUG_A: player.mo (" + mo.x.out + " " + mo.y.out + " " + mo.z.out + " " + mo.angle.out + ")%N")
			else
				print ("DEBUG_A: player.mo is Void%N")
			end
		end

	debug_b
		do
				--			if attached players [consoleplayer] as p and then attached p.mo as mo then
				--				mo.x := 79471682
				--				mo.y := -231677363
				--				mo.z := 0
				--				mo.angle := (1098907648).to_natural_32
				--					--				i_main.p_maputl.P_SetThingPosition (mo)
				--					--				i_main.p_mobj.after_p_set_thing_position (mo, {P_LOCAL}.onfloorz)
				--				mo.momx := 116642
				--				mo.momy := 414988
				--				mo.momz := 0
				--				p.bob := 863093
				--				p.deltaviewheight := 0
				--				p.viewheight := 2686976
				--				p.viewz := 2891133
				--			else
				--				print ("DEBUG_B: player.mo is Void%N")
				--			end
			G_ExitLevel
		end

	G_BuildTiccmd (cmd: TICCMD_T)
			-- Builds a ticcmd from all of the available inputs
			-- or reads it from the demo buffer.
			-- If recording a demo, write it out
		local
			i: INTEGER
			done: BOOLEAN
			strafe: BOOLEAN
			bstrafe: BOOLEAN
			speed: INTEGER
			tspeed: INTEGER
			forward: INTEGER
			side: INTEGER
			base: TICCMD_T
		do
			base := i_main.i_system.I_BaseTiccmd
			cmd.copy_from (base) -- memcpy(cmd,base,sizeof(*cmd))
			cmd.consistancy := consistancy [consoleplayer] [i_main.d_net.maketic \\ {D_NET}.BACKUPTICS]

				-- DEBUG
			if gamekeydown [key_debug_a] then
				debug_a
			end
			if gamekeydown [key_debug_b] then
				debug_b
			end
			strafe := gamekeydown [key_strafe] or mousebuttons [mousebstrafe] or joybuttons [joybstrafe]
			speed := if gamekeydown [key_speed] or joybuttons [joybspeed] then 1 else 0 end
			forward := 0
			side := 0

				-- use two stage accelerative turning
				-- on the keyboard and joystick
			if joyxmove < 0 or joyxmove > 0 or gamekeydown [key_right] or gamekeydown [key_left] then
				turnheld := turnheld + i_main.d_net.ticdup
			else
				turnheld := 0
			end
			if turnheld < SLOWTURNTICS then
				tspeed := 2 -- slow turn
			else
				tspeed := speed
			end

				-- let movement keys cancel each other out
			if strafe then
				if gamekeydown [key_right] then
					side := side + sidemove [speed]
				end
				if gamekeydown [key_left] then
					side := side - sidemove [speed]
				end
				if joyxmove > 0 then
					side := side + sidemove [speed]
				end
				if joyxmove < 0 then
					side := side - sidemove [speed]
				end
			else
				if gamekeydown [key_right] then
					cmd.angleturn := cmd.angleturn - angleturn [tspeed]
				end
				if gamekeydown [key_left] then
					cmd.angleturn := cmd.angleturn + angleturn [tspeed]
				end
				if joyxmove > 0 then
					cmd.angleturn := cmd.angleturn - angleturn [tspeed]
				end
				if joyxmove < 0 then
					cmd.angleturn := cmd.angleturn + angleturn [tspeed]
				end
			end
			if gamekeydown [key_up] then
				forward := forward + forwardmove [speed]
			end
			if gamekeydown [key_down] then
				forward := forward - forwardmove [speed]
			end
			if joyymove < 0 then
				forward := forward + forwardmove [speed]
			end
			if joyymove > 0 then
				forward := forward - forwardmove [speed]
			end
			if gamekeydown [key_straferight] then
				side := side + sidemove [speed]
			end
			if gamekeydown [key_strafeleft] then
				side := side - sidemove [speed]
			end

				-- buttons
			cmd.chatchar := i_main.hu_stuff.HU_dequeueChatChar
			if gamekeydown [key_fire] or mousebuttons [mousebfire] or joybuttons [joybfire] then
				cmd.buttons := cmd.buttons | {D_EVENT}.BT_ATTACK
			end
			if gamekeydown [key_use] or joybuttons [joybuse] then
				cmd.buttons := cmd.buttons | {D_EVENT}.BT_USE
				dclicks := 0 -- clear double clicks if hit use button
			end

				-- chainsaw overrides
			from
				i := 0
				done := False
			until
				done or i >= NUMWEAPONS - 1
			loop
				if gamekeydown [('1').code + i] then
					cmd.buttons := cmd.buttons | {D_EVENT}.BT_CHANGE
					cmd.buttons := cmd.buttons | (i |<< {D_EVENT}.BT_WEAPONSHIFT)
					done := True
				end
				i := i + 1
			end

				-- mouse
			if mousebuttons [mousebforward] then
				forward := forward + forwardmove [speed]
			end

				-- forward double click
			if mousebuttons [mousebforward] /= dclickstate and dclicktime > 1 then
				dclickstate := mousebuttons [mousebforward]
				if dclickstate then
					dclicks := dclicks + 1
				end
				if dclicks = 2 then
					cmd.buttons := cmd.buttons | {D_EVENT}.BT_USE
					dclicks := 0
				else
					dclicktime := 0
				end
			else
				dclicktime := dclicktime + i_main.d_net.ticdup
				if dclicktime > 20 then
					dclicks := 0
					dclickstate := False
				end
			end

				-- strafe double click
			bstrafe := mousebuttons [mousebstrafe] or joybuttons [joybstrafe]
			if bstrafe /= dclickstate2 and dclicktime2 > 1 then
				dclickstate2 := bstrafe
				if dclickstate2 then
					dclicks2 := dclicks2 + 1
				end
				if dclicks2 = 2 then
					cmd.buttons := cmd.buttons | {D_EVENT}.BT_USE
					dclicks2 := 0
				else
					dclicktime2 := 0
				end
			else
				dclicktime2 := dclicktime2 + i_main.d_net.ticdup
				if dclicktime2 > 20 then
					dclicks2 := 0
					dclickstate2 := False
				end
			end
			forward := forward + mousey
			if strafe then
				side := side + mousex * 2
			else
				cmd.angleturn := cmd.angleturn - mousex * 0x8
			end
			mousex := 0
			mousey := 0
			if forward > MAXPLMOVE then
				forward := MAXPLMOVE
			elseif forward < - MAXPLMOVE then
				forward := - MAXPLMOVE
			end
			if side > MAXPLMOVE then
				side := MAXPLMOVE
			elseif side < - MAXPLMOVE then
				side := - MAXPLMOVE
			end
			cmd.forwardmove := (cmd.forwardmove + forward).to_integer_8
			cmd.sidemove := (cmd.sidemove + side).to_integer_8

				-- special buttons
			if sendpause then
				sendpause := False
				cmd.buttons := {D_EVENT}.BT_SPECIAL | {D_EVENT}.BTS_PAUSE
			end
			if sendsave then
				sendsave := False
				cmd.buttons := {D_EVENT}.BT_SPECIAL | {D_EVENT}.BTS_SAVEGAME | (savegameslot |<< {D_EVENT}.BTS_SAVESHIFT)
			end
		end

	G_Ticker
			-- Make ticcmd_ts for the players.
		local
			i: INTEGER
			buf: INTEGER
			cmd: TICCMD_T
			btn: INTEGER
		do
				-- do player reborns if needed
			from
				i := 0
			until
				i >= {DOOMDEF_H}.MAXPLAYERS
			loop
				if playeringame [i] and players [i].playerstate = {PLAYER_T}.PST_REBORN then
					G_DoReborn (i)
				end
				i := i + 1
			end

				-- do things to change the game state.
			from
			until
				gameaction = ga_nothing
			loop
				if gameaction = ga_loadlevel then
					G_DoLoadLevel
				elseif gameaction = ga_newgame then
					G_DoNewGame
				elseif gameaction = ga_loadgame then
					G_DoLoadGame
				elseif gameaction = ga_savegame then
					G_DoSaveGame
				elseif gameaction = ga_playdemo then
					G_DoPlayDemo
				elseif gameaction = ga_completed then
					G_DoCompleted
				elseif gameaction = ga_victory then
					i_main.f_finale.F_StartFinale
				elseif gameaction = ga_worlddone then
					G_DoWorldDone
				elseif gameaction = ga_screenshot then
					i_main.m_misc.M_ScreenShot
					gameaction := ga_nothing
				end
			end

				-- get commands, check consistancy,
				-- and build new consistancy check
			buf := (gametic // i_main.d_net.ticdup) \\ {D_NET}.BACKUPTICS
			from
				i := 0
			until
				i >= MAXPLAYERS
			loop
				if playeringame [i] then
					cmd := players [i].cmd
					cmd.copy (i_main.d_net.netcmds [i] [buf])
					if demoplayback then
						G_ReadDemoTiccmd (cmd)
					end
					if demorecording then
						G_WriteDemoTiccmd (cmd)
					end

						-- check for turbo cheats
					if cmd.forwardmove > TURBOTHRESHOLD and (gametic & 31 /= 0) and ((gametic |>> 5) & 3) = i then
						players [consoleplayer].message := {HU_STUFF}.player_names [i] + " is turbo!"
					end
					if netgame and not netdemo and gametic \\ i_main.d_net.ticdup = 0 then
						if gametic > {D_NET}.BACKUPTICS and consistancy [i] [buf] /= cmd.consistancy then
							{I_MAIN}.i_error ("consistancy failure (" + cmd.consistancy.out + " should be " + consistancy [i] [buf].out + ")")
						end
						if attached players [i].mo as mo then
							consistancy [i] [buf] := mo.x.to_integer_32
						else
							consistancy [i] [buf] := i_main.m_random.rndindex
						end
					end
				end
				i := i + 1
			end

				-- check for special buttons
			from
				i := 0
			until
				i >= MAXPLAYERS
			loop
				if playeringame [i] then
					if players [i].cmd.buttons & {D_EVENT}.BT_SPECIAL /= 0 then
						btn := players [i].cmd.buttons & {D_EVENT}.BT_SPECIALMASK
						if btn = {D_EVENT}.BTS_PAUSE then
							paused := not paused
							if paused then
								i_main.s_sound.S_PauseSound
							else
								i_main.s_sound.S_ResumeSound
							end
						elseif btn = {D_EVENT}.BTS_SAVEGAME then
							if savedescription = Void then
								savedescription := "NET GAME"
							end
							savegameslot := (players [i].cmd.buttons & {D_EVENT}.BTS_SAVEMASK) |>> {D_EVENT}.BTS_SAVESHIFT
							gameaction := ga_savegame
						end
					end
				end
				i := i + 1
			end

				-- do main actions
			if gamestate = GS_LEVEL then
				i_main.p_tick.P_Ticker
				i_main.st_stuff.ST_Ticker
				i_main.am_map.AM_Ticker
				i_main.hu_stuff.HU_Ticker
			elseif gamestate = GS_INTERMISSION then
				i_main.wi_stuff.WI_Ticker
			elseif gamestate = GS_FINALE then
				i_main.f_finale.F_Ticker
			elseif gamestate = GS_DEMOSCREEN then
				check attached i_main.d_main as d_doom_main then
					d_doom_main.D_PageTicker
				end
			end
		end

feature -- demo

	G_ReadDemoTiccmd (cmd: TICCMD_T)
		require
			attached demobuffer
		do
			check attached demobuffer as db then
				if db.ticks_after then
						-- end of demo data stream
					G_CheckDemoStatus.do_nothing
				else
					cmd.copy_from (db.current_tick.to_ticcmd)
					db.advance_tick
				end
			end
		end

	G_WriteDemoTiccmd (cmd: TICCMD_T)
		require
			attached demobuffer
		do
			if gamekeydown [('q').code] then
				G_CheckDemoStatus.do_nothing
			end
			check attached demobuffer as db then
				db.add_tick (create {DEMOTICK_T}.from_ticcmd (cmd))
				if db.ticks.count * 4 > db.maxsize - 16 then -- demo_p > demoend - 16
						-- no more space
					G_CheckDemoStatus.do_nothing
				else
					G_ReadDemoTiccmd (cmd) -- make SURE it is exactly the same
				end
			end
		end

	G_CheckDemoStatus: BOOLEAN
			-- Called after a death or level completion to allow demos to be cleaned up
			-- Returns true if a new demo loop action will take place
		require
			demorecording implies attached demoname and attached demobuffer
		local
			endtime: INTEGER
			p: MANAGED_POINTER_WITH_OFFSET
		do
			if timingdemo then
				endtime := i_main.i_system.i_gettime
				across
					i_main.i_timer.perfframes is frame
				loop
					print (frame.microseconds.out + "," + frame.description + "%N")
				end
				{I_MAIN}.i_error ("timed " + gametic.out + " gametics in " + (endtime - starttime).out + " realtics")
			end
			if demoplayback then
				if singledemo then
					i_main.i_system.i_quit
				end
				demoplayback := False
				netdemo := False
				netgame := False
				deathmatch := False
				playeringame [1] := False
				playeringame [2] := False
				playeringame [3] := False
				i_main.d_main.respawnparm := False
				i_main.d_main.fastparm := False
				i_main.d_main.nomonsters := False
				consoleplayer := 0
				i_main.d_main.D_AdvanceDemo
				Result := True
			end
			if demorecording then
				check attached demoname as l_demoname and then attached demobuffer as l_demobuffer then
					i_main.m_misc.M_WriteFile_managed_pointer (l_demoname, l_demobuffer.to_managed_pointer).do_nothing
					demobuffer := Void
					demorecording := False
					{I_MAIN}.i_error ("Demo " + l_demoname + " recorded")
				end
			end
		end

feature -- G_TimeDemo

	G_TimeDemo (name: STRING)
		do
			nodrawers := i_main.m_argv.m_checkparm ("-nodraw").to_boolean
			noblit := i_main.m_argv.m_checkparm ("-noblit").to_boolean
			timingdemo := True
			i_main.d_main.singletics := True
			defdemoname := name
			gameaction := ga_playdemo
		end

feature

	G_DoReborn (playernum: INTEGER)
		do
			if not netgame then
					-- reload the level from scratch
				gameaction := ga_loadlevel
			else
				{NOT_IMPLEMENTED}.not_implemented ("G_DoReborn for netgame", true)
			end
		end

feature -- G_DoLoadLevel

	wipegamestate: INTEGER

	G_DoLoadLevel
		local
			i: INTEGER
		do
				-- Set the sky map.
				-- First thing, we have a dummy sky texture name,
				-- a flat. The data is in the WAD only because
				-- we look for an actual index, instead of simply
				-- setting one
			i_main.r_sky.skyflatnum := i_main.r_data.R_FlatNumForName ({R_SKY}.SKYFLATNAME)

				-- DOOM determines the sky texture to be used
				-- depending on the current episode, and the game version.
			if i_main.doomstat_h.gamemode = {GAME_MODE_T}.commercial
				-- or i_main.doomstat_h.gamemode = {GAME_MODE_T}.pack_tnt or i_main.doomstat_h.gamemode = {GAME_MODE_T}.pack_plut
			then
				i_main.r_sky.skytexture := i_main.r_data.r_texturenumforname ("SKY3")
				if gamemap < 12 then
					i_main.r_sky.skytexture := i_main.r_data.R_TextureNumForName ("SKY1")
				elseif gamemap < 21 then
					i_main.r_sky.skytexture := i_main.r_data.r_texturenumforname ("SKY2")
				end
			end
			levelstarttic := gametic -- for time calculation

			if wipegamestate = GS_LEVEL then
				wipegamestate := -1 -- force a wipe
			end
			gamestate := GS_LEVEL
			from
				i := 0
			until
				i >= MAXPLAYERS
			loop
				if playeringame [i] and then players [i].playerstate = {D_PLAYER}.PST_DEAD then
					players [i].playerstate := {D_PLAYER}.PST_REBORN
				end
				players [i].frags.fill_with (0)
				i := i + 1
			end
			i_main.p_setup.P_SetupLevel (gameepisode, gamemap, 0, gameskill)
			displayplayer := consoleplayer -- view the guy you are playing
			starttime := i_main.i_system.I_GetTime
			gameaction := ga_nothing

				-- clear cmd building stuff
			gamekeydown.fill_with (False)
			joyxmove := 0
			joyymove := 0
			mousex := 0
			mousey := 0
			sendpause := False
			sendsave := False
			paused := False
			mousebuttons.fill_with (False)
			joybuttons.fill_with (False)
		end

	G_DoNewGame
		do
			demoplayback := False
			netdemo := False
			netgame := False
			deathmatch := False
			playeringame [1] := False
			playeringame [2] := False
			playeringame [3] := False
			check attached i_main.d_main as main then
				main.respawnparm := False
				main.fastparm := False
				main.nomonsters := False
			end
			consoleplayer := 0
			G_InitNew (d_skill, d_episode, d_map)
			gameaction := ga_nothing
		end

	G_DoLoadGame
		do
			{NOT_IMPLEMENTED}.not_implemented ("G_DoLoadGame", true)
		end

	G_DoSaveGame
		do
			{NOT_IMPLEMENTED}.not_implemented ("G_DoSaveGame", true)
		end

	G_DoPlayDemo
		require
			attached defdemoname
		local
			skill: INTEGER
			i, episode, map: INTEGER
		do
			gameaction := ga_nothing
			check attached defdemoname as l_defdemoname then
				create demobuffer.from_pointer (i_main.w_wad.w_cachelumpname (l_defdemoname))
			end
			check attached demobuffer as l_demobuffer then
				if l_demobuffer.version /= {DOOMDEF_H}.VERSION then
					print ("Demo is from a different game version!%N")
					gameaction := ga_nothing
				else
					skill := l_demobuffer.skill
					episode := l_demobuffer.episode
					map := l_demobuffer.map
					deathmatch := l_demobuffer.deathmatch
					i_main.d_main.respawnparm := l_demobuffer.respawnparm
					i_main.d_main.fastparm := l_demobuffer.fastparm
					i_main.d_main.nomonsters := l_demobuffer.nomonsters
					consoleplayer := l_demobuffer.consoleplayer
					from
						i := 0
					until
						i >= {DOOMDEF_H}.maxplayers
					loop
						playeringame [i] := l_demobuffer.playeringame [i]
						i := i + 1
					end
					if playeringame [1] then
						netgame := True
						netdemo := True
					end

						-- don't spend a lot of time in loadlevel
					precache := False
					G_InitNew (skill, episode, map)
					precache := True
					usergame := False
					demoplayback := True
				end
			end
		end

	G_RecordDemo (name: STRING)
		local
			i: INTEGER
			maxsize: INTEGER
		do
			usergame := False
			demoname := name + ".lmp"
			maxsize := 0x20000
			i := i_main.m_argv.m_checkparm ("-maxdemo")
			if i.to_boolean and i < i_main.m_argv.myargv.count - 1 then
				maxsize := i_main.m_argv.myargv [i + 1].to_integer * 1024
			end
			create demobuffer.make (maxsize)
				-- skip demoend = demobuffer + maxsize
			demorecording := True
		end

	G_PlayerFinishLevel (player: INTEGER)
			-- Can when a player completes a level.
		local
			p: PLAYER_T
		do
			p := players [player]
			p.powers.fill_with (0)
			p.cards.fill_with (False)
			check attached p.mo as mo then
				mo.flags := mo.flags & {P_MOBJ}.MF_SHADOW.bit_not -- cancel invisibility
			end
			p.extralight := 0 -- cancel gun flashes
			p.fixedcolormap := 0 -- cancel ir gogles
			p.damagecount := 0 -- no palette changes
			p.bonuscount := 0
		end

	cpars: ARRAY [INTEGER]

	pars: ARRAY [ARRAY [INTEGER]]

	statcopy: detachable WBSTARTSTRUCT_T

	G_DoCompleted
		local
			i: INTEGER
			returned: BOOLEAN
		do
			gameaction := ga_nothing
			from
				i := 0
			until
				i >= MAXPLAYERS
			loop
				if playeringame [i] then
					G_PlayerFinishLevel (i) -- take away cards and stuff
				end
				i := i + 1
			end
			if i_main.am_map.automapactive then
				i_main.am_map.AM_Stop
			end
			if i_main.doomstat_h.gamemode /= {GAME_MODE_T}.commercial then
				if gamemap = 8 then
					gameaction := ga_victory
					returned := True
				elseif gamemap = 9 then
					from
						i := 0
					until
						i >= MAXPLAYERS
					loop
						players [i].didsecret := True
						i := i + 1
					end
				end
				if not returned then
					wminfo.didsecret := players [consoleplayer].didsecret
					wminfo.epsd := gameepisode - 1
					wminfo.last := gamemap - 1

						-- wminfo.next is 0 biased, unlike gamemap
					if i_main.doomstat_h.gamemode = {GAME_MODE_T}.commercial then
						if secretexit then
							if gamemap = 15 then
								wminfo.next := 30
							elseif gamemap = 31 then
								wminfo.next := 31
							end
						else
							if gamemap = 31 or gamemap = 32 then
								wminfo.next := 15
							else
								wminfo.next := gamemap
							end
						end
					else
						if secretexit then
							wminfo.next := 8 -- go to secret level
						elseif gamemap = 9 then
								-- returning from secret level
							if gameepisode = 1 then
								wminfo.next := 3
							elseif gameepisode = 2 then
								wminfo.next := 5
							elseif gameepisode = 3 then
								wminfo.next := 6
							elseif gameepisode = 4 then
								wminfo.next := 2
							end
						else
							wminfo.next := gamemap -- go to next level
						end
					end
					wminfo.maxkills := totalkills
					wminfo.maxitems := totalitems
					wminfo.maxsecret := totalsecret
					wminfo.maxfrags := 0
					if i_main.doomstat_h.gamemode = {GAME_MODE_T}.commercial then
						wminfo.partime := 35 * cpars [gamemap - 1]
					else
						wminfo.partime := 35 * pars [gameepisode] [gamemap]
					end
					wminfo.pnum := consoleplayer
					from
						i := 0
					until
						i >= MAXPLAYERS
					loop
						wminfo.plyr [i].in := playeringame [i]
						wminfo.plyr [i].skills := players [i].killcount
						wminfo.plyr [i].sitems := players [i].itemcount
						wminfo.plyr [i].ssecret := players [i].secretcount
						wminfo.plyr [i].stime := i_main.p_tick.leveltime
						wminfo.plyr [i].frags.copy (players [i].frags)
						i := i + 1
					end
					gamestate := GS_INTERMISSION
					viewactive := False
					i_main.am_map.automapactive := False
					if attached statcopy as statcopy_attached then
						statcopy_attached.copy (wminfo)
					end
					i_main.wi_stuff.WI_Start (wminfo)
				end
			end
		end

	G_WorldDone
		do
			gameaction := ga_worlddone
			if secretexit then
				players [consoleplayer].didsecret := True
			end
			if i_main.doomstat_h.gamemode = {GAME_MODE_T}.commercial then
				if gamemap = 15 or gamemap = 31 and not secretexit then
						-- break
				elseif gamemap = 6 or gamemap = 11 or gamemap = 20 or gamemap = 30 or gamemap = 15 or gamemap = 31 then
					i_main.f_finale.F_StartFinale
				end
			end
		end

	G_DoWorldDone
		do
			gamestate := GS_LEVEL
			gamemap := wminfo.next + 1
			G_DoLoadLevel
			gameaction := ga_nothing
			viewactive := True
		end

feature

	players: ARRAY [PLAYER_T]
		local
			i: INTEGER
		once
			create Result.make_filled (create {PLAYER_T}.make, 0, {DOOMDEF_H}.maxplayers - 1)
			from
				i := 0
			until
				i >= {DOOMDEF_H}.maxplayers
			loop
				Result [i] := create {PLAYER_T}.make
				i := i + 1
			end
		end

	player_index (p: PLAYER_T): INTEGER
		do
			Result := {UTILS [PLAYER_T]}.first_index (players, p)
		ensure
			players [Result] = p
		end

	playeringame: ARRAY [BOOLEAN]
		once
			create Result.make_filled (False, 0, {DOOMDEF_H}.maxplayers - 1)
		end

feature

	G_Responder (ev: EVENT_T): BOOLEAN
		do
			{NOT_IMPLEMENTED}.not_implemented ("G_Responder", false)
				-- allow spy mode changes even during the demo
			if gamestate = {DOOMDEF_H}.gs_level and ev.type = {EVENT_T}.ev_keydown and ev.data1 = {DOOMDEF_H}.key_f12 and (singledemo or not deathmatch) then
				from
					displayplayer := (displayplayer + 1) \\ MAXPLAYERS
				until
					playeringame [displayplayer] and displayplayer /= consoleplayer
				loop
					displayplayer := (displayplayer + 1) \\ MAXPLAYERS
				end
				Result := True
			else
					-- any other key pops up menu if in demos
				if gameaction = ga_nothing and not singledemo and (demoplayback or gamestate = gs_demoscreen) then
					if ev.type = {EVENT_T}.ev_keydown or (ev.type = {EVENT_T}.ev_mouse and ev.data1 /= 0) or (ev.type = {EVENT_T}.ev_joystick and ev.data1 /= 0) then
						i_main.m_menu.M_StartControlPanel
						Result := True
					else
						Result := False
					end
				else
					if gamestate = GS_LEVEL and then i_main.hu_stuff.HU_Responder (ev) then
						Result := True
					elseif gamestate = GS_LEVEL and then i_main.st_stuff.ST_Responder (ev) then
						Result := True
					elseif gamestate = GS_LEVEL and then i_main.am_map.AM_Responder (ev) then
						Result := True
					elseif gamestate = GS_FINALE and then i_main.f_finale.F_Responder (ev) then
						Result := True
					else
						if ev.type = {EVENT_T}.ev_keydown then
							if ev.data1 = KEY_PAUSE then
								sendpause := True
							else
								if ev.data1 < NUMKEYS then
									gamekeydown [ev.data1] := True
								end
							end
							Result := True
						elseif ev.type = {EVENT_T}.ev_keyup then
							if ev.data1 < NUMKEYS then
								gamekeydown [ev.data1] := False
							end
							Result := False -- always let key up events filter down
						elseif ev.type = {EVENT_T}.ev_mouse then
							SetMouseButtons (ev.data1)
							mousex := ev.data2 * (i_main.m_menu.mouseSensitivity + 5) // 10
							mousey := ev.data3 * (i_main.m_menu.mouseSensitivity + 5) // 10
							Result := True
						end

							-- skip ev_joystick
					end
				end
			end
		end

	SetMouseButtons (a_button_mask: INTEGER)
		local
			i: INTEGER
			button_mask: NATURAL
			button_on: BOOLEAN
		do
			button_mask := a_button_mask.as_natural_32
			from
				i := 0
			until
				i >= {I_INPUT}.MAX_MOUSE_BUTTONS
			loop
				button_on := (button_mask & ({NATURAL} 1 |<< i)) /= 0
					-- Detect button press:
					-- skip mouse weapon next/prev buttons
				mousebuttons [i] := button_on
				i := i + 1
			end
		end

feature -- G_PlayDemo

	defdemoname: detachable STRING

	G_DeferedPlayDemo (name: STRING)
		do
			defdemoname := name
			gameaction := ga_playdemo
		end

feature

	G_DeathMatchSpawnPlayer (playernum: INTEGER)
			-- Spawns a player at one of the random death match spots
			-- called at level load and each death
		do
			{NOT_IMPLEMENTED}.not_implemented ("G_DeathMatchSpawnPlayer", False)
		end

feature

	G_PlayerReborn (player: INTEGER)
			-- Called after a player dies
			-- almost everything is cleared and initialized
		local
			p: PLAYER_T
			i: INTEGER
			frags: ARRAY [INTEGER]
			killcount: INTEGER
			itemcount: INTEGER
			secretcount: INTEGER
		do
			create frags.make_empty
			frags.copy (players [player].frags)
			killcount := players [player].killcount
			itemcount := players [player].itemcount
			secretcount := players [player].secretcount
			p := players [player]
			p.reset
			p.frags.copy (frags)
			p.killcount := killcount
			p.secretcount := secretcount
			p.usedown := True
			p.attackdown := True
			p.playerstate := {PLAYER_T}.pst_live
			p.health := {P_LOCAL}.MAXHEALTH
			p.readyweapon := wp_pistol
			p.pendingweapon := wp_pistol
			p.weaponowned [wp_fist] := True
			p.weaponowned [wp_pistol] := True
			p.ammo [am_clip] := 50
			from
				i := 0
			until
				i >= NUMAMMO
			loop
				p.maxammo [i] := {P_INTER}.maxammo [i]
				i := i + 1
			end
		end

invariant
	cpars.lower = 0 and cpars.count = 32
	pars.lower = 1 and pars.count = 3 and across pars as p all p.item.lower = 1 and p.item.count = 9 end

end
