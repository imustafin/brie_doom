note
	description: "st_binicon_t with it's functions from st_lib.c"

class
	ST_BIN_ICON

create
	make

feature

	make (a_x, a_y: INTEGER; i: PATCH_T; a_val: BOOLEAN; a_on: BOOLEAN)
		do
			x := a_x
			y := a_y
			oldval := False
			val := a_val
			on := a_on
			p := i
		end

feature

	x, y: INTEGER
			-- center-justified location of icon

	oldval: BOOLEAN
			-- last icon value

	val: BOOLEAN
			-- pointer to current icon status

	on: BOOLEAN
			-- pointer to boolean
			-- stating whether to update icon

	p: PATCH_T
			-- icon

	data: INTEGER
			-- user data

end
