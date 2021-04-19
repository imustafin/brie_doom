note
	description: "p_mobj.h"

class
	MOBJ_T

create
	make

feature

	make
		do
		end

feature

	x: FIXED_T

	y: FIXED_T

	z: FIXED_T

	angle: ANGLE_T assign set_angle -- orientation

	set_angle (a_angle: like angle)
		do
			angle := a_angle
		end

	spawnpoint: detachable MAPTHING_T assign set_spawnpoint
			-- For nightmare respawn

	set_spawnpoint (a_spawnpoint: like spawnpoint)
		do
			spawnpoint := spawnpoint
		end

	tics: INTEGER assign set_tics -- state tic counter

	set_tics (a_tics: like tics)
		do
			tics := a_tics
		end

	flags: INTEGER assign set_flags

	set_flags (a_flags: like flags)
		do
			flags := a_flags
		end

	player: detachable PLAYER_T assign set_player
			-- Additional info record for player avatars only.
			-- Only valid if type == MT_PLAYER

	set_player (a_player: like player)
		do
			player := a_player
		end

	health: INTEGER assign set_health

	set_health (a_health: like health)
		do
			health := a_health
		end

feature -- More list: links in sector (if needed)

	snext: detachable MOBJ_T

	sprev: detachable MOBJ_T

end
