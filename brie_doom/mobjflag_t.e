note
	description: "mobjflag_t from p_mobj.h"
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
	MOBJFLAG_T

feature -- mobjflag_t;

	MF_SPECIAL: INTEGER = 1 -- Call P_SpecialThing when touched.

	MF_SOLID: INTEGER = 2 -- Blocks.

	MF_SHOOTABLE: INTEGER = 4 -- Can be hit.

	MF_NOSECTOR: INTEGER = 8 -- Don't use the sector links (invisible but touchable).

	MF_NOBLOCKMAP: INTEGER = 16 -- Don't use the blocklinks (inert but displayable)

	MF_AMBUSH: INTEGER = 32 --     // Not to be activated by sound, deaf monster.

	MF_JUSTHIT: INTEGER = 64 -- Will try to attack right back.

	MF_JUSTATTACKED: INTEGER = 128 --     // Will take at least one step before attacking.

	MF_SPAWNCEILING: INTEGER = 256
			-- On level spawning (initial position),
			--  hang from ceiling instead of stand on floor.

	MF_NOGRAVITY: INTEGER = 512
			-- Don't apply gravity (every tic),
			--  that is, object will float, keeping current height
			--  or changing it actively.

		-- Movement flags.

	MF_DROPOFF: INTEGER = 0x400 --     // This allows jumps from high places.

	MF_PICKUP: INTEGER = 0x800 -- For players, will pick up items.

	MF_NOCLIP: INTEGER = 0x1000 --     // Player cheat. ???

	MF_SLIDE: INTEGER = 0x2000 --     // Player: keep info about sliding along walls.

	MF_FLOAT: INTEGER = 0x4000
			-- Allow moves to any height, no gravity.
			-- For active floaters, e.g. cacodemons, pain elementals.

	MF_TELEPORT: INTEGER = 0x8000
			-- Don't cross lines
			--   ??? or look at heights on teleport.

	MF_MISSILE: INTEGER = 0x10000
			-- Don't hit same species, explode on block.
			-- Player missiles as well as fireballs of various kinds.

	MF_DROPPED: INTEGER = 0x20000
			-- Dropped by a demon, not level spawned.
			-- E.g. ammo clips dropped by dying former humans.

	MF_SHADOW: INTEGER = 0x40000
			-- Use fuzzy draw (shadow demons or spectres),
			--  temporary player invisibility powerup.

	MF_NOBLOOD: INTEGER = 0x80000
			-- Flag: don't bleed when shot (use puff),
			--  barrels and shootable furniture shall not bleed.

	MF_CORPSE: INTEGER = 0x100000
			-- Don't stop moving halfway off a step,
			--  that is, have dead bodies slide down all the way.

	MF_INFLOAT: INTEGER = 0x200000
			-- Floating to a height for a move, ???
			--  don't auto float to target's height.

	MF_COUNTKILL: INTEGER = 0x400000
			-- On kill, count this enemy object
			--  towards intermission kill total.
			-- Happy gathering.

	MF_COUNTITEM: INTEGER = 0x800000
			-- On picking up, count this item object
			-- towards intermission item total.

	MF_SKULLFLY: INTEGER = 0x1000000
			-- Special handling: skull in flight.
			-- Neither a cacodemon nor a missile.

	MF_NOTDMATCH: INTEGER = 0x2000000
			-- Don't spawn this object
			--  in death match mode (e.g. key cards).

	MF_TRANSLATION: INTEGER = 0xc000000
			-- Player sprites in multiplayer modes are modified
			--  using an internal color lookup table for re-indexing.
			-- If 0x4 0x8 or 0xc,
			--  use a translation table for player colormaps

	MF_TRANSSHIFT: INTEGER = 26
			-- Hmm ???.

end
