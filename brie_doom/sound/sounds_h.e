note
	description: "sounds.h"
	license: "[
		Copyright (C) 1993-1996 by id Software, Inc.
		Copyright (C) 2005-2014 Simon Howard
		Copyright (C) 2021 Ilgiz Mustafin

		This program is free software; you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation; either version 2 of the License, or
		(at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License along
		with this program; if not, write to the Free Software Foundation, Inc.,
		51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
	]"

class
	SOUNDS_H

inherit

	SFXENUM_T

feature -- musicenum_t

	mus_None: INTEGER = 0

	mus_e1m1: INTEGER = 1

	mus_e1m2: INTEGER = 2

	mus_e1m3: INTEGER = 3

	mus_e1m4: INTEGER = 4

	mus_e1m5: INTEGER = 5

	mus_e1m6: INTEGER = 6

	mus_e1m7: INTEGER = 7

	mus_e1m8: INTEGER = 8

	mus_e1m9: INTEGER = 9

	mus_e2m1: INTEGER = 10

	mus_e2m2: INTEGER = 11

	mus_e2m3: INTEGER = 12

	mus_e2m4: INTEGER = 13

	mus_e2m5: INTEGER = 14

	mus_e2m6: INTEGER = 15

	mus_e2m7: INTEGER = 16

	mus_e2m8: INTEGER = 17

	mus_e2m9: INTEGER = 18

	mus_e3m1: INTEGER = 19

	mus_e3m2: INTEGER = 20

	mus_e3m3: INTEGER = 21

	mus_e3m4: INTEGER = 22

	mus_e3m5: INTEGER = 23

	mus_e3m6: INTEGER = 24

	mus_e3m7: INTEGER = 25

	mus_e3m8: INTEGER = 26

	mus_e3m9: INTEGER = 27

	mus_inter: INTEGER = 28

	mus_intro: INTEGER = 29

	mus_bunny: INTEGER = 30

	mus_victor: INTEGER = 31

	mus_introa: INTEGER = 32

	mus_runnin: INTEGER = 33

	mus_stalks: INTEGER = 34

	mus_countd: INTEGER = 35

	mus_betwee: INTEGER = 36

	mus_doom: INTEGER = 37

	mus_the_da: INTEGER = 38

	mus_shawn: INTEGER = 39

	mus_ddtblu: INTEGER = 40

	mus_in_cit: INTEGER = 41

	mus_dead: INTEGER = 42

	mus_stlks2: INTEGER = 43

	mus_theda2: INTEGER = 44

	mus_doom2: INTEGER = 45

	mus_ddtbl2: INTEGER = 46

	mus_runni2: INTEGER = 47

	mus_dead2: INTEGER = 48

	mus_stlks3: INTEGER = 49

	mus_romero: INTEGER = 50

	mus_shawn2: INTEGER = 51

	mus_messag: INTEGER = 52

	mus_count2: INTEGER = 53

	mus_ddtbl3: INTEGER = 54

	mus_ampie: INTEGER = 55

	mus_theda3: INTEGER = 56

	mus_adrian: INTEGER = 57

	mus_messg2: INTEGER = 58

	mus_romer2: INTEGER = 59

	mus_tense: INTEGER = 60

	mus_shawn3: INTEGER = 61

	mus_openin: INTEGER = 62

	mus_evil: INTEGER = 63

	mus_ultima: INTEGER = 64

	mus_read_m: INTEGER = 65

	mus_dm2ttl: INTEGER = 66

	mus_dm2int: INTEGER = 67

	NUMMUSIC: INTEGER = 68

