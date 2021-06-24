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

	CHEAT_T

	WEAPONTYPE_T

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
			create keys.make_filled (Void, 0, {CARD_T}.NUMCARDS - 1)
			create oldweaponsowned.make_filled (False, 0, numweapons - 1)
			create keyboxes.make_filled (0, 0, 2)
			create w_maxammo.make_filled (Void, 0, 3)
			create w_ammo.make_filled (Void, 0, 3)
			create w_keyboxes.make_filled (Void, 0, 2)
			create w_arms.make_filled (Void, 0, 5)
			lastattackdown := -1
			oldhealth := -1
		ensure
			arms.lower = 0 and arms.count = 6 and across arms as a all a.item.lower = 0 and a.item.count = 2 end
			faces.lower = 0 and faces.count = ST_NUMFACES
			keys.lower = 0 and keys.count = {CARD_T}.NUMCARDS
			shortnum.lower = 0 and shortnum.count = 10
			tallnum.lower = 0 and tallnum.count = 10
			oldweaponsowned.lower = 0 and oldweaponsowned.count = numweapons
			keyboxes.lower = 0 and keyboxes.count = 3
			w_maxammo.lower = 0 and w_maxammo.count = 4
			w_ammo.lower = 0 and w_ammo.count = 4
			w_keyboxes.lower = 0 and w_keyboxes.count = 3
			w_arms.lower = 0 and w_arms.count = 6
			lastattackdown = -1
			oldhealth = -1
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
		ensure
			instance_free: class
		end

	ST_AMMOX: INTEGER = 44

	ST_AMMOY: INTEGER = 171

	ST_AMMOWIDTH: INTEGER = 3

	ST_HEALTHX: INTEGER = 90

	ST_HEALTHY: INTEGER = 171

	ST_ARMSBGY: INTEGER = 168

	ST_ARMSX: INTEGER = 111

	ST_ARMSY: INTEGER = 172

	ST_ARMSXSPACE: INTEGER = 12

	ST_ARMSYSPACE: INTEGER = 10

	ST_FRAGSX: INTEGER = 138

	ST_FRAGSY: INTEGER = 171

	ST_FRAGSWIDTH: INTEGER = 2

	ST_FACESX: INTEGER = 143

	ST_FACESY: INTEGER = 168

	ST_ARMORX: INTEGER = 221

	ST_ARMORY: INTEGER = 171

	ST_KEY0X: INTEGER = 239

	ST_KEY0Y: INTEGER = 171

	ST_KEY1X: INTEGER = 239

	ST_KEY1Y: INTEGER = 181

	ST_KEY2X: INTEGER = 239

	ST_KEY2Y: INTEGER = 191

	ST_AMMO0X: INTEGER = 288

	ST_AMMO0Y: INTEGER = 173

	ST_AMMO0WIDTH: INTEGER = 3

	ST_AMMO1WIDTH: INTEGER
		once
			Result := ST_AMMO0WIDTH
		end

	ST_AMMO2WIDTH: INTEGER
		once
			Result := ST_AMMO0WIDTH
		end

	ST_AMMO3WIDTH: INTEGER
		once
			Result := ST_AMMO0WIDTH
		end

	ST_AMMO1X: INTEGER = 288

	ST_AMMO1Y: INTEGER = 179

	ST_AMMO2X: INTEGER = 288

	ST_AMMO2Y: INTEGER = 191

	ST_AMMO3X: INTEGER = 288

	ST_AMMO3Y: INTEGER = 185

	ST_MAXAMMO0X: INTEGER = 314

	ST_MAXAMMO0Y: INTEGER = 173

	ST_MAXAMMO0WIDTH: INTEGER = 3

	ST_MAXAMMO1X: INTEGER = 314

	ST_MAXAMMO1Y: INTEGER = 179

	ST_MAXAMMO1WIDTH: INTEGER
		once
			Result := ST_MAXAMMO0WIDTH
		end

	ST_MAXAMMO2X: INTEGER = 314

	ST_MAXAMMO2Y: INTEGER = 191

	ST_MAXAMMO2WIDTH: INTEGER
		once
			Result := ST_MAXAMMO0WIDTH
		end

	ST_MAXAMMO3X: INTEGER = 314

	ST_MAXAMMO3Y: INTEGER = 185

	ST_MAXAMMO3WIDTH: INTEGER
		once
			Result := ST_MAXAMMO0WIDTH
		end

