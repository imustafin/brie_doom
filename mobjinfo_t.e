note
	description: "mobjinfo_t from info.h"

class
	MOBJINFO_T

create
	make

feature

	make
		do
		end

feature

	speed: INTEGER assign set_speed

	set_speed (a_speed: like speed)
		do
			speed := a_speed
		end

end
