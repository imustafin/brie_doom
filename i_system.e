note
	description: "i_system.c"

class
	I_SYSTEM

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

feature

	I_Init
		do
			if {SDL_FUNCTIONS_API}.sdl_init ({SDL_CONSTANT_API}.sdl_init_video | {SDL_CONSTANT_API}.sdl_init_audio) < 0 then
				 i_main.i_error ("Could not initialze SDL: " + {SDL_ERROR}.sdl_get_error)
			end
			i_main.i_sound.I_InitSound
		end

feature

	I_Quit
	do
		-- Stub
		{EXCEPTIONS}.die (0)
	end

end
