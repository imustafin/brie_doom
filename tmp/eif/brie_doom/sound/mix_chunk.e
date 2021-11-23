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
	MIX_CHUNK

inherit

	MIX_CHUNK_STRUCT_API
		rename
			set_abuf as set_abuf_api,
			abuf as abuf_api
		end

create
	make

feature -- abuf

	abuf_managed: detachable MANAGED_POINTER

	allocate_abuf (len: INTEGER)
		local
			new_abuf: MANAGED_POINTER
		do
			create new_abuf.make (len)
			abuf_managed := new_abuf
			set_c_abuf (item, new_abuf.item)
		end

end
