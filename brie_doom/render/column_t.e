note
	description: "r_defs.h"

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
