note
	description: "[
		p_local.h
		Play functions, animation, global header.
	]"

class
	P_LOCAL

feature

	MAXRADIUS: INTEGER
			-- MAXRADIUS is for precalculated sector block boxes
			-- the spider demon is larger,
			-- but we do not have any moving sectors nearby
		once
			Result := 32 * {M_FIXED}.FRACUNIT
		ensure
			instance_free: class
		end

	MAPBLOCKSHIFT: INTEGER
		once
			Result := {M_FIXED}.fracbits + 7
		ensure
			instance_free: class
		end

	ONFLOORZ: INTEGER
		once
			Result := {DOOMTYPE_H}.MININT
		ensure
			instance_free: class
		end

	ONCEILINGZ: INTEGER
		once
			Result := {DOOMTYPE_H}.MAXINT
		ensure
			instance_free: class
		end

end
