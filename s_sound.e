note
	description: "[
		s_sound.c
		none
	]"

class
	S_SOUND

create
	make

feature

	make
		do
		end

feature

	snd_SfxVolume: INTEGER = 15

	snd_MusicVolume: INTEGER = 15

feature

	S_Init (sfxVolume: INTEGER; musicVolume: INTEGER)
			-- Initializes sound stuff, including volume
			-- Sets channels, SFX and music volume,
			--  allocates channel buffer, sets S_sfx lookup.
		do
				-- Stub
		end

feature

	S_UpdateSounds (listener_p: MOBJ_T)
		do
				-- Stub
		end

	S_StartSound (origin: detachable ANY; sfx_id: INTEGER)
		do
			S_StartSoundAtVolume (origin, sfx_id, snd_SfxVolume)
		end

	S_StartSoundAtVolume (origin: detachable ANY; sfx_id: INTEGER; volume: INTEGER)
		do
				-- Stub
		end

end
