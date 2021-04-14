note
	description: "[
		p_mobj.c
		Moving object handling. Spawn functions.
	]"

class
	P_MOBJ

feature -- P_RemoveMobj

	iquehead: INTEGER assign set_iquehead

	set_iquehead (a_iquehead: like iquehead)
		do
			iquehead := a_iquehead
		end

	iquetail: INTEGER assign set_iquetail

	set_iquetail (a_iquetail: like iquetail)
		do
			iquetail := a_iquetail
		end

end
