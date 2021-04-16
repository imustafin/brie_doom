note
	description: "p_mobj.h"

class
	MOBJ_T

create
	make

feature

	make
		do
		end

feature

	x: FIXED_T

	y: FIXED_T

	z: FIXED_T

	angle: ANGLE_T -- orientation

feature -- More list: links in sector (if needed)

	snext: detachable MOBJ_T

	sprev: detachable MOBJ_T

end
