note
	description: "[
		chocolate doom i_pcsound.c
		System interface for PC speaker sound.
	]"
	license: "[
				Copyright (C) 2005-2014 Simon Howard
				Copyright (C) 2021 Ilgiz Mustafin
		
				This program is free software; you can redistribute it and/or modify
				it under the terms of the GNU General Public License as published by
				the Free Software Foundation; either version 2 of the License, or
				(at your option) any later version.
		
				This program is distributed in the hope that it will be useful,
				but WITHOUT ANY WARRANTY; without even the implied warranty of
				MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
				GNU General Public License for more details.
		
				You should have received a copy of the GNU General Public License along
				with this program; if not, write to the Free Software Foundation, Inc.,
				51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
	]"

class
	SOUND_PCSOUND_MODULE

inherit

	SOUND_MODULE_T

create
	make

feature {NONE}

	make
		do
		end

feature

	sound_devices: ARRAY [INTEGER]
		once
			Result := <<{I_SOUND}.snddevice_pcspeaker>>
		end

	init (use_sfx_prefix: BOOLEAN): BOOLEAN
		do
			{NOT_IMPLEMENTED}.not_implemented ("PCSOUND init", True)
		end

	shutdown
		do
			{NOT_IMPLEMENTED}.not_implemented ("PCSOUND shutdown", True)
		end

	get_sfx_lump_num (sfxinfo: SFXINFO_T): INTEGER
		do
			{NOT_IMPLEMENTED}.not_implemented ("PCSOUND get_sfx_lump_num", True)
		end

	update
		do
			{NOT_IMPLEMENTED}.not_implemented ("PCSOUND update", True)
		end

	update_sound_params (channel, vol, sep: INTEGER)
		do
			{NOT_IMPLEMENTED}.not_implemented ("PCSOUND update_sound_params", True)
		end

	start_sound (sfxinfo: SFXINFO_T; channel, vol, sep, pitch: INTEGER): INTEGER
		do
			{NOT_IMPLEMENTED}.not_implemented ("PCSOUND start_sound", True)
		end

	stop_sound (channel: INTEGER)
		do
			{NOT_IMPLEMENTED}.not_implemented ("PCSOUND stop_sound", True)
		end

	cache_sounds (sounds: ARRAY [SFXINFO_T])
		do
			{NOT_IMPLEMENTED}.not_implemented ("PCSOUND cache_sounds", True)
		end

	sound_is_playing (channel: INTEGER): BOOLEAN
		do
			{NOT_IMPLEMENTED}.not_implemented ("PCSOUND sound_is_playing", True)
		end

feature

	sound_pcsound_module: SOUND_PCSOUND_MODULE
		once
			create Result.make
		ensure
			instance_free: class
		end

end
