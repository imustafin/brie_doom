note
	description: "[
		am_map.c
		the automap code
	]"

class
	AM_MAP

create
	make

feature

	make
		do
		end

feature

	automapactive: BOOLEAN assign set_automapactive

	set_automapactive (a_automapactive: like automapactive)
		do
			automapactive := a_automapactive
		end

feature

	AM_Drawer
		do
				-- Stub
		end

feature

	AM_Responder (ev: EVENT_T): BOOLEAN
		do
				-- Stub
		end

feature

	AM_Ticker
		do
				-- Stub
		end

end
