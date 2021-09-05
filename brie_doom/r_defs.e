note
	description: "[
		r_defs.h
		
		Refresh/rendering module, shared data struct definitions.
	]"

class
	R_DEFS

feature -- slopetype_t

	ST_HORIZONTAL: INTEGER = 0

	ST_VERTICAL: INTEGER = 1

	ST_POSITIVE: INTEGER = 2

	ST_NEGATIVE: INTEGER = 3

feature

	MAXDRAWSEGS: INTEGER = 256

feature -- Silhouette
	-- needed for clipping Segs (mainly)
	-- and sprites representing things.

	SIL_NONE: INTEGER = 0

	SIL_BOTTOM: INTEGER = 1

	SIL_TOP: INTEGER = 2

	SIL_BOTH: INTEGER = 3

end
