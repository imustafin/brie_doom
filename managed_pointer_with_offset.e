note
	description: "Utility class to bundle a managed pointer with an offset"

class
	MANAGED_POINTER_WITH_OFFSET

create
	make

feature

	make (a_m: like m; a_ofs: like ofs)
		do
			m := a_m
			ofs := a_ofs
		end

feature

	m: MANAGED_POINTER

	ofs: INTEGER

end
