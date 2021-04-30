note
	description: "chocolate doom i_oplmusic.c"

class
	MUSIC_OPL_MODULE

inherit

	MUSIC_MODULE_T

create
	make

feature {NONE}

	make
		do
		end

feature

	sound_devices: ARRAY [INTEGER]
		once
			Result := <<{I_SOUND}.snddevice_adlib, {I_SOUND}.snddevice_sb>>
		end

	music_opl_module: MUSIC_OPL_MODULE
		once
			create Result.make
		ensure
			instance_free: class
		end

	poll
		do
				-- Stub
		end

	init: BOOLEAN
		do
				-- Stub
		end

	playsong (handle: detachable ANY; looping: BOOLEAN)
		do
				-- Stub
		end

	registersong (handle: detachable ANY; len: INTEGER): detachable ANY
		do
				-- Stub
		end

	stopsong
		do
				-- Stub
		end

	resumemusic
		do
				-- Stub
		end

	unregistersong (handle: detachable ANY)
		do
				-- Stub
		end

	shutdown
		do
				-- Stub
		end

	set_music_volume (vol: INTEGER)
		do
				-- Stub
		end

	pause_music
		do
				-- Stub
		end

	music_is_playing: BOOLEAN
		do
				-- Stub
		end

end
