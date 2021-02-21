note
	description: "[
		g_game.c
		none
	]"

class
	G_GAME

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

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

feature -- controls (have defaults)

	key_right: INTEGER

	key_left: INTEGER

	key_up: INTEGER

	key_down: INTEGER

	key_strafeleft: INTEGER

	key_straferight: INTEGER

	key_fire: INTEGER

	key_use: INTEGER

	key_strafe: INTEGER

	key_speed: INTEGER

	mousebfire: INTEGER

	mousebstrafe: INTEGER

	mousebforward: INTEGER

	joybfire: INTEGER

	joybstrafe: INTEGER

	joybuse: INTEGER

	joybspeed: INTEGER

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

	demorecording: BOOLEAN

	netgame: BOOLEAN assign set_netgame

	set_netgame (a_netgame: like netgame)
		do
			netgame := a_netgame
		end

	deathmatch: BOOLEAN -- only if started as net death

feature -- G_InitNew

	G_InitNew (skill: INTEGER; episode: INTEGER; map: INTEGER)
		do
				-- Stub
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

	G_Responder (event: EVENT_T): BOOLEAN
		do
				-- Stub
		end

feature -- G_PlayDemo

	defdemoname: detachable STRING

	G_DeferedPlayDemo (name: STRING)
		do
			defdemoname := name
			gameaction := ga_playdemo
		end

end
