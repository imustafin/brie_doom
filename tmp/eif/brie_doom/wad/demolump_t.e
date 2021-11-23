note
	description: "Structure of demo lumps as in post-1.2 (namely 1.10)"
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
	DEMOLUMP_T

create
	from_pointer, make

feature

	DEMOMARKER: INTEGER = 0x80

feature

	version: INTEGER assign set_version

	set_version (a_version: like version)
		do
			version := a_version
		end

	skill: INTEGER assign set_skill

	set_skill (a_skill: like skill)
		do
			skill := a_skill
		end

	episode: INTEGER assign set_episode

	set_episode (a_episode: like episode)
		do
			episode := a_episode
		end

	map: INTEGER assign set_map

	set_map (a_map: like map)
		do
			map := a_map
		end

	deathmatch: BOOLEAN assign set_deathmatch

	set_deathmatch (a_deathmatch: like deathmatch)
		do
			deathmatch := a_deathmatch
		end

	respawnparm: BOOLEAN assign set_respawnparm

	set_respawnparm (a_respawnparm: like respawnparm)
		do
			respawnparm := a_respawnparm
		end

	fastparm: BOOLEAN assign set_fastparm

	set_fastparm (a_fastparm: like fastparm)
		do
			fastparm := a_fastparm
		end

	nomonsters: BOOLEAN assign set_nomonsters

	set_nomonsters (a_nomonsters: like nomonsters)
		do
			nomonsters := a_nomonsters
		end

	consoleplayer: INTEGER assign set_consoleplayer

	set_consoleplayer (a_consoleplayer: like consoleplayer)
		do
			consoleplayer := a_consoleplayer
		end

	playeringame: ARRAY [BOOLEAN] assign set_playeringame

	set_playeringame (a_playeringame: like playeringame)
		do
			playeringame := a_playeringame
		end

	ticks: ARRAYED_LIST [DEMOTICK_T]

	ticks_position: INTEGER
			-- One after of the current tick

	ticks_after: BOOLEAN
		do
			Result := ticks_position > ticks.upper
		end

	ticks_before: BOOLEAN
		do
			Result := ticks_position < ticks.lower
		end

	current_tick: DEMOTICK_T
		require
			not ticks_after
		do
			Result := ticks [ticks_position]
		end

	add_tick (tick: DEMOTICK_T)
		do
			ticks.extend (tick)
		end

	advance_tick
		require
			not ticks_after
		do
			ticks_position := ticks_position + 1
		end

	dec_tick
		require
			not ticks_before
		do
			ticks_position := ticks_position - 1
		end

feature

	from_pointer (a_pointer: MANAGED_POINTER)
		local
			i: INTEGER
			offset: INTEGER
			cmd: DEMOTICK_T
		do
			ticks_position := 1
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
			from
				create ticks.make (0)
			until
				a_pointer.read_natural_8 (offset) = DEMOMARKER
			loop
				create cmd
				cmd.forwardmove := a_pointer.read_natural_8 (offset)
				offset := offset + 1
				cmd.sidemove := a_pointer.read_natural_8 (offset)
				offset := offset + 1
				cmd.angleturn := a_pointer.read_natural_8 (offset)
				offset := offset + 1
				cmd.buttons := a_pointer.read_natural_8 (offset)
				offset := offset + 1
				ticks.extend (cmd)
			end
		end

feature -- Write demo

	maxsize: INTEGER

	make (a_maxsize: INTEGER)
		do
			ticks_position := 1
			maxsize := a_maxsize
			create playeringame.make_empty
			create ticks.make (0)
		end

	to_managed_pointer: MANAGED_POINTER
		local
			size: INTEGER
			offset: INTEGER
			i: INTEGER
		do
			size := 9 + {DOOMDEF_H}.maxplayers + 4 * ticks.count + 1
			create Result.make (size)
			offset := 0
			Result.put_natural_8 (version.to_natural_8, offset)
			offset := offset + 1
			Result.put_natural_8 (skill.to_natural_8, offset)
			offset := offset + 1
			Result.put_natural_8 (episode.to_natural_8, offset)
			offset := offset + 1
			Result.put_natural_8 (map.to_natural_8, offset)
			offset := offset + 1
			Result.put_natural_8 (deathmatch.to_integer.to_natural_8, offset)
			offset := offset + 1
			Result.put_natural_8 (respawnparm.to_integer.to_natural_8, offset)
			offset := offset + 1
			Result.put_natural_8 (fastparm.to_integer.to_natural_8, offset)
			offset := offset + 1
			Result.put_natural_8 (nomonsters.to_integer.to_natural_8, offset)
			offset := offset + 1
			Result.put_natural_8 (consoleplayer.to_natural_8, offset)
			offset := offset + 1
			from
				i := 0
			until
				i >= playeringame.count
			loop
				Result.put_natural_8 (playeringame [i].to_integer.to_natural_8, offset)
				offset := offset + 1
				i := i + 1
			end
			across
				ticks is cmd
			loop
				Result.put_natural_8 (cmd.forwardmove, offset)
				offset := offset + 1
				Result.put_natural_8 (cmd.sidemove, offset)
				offset := offset + 1
				Result.put_natural_8 (cmd.angleturn, offset)
				offset := offset + 1
				Result.put_natural_8 (cmd.buttons, offset)
				offset := offset + 1
			end
			Result.put_natural_8 (DEMOMARKER.to_natural_8, offset)
		end

end
