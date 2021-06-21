note
	description: "st_percent_t with it's functions from st_lib.c"

class
	ST_PERCENT

create
	make

feature

	make (x, y: INTEGER; pl: ARRAY [detachable PATCH_T]; num: INTEGER; on: BOOLEAN; a_p: like p)
		do
			create n.make (x, y, pl, num, on, 3)
			p := a_p
		end

feature

	n: ST_NUMBER
			-- number information

	p: PATCH_T
			-- percent sign graphic

end
