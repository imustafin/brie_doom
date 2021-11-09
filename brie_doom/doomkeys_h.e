note
	description: "[
		chocolate doom doomkeys.h
		
		Key definitions
	]"
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
	DOOMKEYS_H

feature -- DOOM keyboard definition

	KEY_RIGHTARROW: INTEGER = 0xae

	KEY_LEFTARROW: INTEGER = 0xac

	KEY_UPARROW: INTEGER = 0xad

	KEY_DOWNARROW: INTEGER = 0xaf

	KEY_RCTRL: INTEGER
		once
			Result := 0x80 + 0x1d
		ensure
			instance_free: class
		end

	KEY_RALT: INTEGER
		once
			Result := 0x80 + 0x38
		ensure
			instance_free: class
		end

	KEY_LALT: INTEGER
		once
			Result := KEY_RALT
		ensure
			instance_free: class
		end

	KEY_RSHIFT: INTEGER
		once
			Result := 0x80 + 0x36
		ensure
			instance_free: class
		end

	KEY_PAUSE: INTEGER = 0xff

	KEY_ENTER: INTEGER = 13

	KEY_ESCAPE: INTEGER = 27

	KEY_BACKSPACE: INTEGER = 127

	KEY_TAB: INTEGER = 9

	KEY_MINUS: INTEGER = 0x2d

	KEY_EQUALS: INTEGER = 0x3d

	KEY_CAPSLOCK: INTEGER
		once
			Result := 0x80 + 0x3a
		ensure
			instance_free: class
		end

	KEY_F1: INTEGER
		once
			Result := 0x80 + 0x3b
		ensure
			instance_free: class
		end

	KEY_F2: INTEGER
		once
			Result := 0x80 + 0x3c
		ensure
			instance_free: class
		end

	KEY_F3: INTEGER
		once
			Result := 0x80 + 0x3d
		ensure
			instance_free: class
		end

	KEY_F4: INTEGER
		once
			Result := 0x80 + 0x3e
		ensure
			instance_free: class
		end

	KEY_F5: INTEGER
		once
			Result := 0x80 + 0x3f
		ensure
			instance_free: class
		end

	KEY_F6: INTEGER
		once
			Result := 0x80 + 0x40
		ensure
			instance_free: class
		end

	KEY_F7: INTEGER
		once
			Result := 0x80 + 0x41
		ensure
			instance_free: class
		end

	KEY_F8: INTEGER
		once
			Result := 0x80 + 0x42
		ensure
			instance_free: class
		end

	KEY_F9: INTEGER
		once
			Result := 0x80 + 0x43
		ensure
			instance_free: class
		end

	KEY_F10: INTEGER
		once
			Result := 0x80 + 0x44
		ensure
			instance_free: class
		end

	KEY_F11: INTEGER
		once
			Result := 0x80 + 0x57
		ensure
			instance_free: class
		end

	KEY_F12: INTEGER
		once
			Result := 0x80 + 0x58
		ensure
			instance_free: class
		end

	KEY_NUMLOCK: INTEGER
		once
			Result := (0x80 + 0x45)
		ensure
			instance_free: class
		end

	KEY_SCRLCK: INTEGER
		once
			Result := (0x80 + 0x46)
		ensure
			instance_free: class
		end

	KEY_PRTSCR: INTEGER
		once
			Result := (0x80 + 0x59)
		ensure
			instance_free: class
		end

	KEY_HOME: INTEGER
		once
			Result := (0x80 + 0x47)
		ensure
			instance_free: class
		end

	KEY_END: INTEGER
		once
			Result := (0x80 + 0x4f)
		ensure
			instance_free: class
		end

	KEY_PGUP: INTEGER
		once
			Result := (0x80 + 0x49)
		ensure
			instance_free: class
		end

	KEY_PGDN: INTEGER
		once
			Result := (0x80 + 0x51)
		ensure
			instance_free: class
		end

	KEY_INS: INTEGER
		once
			Result := (0x80 + 0x52)
		ensure
			instance_free: class
		end

	KEY_DEL: INTEGER
		once
			Result := (0x80 + 0x53)
		ensure
			instance_free: class
		end

	KEYP_0: INTEGER
		once
			Result := KEY_INS
		ensure
			instance_free: class
		end

	KEYP_1: INTEGER
		once
			Result := KEY_END
		ensure
			instance_free: class
		end

	KEYP_2: INTEGER
		once
			Result := KEY_DOWNARROW
		ensure
			instance_free: class
		end

	KEYP_3: INTEGER
		once
			Result := KEY_PGDN
		ensure
			instance_free: class
		end

	KEYP_4: INTEGER
		once
			Result := KEY_LEFTARROW
		ensure
			instance_free: class
		end

	KEYP_5: INTEGER
		once
			Result := (0x80 + 0x4c)
		ensure
			instance_free: class
		end

	KEYP_6: INTEGER
		once
			Result := KEY_RIGHTARROW
		ensure
			instance_free: class
		end

	KEYP_7: INTEGER
		once
			Result := KEY_HOME
		ensure
			instance_free: class
		end

	KEYP_8: INTEGER
		once
			Result := KEY_UPARROW
		ensure
			instance_free: class
		end

	KEYP_9: INTEGER
		once
			Result := KEY_PGUP
		ensure
			instance_free: class
		end

	KEYP_DIVIDE: INTEGER
		once
			Result := ('/').code
		ensure
			instance_free: class
		end

	KEYP_PLUS: INTEGER
		once
			Result := ('+').code
		ensure
			instance_free: class
		end

	KEYP_MINUS: INTEGER
		once
			Result := ('-').code
		ensure
			instance_free: class
		end

	KEYP_MULTIPLY: INTEGER
		once
			Result := ('*').code
		ensure
			instance_free: class
		end

	KEYP_PERIOD: INTEGER
		once
			Result := 0
		ensure
			instance_free: class
		end

	KEYP_EQUALS: INTEGER
		once
			Result := KEY_EQUALS
		ensure
			instance_free: class
		end

	KEYP_ENTER: INTEGER
		once
			Result := KEY_ENTER
		ensure
			instance_free: class
		end

