note
	description: "[
		d_englsh.h
		Printed strings for translation.
		English language support (default).
	]"
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
	D_ENGLSH

feature

	PRESSKEY: STRING = "press a key."

	PRESSYN: STRING = "press y or n."

	NEWGAME: STRING
		once
			Result := "you can't start a new game%Nwhile in a network game.%N%N" + PRESSKEY
		ensure
			instance_free: class
		end

	SWSTRING: STRING
		once
			Result := "this is the shareware version of doom.%N%Nyou need to order the entire trilogy.%N%N" + PRESSKEY
		ensure
			instance_free: class
		end

	NIGHTMARE: STRING
		once
			Result := "are you sure? this skill level%Nisn't even remotely fair.%N%N" + PRESSYN
		ensure
			instance_free: class
		end

	HUSTR_PLRGREEN: STRING = "Green: "

	HUSTR_PLRINDIGO: STRING = "Indigo: "

	HUSTR_PLRBROWN: STRING = "Brown: "

	HUSTR_PLRRED: STRING = "Red: "

feature -- P_Doors.C

	PD_BLUEK: STRING = "You need a blue key to open this door"

	PD_REDK: STRING = "You need a red key to open this door"

	PD_YELLOWK: STRING = "You need a yellow key to open this door"

feature

	GOTARMOR: STRING = "Picked up the armor."

	GOTMEGA: STRING = "Picked up the MegaArmor!"

	GOTHTHBONUS: STRING = "Picked up a health bonus."

	GOTARMBONUS: STRING = "Picked up an armor bonus."

	GOTSTIM: STRING = "Picked up a stimpack."

	GOTMEDINEED: STRING = "Picked up a medikit that you REALLY need!"

	GOTMEDIKIT: STRING = "Picked up a medikit."

	GOTSUPER: STRING = "Supercharge!"

	GOTBLUECARD: STRING = "Picked up a blue keycard."

	GOTYELWCARD: STRING = "Picked up a yellow keycard."

	GOTREDCARD: STRING = "Picked up a red keycard."

	GOTBLUESKUL: STRING = "Picked up a blue skull key."

	GOTYELWSKUL: STRING = "Picked up a yellow skull key."

	GOTREDSKULL: STRING = "Picked up a red skull key."

	GOTINVUL: STRING = "Invulnerability!"

	GOTBERSERK: STRING = "Berserk!"

	GOTINVIS: STRING = "Partial Invisibility"

	GOTSUIT: STRING = "Radiation Shielding Suit"

	GOTMAP: STRING = "Computer Area Map"

	GOTVISOR: STRING = "Light Amplification Visor"

	GOTMSPHERE: STRING = "MegaSphere!"

	GOTCLIP: STRING = "Picked up a clip."

	GOTCLIPBOX: STRING = "Picked up a box of bullets."

	GOTROCKET: STRING = "Picked up a rocket."

	GOTROCKBOX: STRING = "Picked up a box of rockets."

	GOTCELL: STRING = "Picked up an energy cell."

	GOTCELLBOX: STRING = "Picked up an energy cell pack."

	GOTSHELLS: STRING = "Picked up 4 shotgun shells."

	GOTSHELLBOX: STRING = "Picked up a box of shotgun shells."

	GOTBACKPACK: STRING = "Picked up a backpack full of ammo!"

	GOTBFG9000: STRING = "You got the BFG9000!  Oh, yes."

	GOTCHAINGUN: STRING = "You got the chaingun!"

	GOTCHAINSAW: STRING = "A chainsaw!  Find some meat!"

	GOTLAUNCHER: STRING = "You got the rocket launcher!"

	GOTPLASMA: STRING = "You got the plasma gun!"

	GOTSHOTGUN: STRING = "You got the shotgun!"

	GOTSHOTGUN2: STRING = "You got the super shotgun!"

end
