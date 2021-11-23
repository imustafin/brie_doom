note
	description: "mobjinfo_t from info.h"
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
	MOBJINFO_T

create
	default_create, make

feature

	make (a_doomednum: INTEGER; a_spawnstate: INTEGER; a_spawnhealth: INTEGER; a_seestate: INTEGER; a_seesound: INTEGER; a_reactiontime: INTEGER a_attacksound: INTEGER; a_painstate: INTEGER; a_painchance: INTEGER; a_painsound: INTEGER; a_meleestate: INTEGER a_missilestate: INTEGER; a_deathstate: INTEGER; a_xdeathstate: INTEGER; a_deathsound: INTEGER; a_speed: INTEGER; a_radius: INTEGER; a_height: INTEGER; a_mass: INTEGER; a_damage: INTEGER; a_activesound: INTEGER; a_flags: INTEGER; a_raisestate: INTEGER)
		do
			doomednum := a_doomednum
			spawnstate := a_spawnstate
			spawnhealth := a_spawnhealth
			seestate := a_seestate
			seesound := a_seesound
			reactiontime := a_reactiontime
			attacksound := a_attacksound
			painstate := a_painstate
			painchance := a_painchance
			painsound := a_painsound
			meleestate := a_meleestate
			missilestate := a_missilestate
			deathstate := a_deathstate
			xdeathstate := a_xdeathstate
			deathsound := a_deathsound
			speed := a_speed
			radius := a_radius
			height := a_height
			mass := a_mass
			damage := a_damage
			activesound := a_activesound
			flags := a_flags
			raisestate := a_raisestate
		end

feature

	doomednum: INTEGER

	spawnstate: INTEGER

	spawnhealth: INTEGER

	seestate: INTEGER

	seesound: INTEGER

	reactiontime: INTEGER

	attacksound: INTEGER

	painstate: INTEGER

	painchance: INTEGER

	painsound: INTEGER

	meleestate: INTEGER

	missilestate: INTEGER

	deathstate: INTEGER

	xdeathstate: INTEGER

	deathsound: INTEGER

	speed: INTEGER assign set_speed

	set_speed (a_speed: like speed)
		do
			speed := a_speed
		end

	radius: INTEGER

	height: INTEGER

	mass: INTEGER

	damage: INTEGER

	activesound: INTEGER

	flags: INTEGER

	raisestate: INTEGER

end
