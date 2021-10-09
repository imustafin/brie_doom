note
	description: "chocolate doom i_sound.h"
	license: "[
		Copyright (C) 1993-1996 by id Software, Inc.
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
	MUSICINFO_T

create
	make

feature

	make (a_name: STRING; a_lumpnum: INTEGER; a_data, a_handle: detachable ANY)
		do
			name := a_name
			lumpnum := a_lumpnum
			data := a_data
			handle := a_handle
		end

feature

	name: STRING -- up to 6-character name

	lumpnum: INTEGER assign set_lumpnum -- lump number of music

	set_lumpnum (a_lumpnum: like lumpnum)
		do
			lumpnum := a_lumpnum
		end

	data: detachable ANY assign set_data -- music data

	set_data (a_data: like data)
		do
			data := a_data
		end

	handle: detachable ANY assign set_handle -- music handle once registered

	set_handle (a_handle: like handle)
		do
			handle := a_handle
		end

end
