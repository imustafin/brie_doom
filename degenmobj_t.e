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

	x: FIXED_T

	y: FIXED_T

	z: FIXED_T

end
