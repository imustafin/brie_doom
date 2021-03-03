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
			aspect_ratio_correct := True
		end

feature

	multiply: INTEGER

	window: detachable SDL_WINDOW_STRUCT_API

	renderer: detachable SDL_RENDERER_STRUCT_API

	texture: detachable SDL_TEXTURE_STRUCT_API

	texture_upscaled: detachable SDL_TEXTURE_STRUCT_API

	screenbuffer: detachable SDL_SURFACE_STRUCT_API

	argbbuffer: detachable SDL_SURFACE_STRUCT_API

	pixel_format: NATURAL_32

feature -- Aspect ratio correction mode

	aspect_ratio_correct: BOOLEAN

	actualheight: INTEGER

	max_scaling_buffer_pixels: INTEGER = 16000000

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
			video_flags: NATURAL
		do
			if firsttime then
				firsttime := True
				video_flags := 0
					-- skip -fullscreen param
					-- skip -2 param
					-- skip -3 param
					-- skip -grabmouse
				w := {DOOMDEF_H}.SCREENWIDTH * multiply
				video_w := w
				h := {DOOMDEF_H}.SCREENHEIGHT * multiply
				video_h := h
				window := {SDL_VIDEO}.sdl_create_window ("EIFFEL SDL DOOM!", {SDL_CONSTANT_API}.sdl_windowpos_undefined, {SDL_CONSTANT_API}.sdl_windowpos_undefined, video_w, video_h, video_flags)
				if attached window as attached_window then
					pixel_format := {SDL_VIDEO}.sdl_get_window_pixel_format (attached_window)
					renderer := {SDL_RENDER_FUNCTIONS_API}.SDL_Create_Renderer (attached_window, -1, {SDL_RENDERER_FLAGS_ENUM_API}.SDL_RENDERER_TARGETTEXTURE.to_natural_32)
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
			create_upscaled_texture(True)
		end