feature

	ST_DEADFACE: INTEGER
		once
			Result := ST_GODFACE + 1
		end

	ST_GODFACE: INTEGER
		once
			Result := ST_NUMPAINFACES * ST_FACESTRIDE
		end

	ST_RAMPAGEOFFSET: INTEGER
		once
			Result := ST_EVILGRINOFFSET + 1
		end

	ST_EVILGRINOFFSET: INTEGER
		once
			Result := ST_OUCHOFFSET + 1
		end

	ST_OUCHOFFSET: INTEGER
		once
			Result := ST_TURNOFFSET + ST_NUMTURNFACES
		end

	ST_EVILGRINCOUNT: INTEGER
		once
			Result := 2 * {DOOMDEF_H}.TICRATE
		end

	ST_STRAIGHTFACECOUNT: INTEGER
		once
			Result := {DOOMDEF_H}.TICRATE // 2
		end

	ST_TURNCOUNT: INTEGER
		once
			Result := {DOOMDEF_H}.TICRATE
		end

	ST_OUCHCOUNT: INTEGER
		once
			Result := {DOOMDEF_H}.TICRATE
		end

	ST_RAMPAGEDELAY: INTEGER
		once
			Result := 2 * {DOOMDEF_H}.TICRATE
		end

	ST_TURNOFFSET: INTEGER
		once
			Result := ST_NUMSTRAIGHTFACES
		end

	ST_MUCHPAIN: INTEGER = 20

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

	st_randomnumber: INTEGER
			-- a random number per tick

	st_msgcounter: INTEGER
			-- used for making messages go away

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

	st_facecount: INTEGER
			-- count until face changes

