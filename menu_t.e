note
	description: "m_menu.c"

class
	MENU_T

create
	make

feature

	numitems: INTEGER assign set_numitems

	prevMenu: detachable MENU_T assign set_prevmenu

	menuitems: ARRAY [MENUITEM_T]

	routine: PROCEDURE assign set_routine

	x: INTEGER assign set_x

	y: INTEGER assign set_y

	lastOn: INTEGER

feature

	make (a_numitems: like numitems; a_prevmenu: like prevmenu; a_menuitems: like menuitems; a_routine: like routine; a_x: like x; a_y: like y; a_laston: like laston)
		do
			numitems := a_numitems
			prevmenu := a_prevmenu
			menuitems := a_menuitems
			routine := a_routine
			x := a_x
			y := a_y
			laston := a_laston
		end

feature

	set_numitems (a_numitems: like numitems)
		do
			numitems := a_numitems
		end

	set_x (a_x: like x)
		do
			x := a_x
		end

	set_y (a_y: like y)
		do
			y := a_y
		end

	set_prevmenu (a_prevmenu: like prevmenu)
		do
			prevmenu := a_prevmenu
		end

	set_routine (a_routine: like routine)
		do
			routine := a_routine
		end

end
