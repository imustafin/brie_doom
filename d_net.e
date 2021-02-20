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
		end

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
				Result[i] := create {ARRAY [TICCMD_T]}.make_filled (create {TICCMD_T}, 0, BACKUPTICS - 1)
				from
					j := 0
				until
					j >= BACKUPTICS - 1
				loop
					Result[i][j] := create {TICCMD_T}
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
			i_main.i_net.I_InitNetwork
			if doomcom.id /= DOOMCOM_ID then
				i_main.i_error ("Doomcom buffer invalid!")
			end
			netbuffer := doomcom.data
			i_main.g_game.consoleplayer := doomcom.consoleplayer
			i_main.g_game.displayplayer := doomcom.consoleplayer
			if i_main.g_game.netgame then
				D_ArbitrateNetStart
			end
			print ("startskill " + i_main.d_doom_main.startskill.out + " deathmatch: " + i_main.g_game.deathmatch.out + " startmap: " + i_main.d_doom_main.startmap.out + " startepisode: " + i_main.d_doom_main.startepisode.out + "%N")
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

end
