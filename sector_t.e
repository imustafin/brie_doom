note
	description: "[
		sector_t from r_defs.h
		
		The SECTORS record, at runtime.
		Stores things/mobjs
	]"

class
	SECTOR_T

feature

	floorheight: FIXED_T

	ceilingheight: FIXED_T

	floorpic: INTEGER_16

	ceilingpic: INTEGER_16

	lightlevel: INTEGER_16

	special: INTEGER_16

	tag: INTEGER_16

	soundtraversed: INTEGER
			-- 0 = untraversed, 1,2 = sndlines - 1

	soundtarget: detachable MOBJ_T
			-- thing that made a sound (or null)

	blockbox: detachable ARRAY [INTEGER]
			-- mapblock bounding box for height changes

	soundorg: detachable DEGENMOBJ_T
			-- origin for any sounds played by the sector

	validcount: INTEGER assign set_validcout
			-- if == validcount, already checked

	set_validcout (a_validcount: like validcount)
		do
			validcount := a_validcount
		end

	thinglist: detachable MOBJ_T
			-- list of mobjs in sector (head of linked list mobj_t.{snext,sprev})

	specialdata: detachable ANY
			-- thinker_t for reversable actions

	lines: detachable ARRAY [LINE_T]

invariant
	attached blockbox as bb implies bb.count = 4

end
