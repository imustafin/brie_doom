note
	description: "vldoor_t from p_spec.h"

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
