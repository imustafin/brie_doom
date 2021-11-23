note
	description: "state_t from info.h"
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
	STATE_T

create
	make

feature

	make (a_sprite: like sprite; a_frame: like frame; a_tics: like tics; a_action: like action; a_nextstate: like nextstate; a_misc1: like misc1; a_misc2: like misc2)
		do
			sprite := a_sprite
			frame := a_frame
			tics := a_tics
			action := a_action
			nextstate := a_nextstate
			misc1 := a_misc1
			misc2 := a_misc2
		end

feature

	sprite: INTEGER -- statenum_t

	frame: INTEGER_32

	tics: INTEGER_32 assign set_tics

	set_tics (a_tics: like tics)
		do
			tics := a_tics
		end

	action: detachable PROCEDURE

	nextstate: INTEGER -- statenum_t

	misc1: INTEGER_32

	misc2: INTEGER_32

feature

	is_player_run: BOOLEAN
		local
			indices: ARRAY [INTEGER]
		do
			indices := <<{STATENUM_T}.s_play_run1, {STATENUM_T}.s_play_run2, {STATENUM_T}.s_play_run3, {STATENUM_T}.s_play_run4>>
			Result := across indices as i some Current = {INFO}.states [i.item] end
		end

end
