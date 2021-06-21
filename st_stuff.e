note
	description: "[
		st_stuff.c
		Status bar code.
		Does the face/direction indicator animation.
		Does palette indicators as well (red pain/berserk, bright pickup)
	]"

class
	ST_STUFF

inherit

	POWERTYPE_T

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		local
			i: INTEGER
		do
			i_main := a_i_main
				-- Make arms
			create arms.make_filled (create {ARRAY [detachable PATCH_T]}.make_empty, 0, 5)
			from
				i := 0
			until
				i > 5
			loop
				arms [i] := create {ARRAY [detachable PATCH_T]}.make_filled (Void, 0, 1)
				i := i + 1
			end
				-- Make numbers
			create shortnum.make_filled (Void, 0, 9)
			create tallnum.make_filled (Void, 0, 9)
				-- Make others
			create faces.make_filled (Void, 0, ST_NUMFACES - 1)
			create keys.make_filled (Void, 0, {DOOMDEF_H}.NUMCARDS - 1)
			create oldweaponsowned.make_filled (False, 0, {DOOMDEF_H}.numweapons - 1)
			create keyboxes.make_filled (0, 0, 2)
		ensure
			arms.lower = 0 and arms.count = 6 and across arms as a all a.item.lower = 0 and a.item.count = 2 end
			faces.lower = 0 and faces.count = ST_NUMFACES
			keys.lower = 0 and keys.count = {DOOMDEF_H}.NUMCARDS
			shortnum.lower = 0 and shortnum.count = 10
			tallnum.lower = 0 and tallnum.count = 10
			oldweaponsowned.lower = 0 and oldweaponsowned.count = {DOOMDEF_H}.numweapons
			keyboxes.lower = 0 and keyboxes.count = 3
		end

feature

	ST_HEIGHT: INTEGER = 32

	ST_WIDTH: INTEGER
		once
			Result := {DOOMDEF_H}.screenwidth
		end

	ST_NUMPAINFACES: INTEGER = 5

	ST_NUMSTRAIGHTFACES: INTEGER = 3

	ST_NUMEXTRAFACES: INTEGER = 2

	ST_NUMTURNFACES: INTEGER = 2

	ST_NUMSPECIALFACES: INTEGER = 3

	ST_FACESTRIDE: INTEGER
		once
			Result := ST_NUMSTRAIGHTFACES + ST_NUMTURNFACES + ST_NUMSPECIALFACES
		end

	ST_NUMFACES: INTEGER
		once
			Result := ST_FACESTRIDE * ST_NUMPAINFACES + ST_NUMEXTRAFACES
		end

	STARTREDPALS: INTEGER = 1

	STARTBONUSPALS: INTEGER = 9

	NUMREDPALS: INTEGER = 8

	NUMBONUSPALS: INTEGER = 4

	RADIATIONPAL: INTEGER = 13

	st_palette: INTEGER

	ST_X: INTEGER = 0

	ST_X2: INTEGER = 104

	ST_FX: INTEGER = 143

	ST_FY: INTEGER = 169

	ST_ARMSBGX: INTEGER = 104

	ST_Y: INTEGER
		once
			Result := {DOOMDEF_H}.SCREENHEIGHT - ST_HEIGHT
		end

feature

	st_backing_screen: detachable PIXEL_T_BUFFER
			-- graphics are drawn to a backing screen and blitted to the real screen

	lu_palette: INTEGER
			-- lump number for PLAYPAL

	sbar: detachable PATCH_T
			-- main bar left

	sbarr: detachable PATCH_T
			-- main bar right, for doom 1.0

	tallnum: ARRAY [detachable PATCH_T]
			-- 0-9, tall numbers [10]

	tallpercent: detachable PATCH_T

	shortnum: ARRAY [detachable PATCH_T]
			-- 0-9, short, yellow (,different!) numbers [10]

	keys: ARRAY [detachable PATCH_T]
			-- 3 key-cards, 3 skulls [NUMCARDS]

	faces: ARRAY [detachable PATCH_T]
			-- face status patches [ST_NUMFACES]

	faceback: detachable PATCH_T
			-- face background

	armsbg: detachable PATCH_T
			-- main bar right

	arms: ARRAY [ARRAY [detachable PATCH_T]]
			-- weapon ownership patches [6][2]

