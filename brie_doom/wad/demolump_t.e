note
	description: "Structure of demo lumps as in post-1.2 (namely 1.10)"

class
	DEMOLUMP_T

create
	from_pointer, make

feature

	version: INTEGER

	skill: INTEGER

	episode: INTEGER

	map: INTEGER

	deathmatch: BOOLEAN

	respawnparm: BOOLEAN

	fastparm: BOOLEAN

	nomonsters: BOOLEAN

	consoleplayer: INTEGER

	playeringame: ARRAY [BOOLEAN]

	demo_p: MANAGED_POINTER_WITH_OFFSET

	mp: MANAGED_POINTER
feature

	from_pointer (a_pointer: MANAGED_POINTER)
		local
			i: INTEGER
			offset: INTEGER
		do
			mp := a_pointer
			offset := 0
			version := a_pointer.read_natural_8 (offset)
			offset := offset + 1
			skill := a_pointer.read_natural_8 (offset)
			offset := offset + 1
			episode := a_pointer.read_natural_8 (offset)
			offset := offset + 1
			map := a_pointer.read_natural_8 (offset)
			offset := offset + 1
			deathmatch := a_pointer.read_natural_8 (offset).to_boolean
			offset := offset + 1
			respawnparm := a_pointer.read_natural_8 (offset).to_boolean
			offset := offset + 1
			fastparm := a_pointer.read_natural_8 (offset).to_boolean
			offset := offset + 1
			nomonsters := a_pointer.read_natural_8 (offset).to_boolean
			offset := offset + 1
			consoleplayer := a_pointer.read_natural_8 (offset)
			offset := offset + 1
			from
				i := 0
				create playeringame.make_filled (False, 0, 3)
			until
				i >= {DOOMDEF_H}.maxplayers
			loop
				playeringame [i] := a_pointer.read_natural_8 (offset).to_boolean
				offset := offset + 1
				i := i + 1
			end
			create demo_p.make (a_pointer, offset)
		end

	make(maxsize: INTEGER)
		do
			create mp.make (maxsize)
			create demo_p.make (mp, 0)
			create playeringame.make_empty
		end

end
