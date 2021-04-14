note
	description: "wbstartstruct_t from d_player.h"

class
	WBSTARTSTRUCT_T

feature

	epsd: INTEGER

	didsecret: BOOLEAN -- if true, splash the secret level

	last: INTEGER

	next: INTEGER

	maxkills: INTEGER

	maxitems: INTEGER

	maxsecret: INTEGER

	maxfrags: INTEGER assign set_maxfrags

	set_maxfrags (a_maxfrags: like maxfrags)
		do
			maxfrags := a_maxfrags
		end

	partime: INTEGER assign set_partime

	set_partime (a_partime: like partime)
		do
			partime := a_partime
		end

	pnum: INTEGER -- index of this player in game

	plyr: ARRAY [WBPLAYERSTRUCT_T]
		local
			i: INTEGER
		once
			create Result.make_filled (create {WBPLAYERSTRUCT_T}, 0, {DOOMDEF_H}.MAXPLAYERS - 1)
			from
				i := 0
			until
				i >= {DOOMDEF_H}.MAXPLAYERS
			loop
				Result [i] := create {WBPLAYERSTRUCT_T}
				i := i + 1
			end
		ensure
			Result.lower = 0
			Result.count = {DOOMDEF_H}.MAXPLAYERS
		end

end
