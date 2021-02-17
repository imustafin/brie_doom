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

	make
		do
		end

feature

	netcmds: ARRAYED_LIST [ARRAYED_LIST [TICCMD_T]]
		local
			i: INTEGER
		once
			create Result.make ({DOOMDEF_H}.MAXPLAYERS)
			from
				i := 0
			until
				i >= {DOOMDEF_H}.MAXPLAYERS
			loop
				Result.extend (create {ARRAYED_LIST [TICCMD_T]}.make (BACKUPTICS))
				i := i + 1
			end
		end

feature

	D_CheckNetGame
		do
				-- Stub
		end

feature

	maketic: INTEGER assign set_maketic

	BACKUPTICS: INTEGER = 12

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

end
