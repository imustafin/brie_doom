note
	description: "[
		wi_stuff.c
		Intermission screens.
	]"

class
	WI_STUFF

create
	make

feature

	make
		do
		end

feature

	WI_Drawer
		do
				-- Stub
		end

	WI_Ticker
		do
				-- Stub
		end

	WI_Start(wbstartstruct: WBSTARTSTRUCT_T)
		do
			{I_MAIN}.i_error ("WI_Start not implemented")
		end

end
