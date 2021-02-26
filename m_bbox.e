note
	description: "[
		m_bbox.c
		Main loop menu stuff.
		Random number LUT.
		Default Config File.
		PCX Screenshots.
	]"

class
	M_BBOX

feature

	make
		do
		end

feature -- bbox coordinates

	BOXTOP: INTEGER = 0

	BOXBOTTOM: INTEGER = 1

	BOXLEFT: INTEGER = 2

	BOXRIGHT: INTEGER = 3

feature

	M_AddToBox (box: ARRAY [FIXED_T]; x, y: FIXED_T)
		do
			if x < box [BOXLEFT] then
				box [BOXLEFT] := x
			elseif x > box [BOXRIGHT] then
				box [BOXRIGHT] := x
			end
			if y < box [BOXBOTTOM] then
				box [BOXBOTTOM] := y
			elseif y > box [BOXTOP] then
				box [BOXTOP] := y
			end
		ensure
			instance_free: class
		end

end