feature

	st_clock: NATURAL
			-- used for timing

	st_chatstate: INTEGER
			-- st_chatstateenum_t used when in chat

	st_gamestate: INTEGER
			-- st_stateenum_t whether in automap or first-person

	st_oldchat: BOOLEAN
			-- value of st_chat before message popped up

	st_chat: BOOLEAN
			-- whether status bar chat is active

	st_cursoron: BOOLEAN
			-- whether chat window has the cursor on

	st_faceindex: INTEGER
			-- current face index, used by w_faces

	st_oldhealth: INTEGER
			-- used to use appropriately pained face

	oldweaponsowned: ARRAY [BOOLEAN]
			-- used for evil grin [NUMWEAPONS]

	keyboxes: ARRAY [INTEGER]
			-- holds key-type for each key box on bar

feature -- st_chatstateenum_t

	StartChatState: INTEGER = 0

	WaitDestState: INTEGER = 1

	GetChatState: INTEGER = 2

feature -- st_stateenum_t

	AutomapState: INTEGER = 0

	FirstPersonState: INTEGER = 1

feature

	st_statusbaron: BOOLEAN
			-- whether left-side main status bar is active

	st_firsttime: BOOLEAN
			-- ST_Start() has just been called

	plyr: detachable PLAYER_T

feature

	ST_loadGraphics
		local
			i: INTEGER
			j: INTEGER
			facenum: INTEGER
			namebuf: STRING
		do
				-- Load the numbers, tall and short
			from
				i := 0
			until
				i >= 10
			loop
				tallnum [i] := load_patch ("STTNUM" + i.out)
				shortnum [i] := load_patch ("STYSNUM" + i.out)
				i := i + 1
			end

				-- Load percent key.
				-- Note: why not load STMINUS here, too?
			tallpercent := load_patch ("STTPRCNT")
				-- key cards
			from
				i := 0
			until
				i >= {DOOMDEF_H}.NUMCARDS
			loop
				keys [i] := load_patch ("STKEYS" + i.out)
				i := i + 1
			end

				-- arms background
			armsbg := load_patch ("STARMS")

				-- arms ownership widgets
			from
				i := 0
			until
				i >= 6
			loop
					-- gray #
				arms [i] [0] := load_patch ("STGNUM" + i.out)
					-- yellow #
				arms [i] [1] := shortnum [i + 2]
				i := i + 1
			end

				-- face backgrounds for different color players
			faceback := load_patch ("STFB" + i_main.g_game.consoleplayer.out)

				-- status bar for background bits
			if i_main.w_wad.w_checknumforname ("STBAR") > 0 then
				sbar := load_patch ("STBAR")
				sbarr := Void
			else
				sbar := load_patch ("STMBARL")
				sbarr := load_patch ("STMBARR")
			end

				-- face states
			facenum := 0
			from
				i := 0
			until
				i >= ST_NUMPAINFACES
			loop
				from
					j := 0
				until
					j >= ST_NUMSTRAIGHTFACES
				loop
					faces [facenum] := load_patch ("STFST" + i.out + j.out)
					facenum := facenum + 1
					j := j + 1
				end
				faces [facenum] := load_patch ("STFTR" + i.out + "0") -- turn right
				facenum := facenum + 1
				faces [facenum] := load_patch ("STFTL" + i.out + "0") -- turn left
				facenum := facenum + 1
				faces [facenum] := load_patch ("STFOUCH" + i.out) -- ouch!
				facenum := facenum + 1
				faces [facenum] := load_patch ("STFEVL" + i.out) -- evil grin ;)
				facenum := facenum + 1
				faces [facenum] := load_patch ("STFKILL" + i.out) -- pissed off
				facenum := facenum + 1
				i := i + 1
			end
			faces [facenum] := load_patch ("STFGOD0")
			facenum := facenum + 1
			faces [facenum] := load_patch ("STFDEAD0")
			facenum := facenum + 1
		end

	load_patch (name: STRING): PATCH_T
		do
			Result := create {PATCH_T}.from_pointer (i_main.w_wad.w_cachelumpname (name, {Z_ZONE}.pu_static))
		end

	ST_loadData
		do
			lu_palette := i_main.w_wad.w_getnumforname ("PLAYPAL")
			ST_loadGraphics
		end

	ST_Init
		do
			ST_loadData
			create st_backing_screen.make (ST_WIDTH * ST_HEIGHT)
		end

