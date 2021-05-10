note
	description: "point_t from wi_stuff.c"

class
	POINT_T

create
	make

feature

	make (a_x, a_y: INTEGER)
		do
			x := a_x
			y := a_y
		end

feature

	x: INTEGER

	y: INTEGER

end
