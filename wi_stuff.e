note
	description: "[
		wi_stuff.c
		Intermission screens.
	]"

class
	WI_STUFF

inherit

	DOOMDEF_H

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			NUMANIMS := <<epsd0animinfo.count, epsd1animinfo.count, epsd2animinfo.count>>
			NUMANIMS.rebase (0)
			anims := <<epsd0animinfo, epsd1animinfo, epsd2animinfo>>
			anims.rebase (0)
			create bp.make_filled (Void, 0, MAXPLAYERS - 1)
			create p.make_filled (Void, 0, MAXPLAYERS - 1)
			create num.make_filled (Void, 0, 9)
			create yah.make_filled (Void, 0, 1)
			create cnt_secret.make_filled (0, 0, MAXPLAYERS - 1)
			create cnt_items.make_filled (0, 0, MAXPLAYERS - 1)
			create cnt_kills.make_filled (0, 0, MAXPLAYERS - 1)
		end

feature

	wbs: detachable WBSTARTSTRUCT_T

	plrs: detachable ARRAY [WBPLAYERSTRUCT_T]

feature -- animenum_t

	ANIM_ALWAYS: INTEGER = 0

	ANIM_RANDOM: INTEGER = 1

	ANIM_LEVEL: INTEGER = 2

feature -- stateenum_t

	NoState: INTEGER = -1

	StatCount: INTEGER = 0

	ShowNextLoc: INTEGER = 1

feature

	NUMEPISODES: INTEGER = 4

	NUMMAPS: INTEGER = 9

