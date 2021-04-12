note
	description: "[
		chocolate doom i_sdlmusic.c
		System interface for music.
	]"

class
	MUSIC_SDL_MODULE

inherit

	MUSIC_MODULE_T

create
	make

feature {NONE}

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

feature

	music_initialized: BOOLEAN

	sdl_was_initialized: BOOLEAN

	musicpaused: BOOLEAN

	current_music_volume: INTEGER

feature

	MAXMIDLENGTH: INTEGER
		once
			Result := 96 * 1024
		end

feature

	music_sdl_module (a_i_main: like i_main): MUSIC_SDL_MODULE
		once
			create Result.make (a_i_main)
		ensure
			instance_free: class
		end

	sound_devices: ARRAY [INTEGER]
		once
			Result := <<{I_SOUND}.snddevice_pas, {I_SOUND}.snddevice_gus, {I_SOUND}.snddevice_waveblaster, {I_SOUND}.snddevice_soundcanvas, {I_SOUND}.snddevice_genmidi, {I_SOUND}.snddevice_awe32>>
		end

	poll
		do
				-- Stub
		end

	sdl_is_initialized: BOOLEAN
		local
			freq, channels: INTEGER
			format: NATURAL_16
		do
			Result := {SDL_MIXER_FUNCTIONS_API}.mix_query_spec ($freq, $format, $channels) /= 0
		end

	remove_timidity_config
		do
				-- Stub
		end

	init: BOOLEAN
			-- Initialize music subsystem
		local
			i: INTEGER
		do
				-- If SDL_mixer is not initialized, we have to initialize it
				-- and have the responsibility to shut it down later on.

			if sdl_is_initialized then
				music_initialized := True
			else
				if {SDL_FUNCTIONS_API}.sdl_init ({SDL_CONSTANT_API}.SDL_INIT_AUDIO.to_natural_32) < 0 then
					print ("Unable to set up sound.%N")
				elseif {SDL_MIXER_FUNCTIONS_API}.mix_open_audio_device ({I_SOUND}.snd_samplerate, {SDL_AUDIO}.AUDIO_S16SYS.to_natural_32, 2, 1024, default_pointer, {SDL_CONSTANT_API}.SDL_AUDIO_ALLOW_FREQUENCY_CHANGE) < 0 then
					print ("Error initializing SDL_mixer: " + {MIX_ERROR}.get_error)
					{SDL_FUNCTIONS_API}.sdl_quit_sub_system ({SDL_CONSTANT_API}.SDL_INIT_AUDIO.to_natural_32)
				else
					{SDL_AUDIO_FUNCTIONS_API}.sdl_pause_audio (0)
					sdl_was_initialized := True
					music_initialized := True
				end
			end

				-- Initialize SDL_Mixer for MIDI music playback
				-- do nothing with i
			i := {SDL_MIXER_FUNCTIONS_API}.Mix_Init ({MIX_INIT_FLAGS_ENUM_API}.MIX_INIT_MID)

				-- Once initialization is complete, the temporary Timidity config
				-- file can be removed.

			remove_timidity_config

				-- If snd_musiccmd is set, we need to call Mix_SetMusicCMD to
				-- configure an external music playback program.

			if not i_main.i_sound.snd_musiccmd.is_empty then
				if {SDL_MIXER_FUNCTIONS_API}.mix_set_music_cmd ((create {C_STRING}.make (i_main.i_sound.snd_musiccmd)).item) < 0 then
					{I_MAIN}.i_error ("Could not Mix_SetMusicCMD " + {MIX_ERROR}.get_error)
				end
			end

				-- skip WIN32 I_MidiPipInitServer
				-- [AM] Start up midiproc to handle playing MIDI music.
				-- Don't enable it for GUS, since it handles its own volume just fine.
			Result := music_initialized
		end

	playsong (a_handle: MIX_MUSIC_STRUCT_API; looping: BOOLEAN)
			-- Start playing a mid
		local
			loops: INTEGER
		do
			if music_initialized then
				if attached a_handle as handle or i_main.i_midipipe.midi_server_registered then
					if looping then
						loops := -1
					else
						loops := 1
					end

						-- skip #if defined(_WIN32)

					if {SDL_MIXER_FUNCTIONS_API}.mix_play_music (a_handle, loops) < 0 then
						{I_MAIN}.i_error ("Could not Mix_PlayMusic " + {MIX_ERROR}.get_error)
					end
				end
			end
		end

	is_mid (mem: MANAGED_POINTER): BOOLEAN
			-- Determine whether memory block is a .mid file
		do
			Result := mem.count > 4 and then mem.item.memory_compare ((create {C_STRING}.make ("MThd")).item, 4)
		end

	registersong (data: MANAGED_POINTER; len: INTEGER): detachable MIX_MUSIC_STRUCT_API
		local
			filename: STRING
		do
			if music_initialized then
					-- MUS files begin with "MUS"
					-- Reject anything which doesnt have this signature

				filename := i_main.m_misc.M_TempFile ("doom.mid")
				if is_mid (data) and data.count < MAXMIDLENGTH then
					if not i_main.m_misc.M_WriteFile_managed_pointer (filename, data) then
						print ("Could not write temp file%N")
					end
				else
						-- Assume a MUS file and try to convert

					ConvertMus (data, len, filename)
				end

					-- Load the MIDI. In an ideal world we'd be using Mix_LoadMUS_RW()
					-- by now, but Mix_SetMusicCMD() only works with Mix_LoadMUS(),
					-- so we have to generate a temporary file.

					-- skip #if defined(_WIN32)

				Result := {MIX}.mix_load_mus (filename)
				if Result = Void then
					print ("Error loading midi: " + {MIX_ERROR}.get_error)
				end
				if i_main.i_sound.snd_musiccmd.is_empty then
						-- (create {RAW_FILE}.make_create_read_write (filename)).delete
				end
			end
		end

	ConvertMus (musdata: MANAGED_POINTER; len: INTEGER; filename: STRING)
		local
			mus2mid: MUS2MID
		do
			create mus2mid.make (musdata)
			mus2mid.fill_output
			if not i_main.m_misc.M_WriteFile_list (filename, mus2mid.output) then
				print ("Error writing midi file " + filename)
			end
		end

	stopsong
		do
			if music_initialized then
					-- skip _WIN32
				if {SDL_MIXER_FUNCTIONS_API}.mix_halt_music /= 0 then
					{I_MAIN}.i_error ("Could not Mix_HaltMusic")
				end
			end
		end

	resumemusic
		do
			if music_initialized then
				musicpaused := False
				UpdateMusicVolume
			end
		end

	UpdateMusicVolume
			-- SDL_mixer's native MIDI music playing does not pause properly.
			-- As a workaround, set the volume to 0 when paused
		local
			vol: INTEGER
		do
			if musicpaused then
				vol := 0
			else
				vol := ((current_music_volume * {MIX}.MIX_MAX_VOLUME) // 127).to_integer_32
			end

				-- skip _WIN32
			vol := {SDL_MIXER_FUNCTIONS_API}.mix_volume_music (vol) -- ignore return value
		end

	unregistersong (handle: detachable MIX_MUSIC_STRUCT_API)
		do
			if music_initialized then
					-- skip _WIN32

				if attached handle as h then
					{SDL_MIXER_FUNCTIONS_API}.mix_free_music (h)
				end
			end
		end

end
