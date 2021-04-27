note
	description: "[
		p_inter.c
		
		Handling interactions (i.e., collisions)
	]"

class
	P_INTER

feature

	maxammo: ARRAY [INTEGER]
		once
			create Result.make_filled (0, 0, 3)
			Result [0] := 200
			Result [1] := 50
			Result [2] := 300
			Result [3] := 50
		ensure
			Result.lower = 0
			Result.count = {DOOMDEF_H}.numammo
			instance_free: class
		end

	P_DamageMobj (target: MOBJ_T; inflictor, source: detachable MOBJ_T; damage: INTEGER)
		do
				-- Stub
		ensure
			instane_free: class
		end

	P_TouchSpecialThing (special, toucher: MOBJ_T)
		do
				-- Stub

		ensure
			instance_free: class
		end

end