feature -- S_sfx

	S_sfx: ARRAYED_LIST [SFXINFO_T]
		once
			create Result.make (0)
				-- skip dummy value at [0]

			Result.extend (create {SFXINFO_T}.make ("pistol", False, 64, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("shotgun", False, 64, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("sgcock", False, 64, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("dshtgn", False, 64, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("dbopn", False, 64, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("dbcls", False, 64, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("dbload", False, 64, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("plasma", False, 64, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("bfg", False, 64, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("sawup", False, 64, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("sawidl", False, 118, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("sawful", False, 64, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("sawhit", False, 64, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("rlaunc", False, 64, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("rxplod", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("firsht", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("firxpl", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("pstart", False, 100, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("pstop", False, 100, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("doropn", False, 100, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("dorcls", False, 100, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("stnmov", False, 119, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("swtchn", False, 78, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("swtchx", False, 78, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("plpain", False, 96, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("dmpain", False, 96, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("popain", False, 96, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("vipain", False, 96, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("mnpain", False, 96, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("pepain", False, 96, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("slop", False, 78, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("itemup", True, 78, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("wpnup", True, 78, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("oof", False, 96, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("telept", False, 32, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("posit1", True, 98, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("posit2", True, 98, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("posit3", True, 98, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("bgsit1", True, 98, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("bgsit2", True, 98, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("sgtsit", True, 98, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("cacsit", True, 98, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("brssit", True, 94, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("cybsit", True, 92, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("spisit", True, 90, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("bspsit", True, 90, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("kntsit", True, 90, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("vilsit", True, 90, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("mansit", True, 90, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("pesit", True, 90, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("sklatk", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("sgtatck", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("skepch", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("vilatk", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("claw", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("skeswg", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("pldeth", False, 32, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("pdiehi", False, 32, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("podth1", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("podth2", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("podth3", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("bgdth1", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("bgdth2", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("sgtdth", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("cacdth", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("skldth", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("brsdth", False, 32, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("cybdth", False, 32, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("spidth", False, 32, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("bspdth", False, 32, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("vildth", False, 32, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("kntdth", False, 32, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("pedth", False, 32, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("skedth", False, 32, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("posact", True, 120, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("bgact", True, 120, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("dmact", True, 120, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("bspact", True, 100, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("bspwlk", True, 100, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("vilact", True, 100, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("noway", False, 78, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("barexp", False, 60, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("punch", False, 64, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("hoof", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("metal", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("chgun", False, 64, Result [sfx_pistol], 150)) -- originally set usefulness 0
			Result.extend (create {SFXINFO_T}.make ("tink", False, 60, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("bdopn", False, 100, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("bdcls", False, 100, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("itmbk", False, 100, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("flame", False, 32, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("flamst", False, 32, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("getpow", False, 60, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("bospit", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("boscub", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("bossit", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("bospn", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("bosdth", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("manatk", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("mandth", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("sssit", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("ssdth", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("keenpn", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("keendt", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("skeact", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("skesit", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("skeatk", False, 70, Void, -1))
			Result.extend (create {SFXINFO_T}.make ("radio", False, 60, Void, -1))
		ensure
			instance_free: class
		end

feature

	music (name: STRING): MUSICINFO_T
		do
			create Result.make (name, 0, Void, Void)
		ensure
			instance_free: class
		end

	S_music: ARRAYED_LIST [MUSICINFO_T]
		once
			create Result.make (0)

				-- skip NULL [0] element

			Result.extend (music ("e1m1"))
			Result.extend (music ("e1m2"))
			Result.extend (music ("e1m3"))
			Result.extend (music ("e1m4"))
			Result.extend (music ("e1m5"))
			Result.extend (music ("e1m6"))
			Result.extend (music ("e1m7"))
			Result.extend (music ("e1m8"))
			Result.extend (music ("e1m9"))
			Result.extend (music ("e2m1"))
			Result.extend (music ("e2m2"))
			Result.extend (music ("e2m3"))
			Result.extend (music ("e2m4"))
			Result.extend (music ("e2m5"))
			Result.extend (music ("e2m6"))
			Result.extend (music ("e2m7"))
			Result.extend (music ("e2m8"))
			Result.extend (music ("e2m9"))
			Result.extend (music ("e3m1"))
			Result.extend (music ("e3m2"))
			Result.extend (music ("e3m3"))
			Result.extend (music ("e3m4"))
			Result.extend (music ("e3m5"))
			Result.extend (music ("e3m6"))
			Result.extend (music ("e3m7"))
			Result.extend (music ("e3m8"))
			Result.extend (music ("e3m9"))
			Result.extend (music ("inter"))
			Result.extend (music ("intro"))
			Result.extend (music ("bunny"))
			Result.extend (music ("victor"))
			Result.extend (music ("introa"))
			Result.extend (music ("runnin"))
			Result.extend (music ("stalks"))
			Result.extend (music ("countd"))
			Result.extend (music ("betwee"))
			Result.extend (music ("doom"))
			Result.extend (music ("the_da"))
			Result.extend (music ("shawn"))
			Result.extend (music ("ddtblu"))
			Result.extend (music ("in_cit"))
			Result.extend (music ("dead"))
			Result.extend (music ("stlks2"))
			Result.extend (music ("theda2"))
			Result.extend (music ("doom2"))
			Result.extend (music ("ddtbl2"))
			Result.extend (music ("runni2"))
			Result.extend (music ("dead2"))
			Result.extend (music ("stlks3"))
			Result.extend (music ("romero"))
			Result.extend (music ("shawn2"))
			Result.extend (music ("messag"))
			Result.extend (music ("count2"))
			Result.extend (music ("ddtbl3"))
			Result.extend (music ("ampie"))
			Result.extend (music ("theda3"))
			Result.extend (music ("adrian"))
			Result.extend (music ("messg2"))
			Result.extend (music ("romer2"))
			Result.extend (music ("tense"))
			Result.extend (music ("shawn3"))
			Result.extend (music ("openin"))
			Result.extend (music ("evil"))
			Result.extend (music ("ultima"))
			Result.extend (music ("read_m"))
			Result.extend (music ("dm2ttl"))
			Result.extend (music ("dm2int"))
		ensure
			instance_free: class
		end

end
