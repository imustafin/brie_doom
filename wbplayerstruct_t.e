note
	description: "wbplayerstruct_t from d_player.h"

class
	WBPLAYERSTRUCT_T

feature

	in: BOOLEAN assign set_in
			-- whether the player is in game

	set_in (a_in: like in)
		do
			in := a_in
		end

	skills: INTEGER assign set_skills

	set_skills (a_skills: like skills)
		do
			skills := a_skills
		end

	sitems: INTEGER assign set_sitems

	set_sitems (a_sitems: like sitems)
		do
			sitems := a_sitems
		end

	ssecret: INTEGER assign set_ssecret

	set_ssecret (a_ssecret: like ssecret)
		do
			ssecret := a_ssecret
		end

	stime: INTEGER assign set_stime

	set_stime (a_stime: like stime)
		do
			stime := a_stime
		end

	frags: ARRAY [INTEGER]
		once
			create Result.make_filled (0, 0, 3)
		ensure
			Result.lower = 0
			Result.count = 4
		end

	score: INTEGER

end
