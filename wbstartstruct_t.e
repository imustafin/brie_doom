note
	description: "wbstartstruct_t from d_player.h"

class
	WBSTARTSTRUCT_T

feature

	epsd: INTEGER assign set_epsd

	set_epsd (a_epsd: like epsd)
		do
			epsd := a_epsd
		end

	didsecret: BOOLEAN assign set_didsecret
			-- if true, splash the secret level

	set_didsecret (a_didsecret: like didsecret)
		do
			didsecret := a_didsecret
		end

	last: INTEGER assign set_last

	set_last (a_last: like last)
		do
			last := a_last
		end

	next: INTEGER assign set_next

	set_next (a_next: like next)
		do
			next := a_next
		end

	maxkills: INTEGER assign set_maxkills

	set_maxkills (a_maxkills: like maxkills)
		do
			maxkills := a_maxkills
		end

	maxitems: INTEGER assign set_maxitems

	set_maxitems (a_maxitems: like maxitems)
		do
			maxitems := a_maxitems
		end

	maxsecret: INTEGER assign set_maxsecret

	set_maxsecret (a_maxsecret: like maxsecret)
		do
			maxsecret := a_maxsecret
		end

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

	pnum: INTEGER assign set_pnum
			-- index of this player in game

	set_pnum (a_pnum: like pnum)
		do
			pnum := a_pnum
		end

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
