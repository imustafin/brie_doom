note
	description: "st_percent_t with it's functions from st_lib.c"

class
	ST_PERCENT

create
	make

feature

	i_main: I_MAIN

	make (x, y: INTEGER; pl: ARRAY [detachable PATCH_T]; num: FUNCTION[INTEGER]; on: PREDICATE; a_p: like p; a_i_main: I_MAIN)
		do
			i_main := a_i_main
			create n.make (x, y, pl, num, on, 3, a_i_main)
			p := a_p
		end

feature

	n: ST_NUMBER
			-- number information

	p: PATCH_T
			-- percent sign graphic

feature
	update(refresh: BOOLEAN)
		do
			if refresh and n.on.item then
				i_main.v_video.v_drawpatch(n.x, n.y, p)
			end
			n.update (refresh)
		end

end
