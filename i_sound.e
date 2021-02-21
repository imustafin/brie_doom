note
	description: "[
		i_sound.c
		System interface for sound.
	]"

class
	I_SOUND

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

feature

	I_InitSound
		do
				-- Stub
		end

	I_SoundIsPlaying (handle: INTEGER): BOOLEAN
		do
				-- Ouch.
			Result := i_main.g_game.gametic < handle
		end

	I_UpdateSoundParams (handle, vol, sep, pitch: INTEGER)
	do
		-- Stub
		-- I fal to see that this is used.
		-- Would be using the handle to identify
		--  on which channel the sound might be active,
		--  and resetting the channel parameters

		-- UNUSED
	end

end
