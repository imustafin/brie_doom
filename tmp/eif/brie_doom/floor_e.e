note
	description: "floor_e from p_spec.h"
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
	FLOOR_E

feature

	lowerFloor: INTEGER = 0
			-- lower floor to highest surrounding floor

	lowerFloorToLowest: INTEGER = 1
			-- lower floor to lowest surrounding floor

	turboLower: INTEGER = 2
			-- lower floor to highest surrounding floor VERY FAST

	raiseFloor: INTEGER = 3
			-- raise floor to lowest surrounding CEILING

	raiseFloorToNearest: INTEGER = 4
			-- raise floor to next highest surrounding floor

	raiseToTexture: INTEGER = 5
			-- raise floor to shortest height texture around it

	lowerAndChange: INTEGER = 6
			-- lower floor to lowest surrounding floor
			--  and change floorpic

	raiseFloor24: INTEGER = 7

	raiseFloor24AndChange: INTEGER = 8

	raiseFloorCrush: INTEGER = 9

	raiseFloorTurbo: INTEGER = 10
			-- raise to next highest floor, turbo-speed

	donutRaise: INTEGER = 11

	raiseFloor512: INTEGER = 12

end
