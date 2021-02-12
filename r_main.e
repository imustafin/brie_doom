note
	description: "[
		r_main.c
		Rendering main loop and setup functions,
		 utility functions (BSP, geometry, trigonometry).
		See tables.c, too
	]"

class
	R_MAIN

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

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

end
