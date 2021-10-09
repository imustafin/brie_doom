note
	description: "[
		chocolate doom i_midipipe.c
		Client Interface to Midi Server
	]"
	license: "[
		Copyright (C) 2013 James Haley et al.
		Copyright (C) 2017 Alex Mayfield
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
	I_MIDIPIPE

feature

	midi_server_initialized: BOOLEAN
		-- True if the midi process was initialized at least once and has not been
		-- explicitly shut down. This remains true if the server is momentarily
		-- unreachable.

	midi_server_registered: BOOLEAN
		-- True if the current track is being handled via the MIDI server.

end
