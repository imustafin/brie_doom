note
	description: "mobjinfo_t from info.h"

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
