note
	description: "[
		f_wipe.c
		Mission begin melt/wipe screen special effect.
	]"

class
	F_WIPE

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			create wipe_scr_start.make_empty
			create wipe_scr_end.make_empty
		end

feature

	wipe_scr_start: ARRAY [NATURAL_8]

	wipe_scr_end: ARRAY [NATURAL_8]

feature

	wipe_StartScreen (x, y, width, height: INTEGER)
		do
			wipe_scr_start := i_main.v_video.screens [2]
			check attached i_main.i_video as iv then
				iv.I_ReadScreen (wipe_scr_start)
			end
		end

	wipe_EndScreen (x, y, width, height: INTEGER)
		do
			wipe_scr_end := i_main.v_video.screens [3]
			check attached i_main.i_video as iv then
				iv.i_readscreen (wipe_scr_end)
			end
			i_main.v_video.V_DrawBlock (x, y, 0, width, height, wipe_scr_start) -- restore start scr.
		end

	wipe_ScreenWipe (wipeno: INTEGER; x, y: INTEGER; width, height: INTEGER; ticks: INTEGER): BOOLEAN -- originally returned int
		do
				-- Stub
		end

feature -- wipenos

	wipe_ColorXForm: INTEGER = 0

	wipe_Melt: INTEGER = 1

	wipe_NUMWIPES: INTEGER = 2

end
