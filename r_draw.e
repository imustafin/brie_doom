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

	scaledviewwidth: INTEGER

	viewheight: INTEGER

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

end
