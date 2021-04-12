note
	description: "chocolate doom i_musicpack.c"

class
	I_MUSICPACK

inherit

	MUSIC_MODULE_T

create
	make

feature

	make
		do
		end

feature

	sound_devices: ARRAY [INTEGER]
		once
			create Result.make_empty
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

end
