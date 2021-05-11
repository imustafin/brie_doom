note
	description: "[
		d_net.c
		DOOM Network game communication and protocol,
		all OS independend parts.
	]"

class
	D_NET

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			create netbuffer.make
			create doomcom.make
			create localcmds.make_filled (create {TICCMD_T}, 0, BACKUPTICS - 1)
			create nodeforplayer.make_filled (0, 0, {DOOMDEF_H}.MAXPLAYERS - 1)
			create frameskip.make_filled (False, 0, 3)
			create frametics.make_filled (0, 0, 3)
		end

feature

	skiptics: INTEGER

	localcmds: ARRAY [TICCMD_T]

	nodeforplayer: ARRAY [INTEGER]

feature

	netcmds: ARRAY [ARRAY [TICCMD_T]]
		local
			i: INTEGER
			j: INTEGER
		once
			create Result.make_filled (create {ARRAY [TICCMD_T]}.make_empty, 0, {DOOMDEF_H}.maxplayers - 1)
			from
				i := 0
			until
				i >= {DOOMDEF_H}.MAXPLAYERS
			loop
				Result [i] := create {ARRAY [TICCMD_T]}.make_filled (create {TICCMD_T}, 0, BACKUPTICS - 1)
				from
					j := 0
				until
					j >= BACKUPTICS - 1
				loop
					Result [i] [j] := create {TICCMD_T}
					j := j + 1
				end
				i := i + 1
			end
		end

feature

	nettics: ARRAY [INTEGER]
		once
			create Result.make_filled (0, 0, maxnetnodes - 1)
		end

	nodeingame: ARRAY [BOOLEAN]
			-- set false as nodes leave game
		once
			create Result.make_filled (False, 0, maxnetnodes - 1)
		end

	remoteresend: ARRAY [BOOLEAN]
			-- set when local needs tics
		once
			create Result.make_filled (False, 0, maxnetnodes - 1)
		end

	resendto: ARRAY [INTEGER]
			-- set when remote needs tics
		once
			create Result.make_filled (0, 0, maxnetnodes - 1)
		end

feature

	D_CheckNetGame
		local
			i: INTEGER
		do
			from
				i := 0
			until
				i >= MAXNETNODES
			loop
				nodeingame [i] := False
				nettics [i] := 0
				remoteresend [i] := False -- set when local needs tics
				resendto [i] := 0 -- which tic to start sending

				i := i + 1
			end
			check attached i_main.i_net as i_net then
				i_net.I_InitNetwork
			end
			if doomcom.id /= DOOMCOM_ID then
				i_main.i_error ("Doomcom buffer invalid!")
			end
			netbuffer := doomcom.data
			i_main.g_game.consoleplayer := doomcom.consoleplayer
			i_main.g_game.displayplayer := doomcom.consoleplayer
			if i_main.g_game.netgame then
				D_ArbitrateNetStart
			end
			check attached i_main.d_doom_main as d then
				print ("startskill " + d.startskill.out + " deathmatch: " + i_main.g_game.deathmatch.out + " startmap: " + d.startmap.out + " startepisode: " + d.startepisode.out + "%N")
			end
			ticdup := doomcom.ticdup
			maxsend := BACKUPTICS \\ (2 * ticdup) - 1
			if maxsend < 1 then
				maxsend := 1
			end
			from
				i := 0
			until
				i >= doomcom.numplayers
			loop
				i_main.g_game.playeringame [i] := True
				i := i + 1
			end
			from
				i := 0
			until
				i >= doomcom.numnodes
			loop
				nodeingame [i] := True
				i := i + 1
			end
			print ("player " + (i_main.g_game.consoleplayer + 1).out + " of " + doomcom.numplayers.out + " (" + doomcom.numnodes.out + " nodes)%N")
		end

feature

	maketic: INTEGER assign set_maketic

	BACKUPTICS: INTEGER = 12

	MAXNETNODES: INTEGER = 8 -- Max computers/players in a game.

	ticdup: INTEGER

	maxsend: INTEGER -- BACKUPTICS/(2*ticdup)-1

feature

	doomcom: DOOMCOM_T assign set_doomcom

	DOOMCOM_ID: INTEGER_64 = 0x12345678

	netbuffer: DOOMDATA_T

feature

	set_doomcom (a_doomcom: like doomcom)
		do
			doomcom := a_doomcom
		end

feature

	set_maketic (a_maketic: like maketic)
		do
			maketic := a_maketic
		end