feature

	Scancode_to_keys_array: ARRAY [INTEGER]
		once
			Result := {ARRAY [INTEGER]} << --
				-- 1-4
				0, 0, 0, ('a').code,
				-- 5-9
 ('b').code, ('c').code, ('d').code, ('e').code, ('f').code,
				-- 10-14
 ('g').code, ('h').code, ('i').code, ('j').code, ('k').code,
				-- 14-19
 ('l').code, ('m').code, ('n').code, ('o').code, ('p').code,
				-- 20-24
 ('q').code, ('r').code, ('s').code, ('t').code, ('u').code,
				-- 25-29
 ('v').code, ('w').code, ('x').code, ('y').code, ('z').code,
				-- 30-34
 ('1').code, ('2').code, ('3').code, ('4').code, ('5').code,
				-- 35-39
 ('6').code, ('7').code, ('8').code, ('9').code, ('0').code,
				-- 40-44
 KEY_ENTER, KEY_ESCAPE, KEY_BACKSPACE, KEY_TAB, (' ').code,
				-- 45-49
 KEY_MINUS, KEY_EQUALS, ('[').code, (']').code, ('%H').code,
				-- 50-54
 0, (';').code, ('%'').code, ('`').code, (',').code,
				-- 55-59
 ('.').code, ('/').code, KEY_CAPSLOCK, KEY_F1, KEY_F2,
				-- 60-64
 KEY_F3, KEY_F4, KEY_F5, KEY_F6, KEY_F7,
				-- 65-69
 KEY_F8, KEY_F9, KEY_F10, KEY_F11, KEY_F12,
				-- 70-74
 KEY_PRTSCR, KEY_SCRLCK, KEY_PAUSE, KEY_INS, KEY_HOME,
				-- 74-79
 KEY_PGUP, KEY_DEL, KEY_END, KEY_PGDN, KEY_RIGHTARROW,
				-- 80-82
 KEY_LEFTARROW, KEY_DOWNARROW, KEY_UPARROW,
				-- 83-84
 KEY_NUMLOCK, KEYP_DIVIDE,
				-- 85-89
 KEYP_MULTIPLY, KEYP_MINUS, KEYP_PLUS, KEYP_ENTER, KEYP_1,
				-- 90-94
 KEYP_2, KEYP_3, KEYP_4, KEYP_5, KEYP_6,
				-- 95-99
 KEYP_7, KEYP_8, KEYP_9, KEYP_0, KEYP_PERIOD,
				-- 100-103
 0, 0, 0, KEYP_EQUALS>>
		ensure
			instance_free: class
		end

end
