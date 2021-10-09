note
	description: "p_mobj.h"
	license: "[
		Copyright (C) 1993-1996 by id Software, Inc.
		Copyright (C) 2005-2014 Simon Howard
		Copyright (C) 2021 Ilgiz Mustafin

		This program is free software; you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation; either version 2 of the License, or
		(at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License along
		with this program; if not, write to the Free Software Foundation, Inc.,
		51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
	]"

class
	MOBJ_T

inherit

	DEGENMOBJ_T

	WITH_THINKER

create
	make

feature

	make
		do
			make_thinker
		end

feature -- Movement direction, movement generation (zig-zagging)

	movedir: INTEGER assign set_movedir
			-- 0-7

	set_movedir (a_movedir: like movedir)
		do
			movedir := a_movedir
		end

	movecount: INTEGER assign set_movecount -- when 0, select a new dir

	set_movecount (a_movecount: like movecount)
		do
			movecount := a_movecount
		end

feature

	target: detachable MOBJ_T assign set_target
			-- Thing being chased/attacked (or NULL),
			-- also the originator for missiles.

	set_target (a_target: like target)
		do
			target := a_target
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
			spawnpoint := a_spawnpoint
		ensure
			spawnpoint = a_spawnpoint
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

feature

	threshold: INTEGER assign set_threshold
			-- If >0, the target will be chased
			-- no matter what (even if shot)

	set_threshold (a_threshold: like threshold)
		do
			threshold := a_threshold
		end

end
