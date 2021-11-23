note
	description: "wbplayerstruct_t from d_player.h"
	license: "[
				Copyright (C) 1993-1996 by id Software, Inc.
				Copyright (C) 2005-2014 Simon Howard
				Copyright (C) 2021 Ilgiz Mustafin
		
				This program is free software; you can redistribute it and/or modify
				it under the terms of the GNU General Public License as published by
				the Free Software Foundation; either version 2 of the License, or
				(at your option) any later version.
		
				This program is distributed in the hope that it will be useful,
				but WITHOUT ANY WARRANTY; without even the implied warranty of
				MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
				GNU General Public License for more details.
		
				You should have received a copy of the GNU General Public License along
				with this program; if not, write to the Free Software Foundation, Inc.,
				51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
	]"

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
