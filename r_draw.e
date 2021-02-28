note
	description: "[
		r_draw.c
		The actual span/column drawing functios.
		Here find the main potential for optimization
		 e.g. inline assembly, different algorithms.
	]"

class
	R_DRAW

inherit

	DOOMDEF_H

create
	make

feature

	make
		do
		end

feature

	SBARHEIGHT: INTEGER = 32 -- status bar height at bottom of screen

feature -- ?

	MAXWIDTH: INTEGER = 1120

	MAXHEIGHT: INTEGER = 832

feature

	columnofs: ARRAY [INTEGER]
		attribute
			create Result.make_filled (0, 0, MAXWIDTH - 1)
		end

	ylookup: ARRAY [INTEGER] -- index in screen[0]
		attribute
			create Result.make_filled (0, 0, MAXHEIGHT - 1)
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
		local
			i: INTEGER
		do
				-- Handle resize,
				--  e.g. smaller view windows
				--  with border and/or status bar.
			viewwindowx := (SCREENWIDTH - width) |>> 1

				-- Collumn offset. For windows.
			from
				i := 0
			until
				i >= width
			loop
				columnofs [i] := viewwindowx + i
				i := i + 1
			end

				-- Samw with base row offset.
			if width = SCREENWIDTH then
				viewwindowy := 0
			else
				viewwindowy := (SCREENHEIGHT - SBARHEIGHT - height) |>> 1
			end

				-- Precalculate all row offsets.
			from
				i := 0
			until
				i >= height
			loop
				ylookup [i] := (i + viewwindowy) * SCREENWIDTH
				i := i + 1
			end
		end

end