feature

	epsd0animinfo: ARRAY [ANIM_T]
		do
			Result := <<
				--
			create {ANIM_T}.make (ANIM_ALWAYS, TICRATE // 3, 3, create {POINT_T}.make (224, 104)),
				--
 create {ANIM_T}.make (ANIM_ALWAYS, TICRATE // 3, 3, create {POINT_T}.make (184, 160)),
				--
 create {ANIM_T}.make (ANIM_ALWAYS, TICRATE // 3, 3, create {POINT_T}.make (112, 136)),
				--
 create {ANIM_T}.make (ANIM_ALWAYS, TICRATE // 3, 3, create {POINT_T}.make (72, 112)),
				--
 create {ANIM_T}.make (ANIM_ALWAYS, TICRATE // 3, 3, create {POINT_T}.make (88, 96)),
				--
 create {ANIM_T}.make (ANIM_ALWAYS, TICRATE // 3, 3, create {POINT_T}.make (64, 48)),
				--
 create {ANIM_T}.make (ANIM_ALWAYS, TICRATE // 3, 3, create {POINT_T}.make (192, 40)),
				--
 create {ANIM_T}.make (ANIM_ALWAYS, TICRATE // 3, 3, create {POINT_T}.make (136, 16)),
				--
 create {ANIM_T}.make (ANIM_ALWAYS, TICRATE // 3, 3, create {POINT_T}.make (80, 16)),
				--
 create {ANIM_T}.make (ANIM_ALWAYS, TICRATE // 3, 3, create {POINT_T}.make (64, 24))
				--
			>>
			Result.rebase (0)
		ensure
			Result.lower = 0
		end

	epsd1animinfo: ARRAY [ANIM_T]
		do
			Result := <<
				--
			create {ANIM_T}.make2 (ANIM_LEVEL, TICRATE // 3, 1, create {POINT_T}.make (128, 136), 1),
				--
 create {ANIM_T}.make2 (ANIM_LEVEL, TICRATE // 3, 1, create {POINT_T}.make (128, 136), 2),
				--
 create {ANIM_T}.make2 (ANIM_LEVEL, TICRATE // 3, 1, create {POINT_T}.make (128, 136), 3),
				--
 create {ANIM_T}.make2 (ANIM_LEVEL, TICRATE // 3, 1, create {POINT_T}.make (128, 136), 4),
				--
 create {ANIM_T}.make2 (ANIM_LEVEL, TICRATE // 3, 1, create {POINT_T}.make (128, 136), 5),
				--
 create {ANIM_T}.make2 (ANIM_LEVEL, TICRATE // 3, 1, create {POINT_T}.make (128, 136), 6),
				--
 create {ANIM_T}.make2 (ANIM_LEVEL, TICRATE // 3, 1, create {POINT_T}.make (128, 136), 7),
				--
 create {ANIM_T}.make2 (ANIM_LEVEL, TICRATE // 3, 3, create {POINT_T}.make (192, 144), 8),
				--
 create {ANIM_T}.make2 (ANIM_LEVEL, TICRATE // 3, 1, create {POINT_T}.make (128, 136), 8)
				--
			>>
			Result.rebase (0)
		ensure
			Result.lower = 0
		end

	epsd2animinfo: ARRAY [ANIM_T]
		do
			Result := <<
				--
			create {ANIM_T}.make (ANIM_ALWAYS, TICRATE // 3, 3, create {POINT_T}.make (104, 168)),
				--
 create {ANIM_T}.make (ANIM_ALWAYS, TICRATE // 3, 3, create {POINT_T}.make (40, 136)),
				--
 create {ANIM_T}.make (ANIM_ALWAYS, TICRATE // 3, 3, create {POINT_T}.make (160, 96)),
				--

 create {ANIM_T}.make (ANIM_ALWAYS, TICRATE // 3, 3, create {POINT_T}.make (104, 80)),
				--
 create {ANIM_T}.make (ANIM_ALWAYS, TICRATE // 3, 3, create {POINT_T}.make (120, 32)),
				--
 create {ANIM_T}.make (ANIM_ALWAYS, TICRATE // 4, 3, create {POINT_T}.make (40, 0))
				--
			>>
			Result.rebase (0)
		ensure
			Result.lower = 0
		end

feature

	NUMANIMS: ARRAY [INTEGER]

	anims: ARRAY [ARRAY [ANIM_T]]

	NUMCMAPS: INTEGER

feature

	me: INTEGER
			-- wbs->pnum

	acceleratestage: INTEGER
			-- used to accelerate or skip a stage

	state: INTEGER
			-- specifies current state (stateenum_t)

	firstrefresh: INTEGER
			-- signals to refresh everything for one frame

	cnt: INTEGER
			-- used for general timing

	bcnt: INTEGER
			-- used for timing of background animation

	sp_state: INTEGER

	cnt_kills: ARRAY [INTEGER]

	cnt_items: ARRAY [INTEGER]

	cnt_secret: ARRAY [INTEGER]

	cnt_time: INTEGER

	cnt_par: INTEGER

	cnt_pause: INTEGER

feature -- GRAPHICS

		-- background (map of levels).

	bg: detachable PATCH_T

		-- You Are Here graphic

	yah: ARRAY [detachable PATCH_T]

		-- splat

	splat: detachable PATCH_T

		-- %, : graphics

	percent: detachable PATCH_T

	colon: detachable PATCH_T

		-- 0-9 graphic

	num: ARRAY [detachable PATCH_T]

		-- minus sign

	wiminus: detachable PATCH_T

		-- "Finished!" graphics

	finished: detachable PATCH_T

		-- "Entering" graphic

	entering: detachable PATCH_T

		-- "secret"

	sp_secret: detachable PATCH_T

		-- "Kills", "Scrt", "Items", "Frags"

	kills: detachable PATCH_T

	secret: detachable PATCH_T

	items: detachable PATCH_T

	frags: detachable PATCH_T

		-- Time sucks.

	time: detachable PATCH_T

	par: detachable PATCH_T

	sucks: detachable PATCH_T

		-- "killers", "victims"

	killers: detachable PATCH_T

	victims: detachable PATCH_T

		-- "Total", your face, your dead face

	total: detachable PATCH_T

	star: detachable PATCH_T

	bstar: detachable PATCH_T

		-- "red P[1..MAXPLAYERS]"

	p: ARRAY [detachable PATCH_T]

		-- "gray P[1..MAXPLAYERS]"

	bp: ARRAY [detachable PATCH_T]

		-- Name graphics of each level (centered)

	lnames: detachable ARRAY [detachable PATCH_T]

feature

	WI_Drawer
		do
				-- Stub
		end

	WI_Ticker
		do
				-- Stub
		end

	WI_initVariables (wbstartstruct: WBSTARTSTRUCT_T)
		do
			wbs := wbstartstruct
				-- skip RANGECHECKING
			check attached wbs as l_wbs then
				acceleratestage := 0
				cnt := 0
				bcnt := 0
				firstrefresh := 1
				me := l_wbs.pnum
				plrs := l_wbs.plyr
				if l_wbs.maxkills = 0 then
					l_wbs.maxkills := 1
				end
				if l_wbs.maxitems = 0 then
					l_wbs.maxitems := 1
				end
				if l_wbs.maxsecret = 0 then
					l_wbs.maxsecret := 1
				end
				if i_main.doomstat_h.gamemode /= {GAME_MODE_T}.retail then
					if l_wbs.epsd > 2 then
						l_wbs.epsd := l_wbs.epsd - 3
					end
				end
			end
		end

	two_digits (i: INTEGER): STRING
		do
			if i.out.count < 2 then
				Result := "0" + i.out
			else
				Result := i.out
			end
		ensure
			Result.count = 2
			Result.to_integer = i
		end

	WI_loadData
		require
			wbs /= Void
		local
			i: INTEGER
			j: INTEGER
			name: STRING
			a: ANIM_T
		do
			check attached wbs as l_wbs then
				if i_main.doomstat_h.gamemode = {GAME_MODE_T}.commercial then
					name := "INTERPIC"
				else
					name := "WIMAP" + l_wbs.epsd.out
				end
				if i_main.doomstat_h.gamemode = {GAME_MODE_T}.retail then
					if l_wbs.epsd = 3 then
						name := "INTERPIC"
					end
				end
					-- background
				bg := create {PATCH_T}.from_pointer (i_main.w_wad.W_CacheLumpName (name, {Z_ZONE}.pu_cache))
				check attached bg as l_bg then
					i_main.v_video.v_drawpatch (0, 0, l_bg)
				end
				if i_main.doomstat_h.gamemode = {GAME_MODE_T}.commercial then
					NUMCMAPS := 32
					create lnames.make_filled (Void, 0, 32 - 1)
					from
						i := 0
					until
						i >= NUMCMAPS
					loop
						check attached lnames as lns then
							lns [i] := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("CWILV" + two_digits (i), {Z_ZONE}.pu_cache))
						end
						i := i + 1
					end
				else
					create lnames.make_filled (Void, 0, NUMMAPS - 1)
					from
						i := 0
					until
						i >= NUMMAPS
					loop
						check attached lnames as lns then
							lns [i] := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WILV" + l_wbs.epsd.out + i.out, {Z_ZONE}.pu_cache))
						end
						i := i + 1
					end
						-- you are here
					yah [0] := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WIURH0", {Z_ZONE}.pu_static))
						-- you are here (alt.)
					yah [1] := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WIURH1", {Z_ZONE}.pu_static))
						-- splat
					splat := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WISPLAT", {Z_ZONE}.pu_static))
					if l_wbs.epsd < 3 then
						from
							j := 0
						until
							j >= NUMANIMS [l_wbs.epsd]
						loop
							a := anims [l_wbs.epsd] [j]
							from
								i := 0
							until
								i >= a.nanims
							loop
									-- MONDO HACK!
								if l_wbs.epsd /= 1 or j /= 0 then
										-- animations
									a.p [i] := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WIA" + l_wbs.epsd.out + two_digits (j) + two_digits (i), {Z_ZONE}.pu_static))
								else
										-- HACK ALERT!
									a.p [i] := anims [1] [4].p [i]
								end
								i := i + 1
							end
							j := j + 1
						end
					end
				end
			end
				-- More hacks on minus sign.
			wiminus := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WIMINUS", {Z_ZONE}.pu_static))
			from
				i := 0
			until
				i >= 10
			loop
					-- numbers 0-9
				num [i] := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WINUM" + i.out, {Z_ZONE}.pu_static))
				i := i + 1
			end
				-- percent sign
			percent := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WIPCNT", {Z_ZONE}.pu_static))
				-- "finished"
			finished := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WIF", {Z_ZONE}.pu_static))
				-- "entering"
			entering := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WIOSTK", {Z_ZONE}.pu_static))
				-- "scrt"
			secret := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WIOSTS", {Z_ZONE}.pu_static))
				-- "secret"
			sp_secret := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WISCRT2", {Z_ZONE}.pu_static))
				-- Yuck.
			if {DOOMDEF_H}.french /= 0 then
					-- "items"
				if i_main.g_game.netgame and not i_main.g_game.deathmatch then
					items := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WIOBJ", {Z_ZONE}.pu_static))
				else
					items := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WIOSTI", {Z_ZONE}.pu_static))
				end
			else
				items := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WIOSTI", {Z_ZONE}.pu_static))
			end
				-- "frgs"
			frags := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WIFRGS", {Z_ZONE}.pu_static))
				-- ":"
			colon := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WICOLON", {Z_ZONE}.pu_static))
				-- "time"
			time := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WITIME", {Z_ZONE}.pu_static))
				-- "sucks"
			sucks := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WISUCKS", {Z_ZONE}.pu_static))
				-- "par"
			par := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WIPAR", {Z_ZONE}.pu_static))
				-- "killers" (vertical)
			killers := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WIKILRS", {Z_ZONE}.pu_static))
				-- "victims" (horiz)
			victims := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WIVCTMS", {Z_ZONE}.pu_static))
				-- "total"
			total := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WIMSTT", {Z_ZONE}.pu_static))
				-- your face
			star := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("STFST01", {Z_ZONE}.pu_static))
				-- dead face
			bstar := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("STFDEAD0", {Z_ZONE}.pu_static))
			from
				i := 0
			until
				i >= {DOOMDEF_H}.MAXPLAYERS
			loop
				p [i] := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("STPB" + i.out, {Z_ZONE}.pu_static))
					-- "1,2,3,4"
				bp [i] := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname ("WIBP" + (i + 1).out, {Z_ZONE}.pu_static))
				i := i + 1
			end
		end

	WI_initDeathmatchStats
		do
			{I_MAIN}.i_error ("WI_initDeathmatchStats not implemnted")
		end

	WI_initNetGameStats
		do
			{I_MAIN}.i_error ("WI_initNetgameStat not implemented")
		end

	WI_initStats
		do
			state := StatCount
			acceleratestage := 0
			sp_state := 1
			cnt_kills [0] := -1
			cnt_items [0] := -1
			cnt_secret [0] := -1
			cnt_time := -1
			cnt_par := -1
			cnt_pause := {DOOMDEF_H}.TICRATE
			WI_initAnimatedBack
		end

	WI_initAnimatedBack
		local
			i: INTEGER
			a: ANIM_T
		do
			if i_main.doomstat_h.gamemode = {GAME_MODE_T}.commercial then
					-- return
			else
				check attached wbs as l_wbs then
					if l_wbs.epsd > 2 then
							-- return
					else
						from
							i := 0
						until
							i >= NUMANIMS [l_wbs.epsd]
						loop
							a := anims [l_wbs.epsd] [i]
								-- init variables
							a.ctr := -1

								-- specify the next time to draw it
							if a.type = ANIM_ALWAYS then
								a.nexttic := bcnt + 1 + (i_main.m_random.m_random \\ a.period)
							elseif a.type = ANIM_RANDOM then
								a.nexttic := bcnt + 1 + a.data2 + (i_main.m_random.m_random \\ a.data1)
							elseif a.type = ANIM_LEVEL then
								a.nexttic := bcnt + 1
							end
							i := i + 1
						end
					end
				end
			end
		end

	WI_Start (wbstartstruct: WBSTARTSTRUCT_T)
		do
			WI_initVariables (wbstartstruct)
			WI_loadData
			if i_main.g_game.deathmatch then
				WI_initDeathmatchStats
			elseif i_main.g_game.netgame then
				WI_initNetgameStats
			else
				WI_initStats
			end
		end

invariant
	NUMANIMS.lower = 0
	NUMANIMS.count = NUMEPISODES - 1 -- Very sys, NUMANIMS initializer only sets 3 items
	anims.lower = 0 and across anims as ai all ai.item.lower = 0 end
	anims.count = NUMEPISODES - 1 -- Very sus, anims initializer only sets 3 items
	{UTILS [detachable PATCH_T]}.invariant_ref_array (p, MAXPLAYERS)
	{UTILS [detachable PATCH_T]}.invariant_ref_array (bp, MAXPLAYERS)
	{UTILS [detachable PATCH_T]}.invariant_ref_array (yah, 2)
	{UTILS [detachable PATCH_T]}.invariant_ref_array (num, 10)
	cnt_kills.lower = 0 and cnt_kills.count = MAXPLAYERS
	cnt_items.lower = 0 and cnt_items.count = MAXPLAYERS
	cnt_secret.lower = 0 and cnt_items.count = MAXPLAYERS

end
