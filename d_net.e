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
		end

feature

	skiptics: INTEGER

	localcmds: ARRAY [TICCMD_T]

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

feature

	TryRunTics
		do
				-- Stub
		end

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

end
