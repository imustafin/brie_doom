note
	description: "floor_e from p_spec.h"

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
