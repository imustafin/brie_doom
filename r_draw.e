note
	description: "[
		r_draw.c
		The actual span/column drawing functios.
		Here find the main potential for optimization
		 e.g. inline assembly, different algorithms.
	]"

class
	R_DRAW

create
	make

feature

	make
		do
		end

feature

	R_InitTranslationTables
			-- Creates the translation tables to map
			--  the green color rmap to gray, brown, red.
			-- Assumes a given structure of the PLAYPAL.
			-- Could be read from a lump instead.
		do
				-- Stub
		end

feature

	viewwidth: INTEGER assign set_viewwidth

	set_viewwidth (a_viewwidth: like viewwidth)
		do
			viewwidth := a_viewwidth
		end

	scaledviewwidth: INTEGER assign set_scaledviewwidth

	set_scaledviewwidth (a_scaledviewwidth: like scaledviewwidth)
		do
			scaledviewwidth := a_scaledviewwidth
		end

	viewheight: INTEGER assign set_viewheight

	set_viewheight (a_viewheight: like viewheight)
		do
			viewheight := a_viewheight
		end

	viewwindowx: INTEGER

	viewwindowy: INTEGER

feature

	R_FillBackScreen
			-- Fills the back screen with a pattern
			--  for variable screen sizes
			-- Also draws a beveled edge.
		do
				-- Stub
		end

	R_DrawViewBorder
			-- Draws the border around the view
			--  for different size windows?
		do
				-- Stub
		end

feature

	R_DrawColumn
		do
				-- Stub
		end

	R_DrawTranslatedColumn
		do
				-- Stub
		end

	R_DrawSpan
		do
				-- Stub
		end

feature

	R_DrawColumnLow
		do
				-- Stub
		end

	R_DrawFuzzColumn
		do
				-- Stub
		end

	r_DrawSpanLow
		do
				-- Stub
		end

feature

	R_InitBuffer (width, height: INTEGER)
		do
				-- Stub
		end

end
