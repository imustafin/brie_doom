note
	description: "[
		r_main.c
		Rendering main loop and setup functions,
		 utility functions (BSP, geometry, trigonometry).
		See tables.c, too
	]"

class
	R_MAIN

inherit
	TABLES

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

feature
	viewx: FIXED_T
	viewy: FIXED_T
	viewz: FIXED_T

feature -- R_SetViewSize

	setsizeneeded: BOOLEAN

	setblocks: INTEGER

	setdetail: INTEGER

	R_SetViewSize (blocks: INTEGER; detail: INTEGER)
			-- Do not really change anything here,
			--  because it might be in the middle of a refresh.
			-- The change will take effect next refresh.
		do
			setsizeneeded := True
			setblocks := blocks
			setdetail := detail
		end

feature

	R_InitPointToAngle
		do
				-- UNUSED - now getting from tables.c
		end

	R_InitTables
		do
				-- UNUSED - now getting from tables.c
		end

feature -- R_InitLightTables

	DISTMAP: INTEGER = 2

	R_InitLightTables
		do
				-- Stub
		end

feature -- R_Init

	framecount: INTEGER -- just for profiling purposes

	R_Init
		do
			i_main.r_data.R_InitData
			print ("%NR_InitData")
			R_InitPointToAngle
			print ("%NR_InitPointToAngle")
			R_InitTables
				-- viewwidth / viewheight / detaillevel are set by the defaults
			print ("%NR_InitTables")
			R_SetViewSize (i_main.m_menu.screenblocks, i_main.m_menu.detaillevel)
			i_main.r_plane.R_InitPlanes
			print ("%NR_InitPlanes")
			R_InitLightTables
			print ("%NR_InitLightTables")
			i_main.r_sky.R_InitSkyMap
			print ("%NR_InitSkyMap")
			i_main.r_draw.R_InitTranslationTables
			print ("%NR_InitTranslationsTables")
			framecount := 0
		end

feature

	R_PointToAngle2 (x1, y1, x2, y2: FIXED_T): ANGLE_T
		do
			viewx := x1
			viewy := y1
			Result := R_PointToAngle (x2, y2)
		end

	R_PointToAngle (a_x, a_y: FIXED_T): ANGLE_T
			-- To get a global angle from cartesian coordinates,
			--  the coordinates are flipped until they are in
			--  the first octant of the coordinate system, then
			--  the y (<= x) is scaled and divided by x to get a
			--  tangent (slope) value which is looked up in the
			--  tantoangle[] table.
		local
			x, y: FIXED_T
		do
			x := a_x - viewx
			y := a_y - viewy
			if x = 0 and y = 0 then
				Result := {NATURAL} 0
			else
				if x >= 0 then
						-- x >= 0
					if y >= 0 then
							-- y >= 0
						if x > y then
								-- octant 0
							Result := tantoangle [SlopeDiv (y, x)]
						else
								-- octant 1
							Result := (ANG90 - 1 - tantoangle [SlopeDiv (x, y)]).as_natural_32
						end
					else
							-- y < 0
						y := - y
						if x > y then
								-- octant 8
							Result := (- tantoangle [SlopeDiv (y, x)].as_integer_32).as_natural_32
						else
								-- octant 7
							Result := (ANG270 + tantoangle [SlopeDiv (x, y)]).as_natural_32
						end
					end
				else
						-- x < 0
					x := - x
					if y >= 0 then
							-- y >= 0
						if x > y then
								-- octant 3
							Result := (ANG180 - 1 - tantoangle [SlopeDiv (y, x)]).as_natural_32
						else
								-- octant 2
							Result := (ANG90 + tantoangle [SlopeDiv (x, y)]).as_natural_32
						end
					else
							-- y < 0
						y := - y
						if x > y then
								-- octant 4
							Result := (ANG180 + tantoangle [SlopeDiv (y, x)]).as_natural_32
						else
								-- octant 5
							Result := (ANG270 - 1 - tantoangle [SlopeDiv (x, y)]).as_natural_32
						end
					end
				end
			end
		end
end
