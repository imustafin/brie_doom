note
	description: "m_menu.c"

class
	MENUITEM_T

create
	make

feature

	status: INTEGER

	name: STRING

	routine: PROCEDURE [TUPLE [INTEGER]] assign set_routine

	alphaKey: CHARACTER

feature

	make (a_status: like status; a_name: like name; a_routine: like routine; a_alphaKey: like alphaKey)
		do
			status := a_status
			name := a_name
			routine := a_routine
			alphaKey := a_alphaKey
		end

feature

	set_routine (a_routine: like routine)
		do
			routine := a_routine
		end

end
