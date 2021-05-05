note
	description: "[
		p_spec.c
		Implements special effects:
		Texture animation, height or lighting changes
		 according to adjacent sectors, respective
		 utility functions, etc.
		Line Tag handling. Line and Sector triggers.
	]"

class
	P_SPEC

create
	make

feature

	make
		do
		end

feature

	VDOORSPEED: INTEGER
		once
			Result := {M_FIXED}.fracunit * 2
		ensure
			instance_free: class
		end

	VDOORWAIT: INTEGER = 150

feature

	P_InitPicAnims
		do
				-- Stub
		end

	P_SpawnSpecials
		do
				-- Stub
		end

	P_UpdateSpecials
			-- Animate planes, scroll walls, etc.
		do
				-- Stub
		end

	P_PlayerInSpecialSector (player: PLAYER_T)
			-- Called every tic frame
			-- that the player origin is in a special sector
		do
			{I_MAIN}.i_error ("P_PlayerInSpecialSector is not implemented")
		end

	P_CrossSpecialLine (linenum, side: INTEGER; thing: MOBJ_T)
			-- Called every time a thing origin is about
			-- to cross a line with a non 0 special
		do
				-- Stub
		end

	P_FindLowestCeilingSurrounding (sec: SECTOR_T): FIXED_T
		local
			i: INTEGER
			ch: LINE_T
			other: SECTOR_T
		do
			Result := {DOOMTYPE_H}.MAXINT
			from
				i := sec.lines.lower
			until
				i > sec.lines.upper
			loop
				ch := sec.lines [i]
				other := getNextSector (ch, sec)
				if attached other then
					if other.ceilingheight < Result then
						Result := other.ceilingheight
					end
				end
				i := i + 1
			end
		end

	getNextSector (line: LINE_T; sec: SECTOR_T): detachable SECTOR_T
			-- Return sector_t * of sector next to current.
			-- NULL if not two-sided line
		do
			if line.flags & {DOOMDATA_H}.ML_TWOSIDED = 0 then
				Result := Void
			else
				if line.frontsector = sec then
					Result := line.backsector
				else
					Result := line.frontsector
				end
			end
		end

feature -- Special Stuff that can not be categorized

	EV_DoDonut (line: LINE_T): BOOLEAN
		do
			{I_MAIN}.i_error ("EV_DoDonut not implemented")
		ensure
			instance_free: class
		end

end
