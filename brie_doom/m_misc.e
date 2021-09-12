note
	description: "[
		m_misc.c
		Main loop menu stuff.
		Default Config File.
		PCX Screenshots.
	]"

class
	M_MISC

inherit

	DOOMDEF_H

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

feature

	usemouse: INTEGER assign set_usemouse

	set_usemouse (a_usemouse: like usemouse)
		do
			usemouse := a_usemouse
		end

	usejoystick: INTEGER assign set_usejoystick

	set_usejoystick (a_usejoystick: like usejoystick)
		do
			usejoystick := a_usejoystick
		end

feature

	defaults: ARRAYED_LIST [TUPLE [name: STRING; set_value: PROCEDURE [INTEGER]; defaultvalue: INTEGER]]
		once
			create Result.make (0)
			Result.extend (["mouse_sensitivity", agent (i_main.m_menu).set_mouseSensitivity, 5])
			Result.extend (["sfx_volume", agent (i_main.s_sound).set_snd_SfxVolume, 8])
			Result.extend (["music_volume", agent (i_main.s_sound).set_snd_MusicVolume, 2])
			Result.extend (["show_messages", agent (i_main.m_menu).set_showMessages, 1])
			Result.extend (["key_right", agent (i_main.g_game).set_key_right, KEY_RIGHTARROW])
			Result.extend (["key_left", agent (i_main.g_game).set_key_left, KEY_LEFTARROW])
			Result.extend (["key_up", agent (i_main.g_game).set_key_up, KEY_UPARROW])
			Result.extend (["key_down", agent (i_main.g_game).set_key_down, KEY_DOWNARROW])
			Result.extend (["key_strafeleft", agent (i_main.g_game).set_key_strafeleft, (',').code])
			Result.extend (["key_straferight", agent (i_main.g_game).set_key_straferight, ('.').code])
			Result.extend (["key_fire", agent (i_main.g_game).set_key_fire, KEY_RCTRL])
			Result.extend (["key_use", agent (i_main.g_game).set_key_use, (' ').code])
			Result.extend (["key_strafe", agent (i_main.g_game).set_key_strafe, KEY_RALT])
			Result.extend (["key_speed", agent (i_main.g_game).set_key_speed, KEY_RSHIFT])
			Result.extend (["use_mouse", agent set_usemouse, 1])
			Result.extend (["key_debug_a", agent (i_main.g_game).set_key_debug_a, ('n').code]) -- debug
			Result.extend (["key_debug_b", agent (i_main.g_game).set_key_debug_b, ('m').code]) -- debug
			Result.extend (["mouseb_fire", agent (i_main.g_game).set_mousebfire, 0])
			Result.extend (["mouseb_strafe", agent (i_main.g_game).set_mousebstrafe, 1])
			Result.extend (["mouseb_forward", agent (i_main.g_game).set_mousebforward, 2])
			Result.extend (["use_joystick", agent set_usejoystick, 0])
			Result.extend (["joyb_fire", agent (i_main.g_game).set_joybfire, 0])
			Result.extend (["joyb_strafe", agent (i_main.g_game).set_joybstrafe, 1])
			Result.extend (["joyb_use", agent (i_main.g_game).set_joybuse, 3])
			Result.extend (["joyb_speed", agent (i_main.g_game).set_joybspeed, 2])
			Result.extend (["screenblocks", agent (i_main.m_menu).set_screenblocks, 9])
			Result.extend (["detaillevel", agent (i_main.m_menu).set_detaillevel, 0])
			Result.extend (["snd_channels", agent (i_main.s_sound).set_numChannels, 3])
			Result.extend (["usegamma", agent (i_main.v_video).set_usegamma, 0])
		end

feature

	M_LoadDefaults
		do
				-- set everything to base values
			across
				defaults as d
			loop
				d.item.set_value.call (d.item.defaultvalue)
			end
			print("M_LoadDefaults not implemented%N")

				-- skip -config
				-- skip reading
		end

	M_ScreenShot
		do
				-- Stub
		end

	M_TempFile (s: STRING): STRING
			-- Returns the path to a temporary file of the given name,
			-- stored inside the system temporary directory.
			--
			-- The returned value must be freed with Z_Free after use.
		local
			tempdir: STRING
		do
				-- skip #ifdef _WIN32
			tempdir := "/tmp"
			Result := tempdir + operating_environment.directory_separator.out + s
		end

	M_WriteFile_managed_pointer (name: STRING; source: MANAGED_POINTER): BOOLEAN
		local
			handle: RAW_FILE
		do
			create handle.make_open_write(name)
			if handle.is_writable then
				handle.put_managed_pointer (source, 0, source.count)
				handle.close
				Result := True
			end
		end

	M_WriteFile_list (name: STRING; source: LIST [NATURAL_8]): BOOLEAN
		local
			handle: RAW_FILE
		do
			create handle.make_open_write (name)
			if handle.is_writable then
				across
					source as s
				loop
					handle.put_natural_8 (s.item)
				end
				handle.close
				Result := True
			end
		end

	M_DirName(path: STRING): STRING
		-- Returns the directory portion of the given path,
		-- without the trailing slash separator character.
		-- If no directory is described in the path,
		-- the string "." is returned. In either case, the result is newly
		-- allocated and must be freed by the caller after use.
	local
		last_sep: INTEGER
	do
		last_sep := path.last_index_of (operating_environment.directory_separator, path.count)
		if last_sep = 0 then
			Result := "."
		else
			Result := path.substring (1, last_sep - 1)
		end
	end

end
