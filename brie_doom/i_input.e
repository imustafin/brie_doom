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
	I_INPUT

inherit

	DOOMKEYS_H

	SDL_SCANCODE_ENUM_API

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

feature

	I_HandleKeyboardEvent (sdlevent: SDL_EVENT_UNION_API)
		note
			source: "chocolate doom i_input.c"
		local
			event: EVENT_T
		do
				-- XXX: passing pointers to event for access after this function
				-- has terminated is undefined behaviour
			create event.make
			if sdlevent.type = {SDL_CONSTANT_API}.sdl_keydown then
				event.type := {EVENT_T}.ev_keydown
				event.data1 := TranslateKey (sdlevent.key.keysym)
				event.data2 := GetLocalizedKey (sdlevent.key.keysym)
				event.data3 := GetTypedChar (sdlevent.key.keysym)
				if event.data1 /= 0 then
					i_main.d_main.D_PostEvent (event)
				end
			elseif sdlevent.type = {SDL_CONSTANT_API}.sdl_keyup then
				event.type := {EVENT_T}.ev_keyup
				event.data1 := TranslateKey (sdlevent.key.keysym)

					-- data2/data3 are initialized to zero for ev_keyup.
					-- For ev_keydown it's the shifted Unicode character
					-- that was typed, but if something wants to detect
					-- key releases it should do so based on data1
					-- (key ID), not the printable char.

				event.data2 := 0
				event.data3 := 0
				if event.data1 /= 0 then
					i_main.d_main.D_PostEvent (event)
				end
			end
		end

	TranslateKey (key: SDL_KEYSYM_STRUCT_API): INTEGER
			-- Translates the SDL key to a value of the type found in doomkeys.h
		note
			c_doom: "xlatekey"
			source: "chocolate doom i_input.c"
		local
			sc: INTEGER
		do
			sc := key.scancode
			if sc = SDL_SCANCODE_LCTRL or sc = SDL_SCANCODE_RCTRL then
				Result := KEY_RCTRL
			elseif sc = SDL_SCANCODE_LSHIFT or sc = SDL_SCANCODE_RSHIFT then
				Result := KEY_RSHIFT
			elseif sc = SDL_SCANCODE_LALT then
				Result := KEY_LALT
			elseif sc = SDL_SCANCODE_RALT then
				Result := KEY_RALT
			else
				if sc > 0 and sc <= Scancode_to_keys_array.upper then
					Result := Scancode_to_keys_array [sc]
				else
					Result := 0
				end
			end
		ensure
			instance_free: class
		end

	GetLocalizedKey (key: SDL_KEYSYM_STRUCT_API): INTEGER
		do
			{NOT_IMPLEMENTED}.not_implemented ("GetLocalizedKey", false)
		end

	GetTypedChar (key: SDL_KEYSYM_STRUCT_API): INTEGER
		do
			{NOT_IMPLEMENTED}.not_implemented ("GetTypedChar", false)
		end

