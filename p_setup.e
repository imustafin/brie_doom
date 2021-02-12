note
	description: "[
		p_setup.c
		Do all the WAD I/O, get map description,
		set up initial state and misc. LUTs.
	]"

class
	P_SETUP

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

feature

	P_Init
		do
			i_main.p_switch.P_InitSwitchList
			i_main.p_spec.P_InitPicAnims
			i_main.r_things.R_InitSprites (i_main.info.sprnames)
		end

end
