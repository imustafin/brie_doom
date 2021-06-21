note
	description: "st_multicon_t with it's functions from st_lib.c"

class
	ST_MULT_ICON

create
	make

feature

	make (a_x, a_y: INTEGER; il: ARRAY [detachable PATCH_T]; a_inum: INTEGER; a_on: BOOLEAN)
		do
			x := a_x
			y := a_y
			oldinum := -1
			on := a_on
			p := il
		end

feature

	x, y: INTEGER
			-- center-justified location of icons

	oldinum: INTEGER
			-- last icon number

	inum: INTEGER
			-- pointer to current icon

	on: BOOLEAN
			-- pointer to boolean stating
			-- whether to update icon

	p: ARRAY [detachable PATCH_T]
			-- list of icons

	data: INTEGER
			-- user data

end
