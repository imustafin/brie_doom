note
	description: "ammotype_t enum from doomdef.h"

class
	AMMOTYPE_T

feature -- ammotype_t

	am_clip: INTEGER = 0 -- Pistol / chaingun ammo

	am_shell: INTEGER = 1 -- Shotgun / double barreled shotgun

	am_cell: INTEGER = 2 -- Plasma rifle, BFG.

	am_misl: INTEGER = 3 -- Missile launcher

	NUMAMMO: INTEGER = 4

	am_noammo: INTEGER = 5 -- Unlimited for chainsaw / fist.

end