feature

	w_ready: detachable ST_NUMBER
			-- ready-weapon widget

	w_frags: detachable ST_NUMBER
			-- in deathmatch only, summary of frags stats

	w_health: detachable ST_PERCENT
			-- health widget

	w_armsbg: detachable ST_BIN_ICON
			-- arms background

	w_arms: ARRAY [detachable ST_MULT_ICON]
			-- weapon ownership widgets [6]

	w_faces: detachable ST_MULT_ICON
			-- face status widget

	w_keyboxes: ARRAY [detachable ST_MULT_ICON]
			-- keycard widgets [3]

	w_armor: detachable ST_PERCENT
			-- armor widget

	w_ammo: ARRAY [detachable ST_NUMBER]
			-- ammo widgets [4]

	w_maxammo: ARRAY [detachable ST_NUMBER]
			-- max ammo widgets

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
				i >= {CARD_T}.NUMCARDS
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
				arms [i] [0] := load_patch ("STGNUM" + (i + 2).out)
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
		local
			i: INTEGER
		do
				-- used by w_arms[] widgets
			st_armson := st_statusbaron and not i_main.g_game.deathmatch
				-- used by w_frags widget
			st_fragson := i_main.g_game.deathmatch and st_statusbaron
			check attached w_ready as wr then
				wr.update (refresh)
			end
			from
				i := 0
			until
				i >= 4
			loop
				check attached w_ammo [i] as wai then
					wai.update (refresh)
				end
				check attached w_maxammo [i] as wmai then
					wmai.update (refresh)
				end
				i := i + 1
			end
			check attached w_health as wh then
				wh.update (refresh)
			end
			check attached w_armor as wa then
				wa.update (refresh)
			end
			check attached w_armsbg as wabg then
				wabg.update (refresh)
			end
			from
				i := 0
			until
				i >= 6
			loop
				check attached w_arms [i] as wi then
					wi.update (refresh)
				end
				i := i + 1
			end
			check attached w_faces as wf then
				wf.update (refresh)
			end
			from
				i := 0
			until
				i >= 3
			loop
				check attached w_keyboxes [i] as wki then
					wki.update (refresh)
				end
				i := i + 1
			end
			check attached w_frags as wf then
				wf.update (refresh)
			end
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

	st_notdeathmatch: BOOLEAN

	st_armson: BOOLEAN

	st_fragscount: INTEGER

	st_fragson: BOOLEAN

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
		local
			i: INTEGER
		do
				-- ready weapon info
			check attached plyr as p then
				create w_ready.make (ST_AMMOX, ST_AMMOY, tallnum, (agent : INTEGER
					do
						check attached plyr as agent_p then
							Result := agent_p.ammo [{D_ITEMS}.weaponinfo [agent_p.readyweapon].ammo]
						end
					end), agent st_statusbaron, ST_AMMOWIDTH, i_main)
					-- the last weapon type
				check attached w_ready as wr then
					wr.data := p.readyweapon
				end

					-- health percentage
				check attached tallpercent as tp then
					create w_health.make (ST_HEALTHX, ST_HEALTHY, tallnum, (agent : INTEGER
						do
							check attached plyr as agent_p then
								Result := agent_p.health
							end
						end), agent st_statusbaron, tp, i_main)
				end

					-- arms background
				check attached armsbg as abg then
					create w_armsbg.make (ST_ARMSBGX, ST_ARMSBGY, abg, agent st_notdeathmatch, agent st_statusbaron, i_main)
				end

					-- weapons owned
				from
					i := 0
				until
					i >= 6
				loop
					w_arms [i] := create {ST_MULT_ICON}.make (ST_ARMSX + (i \\ 3) * ST_ARMSXSPACE, ST_ARMSY + (i // 3) * ST_ARMSYSPACE, arms [i], (agent  (wep: INTEGER): INTEGER
						do
							check attached plyr as agent_p then
								Result := agent_p.weaponowned [wep + 1].to_integer
							end
						end (i)), agent st_armson, i_main)
					i := i + 1
				end

					-- frags sum
				create w_frags.make (ST_FRAGSX, ST_FRAGSY, tallnum, agent st_fragscount, agent st_fragson, ST_FRAGSWIDTH, i_main)
					-- faces
				create w_faces.make (ST_FACESX, ST_FACESY, faces, agent st_faceindex, agent st_statusbaron, i_main)
					-- armor percentage - should be colored later
				check attached tallpercent as tp then
					create w_armor.make (ST_ARMORX, ST_ARMORY, tallnum, (agent : INTEGER
						do
							check attached plyr as agent_p then
								Result := agent_p.armorpoints
							end
						end), agent st_statusbaron, tp, i_main)
				end

					-- keyboxes 0-2
				w_keyboxes [0] := create {ST_MULT_ICON}.make (ST_KEY0X, ST_KEY0Y, keys, (agent : INTEGER
					do
						Result := keyboxes [0]
					end), agent st_statusbaron, i_main)
				w_keyboxes [1] := create {ST_MULT_ICON}.make (ST_KEY1X, ST_KEY1Y, keys, (agent : INTEGER
					do
						Result := keyboxes [1]
					end), agent st_statusbaron, i_main)
				w_keyboxes [2] := create {ST_MULT_ICON}.make (ST_KEY2X, ST_KEY2Y, keys, (agent : INTEGER
					do
						Result := keyboxes [2]
					end), agent st_statusbaron, i_main)
					-- ammo count (all four kinds)
				w_ammo [0] := create {ST_NUMBER}.make (ST_AMMO0X, ST_AMMO0Y, shortnum, (agent : INTEGER
					do
						check attached plyr as agent_p then
							Result := agent_p.ammo [0]
						end
					end), agent st_statusbaron, ST_AMMO0WIDTH, i_main)
				w_ammo [1] := create {ST_NUMBER}.make (ST_AMMO1X, ST_AMMO1Y, shortnum, (agent : INTEGER
					do
						check attached plyr as agent_p then
							Result := agent_p.ammo [1]
						end
					end), agent st_statusbaron, ST_AMMO1WIDTH, i_main)
				w_ammo [2] := create {ST_NUMBER}.make (ST_AMMO2X, ST_AMMO2Y, shortnum, (agent : INTEGER
					do
						check attached plyr as agent_p then
							Result := agent_p.ammo [2]
						end
					end), agent st_statusbaron, ST_AMMO2WIDTH, i_main)
				w_ammo [3] := create {ST_NUMBER}.make (ST_AMMO3X, ST_AMMO3Y, shortnum, (agent : INTEGER
					do
						check attached plyr as agent_p then
							Result := agent_p.ammo [3]
						end
					end), agent st_statusbaron, ST_AMMO3WIDTH, i_main)
					-- max ammo count (all four kinds)
				w_maxammo [0] := create {ST_NUMBER}.make (ST_MAXAMMO0X, ST_MAXAMMO0Y, shortnum, (agent : INTEGER
					do
						check attached plyr as agent_p then
							Result := agent_p.maxammo [0]
						end
					end), agent st_statusbaron, ST_MAXAMMO0WIDTH, i_main)
				w_maxammo [1] := create {ST_NUMBER}.make (ST_MAXAMMO1X, ST_MAXAMMO1Y, shortnum, (agent : INTEGER
					do
						check attached plyr as agent_p then
							Result := agent_p.maxammo [1]
						end
					end), agent st_statusbaron, ST_MAXAMMO1WIDTH, i_main)
				w_maxammo [2] := create {ST_NUMBER}.make (ST_MAXAMMO2X, ST_MAXAMMO2Y, shortnum, (agent : INTEGER
					do
						check attached plyr as agent_p then
							Result := agent_p.maxammo [2]
						end
					end), agent st_statusbaron, ST_MAXAMMO2WIDTH, i_main)
				w_maxammo [3] := create {ST_NUMBER}.make (ST_MAXAMMO3X, ST_MAXAMMO3Y, shortnum, (agent : INTEGER
					do
						check attached plyr as agent_p then
							Result := agent_p.maxammo [3]
						end
					end), agent st_statusbaron, ST_MAXAMMO3WIDTH, i_main)
			end
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
				i >= NUMWEAPONS
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
			st_clock := st_clock + 1
			st_randomnumber := i_main.m_random.m_random
			ST_updateWidgets
			check attached plyr as p then
				st_oldhealth := p.health
			end
		end

