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

	renderer: detachable SDL_RENDERER_STRUCT_API

	texture: detachable SDL_TEXTURE_STRUCT_API

feature -- I_InitGraphics

	firsttime: BOOLEAN

	I_InitGraphics
		local
			video_w, w: INTEGER
			video_h, h: INTEGER
			video_bpp: INTEGER
			video_flags: NATURAL
		do
			if firsttime then
				firsttime := True
				video_flags := {SDL_CONSTANT_API}.sdl_swsurface.to_natural_32 -- originally was also adding SDL_HWPALETTE
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
					renderer := {SDL_RENDER_FUNCTIONS_API}.SDL_Create_Renderer (attached_window, -1, 0)
					if not attached renderer then
						{I_MAIN}.i_error ("Could not create renderer: " + {SDL_ERROR}.sdl_get_error)
					end
					if attached renderer as attached_renderer then
						texture := {SDL_RENDER_FUNCTIONS_API}.sdl_create_texture (attached_renderer, {SDL_PIXEL_FORMAT_ENUM_ENUM_API}.SDL_PIXELFORMAT_ARGB8888.to_natural_32, {SDL_TEXTURE_ACCESS_ENUM_API}.SDL_TEXTUREACCESS_STREAMING, w, h)
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

	I_ReadScreen (scr: ARRAY [NATURAL_8])
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

feature -- I_FinishUpdate

	lasttic: INTEGER

	I_FinishUpdate
		local
			tics: INTEGER
			i: INTEGER
			olineptr: POINTER
			ilineptr: POINTER
			y: INTEGER
			mp: MANAGED_POINTER
		do
				-- skip devparm

			create mp.make (i_main.v_video.screens[0].count)
			from
				i := i_main.v_video.screens [0].lower
			until
				i > i_main.v_video.screens [0].upper
			loop
				mp.put_natural_8 (i_main.v_video.screens [0] [i], i)
				i := i + 1
			end
			check attached texture as attached_texture then
				if {SDL_RENDER}.sdl_update_texture (attached_texture, create {SDL_RECT_STRUCT_API}.make, mp.item, {DOOMDEF_H}.SCREENWIDTH) < 0 then
					i_main.i_error ("Error updating texture " + {SDL_ERROR}.sdl_get_error)
				end
				check attached renderer as attached_renderer then
					if {SDL_RENDER}.sdl_render_clear (attached_renderer) < 0 then
						i_main.i_error ("Error in SDL_RenderClear " + {SDL_ERROR}.sdl_get_error)
					end
					if {SDL_RENDER}.sdl_render_copy (attached_renderer, attached_texture, Void, Void) < 0 then
						i_main.i_error ("Error in SDL_RenderCopy " + {SDL_ERROR}.sdl_get_error)
					end
					{SDL_RENDER}.sdl_render_present (attached_renderer)
				end
			end
		end

feature

	I_SetPalette (palette: ANY) -- originally took void* palette
		do
				-- Stub
		end

end
