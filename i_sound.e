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

	steptable: ARRAY [INTEGER]
			-- Pitch to stepping lookup, unused.
		once
			create Result.make_filled (0, 0, 255)
		end

	vol_lookup: ARRAY [INTEGER]
			-- Volume lookups.
		once
			create Result.make_filled (0, 0, 128 * 256 - 1)
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

	I_SetChannels
			-- SFX API
			-- Note: this was called by S_Init.
			-- However, whatever they did in the
			-- old DPMS based DOS version, this
			-- were simply dummies in the Linux
			-- version.
			-- See soundserver initdata().
		local
			i, j: INTEGER
			steptablemid: INTEGER
		do
			steptablemid := 128

				-- skip commented out channels[i] = 0

				-- This table provides step widths for pitch parameters.
				-- I fail to see that this is currently used.
			from
				i := -128
			until
				i >= 128
			loop
				steptable [steptablemid + i] := ((2).to_real.power (i / 64) * 65536).floor
				i := i + 1
			end

				-- Generates volume lookup tables
				--  which also turn the unsigned samples
				--  into signed samples.
			from
				i := 0
			until
				i >= 128
			loop
				from
					j := 0
				until
					j >= 256
				loop
					vol_lookup [i * 256 + j] := (i * (j - 128) * 256) // 127
					j := j + 1
				end
				i := i + 1
			end
		end

	I_SetMusicVolume (volume: INTEGER)
			-- MUSIC API - dummy. Some code from DOS version.
		do
				-- Internal state variable.
			i_main.s_sound.snd_MusicVolume := volume
				-- Now set volume on output device.
				-- Whatever( snd_MusicVolume );
		end

end
