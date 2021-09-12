note
	description: "[
		i_net.c
	]"

class
	I_NET

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

feature

	I_InitNetwork
		do
			print("I_InitNetwork not implemented%N")
			i_main.d_net.doomcom := (create {DOOMCOM_T}.make)
				-- Skip -dup param
			i_main.d_net.doomcom.ticdup := 1
				-- Skip -extratic param
			i_main.d_net.doomcom.extratics := 0

				-- Skip -port param
				-- Skip -net param

				-- single player game
			i_main.g_game.netgame := False
			i_main.d_net.doomcom.id := {D_NET}.doomcom_id
			i_main.d_net.doomcom.numplayers := 1
			i_main.d_net.doomcom.numnodes := 1
			i_main.d_net.doomcom.deathmatch := 0 -- was assigning false originally
			i_main.d_net.doomcom.consoleplayer := 0

				-- Continue skipping -net param
		end

end
