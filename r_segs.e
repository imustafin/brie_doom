note
	description: "[
		r_segs.c
		All the clipping: columns, horizontal spans, sky columns.
	]"

class
	R_SEGS

create
	make

feature

	make
		do
			create walllights.make_empty
		end

feature

	walllights: ARRAY [LIGHTTABLE_T] assign set_walllights

	set_walllights (a_walllights: like walllights)
		do
			walllights := a_walllights
		end

end