feature -- CreateUpscaledTexture

	h_upscale_old: INTEGER

	w_upscale_old: INTEGER

	create_upscaled_texture (force: BOOLEAN)
		local
			w, h: INTEGER
			h_upscale, w_upscale: INTEGER
			new_texture, old_texture: SDL_TEXTURE_STRUCT_API
			b: BOOLEAN
		do
				-- Get the size of the renderer output. The units this gives us will be
				-- real world pixels, which are not necessarily equivalent to the screen's
				-- window size (because of highdpi).
			check attached renderer as r then
				if {SDL_RENDER_FUNCTIONS_API}.sdl_get_renderer_output_size (r, $w, $h) /= 0 then
					{I_MAIN}.i_error ("Failed to get renderer output size " + {SDL_ERROR}.sdl_get_error)
				end
			end

				-- When the screen or window dimensions do not match the aspect ratio
				-- of the texture, the rendered area is scaled down to fit. Calculate
				-- the actual dimensions of the rendered area.

			if w * actualheight < h * {DOOMDEF_H}.SCREENWIDTH then
					-- Tall window.
				h := w * actualheight // {DOOMDEF_H}.SCREENWIDTH
			else
					-- Wide window.
				w := h * {DOOMDEF_H}.SCREENWIDTH // actualheight
			end

				-- Pick texture size the next integer multiple of the screen dimensions.
				-- If one screen dimension matches an integer multiple of the original
				-- resolution, there is no need to overscale in this direction.

			w_upscale := (w + {DOOMDEF_H}.SCREENWIDTH - 1) // {DOOMDEF_H}.SCREENWIDTH
			h_upscale := (h + {DOOMDEF_H}.SCREENHEIGHT - 1) // {DOOMDEF_H}.SCREENHEIGHT

				-- Minimum texture dimensions of 320x200.

			if w_upscale < 1 then
				w_upscale := 1
			end
			if h_upscale < 1 then
				h_upscale := 1
			end
			limit_texture_size ($w_upscale, $h_upscale)

				-- Create a new texture only if the upscale factors have actually changed.

			if (h_upscale = h_upscale_old and w_upscale = w_upscale_old and not force) then
					-- return
			else
				h_upscale_old := h_upscale
				w_upscale_old := w_upscale

					-- Set the scaling quality for rendering the upscaled texture to "linear",
					-- which looks much softer and smoother than "nearest" but does a better
					-- job at downscaling from the upscaled texture to screen.

				b := {SDL_HINTS}.SDL_Set_Hint ({SDL_CONSTANT_API}.SDL_HINT_RENDER_SCALE_QUALITY, "linear")
				check attached renderer as r then
					new_texture := {SDL_RENDER_FUNCTIONS_API}.SDL_Create_Texture (r, pixel_format, {SDL_TEXTURE_ACCESS_ENUM_API}.SDL_TEXTUREACCESS_TARGET, w_upscale * {DOOMDEF_H}.SCREENWIDTH, h_upscale * {DOOMDEF_H}.SCREENHEIGHT)
					old_texture := texture_upscaled;
					texture_upscaled := new_texture;
					if attached old_texture as ot then
						{SDL_RENDER_FUNCTIONS_API}.SDL_Destroy_Texture (ot);
					end
				end
			end
		end

	limit_texture_size (w_upscale, h_upscale: TYPED_POINTER [INTEGER])
		local
			rinfo: SDL_RENDERER_INFO_STRUCT_API
			orig_w, orig_h: INTEGER
			mp_w, mp_h: MANAGED_POINTER
		do
			create rinfo.make
			create mp_w.share_from_pointer (w_upscale, {PLATFORM}.integer_32_bytes)
			orig_w := mp_w.read_integer_32 (0)
			create mp_h.share_from_pointer (h_upscale, {PLATFORM}.integer_32_bytes)
			orig_h := mp_h.read_integer_32 (0)
			check attached renderer as r then
				if {SDL_RENDER_FUNCTIONS_API}.sdl_get_renderer_info (r, rinfo) /= 0 then
					{I_MAIN}.i_error ("CreateUpscaledTexture: SDL_GetRendererInfo() call failed " + {SDL_ERROR}.sdl_get_error)
				end
			end
			from
			until
				mp_w.read_integer_32 (0) * {DOOMDEF_H}.SCREENWIDTH <= rinfo.max_texture_width
			loop
				mp_w.put_integer_32 (mp_w.read_integer_32 (0) - 1, 0)
			end
			from
			until
				mp_h.read_integer_32 (0) * {DOOMDEF_H}.SCREENHEIGHT <= rinfo.max_texture_height
			loop
				mp_h.put_integer_32 (mp_h.read_integer_32 (0) - 1, 0)
			end
			if (mp_w.read_integer_32 (0) < 1 and rinfo.max_texture_width > 0) or (mp_h.read_integer_32 (0) < 1 and rinfo.max_texture_height > 0) then
				{I_MAIN}.i_error ("[
					CreateUpscaledTexture: Can't create a texture big enough for
					the whole screen! Maximum texture size
				]" + rinfo.max_texture_width.out + "x" + rinfo.max_texture_height.out)
			end

				-- We limit the amount of texture memory used for the intermediate buffer,
				-- since beyond a certain point there are diminishing returns. Also,
				-- depending on the hardware there may be performance problems with very
				-- huge textures, so the user can use this to reduce the maximum texture
				-- size if desired.

			if (max_scaling_buffer_pixels < {DOOMDEF_H}.SCREENWIDTH * {DOOMDEF_H}.SCREENHEIGHT) then
				{I_MAIN}.i_error ("[
					CreateUpscaledTexture: max_scaling_buffer_pixels too small
					        to create a texture buffer:
				]" + max_scaling_buffer_pixels.out + " < " + ({DOOMDEF_H}.SCREENWIDTH * {DOOMDEF_H}.SCREENHEIGHT).out)
			end
			from
			until
				(mp_w.read_integer_32 (0) * mp_h.read_integer_32 (0) * {DOOMDEF_H}.SCREENWIDTH * {DOOMDEF_H}.SCREENHEIGHT) <= max_scaling_buffer_pixels
			loop
				if mp_w.read_integer_32 (0) > mp_h.read_integer_32 (0) then
					mp_w.put_integer_32 (mp_w.read_integer_32 (0) - 1, 0)
				else
					mp_h.put_integer_32 (mp_h.read_integer_32 (0) - 1, 0)
				end
			end
			if mp_w.read_integer_32 (0) /= orig_w or mp_h.read_integer_32 (0) /= orig_h then
				print ("CreateUpscaledTexture: Limited texture size to " + (mp_w.read_integer_32 (0) * {DOOMDEF_H}.SCREENWIDTH).out + "x" + (mp_h.read_integer_32 (0) * {DOOMDEF_H}.SCREENHEIGHT).out)
			end
		end

feature -- I_FinishUpdate

	lasttic: INTEGER

	I_FinishUpdate
		local
			i: INTEGER
			mp: MANAGED_POINTER
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
				check attached renderer as r and then attached texture_upscaled as tu then

						-- copy screen[0] to sb
					create mp.share_from_pointer (sb.pixels, i_main.v_video.screens [0].count)
					from
						i := 0
					until
						i > i_main.v_video.screens [0].upper
					loop
						mp.put_natural_8 (i_main.v_video.screens [0] [i], i)
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

--						 Render this intermediate texture into the upscaled texture
--						 using "nearest" integer scaling.

					if {SDL_RENDER}.SDL_Set_Render_Target (r, tu) < 0 then
						i_main.i_error ("render target " + {SDL_ERROR}.sdl_get_error)
					end
					if {SDL_RENDER}.SDL_Render_Copy (r, t, Void, Void) < 0 then
						i_main.i_error ("render copy " + {SDL_ERROR}.sdl_get_error)
					end

--						 Finally, render this upscaled texture to screen using linear scaling.

					if {SDL_RENDER}.SDL_Set_Render_Target (r, Void) < 0 then
						i_main.i_error ("render target " + {SDL_ERROR}.sdl_get_error)
					end
					if {SDL_RENDER}.SDL_Render_Copy (r, tu, Void, Void) < 0 then
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
