note
	description: "[
		sector_t from r_defs.h
		
		The SECTORS record, at runtime.
		Stores things/mobjs
	]"

class
	SECTOR_T

create
	make, from_pointer

feature

	make
		do
			create lines.make (0)
			create blockbox.make_filled (0, 0, 3)
			create soundorg
		end

feature

	floorheight: FIXED_T assign set_floorheight

	set_floorheight (a_floorheight: like floorheight)
		do
			floorheight := a_floorheight
		end

	ceilingheight: FIXED_T assign set_ceilingheight

	set_ceilingheight (a_ceilingheight: like ceilingheight)
		do
			ceilingheight := a_ceilingheight
		end

	floorpic: INTEGER_16

	ceilingpic: INTEGER_16

	lightlevel: INTEGER_16

	special: INTEGER_16

	tag: INTEGER_16

	soundtraversed: INTEGER
			-- 0 = untraversed, 1,2 = sndlines - 1

	soundtarget: detachable MOBJ_T
			-- thing that made a sound (or null)

	blockbox: ARRAY [INTEGER]
			-- mapblock bounding box for height changes

	soundorg: DEGENMOBJ_T
			-- origin for any sounds played by the sector

	validcount: INTEGER assign set_validcout
			-- if == validcount, already checked

	set_validcout (a_validcount: like validcount)
		do
			validcount := a_validcount
		end

	thinglist: detachable MOBJ_T assign set_thinglist
			-- list of mobjs in sector (head of linked list mobj_t.{snext,sprev})

	set_thinglist (a_thinglist: like thinglist)
		do
			thinglist := a_thinglist
		end

	specialdata: detachable ANY assign set_specialdata
			-- thinker_t for reversable actions

	set_specialdata (a_specialdata: like specialdata)
		do
			specialdata := a_specialdata
		end

	linecount: INTEGER assign set_linecount

	set_linecount (a_linecount: like linecount)
		do
			linecount := a_linecount
		end

	lines: ARRAYED_LIST [LINE_T]

feature

	from_pointer (m: MANAGED_POINTER; offset: INTEGER; i_main: I_MAIN)
		local
			floorpic_name: STRING
			ceilingpic_name: STRING
		do
			floorheight := m.read_integer_16_le (offset).to_integer_32 |<< {M_FIXED}.fracbits
			ceilingheight := m.read_integer_16_le (offset + 2).to_integer_32 |<< {M_FIXED}.fracbits
				-- Read pic names
			floorpic_name := (create {C_STRING}.make_by_pointer_and_count (m.item + offset + 4, 8)).string
			ceilingpic_name := (create {C_STRING}.make_by_pointer_and_count (m.item + offset + 12, 8)).string
			floorpic := i_main.r_data.R_FlatNumForName (floorpic_name).to_integer_16
			ceilingpic := i_main.r_data.R_FlatNumForName (ceilingpic_name).to_integer_16

				-- Read other data
			lightlevel := m.read_integer_16_le (offset + 20)
			special := m.read_integer_16_le (offset + 22)
			tag := m.read_integer_16_le (offset + 24)
			thinglist := Void
			linecount := 0
			create lines.make (0)
			create blockbox.make_filled (0, 0, 3)
			create soundorg
		end

	structure_size: INTEGER = 26

invariant
	blockbox.count = 4
	blockbox.lower = 0

end