feature

	largeammo: INTEGER = 1994

	lastattackdown: INTEGER

	priority: INTEGER

	ST_UpdateFaceWidget
			-- This is a not-very-pretty routine which handles
			-- the face states and their timing.
			-- the precedence of expressions is this:
			-- dead > evil grin > turned head > straight head
		local
			i: INTEGER
			badguyangle: ANGLE_T
			diffang: ANGLE_T
			doevilgrin: BOOLEAN
		do
			check attached plyr as p then
				if priority < 10 then
						-- dead
					if p.health = 0 then
						priority := 9
						st_faceindex := ST_DEADFACE
						st_facecount := 1
					end
				end
				if priority < 9 then
					if p.bonuscount /= 0 then
							-- picking up bonus
						doevilgrin := False
						from
							i := 0
						until
							i >= {WEAPONTYPE_T}.NUMWEAPONS
						loop
							if oldweaponsowned [i] /= p.weaponowned [i] then
								doevilgrin := True
								oldweaponsowned [i] := p.weaponowned [i]
							end
							i := i + 1
						end
						if doevilgrin then
								-- evil grin if just picked up weapon
							priority := 8
							st_facecount := ST_EVILGRINCOUNT
							st_faceindex := ST_calcPainOffset + ST_EVILGRINOFFSET
						end
					end
				end
				if priority < 8 then
					if p.damagecount /= 0 and then attached p.attacker as attacker and then attacker /= p.mo then
							-- being attacked
						priority := 7
						if p.health - st_oldhealth > ST_MUCHPAIN then
							st_facecount := ST_TURNCOUNT
							st_faceindex := ST_calcPainOffset + ST_OUCHOFFSET
						else
							check attached p.mo as mo then
								badguyangle := i_main.r_main.r_pointtoangle2 (mo.x, mo.y, attacker.x, attacker.y)
								if badguyangle > mo.angle then
										-- whether right or left
									diffang := badguyangle - mo.angle
									i := (diffang > {R_MAIN}.ANG180).to_integer
								else
										-- whether left or right
									diffang := mo.angle - badguyangle
									i := (diffang <= {R_MAIN}.ANG180).to_integer
								end -- confusing, aint it?

								st_facecount := ST_TURNCOUNT
								st_faceindex := ST_calcPainOffset
								if diffang < {R_MAIN}.ANG45 then
										-- head on
									st_faceindex := st_faceindex + ST_RAMPAGEOFFSET
								elseif i /= 0 then
										-- turn face right
									st_faceindex := st_faceindex + ST_TURNOFFSET
								else
										-- turn face left

									st_faceindex := st_faceindex + ST_TURNOFFSET + 1
								end
							end
						end
					end
				end
				if priority < 7 then
						-- getting hurt because of your own stupidity
					if p.damagecount /= 0 then
						if p.health - st_oldhealth > ST_MUCHPAIN then
							priority := 7
							st_facecount := ST_TURNCOUNT
							st_faceindex := ST_calcPainOffset + ST_OUCHOFFSET
						else
							priority := 6
							st_facecount := ST_TURNCOUNT
							st_faceindex := ST_calcPainOffset + ST_RAMPAGEOFFSET
						end
					end
				end
				if priority < 6 then
						-- rapid firing
					if p.attackdown then
						if lastattackdown = -1 then
							lastattackdown := ST_RAMPAGEDELAY
						else
							lastattackdown := lastattackdown - 1
							if lastattackdown = 0 then
								priority := 5
								st_faceindex := ST_calcPainOffset + ST_RAMPAGEOFFSET
								st_facecount := 1
								lastattackdown := 1
							end
						end
					else
						lastattackdown := -1
					end
				end
				if priority < 5 then
						-- invulnerability
					if p.cheats & CF_GODMODE /= 0 or p.powers [pw_invulnerability] /= 0 then
						priority := 4
						st_faceindex := ST_GODFACE
						st_facecount := 1
					end
				end

					-- look left or look right if the facecount has timed out
				if st_facecount = 0 then
					st_faceindex := ST_calcPainOffset + (st_randomnumber \\ 3)
					st_facecount := ST_STRAIGHTFACECOUNT
					priority := 0
				end
				st_facecount := st_facecount - 1
			end
		end

