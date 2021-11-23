note
	license: "[
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
	SDL_AUDIO_CVT

inherit

	SDL_AUDIO_CVT_STRUCT_API
		rename
			set_buf as set_buf_api,
			buf as buf_api
		end

create
	make

feature

	buf_managed: detachable MANAGED_POINTER

	allocate_buf (length: INTEGER)
		local
			new_buf: MANAGED_POINTER
		do
			create new_buf.make (length)
			buf_managed := new_buf
			set_c_buf (item, new_buf.item)
		end

end
