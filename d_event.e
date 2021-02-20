note
	description: "d_event.h"

class
	D_EVENT

create
	make

feature

	make
		do
		end

feature

	MAXEVENTS: INTEGER = 64

feature -- buttoncode_t

	BT_ATTACK: INTEGER = 1 -- Press "fire".

	BT_USE: INTEGER = 2 -- Use button, to open doors, activate switches.

		-- Flag: game events, not really buttons.

	BT_SPECIAL: INTEGER = 128

	BT_SPECIALMASK: INTEGER = 3

		-- Flag, weapon change pending.
		-- If true, the next 3 bits hold weapon num.

	BT_CHANGE: INTEGER = 4

		-- The 3bit weapon mask and shift, convenience.

	BT_WEAPONMASK: INTEGER = 56 -- originally (8+16+32)

	BT_WEAPONSHIFT: INTEGER = 3

	BTS_PAUSE: INTEGER = 1 -- Pause the game.

	BTS_SAVEGAME: INTEGER = 2 -- Save the game at each console.

		-- Savegame slot numbers
		--  occupy the second byte of buttons.

	BTS_SAVEMASK: INTEGER = 28 -- originally (4+8+16)

	BTS_SAVESHIFT: INTEGER = 2

end
