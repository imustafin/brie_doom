note
	description: "button_t from p_spec.h"

class
	BUTTON_T

feature

	line: detachable LINE_T assign set_line

	set_line (a_line: like line)
		do
			line := a_line
		end

	where: INTEGER assign set_where

	set_where (a_where: like where)
		do
			where := a_where
		end

	btexture: INTEGER assign set_btexture

	set_btexture (a_btexture: like btexture)
		do
			btexture := a_btexture
		end

	btimer: INTEGER assign set_btimer

	set_btimer (a_btimer: like btimer)
		do
			btimer := a_btimer
		end

	soundorg: detachable DEGENMOBJ_T assign set_soundorg

	set_soundorg (a_soundorg: like soundorg)
		do
			soundorg := a_soundorg
		end

feature -- bwhere_e

	top: INTEGER = 0

	middle: INTEGER = 1

	bottom: INTEGER = 2

end
