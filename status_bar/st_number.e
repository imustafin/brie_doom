note
	description: "st_number_t with it's functions from st_lib.c"

class
	ST_NUMBER

create
	make

feature

	make (a_x: like x; a_y: like y; a_p: like p; a_num: like num; a_on: like on; a_width: like width)
		do
			x := a_x
			y := a_y
			oldnum := 0
			width := a_width
			num := a_num
			on := a_on
			p := a_p
		end

feature

	x, y: INTEGER
			-- upper right-hand corner
			-- of the number (right-justified)

	width: INTEGER
			-- max # of digits in number

	oldnum: INTEGER
			-- last number value

	num: INTEGER
			-- pointer to current value

	on: BOOLEAN
			-- pointer to boolean stating
			-- whether to update number

	p: ARRAY [detachable PATCH_T]
			-- list of patches for 0-9

	data: INTEGER assign set_data
			-- user data

	set_data (a_data: like data)
		do
			data := a_data
		end

end
