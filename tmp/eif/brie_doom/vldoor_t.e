note
	description: "vldoor_t from p_spec.h"
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
	VLDOOR_T

inherit

	WITH_THINKER

create
	make

feature

	make (a_sector: like sector)
		do
			make_thinker
			sector := a_sector
		end

feature

	type: INTEGER assign set_type -- vldoor_e

	set_type (a_type: like type)
		do
			type := a_type
		end

	sector: SECTOR_T assign set_sector

	set_sector (a_sector: like sector)
		do
			sector := a_sector
		end

	topheight: FIXED_T assign set_topheight

	set_topheight (a_topheight: like topheight)
		do
			topheight := a_topheight
		end

	speed: FIXED_T assign set_speed

	set_speed (a_speed: like speed)
		do
			speed := a_speed
		end

	direction: INTEGER assign set_direction
			-- 1 = up, 0 = waiting at top, -1 = down

	set_direction (a_direction: like direction)
		do
			direction := a_direction
		end

	topwait: INTEGER assign set_topwait
			-- tics to wait at the top

	set_topwait (a_topwait: like topwait)
		do
			topwait := a_topwait
		end

	topcountdown: INTEGER assign set_topcountdown
			-- (keep in case a door going down is reset)
			-- when it reaches 0, start going down

	set_topcountdown (a_topcountdown: like topcountdown)
		do
			topcountdown := a_topcountdown
		end

end