feature

	lastcalc: INTEGER

	oldhealth: INTEGER

	ST_calcPainOffset: INTEGER
		local
			health: INTEGER
		do
			check attached plyr as p then
				health := if p.health > 100 then 100 else p.health end
				if health /= oldhealth then
					lastcalc := ST_FACESTRIDE * (((100 - health) * ST_NUMPAINFACES) // 101)
					oldhealth := health
				end
			end
			Result := lastcalc
		end

feature

	ST_UpdateWidgets
		local
			i: INTEGER
		do
				-- must redirect the pointer if the ready weapon has changed.
			check attached plyr as p then
				if {D_ITEMS}.weaponinfo [p.readyweapon].ammo = {AMMOTYPE_T}.am_noammo then
					check attached w_ready as wr then
						wr.num := agent largeammo
					end
				else
					check attached w_ready as wr then
						wr.num := (agent : INTEGER
							do
								check attached plyr as agent_p then
									Result := agent_p.ammo [{D_ITEMS}.weaponinfo [agent_p.readyweapon].ammo]
								end
							end)
					end
				end
				check attached w_ready as wr then
					wr.data := p.readyweapon
				end

					-- update keycard multiple widgets
				from
					i := 0
				until
					i >= 3
				loop
					keyboxes [i] := if p.cards [i] then i else -1 end
					if p.cards [i + 3] then
						keyboxes [i] := i + 3
					end
					i := i + 1
				end

					-- refresh everything if this is him coming back to life
				ST_updateFaceWidget

					-- used by w_armsbg widget
				st_notdeathmatch := not i_main.g_game.deathmatch

					-- used by w_arms[] widgets
				st_armson := st_statusbaron and not i_main.g_game.deathmatch

					-- used by w_frags widget
				st_fragson := i_main.g_game.deathmatch and st_statusbaron
				st_fragscount := 0
				from
					i := 0
				until
					i >= {DOOMDEF_H}.MAXPLAYERS
				loop
					if i /= i_main.g_game.consoleplayer then
						st_fragscount := st_fragscount + p.frags [i]
					else
						st_fragscount := st_fragscount - p.frags [i]
					end
					i := i + 1
				end

					-- get rid of chat window if up because of message
				st_msgcounter := st_msgcounter - 1
				if st_msgcounter = 0 then
					st_chat := st_oldchat
				end
			end
		end

end
