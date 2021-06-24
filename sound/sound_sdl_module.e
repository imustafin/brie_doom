note
	description: "chocolate doom i_sdlsound.c"

class
	SOUND_SDL_MODULE

inherit

	SOUND_MODULE_T

create
	make

feature {NONE}

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			create channels_playing.make_filled (Void, 0, NUM_CHANNELS - 1)
		end

feature

	sound_initialized: BOOLEAN

	use_libsamplerate: BOOLEAN = False

	use_sfx_prefix: BOOLEAN

	mixer_freq: INTEGER

	mixer_format: INTEGER_16

	mixer_channels: INTEGER

	NUM_CHANNELS: INTEGER = 16

	channels_playing: ARRAY [detachable ALLOCATED_SOUND_T]

feature

	allocated_sounds_head: detachable ALLOCATED_SOUND_T

	allocated_sounds_tail: detachable ALLOCATED_SOUND_T

	allocated_sounds_size: INTEGER

feature

	release_sound_on_channel (channel: INTEGER)
		local
			snd: ALLOCATED_SOUND_T
		do
			snd := channels_playing [channel]
			{SDL_MIXER_FUNCTIONS_API}.mix_halt_channel (channel).do_nothing
			if attached snd then
				channels_playing [channel] := Void
				unlock_allocated_sound (snd)

					-- if the sound is a pitch-shift and it's not in use, immediately
					-- free it
				if snd.pitch /= {I_SOUND}.NORM_PITCH and snd.use_count <= 0 then
					free_allocated_sound (snd)
				end
			end
		end

	free_allocated_sound (snd: ALLOCATED_SOUND_T)
		do
				-- Unlink from linked list
			allocated_sound_unlink (snd)

				-- Keep track of the amount of allocated sound data:
			allocated_sounds_size := allocated_sounds_size - snd.chunk.alen.to_integer_32

				-- free(snd)
		end

	lock_sound (sfxinfo: SFXINFO_T): BOOLEAN
		do
			Result := True

				-- if the sound isn't loaded, load it now
			if get_allocated_sound_by_sfx_info_and_pitch (sfxinfo, {I_SOUND}.NORM_PITCH) = Void then
				if not cache_sfx (sfxinfo) then
					Result := False
				end
			end
			if Result then
				check attached get_allocated_sound_by_sfx_info_and_pitch (sfxinfo, {I_SOUND}.NORM_PITCH) as snd then
					lock_allocated_sound (snd)
				end
			end
		end

	get_allocated_sound_by_sfx_info_and_pitch (sfxinfo: SFXINFO_T; pitch: INTEGER): detachable ALLOCATED_SOUND_T
		do
			from
				Result := allocated_sounds_head
			until
				Result = Void or else (Result.sfxinfo = sfxinfo and Result.pitch = pitch)
			loop
				Result := Result.next
			end
		end

	pitch_shift (insnd: ALLOCATED_SOUND_T; pitch: INTEGER): ALLOCATED_SOUND_T
		local
			inp: INTEGER -- index in srcbuf
			outp: INTEGER -- index in dstbuf
			srcbuf: MANAGED_POINTER -- Sint16
			dstbuf: MANAGED_POINTER -- Sint16
			srclen, dstlen: NATURAL_32
		do
			srclen := insnd.chunk.alen
			check attached insnd.chunk.abuf_managed as abuf then
				create srcbuf.share_from_pointer (abuf.item, srclen.to_integer_32)
			end

				-- determine ratio pitch:NORM_PITCH and apply to srclen, then invert.
				-- This is an approximation of vanilla behaviour based on measurements
			dstlen := ((1 + (1 - pitch / {I_SOUND}.NORM_PITCH)) * srclen).floor.to_natural_32

				-- ensure that the new buffer is an even length
			if dstlen \\ 2 = 0 then
				dstlen := dstlen + 1
			end
			check attached insnd.sfxinfo as insnd_sfxinfo then
				Result := allocate_sound (insnd_sfxinfo, dstlen)
			end
			if attached Result then
				Result.pitch := pitch
				check attached Result.chunk.abuf_managed as abuf then
					create dstbuf.share_from_pointer (abuf.item, dstlen.to_integer_32) -- dstbuf = (Sint16 *)outsnd->chunk.abuf;
				end

					-- loop over output buffer. find corresponding input cell, copy over
				from
					outp := 0
				until
					outp >= dstlen.to_integer_32
				loop
					inp := (outp // 2) // dstlen.to_integer_32 * srclen.to_integer_32
					dstbuf.put_integer_16 (srcbuf.read_integer_16 (inp), outp)
					outp := outp + 2 -- sizeof Sint16
				end
			end
		end

	lock_allocated_sound (snd: ALLOCATED_SOUND_T)
			-- Lock a sound, to indicate that it may not be freed.
		do
				-- Increase use count, to stop the sound being freed.

			snd.use_count := snd.use_count + 1

				-- When we use a sound, re-link it into the list at the head, so
				-- that the oldest sounds fall to the end of the list for freeing.

			allocated_sound_unlink (snd)
			allocated_sound_link (snd)
		end

	allocated_sound_unlink (snd: ALLOCATED_SOUND_T)
			-- Unlink a sound from the linked list
		do
			if snd.prev = Void then
				allocated_sounds_head := snd.next
			else
				check attached snd.prev as prev then
					prev.next := snd.next
				end
			end
			if snd.next = Void then
				allocated_sounds_tail := snd.prev
			else
				check attached snd.next as next then
					next.prev := snd.prev
				end
			end
		end

	unlock_allocated_sound (snd: ALLOCATED_SOUND_T)
			-- Unlock a sound to indicate that it may now be freed.
		do
			if snd.use_count <= 0 then
				{I_MAIN}.i_error ("Sound effect released more times than it was locked...")
			end
			snd.use_count := snd.use_count - 1
		end

feature

	init (a_use_sfx_prefix: BOOLEAN): BOOLEAN
		local
			i: INTEGER
		do
			use_sfx_prefix := a_use_sfx_prefix
			from
				i := 0
			until
				i >= NUM_CHANNELS
			loop
				channels_playing [i] := Void
				i := i + 1
			end
			if {SDL_FUNCTIONS_API}.sdl_init ({SDL_CONSTANT_API}.sdl_init_audio.to_natural_32) < 0 then
				print ("Unable to set up sound" + {SDL_ERROR}.sdl_get_error)
				Result := False
			else
				if {SDL_MIXER_FUNCTIONS_API}.mix_open_audio_device ({I_SOUND}.snd_samplerate, {SDL_AUDIO}.AUDIO_S16SYS.to_natural_32, 2, get_slice_size, default_pointer, {SDL_CONSTANT_API}.SDL_AUDIO_ALLOW_FREQUENCY_CHANGE) < 0 then
					print ("Error initialising SDL_mixer: " + {MIX_ERROR}.get_error)
					Result := False
				else
					expand_sound_data_sdl_mode := True
					if {SDL_MIXER_FUNCTIONS_API}.mix_query_spec ($mixer_freq, $mixer_format, $mixer_channels) = 0 then
						{I_MAIN}.i_error ("Error Mix_QuerySpec" + {MIX_ERROR}.get_error)
					end
						-- skip libsamplerate
					if use_libsamplerate then
						print ("use_libsamplerate=" + use_libsamplerate.out + " but libsamplerate not supported")
					end
					if {SDL_MIXER_FUNCTIONS_API}.mix_allocate_channels (NUM_CHANNELS) /= NUM_CHANNELS then
						{I_MAIN}.i_error ("Should not happen! Mix_AllocateChannels(" + NUM_CHANNELS.out + ") returned other value")
					end
					{SDl_AUDIO_FUNCTIONS_API}.sdl_pause_audio (0)
					sound_initialized := True
					Result := True
				end
			end
		end

	expand_sound_data_sdl_mode: BOOLEAN
			-- Use ExpandSoudData_SDL? If not, then ExpandSoundData_SRC

	expand_sound_data (sfxinfo: SFXINFO_T; data: POINTER; samplerate, length: INTEGER): BOOLEAN
		do
			check expand_sound_data_sdl_mode then
				Result := expand_sound_data_sdl (sfxinfo, data, samplerate, length)
			end
		end

	expand_sound_data_sdl (sfxinfo: SFXINFO_T; data: POINTER; samplerate: INTEGER; length: INTEGER): BOOLEAN
			-- Generic sound expansion function for any sample rate.
			-- Returns number of clipped samples (always 0).
		local
			convertor: SDL_AUDIO_CVT
			snd_detachable: ALLOCATED_SOUND_T
			chunk: MIX_CHUNK
			expanded_length: NATURAL_32
		do
			create convertor.make

				-- Calculate the length of the expanded version of the sample
			expanded_length := ((length.to_natural_64) * mixer_freq.to_natural_64 // samplerate.to_natural_64).to_natural_32

				-- Double up twice: 8 -> 16 bit and mono -> stereo
			expanded_length := expanded_length * 4

				-- Allocate a chunk in which to expand the sound

			snd_detachable := allocate_sound (sfxinfo, expanded_length)
			if attached snd_detachable as snd then
				chunk := snd.chunk

					-- If we can, use the standard / optimized SDL conversion routines.
				if samplerate <= mixer_freq and then convertible_ratio (samplerate, mixer_freq) and then {SDL_AUDIO_FUNCTIONS_API}.sdl_build_audio_cvt (convertor, {SDL_AUDIO}.AUDIO_U8.to_natural_32, (1).to_character_8, samplerate, mixer_format.to_natural_32, mixer_channels.to_character_8, mixer_freq) /= 0 then
					convertor.set_len (length)
					convertor.allocate_buf (convertor.len * convertor.len_mult) -- malloc(convertor.len * convertor.len_mult)
					check attached convertor.buf_managed as buf then
						buf.item.memory_copy (data.item, length) -- memcpy (buf, data, length)
						if {SDL_AUDIO_FUNCTIONS_API}.sdl_convert_audio (convertor) < 0 then
							{I_MAIN}.i_error ("Couldn't convert audio " + {SDL_ERROR}.sdl_get_error)
						end
						check attached chunk.abuf_managed as abuf then
							abuf.item.memory_copy (buf.item, chunk.alen.to_integer_32) -- memcpy (chunk.abuf, convertor.buf, chunk.alen)
						end
--						buf.item.memory_free -- free (convertor.buf)
						Result := True
					end
				else
					{I_MAIN}.i_error ("Couldn't convert with SDL")
				end
			else
				Result := False
			end
		end

	convertible_ratio (freq1, freq2: INTEGER): BOOLEAN
		local
			ratio: INTEGER
		do
			if freq1 > freq2 then
				Result := convertible_ratio (freq2, freq1)
			elseif freq2 \\ freq1 /= 0 then
					-- Not in a direct ratio
				Result := False
			else
					-- Check the ratio is a power of 2
				ratio := freq2 // freq1
				from
				until
					ratio.bit_and (1) /= 0
				loop
					ratio := ratio |>> 1
				end
				Result := ratio = 1
			end
		end

	reserve_cache_space (len: NATURAL_32)
			-- Enforce SFX cache size limit. We are just about to allocate "len"
			-- bytes on the heap for a new sound effect, so free up some space
			-- so that we keep allocated_sounds_size < snd_cachesize
		do
				-- Stub
		end

	allocate_sound (sfxinfo: SFXINFO_T; len: NATURAL): ALLOCATED_SOUND_T
		local
			snd: ALLOCATED_SOUND_T
		do
				-- Keep allocated sounds within the cache size.
			reserve_cache_space (len)

				-- Allocate the sound structure and data. The data will immediately
				-- follow the structure, which acts as a header.

			create snd.make
				-- skip free and retries

				-- Skip past the chunk structure for the audio buffer

			snd.chunk.allocate_abuf (len.to_integer_32)
			snd.chunk.set_alen (len)
			snd.chunk.set_allocated (1)
			snd.chunk.set_volume ({MIX}.MIX_MAX_VOLUME.to_character_8)
			snd.pitch := {I_SOUND}.NORM_PITCH
			snd.use_count := 0
			snd.sfxinfo := sfxinfo

				-- Keep track of how much memory all these cached sounds are using...

			allocated_sounds_size := allocated_sounds_size + len.to_integer_32
			allocated_sound_link (snd)
			Result := snd
		end

	allocated_sound_link (snd: ALLOCATED_SOUND_T)
			-- Hook a sound into the linked list at the head
		do
			snd.prev := Void
			snd.next := allocated_sounds_head
			allocated_sounds_head := snd
			if allocated_sounds_tail = Void then
				allocated_sounds_tail := snd
			else
				check attached snd.next as next then
					next.prev := snd
				end
			end
		end

	get_slice_size: INTEGER
		do
				-- Stub
			Result := 1024
		end

	sound_devices: ARRAY [INTEGER]
		once
			Result := <<{I_SOUND}.snddevice_sb, {I_SOUND}.snddevice_pas, {I_SOUND}.snddevice_gus, {I_SOUND}.snddevice_waveblaster, {I_SOUND}.snddevice_soundcanvas, {I_SOUND}.snddevice_awe32>>
		end

feature

	shutdown
		do
			if sound_initialized then
				{SDL_MIXER_FUNCTIONS_API}.mix_close_audio
				{SDL_FUNCTIONS_API}.sdl_quit_sub_system ({SDL_CONSTANT_API}.SDL_INIT_AUDIO.to_natural_32)
				sound_initialized := False
			end
		end

	get_sfx_lump_name (sfxinfo: SFXINFO_T): STRING
		local
			sfx: SFXINFO_T
		do
				-- Linked sfx lumps? Get the lump number for the sound linked to.
			if attached sfxinfo.link as link then
				sfx := link
			else
				sfx := sfxinfo
			end

				-- Doom adds a DS* prefix to sound lumps; Heretic and Hexen don't
				-- do this
			check attached sfx.name as name then
				if use_sfx_prefix then
					Result := "ds" + name
				else
					Result := name
				end
			end
		end

	get_sfx_lump_num (sfxinfo: SFXINFO_T): INTEGER
		do
			Result := i_main.w_wad.w_getnumforname (get_sfx_lump_name (sfxinfo))
		end

	update
		local
			i: INTEGER
		do
			from
				i := channels_playing.lower
			until
				i > channels_playing.upper
			loop
				if attached channels_playing [i] and not sound_is_playing (i) then
					release_sound_on_channel (i)
				end
				i := i + 1
			end
		end

	sound_is_playing (handle: INTEGER): BOOLEAN
		do
			if sound_initialized and handle >= 0 and handle < NUM_CHANNELS then
				Result := {SDL_MIXER_FUNCTIONS_API}.mix_playing (handle) /= 0
			end
		end

	update_sound_params (handle, vol, sep: INTEGER)
		local
			left: INTEGER
			right: INTEGER
		do
			if sound_initialized and handle > 0 and handle < NUM_CHANNELS then
				left := ((254 - sep) * vol) // 127
				right := (sep * vol) // 127
				left := left.max (0).min (255)
				right := right.max (0).min (255)
				{SDL_MIXER_FUNCTIONS_API}.mix_set_panning (handle, left.to_character_8, right.to_character_8).do_nothing
			end
		end

	start_sound (sfxinfo: SFXINFO_T; channel, vol, sep, pitch: INTEGER): INTEGER
		local
			snd: ALLOCATED_SOUND_T
			newsnd: ALLOCATED_SOUND_T
		do
			if not sound_initialized or channel < 0 or channel >= NUM_CHANNELS then
				Result := -1
			else
					-- Release a sound effect if there is already one playing
					-- on this channel
				release_sound_on_channel (channel)

					-- Get the sound data
				if not lock_sound (sfxinfo) then
					Result := -1
				else
					snd := get_allocated_sound_by_sfx_info_and_pitch (sfxinfo, pitch)
					if not attached snd then
							-- fetch the base sound effect, un-pitch-shifted
						snd := get_allocated_sound_by_sfx_info_and_pitch (sfxinfo, {I_SOUND}.NORM_PITCH)
						if not attached snd then
							Result := -1
						else
							if {I_SOUND}.snd_pitchshift /= 0 then
								newsnd := pitch_shift (snd, pitch)
								if newsnd /= Void then
									lock_allocated_sound (newsnd)
									unlock_allocated_sound (snd)
									snd := newsnd
								end
							end
						end
					else
						lock_allocated_sound (snd)
					end
					if Result /= -1 then
							-- play sound
						check attached snd as attached_snd then
							{MIX}.mix_play_channel (channel, attached_snd.chunk, 0).do_nothing
							channels_playing [channel] := attached_snd
						end

							-- set separation, etc.
						update_sound_params (channel, vol, sep)
						Result := channel
					end
				end
			end
		end

	stop_sound (handle: INTEGER)
		do
			if sound_initialized and handle >= 0 and handle < NUM_CHANNELS then
					-- Sound data is no longer needed; release the
					-- sound data being used for this channel

				release_sound_on_channel (handle)
			end
		end

	cache_sounds (sounds: ARRAY [SFXINFO_T])
		do
			if not use_libsamplerate then
				cache_sounds_inner (sounds)
			end
		end

	cache_sounds_inner (sounds: ARRAY [SFXINFO_T])
		local
			i: INTEGER
			name: STRING
		do
			print ("Precaching all sound effects...")
			from
				i := sounds.lower
			until
				i > sounds.upper
			loop
				if i \\ 6 = 0 then
					print (".")
				end
				name := get_sfx_lump_name (sounds [i])
				sounds [i].lumpnum := i_main.w_wad.w_checknumforname (name)
				if sounds [i].lumpnum /= -1 then
					if not cache_sfx (sounds [i]) then
						print ("Could not cache sound " + i.out + "%N")
					end
				end
				i := i + 1
			end
		end

	cache_sfx (sfxinfo: SFXINFO_T): BOOLEAN
		local
			lumpnum: INTEGER
			lumplen: NATURAL
			samplerate: INTEGER
			length: NATURAL
			data: MANAGED_POINTER
		do
				-- need to load the sound
			lumpnum := sfxinfo.lumpnum
			data := i_main.w_wad.w_cachelumpnum (lumpnum, {Z_ZONE}.pu_static)
			lumplen := i_main.w_wad.w_lumplength (lumpnum).to_natural_32

				-- check the header, and ensure that is a valid sound
			if lumplen < 8 or data.read_natural_8_le (0) /= 0x03 or data.read_natural_8_le (1) /= 0x00 then
					-- invalid sound
				Result := False
			else
					-- 16 bit sample rate field, 32 bit length field
--				samplerate := ((data.read_natural_8_le (3).to_natural_32 |<< 8) | data.read_natural_8_le (2).to_natural_32).as_integer_32
				samplerate := data.read_integer_16_le (2)
--				length := (data.read_natural_8_le (7).to_natural_32 |<< 24) | (data.read_natural_8_le (6).to_natural_32 |<< 16) | (data.read_natural_8_le (5).to_natural_32 |<< 8) | data.read_natural_8_le (4).to_natural_32
				length := data.read_natural_32_le (4)

					-- If the header specifies that the length of the sound is greater than
					-- the length of the lump itself, this is an invalid sound lump

					-- We also discard sound lumps that are less than 49 samples long,
					-- as ths is how DMX behaves - although the actual cut-off length
					-- seems to vary slightly depending on the sample rate. This needs
					-- further investigation to better understand the correct
					-- behavior.

				if length > lumplen - 8 or length <= 48 then
					Result := False
				else
						-- The DMX sound library seems to skip the first 16 and last 16
						-- bytes of the lump - reason unknown.
					length := length - 32
					create data.share_from_pointer (data.item + 16, length.to_integer_32)

						-- sample rate conversion
					if not expand_sound_data (sfxinfo, data.item + 8, samplerate, length.to_integer_32) then
						Result := False
					else
							-- skip DEBUG_DUMP_WAVS

							-- don't need the original lump any more
						i_main.w_wad.w_releaselumpnum (lumpnum)
						Result := True
					end
				end
			end
		end

feature

	sound_sdl_module (a_i_main: like i_main): SOUND_SDL_MODULE
		once
			create Result.make (a_i_main)
		ensure
			instance_free: class
		end

end
