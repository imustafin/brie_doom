note
	description: "p_mobj.h"

class
	MOBJ_T

create
	make

feature

	make
		do
			create thinker.make
		end

feature -- Movement direction, movement generation (zig-zagging)

	movedir: INTEGER -- 0-7

	movecount: INTEGER assign set_movecount -- when 0, select a new dir

	set_movecount (a_movecount: like movecount)
		do
			movecount := a_movecount
		end

feature

	target: detachable MOBJ_T
			-- Thing being chased/attacked (or NULL),
			-- also the originator for missiles.

	x: FIXED_T assign set_x

	set_x (a_x: like x)
		do
			x := a_x
		end

	y: FIXED_T assign set_y

	set_y (a_y: like y)
		do
			y := a_y
		end

	z: FIXED_T assign set_z

	set_z (a_z: like z)
		do
			z := a_z
		end

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

	type: INTEGER assign set_type

	set_type (a_type: like type)
		do
			type := a_type
		end

	info: detachable MOBJINFO_T assign set_info

	set_info (a_info: like info)
		do
			info := a_info
		end

	radius: FIXED_T assign set_radius

	set_radius (a_radius: like radius)
		do
			radius := a_radius
		end

	height: FIXED_T assign set_height

	set_height (a_height: like height)
		do
			height := a_height
		end

	reactiontime: INTEGER assign set_reactiontime
			-- Reaction time: if non 0, don't attack yet
			-- Used by player to freeze a bit after teleporting

	set_reactiontime (a_reactiontime: like reactiontime)
		do
			reactiontime := a_reactiontime
		end

	lastlook: INTEGER assign set_lastlook
			-- Player number last looked for

	set_lastlook (a_lastlook: like lastlook)
		do
			lastlook := a_lastlook
		end

	state: detachable STATE_T assign set_state

	set_state (a_state: like state)
		do
			state := a_state
		end

	sprite: INTEGER assign set_sprite -- used to find patch_t and flip value

	set_sprite (a_sprite: like sprite)
		do
			sprite := a_sprite
		end

	frame: INTEGER assign set_frame -- might be ORed with FF_FULLBRIGHT

	set_frame (a_frame: like frame)
		do
			frame := a_frame
		end

		-- The closest interval over all contacted Sectors.

	floorz: FIXED_T assign set_floorz

	set_floorz (a_floorz: like floorz)
		do
			floorz := a_floorz
		end

	ceilingz: FIXED_T assign set_ceilingz

	set_ceilingz (a_ceilingz: like ceilingz)
		do
			ceilingz := a_ceilingz
		end

	thinker: THINKER_T assign set_thinker

	set_thinker (a_thinker: like thinker)
		do
			thinker := a_thinker
		end

	subsector: detachable SUBSECTOR_T assign set_subsector

	set_subsector (a_subsector: like subsector)
		do
			subsector := a_subsector
		end

feature -- More list: links in sector (if needed)

	snext: detachable MOBJ_T assign set_snext

	set_snext (a_snext: like snext)
		do
			snext := a_snext
		end

	sprev: detachable MOBJ_T assign set_sprev

	set_sprev (a_sprev: like sprev)
		do
			sprev := a_sprev
		end

feature -- Interaction info, by BLOCKMAP

		-- Link in blocks (if needed)

	bnext: detachable MOBJ_T assign set_bnext

	set_bnext (a_bnext: like bnext)
		do
			bnext := a_bnext
		end

	bprev: detachable MOBJ_T assign set_bprev

	set_bprev (a_bprev: like bprev)
		do
			bprev := a_bprev
		end

feature -- Momentums, used to update position

	momx: FIXED_T assign set_momx

	set_momx (a_momx: like momx)
		do
			momx := a_momx
		end

	momy: FIXED_T assign set_momy

	set_momy (a_momy: like momy)
		do
			momy := a_momy
		end

	momz: FIXED_T assign set_momz

	set_momz (a_momz: like momz)
		do
			momz := a_momz
		end

end