feature -- TryRunTics

	oldentertics: INTEGER

	frametics: ARRAY [INTEGER]

	frameon: INTEGER

	frameskip: ARRAY [BOOLEAN]

	oldnettics: INTEGER

	TryRunTics
		local
			i: INTEGER
			lowtic: INTEGER
			entertic: INTEGER
			realtics: INTEGER
			availabletics: INTEGER
			counts: INTEGER
			numplaying: INTEGER
			returned: BOOLEAN
			cmd: TICCMD_T
			buf: INTEGER
			j: INTEGER
		do
				-- get real tics
			entertic := i_main.i_system.i_gettime // ticdup
			realtics := entertic - oldentertics
			oldentertics := entertic

				-- get available tics
			NetUpdate
			lowtic := {DOOMTYPE_H}.MAXINT
			numplaying := 0
			from
				i := 0
			until
				i >= doomcom.numnodes
			loop
				if nodeingame [i] then
					numplaying := numplaying + 1
					if nettics [i] < lowtic then
						lowtic := nettics [i]
					end
				end
				i := i + 1
			end
			availabletics := lowtic - i_main.g_game.gametic // ticdup

				-- decide how many tics to run
			if realtics < availabletics - 1 then
				counts := realtics + 1
			elseif realtics < availabletics then
				counts := realtics
			else
				counts := availabletics
			end
			if counts < 1 then
				counts := 1
			end
			frameon := frameon + 1
			if i_main.d_doom_main.debugfile /= Void then
				{I_MAIN}.i_error ("debug file writing not implemented")
			end
			if not i_main.g_game.demoplayback then
					-- ideally nettics[0] should be 1 - 3 tics above lowtic
					-- if we are consistantly slower, speed up time
				from
					i := 0
				until
					i >= {DOOMDEF_H}.MAXPLAYERS or else i_main.g_game.playeringame [i]
				loop
					i := i + 1
				end
				if i_main.g_game.consoleplayer = i then
						-- the key player does not adapt
				else
					if nettics [0] <= nettics [nodeforplayer [i]] then
						gametime := gametime - 1
					end
					frameskip [frameon & 3] := oldnettics > nettics [nodeforplayer [i]]
					oldnettics := nettics [0]
					if frameskip [0] and frameskip [1] and frameskip [2] and frameskip [3] then
						skiptics := 1
					end
				end
			end

				-- wait for new tics if needed
			from
			until
				lowtic >= i_main.g_game.gametic // ticdup + counts
			loop
				NetUpdate
				lowtic := {DOOMTYPE_H}.MAXINT
				from
					i := 0
				until
					returned or i >= doomcom.numnodes
				loop
					if nodeingame [i] and nettics [i] < lowtic then
						lowtic := nettics [i]
						i := i + 1
					end
				end
				if lowtic < i_main.g_game.gametic // ticdup then
					{I_MAIN}.i_error ("TryRunTics: lowtic < gametic")
				end

					-- don't stay in here forever -- give the menu a chance to work
				if i_main.i_system.i_gettime // ticdup - entertic >= 20 then
					i_main.m_menu.m_ticker
					returned := True
				end
			end
				-- run the count * ticdup dics
			from
			until
				counts = 0
			loop
				counts := counts - 1
				from
					i := 0
				until
					i >= ticdup
				loop
					if i_main.g_game.gametic // ticdup > lowtic then
						{I_MAIN}.i_error ("gametic > lowtic")
					end
					if i_main.d_doom_main.advancedemo then
						i_main.d_doom_main.D_DoAdvanceDemo
					end
					i_main.m_menu.M_Ticker
					i_main.g_game.G_Ticker
					i_main.g_game.gametic := i_main.g_game.gametic + 1
						-- modify command for duplicated tics
					if i /= ticdup - 1 then
						buf := (i_main.g_game.gametic // ticdup) \\ BACKUPTICS
						from
							j := 0
						until
							j >= {DOOMDEF_H}.MAXPLAYERS
						loop
							cmd := netcmds [j] [buf]
							cmd.chatchar := (0).to_character_8
							if cmd.buttons & {D_EVENT}.BT_SPECIAL /= 0 then
								cmd.buttons := 0
							end
							j := j + 1
						end
					end
					i := i + 1
				end
			end
			NetUpdate
		end

feature

	D_ArbitrateNetStart
		do
				-- Stub
		end

feature -- NetUpdate

	gametime: INTEGER

	NetUpdate
			-- Builds ticcmds for console player,
			-- sends out a packet
		local
			nowtime: INTEGER
			newtics: INTEGER
			i, j: INTEGER
			realstart: INTEGER
			gameticdiv: INTEGER
			break: BOOLEAN
		do
				-- check time
			nowtime := i_main.i_system.i_gettime // ticdup
			newtics := nowtime - gametime
			gametime := nowtime
			if newtics > 0 then
					-- something to update
				if skiptics <= newtics then
					newtics := newtics - skiptics
					skiptics := 0
				else
					skiptics := skiptics - newtics
					newtics := 0
				end
				netbuffer.player := (i_main.g_game.consoleplayer).to_natural_8

					-- build new ticcmds for console player
				gameticdiv := i_main.g_game.gametic // ticdup
				from
					i := 0
				until
					break or i >= newtics
				loop
					i_main.i_video.I_StartTic
					check attached i_main.d_doom_main as main then
						main.d_processevents
					end
					if maketic - gameticdiv >= BACKUPTICS // 2 - 1 then
						break := True -- can't hold any more
					else
						i_main.g_game.G_BuildTiccmd (localcmds [maketic \\ BACKUPTICS])
						maketic := maketic + 1
						i := i + 1
					end
				end
				check attached i_main.d_doom_main as main then
					if main.singletics then
							-- Return
					else
						i_main.i_error ("Non-singletics NetUpdate not imlemented")
					end
				end
			else
				check attached i_main.d_doom_main as main then
					if not main.singletics then
							-- if singletics, would have returned beforee
						
							-- :listen
						GetPackets
					end
				end
			end
		end

	GetPackets
		do
				-- Stub
		end

invariant
	localcmds.count = BACKUPTICS
	localcmds.lower = 0
	frametics.lower = 0 and frametics.count = 4
	frameskip.lower = 0 and frameskip.count = 4
	nodeforplayer.lower = 0 and nodeforplayer.count = {DOOMDEF_H}.MAXPLAYERS

end