feature

	I_HandleMouseEvent (sdlevent: SDL_EVENT_UNION_API)
		do
			if sdlevent.type = {SDL_CONSTANT_API}.sdl_mousebuttondown then
				UpdateMouseButtonState (sdlevent.button.button.natural_32_code, True)
			elseif sdlevent.type = {SDL_CONSTANT_API}.sdl_mousebuttonup then
				UpdateMouseButtonState (sdlevent.button.button.natural_32_code, False)
			elseif sdlevent.type = {SDL_CONSTANT_API}.sdl_mousewheel then
				MapMouseWheelToButtons (sdlevent.wheel)
			end
		end

	Max_mouse_buttons: INTEGER = 8

	mouse_button_state: NATURAL

	UpdateMouseButtonState (a_button: NATURAL; on: BOOLEAN)
		note
			source: "chocolate doom"
		local
			event: EVENT_T
			button: NATURAL
		do
			button := a_button
			if button < {SDL_CONSTANT_API}.SDL_BUTTON_LEFT or button > Max_mouse_buttons.to_natural_32 then
					-- return
			else
					-- Note: button "0" is left, button "1" is right,
					-- button "2" is middle for Doom.  This is different
					-- to how SDL sees things.
				if button = {SDL_CONSTANT_API}.SDL_BUTTON_LEFT then
					button := 0
				elseif button = {SDL_CONSTANT_API}.SDL_BUTTON_RIGHT then
					button := 1
				elseif button = {SDL_CONSTANT_API}.SDL_BUTTON_MIDDLE then
					button := 2
				else
						-- SDL buttons are indexed from 1.
					button := button - 1
				end
					-- Turn bit representing this button on or off.
				if on then
					mouse_button_state := mouse_button_state | ({NATURAL} 1 |<< button.to_integer_32)
				else
					mouse_button_state := mouse_button_state & ({NATURAL} 1 |<< button.to_integer_32).bit_not
				end

					-- Post an event with the new button state.

				create event.make
				event.type := {EVENT_T}.ev_mouse
				event.data1 := mouse_button_state.as_integer_32
				event.data2 := 0
				event.data3 := 0
				i_main.d_main.d_postevent (event)
			end
		end

	MapMouseWheelToButtons (wheel: SDL_MOUSE_WHEEL_EVENT_STRUCT_API)
		note
			source: "chocolate doom"
		local
			up, down: EVENT_T
			button: INTEGER
		do
				-- SDL2 distinguishes button events from mouse wheel events.
				-- We want to treat the mouse wheel as two buttons, as per SDL1
			if wheel.y <= 0 then
					-- scroll down
				button := 4
			else
					-- scroll up
				button := 3
			end

				-- post a button down event
			create down.make
			mouse_button_state := mouse_button_state | ({NATURAL} 1 |<< button)
			down.type := {EVENT_T}.ev_mouse
			down.data1 := mouse_button_state.as_integer_32
			down.data2 := 0
			down.data3 := 0
			i_main.d_main.d_postevent (down)

				-- post a button up event
			create up.make
			mouse_button_state := mouse_button_state & ({NATURAL} 1 |<< button).bit_not
			up.type := {EVENT_T}.ev_mouse
			up.data1 := mouse_button_state.as_integer_32
			up.data2 := 0
			up.data3 := 0
			i_main.d_main.d_postevent (up)
		end

	I_ReadMouse
			-- Read the change in mouse state to generate mouse motion events
			--
			-- This is to combine all mouse movement for a tic into one mouse
			-- motion event.
		note
			source: "chocolate doom i_input.c"
		local
			x, y: INTEGER
			ev: EVENT_T
		do
			{SDL_MOUSE_FUNCTIONS_API}.SDL_Get_Relative_Mouse_State ($x, $y).do_nothing
			if x /= 0 and y /= 0 then
				create ev.make
				ev.type := {EVENT_T}.ev_mouse
				ev.data1 := mouse_button_state.as_integer_32
				ev.data2 := AccelerateMouse (x)
				if not novert.to_boolean then
					ev.data3 := - AccelerateMouse (y)
				else
					ev.data3 := 0
				end
				i_main.d_main.D_PostEvent (ev)
			end
		end

		-- Mouse acceleration
		--
		-- This emulates some of the behavior of DOS mouse drivers by increasing
		-- the speed when the mouse is moved fast.
		--
		-- The mouse input values are input directly to the game, but when
		-- the values exceed the value of mouse_threshold, they are multiplied
		-- by mouse_acceleration to increase the speed.

	mouse_acceleration: REAL assign set_mouse_acceleration

	set_mouse_acceleration (a_mouse_acceleration: like mouse_acceleration)
		do
			mouse_acceleration := a_mouse_acceleration
		end

	mouse_threshold: INTEGER = 10

		-- Disallow mouse and joystick movement to cause forward/backward
		-- motion.  Specified with the '-novert' command line parameter.
		-- This is an int to allow saving to config file

	novert: INTEGER assign set_novert

	set_novert (a_novert: like novert)
		do
			novert := a_novert
		end

	AccelerateMouse (val: INTEGER): INTEGER
		note
			source: "chocolate doom i_input.c"
		do
			if val < 0 then
				Result := - AccelerateMouse (- val)
			elseif val > mouse_threshold then
				Result := ((val - mouse_threshold) * mouse_acceleration + mouse_threshold).floor
			else
				Result := val
			end
		end

end
