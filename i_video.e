note
	description: "[
		i_video.c
		DOOM graphics stuff for SDL library
	]"

class
	I_VIDEO

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			firsttime := True
			multiply := 1
		end

feature

	multiply: INTEGER

	window: detachable SDL_WINDOW_STRUCT_API

	window_surface: detachable SDL_SURFACE_STRUCT_API

feature -- I_InitGraphics

	firsttime: BOOLEAN

	I_InitGraphics
		local
			video_w, w: INTEGER
			video_h, h: INTEGER
			video_bpp: INTEGER
			video_flags: INTEGER
		do
			if firsttime then
				firsttime := True
				video_flags := {SDL_CONSTANT_API}.sdl_swsurface.as_integer_32 -- originally was also adding SDL_HWPALETTE
					-- skip -fullscreen param
					-- skip -2 param
					-- skip -3 param
					-- skip -grabmouse
				w := {DOOMDEF_H}.SCREENWIDTH * multiply
				video_w := w
				h := {DOOMDEF_H}.SCREENHEIGHT * multiply
				video_h := h
				video_bpp := 8

					--  /* We need to allocate a software surface because the DOOM! code expects
					--     the screen surface to be valid all of the time.  Properly done, the
					--     rendering code would allocate the video surface in video memory and
					--     then call SDL_LockSurface()/SDL_UnlockSurface() around frame rendering.
					--     Eventually SDL will support flipping, which would be really nice in
					--     a complete-frame rendering application like this.
					--  */
				inspect video_w \\ w
				when 3 then
					multiply := multiply * 3
				when 2 then
					multiply := multiply * 2
				else
						-- Nothing
				end
				if multiply > 3 then
					{I_MAIN}.i_error ("Smallest available mode (" + video_w.out + "x" + video_h.out + ") is too large!")
				end
				window := {SDL_VIDEO}.sdl_create_window ("EIFFEL SDL DOOM!", {SDL_CONSTANT_API}.sdl_windowpos_undefined, {SDL_CONSTANT_API}.sdl_windowpos_undefined, video_w, video_h, video_flags)
				if attached window as attached_window then
					window_surface := (create {SDL_VIDEO}).sdl_get_window_surface (attached_window)
					if not attached window_surface then
						{I_MAIN}.i_error ("Could not take window surface: " + {SDL_ERROR}.sdl_get_error)
					end

						-- Set up the screen displays
						-- ......actually skip for now
				else
					{I_MAIN}.i_error ("Could not create window: " + {SDL_ERROR}.sdl_get_error)
				end
			end
		end

feature

	I_StartFrame
		do
				-- er?
		end

	I_StartTic
		local
			event: SDL_EVENT_UNION_API
		do
			from
				create event.make
			until
				{SDL_EVENTS}.sdl_poll_event (event) = 0
			loop
				I_GetEvent (event)
			end
		end

	I_GetEvent (a_event: SDL_EVENT_UNION_API)
		local
			event: EVENT_T
		do
			create event.make
			if a_event.type = {SDL_CONSTANT_API}.sdl_keydown then
				event.type := {EVENT_T}.ev_keydown
				event.data1 := xlatekey (a_event.key.keysym)
				i_main.d_doom_main.D_PostEvent (event)
			elseif a_event.type = {SDL_CONSTANT_API}.sdl_keyup then
				event.type := {EVENT_T}.ev_keyup
				event.data1 := xlatekey (a_event.key.keysym)
				i_main.d_doom_main.D_PostEvent (event)
			elseif a_event.type = {SDL_CONSTANT_API}.sdl_quit then
				i_main.i_system.I_Quit
			else
					-- ignore SDL_MOUSEBUTTONDOWN
					-- ignore SDL_MOUSEBUTTONUP
					-- ignore SDL_MOUSEMOTION
			end
		end

	xlatekey (key: SDL_KEYSYM_STRUCT_API): INTEGER
		do
			if key.sym = {SDL_KEYCODE}.sdlk_left then
				Result := {DOOMDEF_H}.key_leftarrow
			elseif key.sym = {SDL_KEYCODE}.sdlk_right then
				Result := {DOOMDEF_H}.key_rightarrow
			elseif key.sym = {SDL_KEYCODE}.sdlk_up then
				Result := {DOOMDEF_H}.key_uparrow
			elseif key.sym = {SDL_KEYCODE}.sdlk_down then
				Result := {DOOMDEF_H}.key_downarrow
			else
				Result := key.sym
			end
		end

feature

	I_ReadScreen (scr: ARRAY [INTEGER_8])
		local
			i: INTEGER
		do
			from
				i := 0
			until
				i >= {DOOMDEF_H}.SCREENWIDTH * {DOOMDEF_H}.SCREENHEIGHT
			loop
				scr [i] := i_main.v_video.screens [0] [i]
				i := i + 1
			end
		end

feature

	I_UpdateNoBlit
		do
				-- what is this?
		end

	I_FinishUpdate
		do
				-- Stub
		end

feature

	I_SetPalette (palette: ANY) -- originally took void* palette
		do
				-- Stub
		end

end
