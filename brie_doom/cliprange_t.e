note
	description: "[
		cliprange_t from r_bsp.c
		
		ClipWallSegment
		Clips the given range of columns
		and includes it in the new clip list.
	]"

class
	CLIPRANGE_T

inherit

	ANY
		redefine
			out
		end

feature

	first: INTEGER assign set_first

	set_first (a_first: like first)
		do
			first := a_first
		end

	last: INTEGER assign set_last

	set_last (a_last: INTEGER)
		do
			last := a_last
		end

feature

	out: STRING
		do
			Result := "(" + first.out + ", " + last.out + ")"
		end

end
