note
	description: "weaponinfo_t from d_items.h"

class
	WEAPONINFO_T

create
	default_create, make

feature

	make (a_ammo: INTEGER; a_upstate: INTEGER; a_downstate: INTEGER; a_readystate: INTEGER; a_atkstate: INTEGER; a_flashstate: INTEGER)
		do
			ammo := a_ammo
			upstate := a_upstate
			downstate := a_downstate
			readystate := a_readystate
			atkstate := a_atkstate
			flashstate := a_flashstate
		end

feature

	ammo: INTEGER

	upstate: INTEGER

	downstate: INTEGER

	readystate: INTEGER

	atkstate: INTEGER

	flashstate: INTEGER

end
