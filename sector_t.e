note
	description: "[
		sector_t from r_defs.h
		
		The SECTORS record, at runtime.
		Stores things/mobjs
	]"

class
	SECTOR_T

create
	default_create, from_pointer

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

feature

	from_pointer (m: MANAGED_POINTER; offset: INTEGER; i_main: I_MAIN)
		local
			floorpic_name: STRING
			ceilingpic_name: STRING
		do
			floorheight := m.read_integer_16_le (offset).to_integer_32 |<< {M_FIXED}.fracbits
			ceilingheight := m.read_integer_16_le (offset + 2).to_integer_32 |<< {M_FIXED}.fracbits
			-- Read pic names
			floorpic_name := (create {C_STRING}.make_by_pointer_and_count (m.item +offset + 4, 8)).string
			ceilingpic_name := (create {C_STRING}.make_by_pointer_and_count (m.item + offset + 12, 8)).string
			floorpic := i_main.r_data.R_FlatNumForName (floorpic_name).to_integer_16
			ceilingpic := i_main.r_data.R_FlatNumForName (ceilingpic_name).to_integer_16

			-- Read other data
			lightlevel := m.read_integer_16_le (offset + 20)
			special := m.read_integer_16_le (offset + 22)
			tag := m.read_integer_16_le (offset + 24)
			thinglist := Void
		end

	structure_size: INTEGER = 26

invariant
	attached blockbox as bb implies bb.count = 4

end
