note
	description: "d_event.h"

class
	EVENT_T

create
	make

feature

	make
		do
		end

feature -- evtype_t

	ev_keydown: INTEGER = 0

	ev_keyup: INTEGER = 1

	ev_mouse: INTEGER = 2

	ev_joystick: INTEGER = 3

feature -- Fields

	type: INTEGER assign set_type

	set_type (a_type: like type)
		do
			type := a_type
		end

	data1: INTEGER assign set_data1 -- keys / mouse/joystick buttons

	set_data1 (a_data1: like data1)
		do
			data1 := a_data1
		end

	data2: INTEGER -- mouse/joystick x move

	data3: INTEGER -- mouse/joystick y move

end
