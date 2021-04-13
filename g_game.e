note
	description: "[
		g_game.c
		none
	]"

class
	G_GAME

inherit

	DOOMDEF_H

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

feature

	nodrawers: BOOLEAN -- for comparative timing purposes

feature

	viewactive: BOOLEAN

	singledemo: BOOLEAN -- quit after playing a demo from cmdline

	demoplayback: BOOLEAN

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

	levelstarttic: INTEGER -- gametic at level start

	starttime: INTEGER -- for comparative timing puroses

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
			create Result.make_filled (False, -1, 2)
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

	turnheld: INTEGER

	SLOWTURNTICS: INTEGER = 6

	forwardmove: ARRAY [INTEGER]
		once
			Result := <<0x19, 0x32>>
		end

	sidemove: ARRAY [INTEGER]
		once
			Result := <<0x18, 0x28>>
		end

	angleturn: ARRAY [INTEGER] -- + slow turn
		once
			Result := <<640, 1280, 320>>
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
			check attached i_main.d_doom_main as main then
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
		do
				-- Stub
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
				done or i >= {DOOMDEF_H}.NUMWEAPONS - 1
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
			cmd.forwardmove := cmd.forwardmove + forward
			cmd.sidemove := cmd.sidemove + side

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
		end

feature

	G_DoReborn (playernum: INTEGER)
		do
				-- Stub
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
			i_main.z_zone.Z_CheckHeap

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
			check attached i_main.d_doom_main as main then
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
				-- Stub
		end

	G_DoSaveGame
		do
				-- Stub
		end

	G_DoPlayDemo
		do
				-- Stub
		end

	G_DoCompleted
		do
				-- Stub
		end

	G_DoWorldDone
		do
				-- Stub
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

	playeringame: ARRAY [BOOLEAN]
		once
			create Result.make_filled (False, 0, {DOOMDEF_H}.maxplayers - 1)
		end

feature

	G_Responder (ev: EVENT_T): BOOLEAN
		do
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
						end
							-- skip ev_mouse
							-- skip ev_joystick
					end
				end
			end
		end

feature -- G_PlayDemo

	defdemoname: detachable STRING

	G_DeferedPlayDemo (name: STRING)
		do
			defdemoname := name
			gameaction := ga_playdemo
		end

end
