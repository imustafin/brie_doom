note
	description: "r_defs.h"
	license: "[
				Copyright (C) 1993-1996 by id Software, Inc.
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
	COLUMN_T

create
	from_pointer

feature

	pointer: MANAGED_POINTER

	offset: INTEGER

feature

	posts: ARRAYED_LIST [POST_T]
		local
			post: POST_T
			ofs: INTEGER
		do
			create Result.make (0)
			from
				ofs := offset
				create post.from_pointer (pointer, ofs)
			until
				post.is_after
			loop
				Result.extend (post)
				ofs := ofs + post.length + 4
				create post.from_pointer (pointer, ofs)
			end
		end

feature

	from_pointer (a_pointer: MANAGED_POINTER; a_offset: INTEGER)
		require
			a_offset >= 0
		do
			pointer := a_pointer
			offset := a_offset
		end

end
