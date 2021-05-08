note
	description: "[
		degenmobj_t from r_defs.h
		
		Each sector has a degenmobj_t in its center
		for sound origin purposes.
		
		I suppose this does not handle sound from
		moving objects (doppler), because
		position is prolly just buffered, not updated
	]"

class
	DEGENMOBJ_T

feature

	x: FIXED_T assign set_x

	set_x (a_x: like x)
		do
			x := a_x
		end

	y: FIXED_T assign set_y

	set_y (a_y: like y)
		do
			y := a_y
		end

	z: FIXED_T assign set_z

	set_z (a_z: like z)
		do
			z := a_z
		end

end
