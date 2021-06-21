note
	description: "[
		st_stuff.c
		Status bar code.
		Does the face/direction indicator animation.
		Does palette indicators as well (red pain/berserk, bright pickup)
	]"

class
	ST_STUFF

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
		ensure
			arms.lower = 0 and arms.count = 6 and across arms as a all a.item.lower = 0 and a.item.count = 2 end
			faces.lower = 0 and faces.count = ST_NUMFACES
			keys.lower = 0 and keys.count = {DOOMDEF_H}.NUMCARDS
			shortnum.lower = 0 and shortnum.count = 10
			tallnum.lower = 0 and tallnum.count = 10
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
				-- Stub
		end

feature

	ST_Responder (ev: EVENT_T): BOOLEAN
		do
				-- Stub
		end

feature

	ST_Start
		do
				-- Stub
		end

feature

	ST_Ticker
		do
				-- Stub
		end

end
