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
			create screens.make_empty
		end

	V_Init
		local
			i: INTEGER
		do
			create screens.make_filled (create {ARRAY [INTEGER_8]}.make_empty, 0, 4)
			from
				i := 0
			until
				i >= 5
			loop
				screens [i] := create {ARRAY [INTEGER_8]}.make_filled (0, 0, {DOOMDEF_H}.screenheight * {DOOMDEF_H}.screenwidth)
				i := i + 1
			end
		end

	screens: ARRAY [ARRAY [INTEGER_8]] -- Each screen is [SCREENWIDTH*SCREENHEIGHT]

feature

	V_DrawPatchDirect (x, y: INTEGER; scrn: INTEGER; patch: PATCH_T)
			-- Draws directly to the screen on the pc.
		do
			V_DrawPatch (x, y, scrn, patch)
		end

	V_DrawPatch (x, y: INTEGER; scrn: INTEGER; patch: PATCH_T)
			-- Masks a column based masked pic to the screen.
		do
				-- Stub
		end

	V_DrawBlock (x, y: INTEGER; scrn: INTEGER; width, height: INTEGER; src: ARRAY [INTEGER_8])
			-- Draw a linear block of pixels into the view buffer.
		do
				-- Stub
		end

end
