note
	description: "[
		v_video.c
		Gamma correction LUT stuff.
		Functions to draw patches (by post) directly to screen.
		Functions to blit a block to the screen
	]"

class
	V_VIDEO

create
	make

feature

	make
		do
		end

	V_Init
		local
			i: INTEGER
			l_screens: like screens
		do
			create l_screens.make_empty
			from
				i := 0
			until
				i >= 4
			loop
				l_screens.force (create {ARRAY [INTEGER_8]}.make_filled (0, 0, {DOOMDEF_H}.screenheight * {DOOMDEF_H}.screenwidth), i)
				i := i + 1
			end
			screens := l_screens
		end

	screens: detachable ARRAY [ARRAY [INTEGER_8]]

end
