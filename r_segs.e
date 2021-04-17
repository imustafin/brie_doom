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

	rw_angle1: ANGLE_T assign set_rw_angle1

	set_rw_angle1 (a_rw_angle1: like rw_angle1)
		do
			rw_angle1 := a_rw_angle1
		end

end
