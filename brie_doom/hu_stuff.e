note
	description: "[
		hu_stuff.c
		Heads-up displays
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
	HU_STUFF

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			create w_message.make
			create w_chat.make
			create w_title.make
		end

feature

	player_names: ARRAY [STRING]
		once
			create Result.make_filled ("", 0, 4)
			Result [0] := {D_ENGLSH}.HUSTR_PLRGREEN
			Result [1] := {D_ENGLSH}.HUSTR_PLRINDIGO
			Result [2] := {D_ENGLSH}.HUSTR_PLRBROWN
			Result [3] := {D_ENGLSH}.HUSTR_PLRRED
		ensure
			Result.lower = 0
			instance_free: class
		end

feature

	HU_Init
		do
			{NOT_IMPLEMENTED}.not_implemented ("HU_Init", False)
		end

feature

	w_message: HU_STEXT_T

	w_chat: HU_ITEXT_T

	w_title: HU_TEXTLINE_T

feature

	QUEUESIZE: INTEGER = 128

	chatchars: ARRAY [CHARACTER]
		once
			create Result.make_filled ((0).to_character_8, 0, QUEUESIZE - 1)
		end

	head: INTEGER

	tail: INTEGER

	HU_dequeueChatChar: CHARACTER
		do
			if head /= tail then
				Result := chatchars [tail]
				tail := (tail + 1) & (QUEUESIZE - 1)
			else
				Result := (0).to_character_8
			end
		end

feature

	HU_Drawer
		do
			{NOT_IMPLEMENTED}.not_implemented ("HU_Drawer", False)
		end

	HU_Erase
		do
			i_main.hu_lib.HUlib_eraseSText (w_message)
			i_main.hu_lib.HUlib_eraseIText (w_chat)
			i_main.hu_lib.HUlib_eraseTextLine (w_title)
		end

feature

	HU_Responder (ev: EVENT_T): BOOLEAN
		do
			{NOT_IMPLEMENTED}.not_implemented ("HU_Responder", False)
		end

feature

	HU_Start
		do
			{NOT_IMPLEMENTED}.not_implemented ("HU_Start", False)
		end

feature

	HU_Ticker
		do
			{NOT_IMPLEMENTED}.not_implemented ("HU_Ticker", False)
		end

end
