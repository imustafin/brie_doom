note
	description: "[
		v_video.c
		Gamma correction LUT stuff.
		Functions to draw patches (by post) directly to screen.
		Functions to blit a block to the screen
	]"

class
	V_VIDEO

inherit

	DOOMDEF_H

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
			create screens.make_filled (create {ARRAY [NATURAL_8]}.make_empty, 0, 4)
			from
				i := 0
			until
				i >= 5
			loop
				screens [i] := create {ARRAY [NATURAL_8]}.make_filled (0, 0, {DOOMDEF_H}.screenheight * {DOOMDEF_H}.screenwidth)
				i := i + 1
			end
		end

	screens: ARRAY [ARRAY [NATURAL_8]] -- Each screen is [SCREENWIDTH*SCREENHEIGHT]

feature

	usegamma: INTEGER assign set_usegamma

	set_usegamma (a_usegamma: like usegamma)
		do
			usegamma := a_usegamma
		end

feature

	V_DrawPatchDirect (x, y: INTEGER; scrn: INTEGER; patch: PATCH_T)
			-- Draws directly to the screen on the pc.
		do
			V_DrawPatch (x, y, scrn, patch)
		end

	V_DrawPatch (a_x, a_y: INTEGER; scrn: INTEGER; patch: PATCH_T)
			-- Masks a column based masked pic to the screen.
		local
			x, y: INTEGER
			count: INTEGER
			col: INTEGER
			column: COLUMN_T
			desttop: INTEGER -- orginally pointer to somewhere in screens[scrn]
			dest: INTEGER -- originally byte*, now is an index of screens[scrn]
			source: ARRAY[NATURAL_8] -- originally byte*
			w: INTEGER
			cols: ARRAYED_LIST [COLUMN_T]
			i: INTEGER
		do
			x := a_x - patch.topoffset
			y := a_y - patch.leftoffset

				-- skip RANGECHECK

			if scrn = 0 then
				V_MarkRect (x, y, patch.width, patch.height)
			end

			desttop := y * SCREENWIDTH + x
			w := patch.width
			cols := patch.columns

			from
				col := 1
			until
				col >= w
			loop
				column := cols [col]
				across
					column.posts as post
				loop
					source := post.item.body
					dest := desttop + post.item.topdelta * SCREENWIDTH
					from
						count := post.item.length
						i := source.lower
					until
						count <= 0
					loop
						count := count - 1
						screens [scrn] [dest] := source [i]
						i := i + 1
						dest := dest + SCREENWIDTH
					end
				end
				x := x + 1
				col := col + 1
				desttop := desttop + 1
			end
		end

	V_DrawBlock (x, y: INTEGER; scrn: INTEGER; width, height: INTEGER; src: ARRAY [NATURAL_8])
			-- Draw a linear block of pixels into the view buffer.
		do
				-- Stub
		end

	V_MarkRect (x, y, width, height: INTEGER)
		do
				-- Stub
		end

end
