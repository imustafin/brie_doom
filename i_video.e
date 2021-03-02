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

	screenbuffer: detachable SDL_SURFACE_STRUCT_API

	argbbuffer: detachable SDL_SURFACE_STRUCT_API

	pixel_format: NATURAL_32

feature

	blit_rect: SDL_RECT_STRUCT_API
		once
			create Result.make
			Result.set_x (0)
			Result.set_y (0)
			Result.set_w ({DOOMDEF_H}.SCREENWIDTH)
			Result.set_h ({DOOMDEF_H}.SCREENHEIGHT)
		end

feature

	palette: ARRAY [SDL_COLOR_STRUCT_API]
		local
			i: INTEGER
		once
			create Result.make_filled (create {SDL_COLOR_STRUCT_API}.make, 0, 255)
			from
				i := Result.lower
			until
				i > Result.upper
			loop
				Result [i] := create {SDL_COLOR_STRUCT_API}.make
				i := i + 1
			end
		end

	palette_to_set: BOOLEAN

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
					pixel_format := {SDL_VIDEO}.sdl_get_window_pixel_format (attached_window)
					renderer := {SDL_RENDER_FUNCTIONS_API}.SDL_Create_Renderer (attached_window, -1, 0)
					if not attached renderer then
						{I_MAIN}.i_error ("Could not create renderer: " + {SDL_ERROR}.sdl_get_error)
					end
					if attached renderer as attached_renderer then
						texture := {SDL_RENDER_FUNCTIONS_API}.sdl_create_texture (attached_renderer, pixel_format, {SDL_TEXTURE_ACCESS_ENUM_API}.SDL_TEXTUREACCESS_STREAMING, {DOOMDEF_H}.SCREENWIDTH, {DOOMDEF_H}.SCREENHEIGHT)
					end

						-- Set up the screen displays
						-- ......actually skip for now
				else
					{I_MAIN}.i_error ("Could not create window: " + {SDL_ERROR}.sdl_get_error)
				end
				set_video_mode
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

