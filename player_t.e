note
	description: "d_player.h"

class
	PLAYER_T

create
	make

feature

	make
		do
			create mo.make
		end

feature -- playerstate_t

	PST_LIVE: INTEGER = 0 -- Playing or camping.

	PST_DEAD: INTEGER = 1 -- Dead on the ground, view follows killer.

	PST_REBORN: INTEGER = 2 -- Ready to restart/respawn???

feature

	mo: detachable MOBJ_T assign set_mo

	set_mo (a_mo: like mo)
		do
			mo := a_mo
		end

	playerstate: INTEGER assign set_playerstate

	set_playerstate (a_playerstate: like playerstate)
		do
			playerstate := a_playerstate
		end

	extralight: INTEGER assign set_extralight -- So gun flashes light up areas

	set_extralight (a_extralight: like extralight)
		do
			extralight := a_extralight
		end

	frags: ARRAY [INTEGER]
		once
			create Result.make_filled (0, 0, {DOOMDEF_H}.MAXPLAYERS - 1)
		end

	killcount: INTEGER assign set_killcount

	set_killcount (a_killcount: like killcount)
		do
			killcount := a_killcount
		end

	secretcount: INTEGER assign set_secretcount

	set_secretcount (a_secretcount: like secretcount)
		do
			secretcount := a_secretcount
		end

	itemcount: INTEGER assign set_itemcount

	set_itemcount (a_itemcount: like itemcount)
		do
			itemcount := a_itemcount
		end

feature -- POV

	viewz: FIXED_T assign set_viewz -- Focal origin above r.z

	set_viewz (a_viewz: like viewz)
		do
			viewz := a_viewz
		end

end