feature

	ST_Drawer (fullscreen: BOOLEAN; refresh: BOOLEAN)
		do
			st_statusbaron := (not fullscreen) or i_main.am_map.automapactive
			st_firsttime := st_firsttime or refresh

				-- Do red-/gold-shifts from gamage/items
			ST_doPaletteStuff

				-- If just after ST_Start, refresh all
			if st_firsttime then
				ST_doRefresh
			else
					-- Otherwise, update as little as possible
				ST_diffDraw
			end
		end

	ST_doPaletteStuff
		local
			palette: INTEGER
			pal: MANAGED_POINTER
			cnt: INTEGER
			bzc: INTEGER
		do
			check attached plyr as p then
				cnt := p.damagecount
				if p.powers [pw_strength] /= 0 then
						-- slowly fade the berzerk out
					bzc := 12 - (p.powers [pw_strength] |>> 6)
					if bzc > cnt then
						cnt := bzc
					end
				end
				if cnt /= 0 then
					palette := (cnt + 7) |>> 3
					if palette >= NUMREDPALS then
						palette := NUMREDPALS - 1
					end
					palette := palette + STARTREDPALS
				elseif p.bonuscount /= 0 then
					palette := (p.bonuscount + 7) |>> 3
					if palette >= NUMBONUSPALS then
						palette := NUMBONUSPALS - 1
					end
					palette := palette + STARTBONUSPALS
				elseif p.powers [pw_ironfeet] > 4 * 32 or p.powers [pw_ironfeet] & 8 /= 0 then
					palette := RADIATIONPAL
				else
					palette := 0
				end
			end

				-- skip Chex Quest

			if palette /= st_palette then
				st_palette := palette
				pal := i_main.w_wad.w_cachelumpnum (lu_palette, {Z_ZONE}.pu_cache)
				create pal.share_from_pointer (pal.item + palette * 768, pal.count - palette * 768)
				i_main.i_video.i_setpalette (pal)
			end
		end

	ST_doRefresh
		do
			st_firsttime := False
				-- draw status bar background to off-screen buff
			ST_refreshBackground
				-- and refresh all widgets
			ST_drawWidgets (True)
		end

	ST_diffDraw
		do
				-- update all widgets
			ST_drawWidgets (False)
		end

	ST_drawWidgets (refresh: BOOLEAN)
		do
				-- Stub
		end

	ST_refreshBackground
		do
			if st_statusbaron then
				check attached st_backing_screen as sb then
					i_main.v_video.v_usebuffer (sb)
				end
				check attached sbar as at_sbar then
					i_main.v_video.v_drawpatch (ST_X, 0, at_sbar)
				end

					-- draw right side of bar if needed (Doom 1.0)
				if attached sbarr as at_sbarr then
					i_main.v_video.v_drawpatch (ST_ARMSBGX, 0, at_sbarr)
				end
				if i_main.g_game.netgame then
					check attached faceback as at_faceback then
						i_main.v_video.v_drawpatch (ST_FX, 0, at_faceback)
					end
				end
				i_main.v_video.v_restorebuffer
				check attached st_backing_screen as sb then
					i_main.v_video.V_CopyRect (ST_X, 0, sb, ST_WIDTH, ST_HEIGHT, ST_X, ST_Y)
				end
			end
		end

feature

	ST_Responder (ev: EVENT_T): BOOLEAN
		do
				-- Stub
		end

feature

	st_stopped: BOOLEAN

	ST_Start
		do
			if not st_stopped then
				ST_Stop
			end
			ST_initData
			ST_createWidgets
			st_stopped := False
		end

	ST_createWidgets
		do
				-- Stub
		end

	ST_Stop
		do
			if st_stopped then
					-- return
			else
				i_main.i_video.i_setpalette (i_main.w_wad.w_cachelumpnum (lu_palette, {Z_ZONE}.pu_cache))
				st_stopped := True
			end
		end

	ST_initData
		local
			i: INTEGER
		do
			st_firsttime := True
			plyr := i_main.g_game.players [i_main.g_game.consoleplayer]
			st_clock := 0
			st_chatstate := StartChatState
			st_gamestate := FirstPersonState
			st_statusbaron := True
			st_oldchat := False
			st_chat := False
			st_cursoron := False
			st_faceindex := 0
			st_palette := -1
			st_oldhealth := -1
			from
				i := 0
			until
				i >= {DOOMDEF_H}.NUMWEAPONS
			loop
				check attached plyr as p then
					oldweaponsowned [i] := p.weaponowned [i]
				end
				i := i + 1
			end
			from
				i := 0
			until
				i >= 3
			loop
				keyboxes [i] := -1
				i := i + 1
			end
			i_main.st_lib.STlib_init
		end

feature

	ST_Ticker
		do
				-- Stub
		end

end