feature

	set_video_mode
			-- from https://github.com/chocolate-doom/chocolate-doom/blob/7a0db31614ec187e363e7664036d95ec56242e44/src/i_video.c#L1149
		local
			bpp: INTEGER
			rmask: NATURAL_32
			gmask: NATURAL_32
			bmask: NATURAL_32
			amask: NATURAL_32
		do
			if attached screenbuffer as sb then
				{SDL_SURFACE_FUNCTIONS_API}.sdl_free_surface (sb)
				screenbuffer := Void
			end
			if screenbuffer = Void then
				create screenbuffer.make_by_pointer ({SDL_SURFACE_FUNCTIONS_API}.sdl_create_rgbsurface (0, {DOOMDEF_H}.SCREENWIDTH, {DOOMDEF_H}.SCREENHEIGHT, 8, 0, 0, 0, 0))
				check attached screenbuffer as sb then
					if {SDL_SURFACE}.sdl_fill_rect (sb, Void, 0) < 0 then
						i_main.i_error ("Error SDL_FillRect" + {SDL_ERROR}.sdl_get_error)
					end
				end
			end
				-- Format of argbbuffer must match the screen pixel format because we
				-- import the surface data into the texture.
			if attached argbbuffer as abb then
				{SDL_SURFACE_FUNCTIONS_API}.sdl_free_surface (abb)
				argbbuffer := Void
			end
			if argbbuffer = Void then
				if {SDL_PIXELS_FUNCTIONS_API}.SDL_Pixel_Format_Enum_To_Masks (pixel_format, $bpp, $rmask, $gmask, $bmask, $amask) /= {SDL_CONSTANT_API}.SDL_True then
					i_main.i_error ("pixel format to masks " + {SDL_ERROR}.sdl_get_error)
				end
				create argbbuffer.make_by_pointer ({SDL_SURFACE_FUNCTIONS_API}.sdl_create_rgbsurface (0, {DOOMDEF_H}.SCREENWIDTH, {DOOMDEF_H}.SCREENHEIGHT, bpp, rmask, gmask, bmask, amask))
				check attached argbbuffer as abb then
					if {SDL_SURFACE}.sdl_fill_rect (abb, Void, 0) < 0 then
						i_main.i_error ("Error SDL_FillRect" + {SDL_ERROR}.sdl_get_error)
					end
				end
			end
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
			void_t: SDL_TEXTURE_STRUCT_API
		do
				-- skip devparm
			check attached screenbuffer as sb then
				if palette_to_set then
					check attached sb.format as f and then attached f.palette as p then
						if {SDL_PIXELS_FUNCTIONS_API}.sdl_set_palette_colors (p, palette [palette.lower], 0, 256) < 0 then
							i_main.i_error ("Error setting palette colors " + {SDL_ERROR}.sdl_get_error)
						end
						palette_to_set := False
					end

						-- skip VGA porch flash
				end
			end
			check attached screenbuffer as sb and then attached argbbuffer as abb and then attached texture as t then
				check attached renderer as r then

						-- copy screen[0] to sb
						create mp.share_from_pointer(sb.pixels, i_main.v_video.screens[0].count)
						from
							i := 0
						until
							i > i_main.v_video.screens[0].upper
						loop
							mp.put_natural_8(i_main.v_video.screens[0][i], i)
							i := i + 1
						end

						-- Blit from the paletted 8-bit screen buffer to the intermediate
						-- 32-bit RGBA buffer that we can load into the texture.
					if {SDL_SURFACE_FUNCTIONS_API}.SDL_Lower_Blit (sb, blit_rect, abb, blit_rect) < 0 then
						i_main.i_error ("From 8bit blit error " + {SDL_ERROR}.sdl_get_error)
					end

						-- Update the intermediate texture with the contents of the RGBA buffer.

					if {SDL_RENDER}.SDL_Update_Texture (t, Void, abb.pixels, abb.pitch) < 0 then
						i_main.i_error ("Upd intermediate with RGBA buffer " + {SDL_ERROR}.sdl_get_error)
					end
						-- Make sure the pillarboxes are kept clear each frame.

					if {SDL_RENDER_FUNCTIONS_API}.SDL_Render_Clear (r) < 0 then
						i_main.i_error ("render clear " + {SDL_ERROR}.sdl_get_error)
					end

						-- Render this intermediate texture into the upscaled texture
						-- using "nearest" integer scaling.

						--					{SDL_RENDER_FUNCTIONS_API}.SDL_Set_Render_Target (r, texture_upscaled)
						--					{SDL_RENDER_FUNCTIONS_API}.SDL_Render_Copy (r, t, NULL, NULL)

						-- Finally, render this upscaled texture to screen using linear scaling.

					if {SDL_RENDER}.SDL_Set_Render_Target (r, Void) < 0 then
						i_main.i_error ("render target " + {SDL_ERROR}.sdl_get_error)
					end
					if {SDL_RENDER}.SDL_Render_Copy (r, t, Void, Void) < 0 then
						i_main.i_error ("render copy " + {SDL_ERROR}.sdl_get_error)
					end

						-- Draw!

					{SDL_RENDER_FUNCTIONS_API}.SDL_Render_Present (r)
				end
			end
		end

feature

	I_SetPalette (doompalette: MANAGED_POINTER) -- originally took void* palette
			-- from https://github.com/chocolate-doom/chocolate-doom/blob/7a0db31614ec187e363e7664036d95ec56242e44/src/i_video.c#L822
		local
			i: INTEGER
			d: INTEGER
			not_3: NATURAL_8
		do
			not_3 := (3).to_natural_8.bit_not
			from
				i := 0
				d := 0
			until
				i >= 256
			loop
				palette [i].set_r ((i_main.v_video.gammatable [i_main.v_video.usegamma] [doompalette.read_natural_8_le (d).to_integer_32 + 1] & not_3).to_character_8)
				d := d + 1
				palette [i].set_g ((i_main.v_video.gammatable [i_main.v_video.usegamma] [doompalette.read_natural_8_le (d).to_integer_32 + 1] & not_3).to_character_8)
				d := d + 1
				palette [i].set_b ((i_main.v_video.gammatable [i_main.v_video.usegamma] [doompalette.read_natural_8_le (d).to_integer_32 + 1] & not_3).to_character_8)
				d := d + 1
				i := i + 1
			end
			palette_to_set := True
		end

end
