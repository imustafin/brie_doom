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
			window_width := 800
			window_height := 600
			fullscreen := False
			create i_videobuffer.make (1)
		end

feature

	SCREENHEIGHT_4_3: INTEGER = 240

feature

	multiply: INTEGER

	screen: detachable SDL_WINDOW_STRUCT_API

	renderer: detachable SDL_RENDERER_STRUCT_API

	texture: detachable SDL_TEXTURE_STRUCT_API

	texture_upscaled: detachable SDL_TEXTURE_STRUCT_API

	screenbuffer: detachable SDL_SURFACE_STRUCT_API

	argbbuffer: detachable SDL_SURFACE_STRUCT_API

	pixel_format: NATURAL_32

feature

	fullscreen: BOOLEAN

	screensaver_mode: BOOLEAN

	fullscreen_width: INTEGER = 0

	fullscreen_height: INTEGER = 0

feature

	startup_delay: INTEGER = 1000
			-- Time to wait for the screen to settle on startup before starting the
			-- game (ms)

feature -- Aspect ratio correction mode

	aspect_ratio_correct: BOOLEAN

	integer_scaling: BOOLEAN -- Force integer scales for resolution-independent rendering

	actualheight: INTEGER

	max_scaling_buffer_pixels: INTEGER = 16000000

feature

	initialized: BOOLEAN

	screenvisible: BOOLEAN = True

feature

	I_VideoBuffer: PIXEL_T_BUFFER
			--  The screen buffer; this is modified to draw things to the screen

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

feature -- Screen width and height, from configuration file.

	window_width: INTEGER

	window_height: INTEGER

feature -- I_InitGraphics

	firsttime: BOOLEAN

	I_InitGraphics
			-- from https://github.com/chocolate-doom/chocolate-doom/blob/7a0db31614ec187e363e7664036d95ec56242e44/src/i_video.c#L1357
		local
			dummy: SDL_EVENT_UNION_API
		do
				-- skip screensaver
				-- SetSdlVideoDriver
			if {SDL_FUNCTIONS_API}.sdl_init ({SDL_CONSTANT_API}.SDL_INIT_VIDEO.to_natural_32) < 0 then
				{I_MAIN}.i_error ("Failed to initialize video: " + {SDL_ERROR}.sdl_get_error)
			end

				-- skip screensaver

			if aspect_ratio_correct then
				actualheight := SCREENHEIGHT_4_3
			else
				actualheight := {DOOMDEF_H}.SCREENHEIGHT
			end

				-- Create the game window; this may switch graphic modes depending on configuraion
			adjust_window_size
			set_video_mode

				-- Start with a clear black screen
				-- (screen will be flipped after we set the palette)

			check attached screenbuffer as sb then
				if {SDL_SURFACE}.sdl_fill_rect (sb, Void, 0) < 0 then
					{I_MAIN}.i_error ("SDL_FillRect failed " + {SDL_ERROR}.sdl_get_error)
				end
			end

				-- Set the palette

			I_SetPalette (i_main.w_wad.W_CacheLumpName ("PLAYPAL", {Z_ZONE}.PU_CACHE))
			set_sdl_palette

				-- SDL2-TODO UpdateFocus()
				-- skip UpdateGrab

				-- On some systems, it takes a second or so for the screen to settle
				-- after changing modes. We include the option to add a delay when
				-- setting the screen mode, so that the game doesn't start immediately
				-- with the player unable to see anything.

			if fullscreen and not screensaver_mode then
				{SDL_TIMER_FUNCTIONS_API}.SDL_Delay (startup_delay.to_natural_32)
			end

				-- The actual 320x200 canvas that we draw to. This is the pixel buffer of
				-- the 8-bit paletted screen buffer that gets blit on an intermediate
				-- 32-bit RGBA screen buffer that gets loaded into a texture that gets
				-- finally rendered into our window or full screen in I_FinishUpdate().

			check attached screenbuffer as sb then
				create i_videobuffer.share_from_pointer (sb.pixels, {DOOMDEF_H}.screenwidth * {DOOMDEF_H}.screenheight)
			end
			i_main.v_video.V_RestoreBuffer

				-- Clear the screen to black.

			I_VideoBuffer.fill_zero

				-- clear out any events waiting at the start and center the mouse
			from
				create dummy.make
			until
				{SDL_EVENTS}.sdl_poll_event (dummy) = 0
			loop
					-- nothing
			end
			initialized := true

				-- Call I_ShutdownGraphics on quit

				-- skip I_AtExit (I_ShutdownGraphics, true)
		end

	adjust_window_size
			-- Adjust window_width / window_height variables to be an an aspect
			-- ratio consistent with the aspect_ratio_correct variable.

		do
			if aspect_ratio_correct or integer_scaling then
				if window_width * actualheight <= window_height * {DOOMDEF_H}.SCREENWIDTH then
						-- We round up window_height if the ratio is not exact; this leaves the result stable.
					window_height := (window_width * actualheight + {DOOMDEF_H}.SCREENWIDTH - 1) // {DOOMDEF_H}.SCREENWIDTH
				else
					window_width := window_height * {DOOMDEF_H}.screenwidth // actualheight
				end
			end
		end

feature

	I_StartFrame
		do
				-- er?
		end

	I_StartTic
		do
			if initialized then
				I_GetEvent
					--				if usemouse and not nomouse and window_focused then
					--					I_ReadMouse
					--				end
					--				if joywait < I_GetTime then
					--					I_UpdateJoystick
					--				end
			end
		end

	I_GetEvent
		local
			event: EVENT_T
			sdl_event: SDL_EVENT_UNION_API
		do
			from
				create event.make
				create sdl_event.make
			until
				{SDL_EVENTS}.sdl_poll_event (sdl_event) = 0
			loop
				create event.make
				if sdl_event.type = {SDL_CONSTANT_API}.sdl_keydown then
					event.type := {EVENT_T}.ev_keydown
					event.data1 := xlatekey (sdl_event.key.keysym)
					check attached i_main.d_main as d then
						d.D_PostEvent (event)
					end
				elseif sdl_event.type = {SDL_CONSTANT_API}.sdl_keyup then
					event.type := {EVENT_T}.ev_keyup
					event.data1 := xlatekey (sdl_event.key.keysym)
					check attached i_main.d_main as d then
						d.D_PostEvent (event)
					end
				elseif sdl_event.type = {SDL_CONSTANT_API}.sdl_quit then
					i_main.i_system.I_Quit
				else
						-- ignore SDL_MOUSEBUTTONDOWN
						-- ignore SDL_MOUSEBUTTONUP
						-- ignore SDL_MOUSEMOTION
				end
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
			elseif key.sym = {SDL_KEYCODE}.sdlk_lctrl or key.sym = {SDL_KEYCODE}.sdlk_rctrl then
				Result := {DOOMDEF_H}.key_rctrl
			else
				Result := key.sym
			end
		end

feature

	I_ReadScreen (scr: PIXEL_T_BUFFER)
		do
			scr.copy_from (I_VideoBuffer)
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
			p: POINTER
			w, h: INTEGER
			window_flags, renderer_flags: INTEGER_32
		do
			w := window_width
			h := window_height

				-- In windowed mode, the window can be resized while the game is
				-- running.

			window_flags := {SDL_WINDOW_FLAGS_ENUM_API}.sdl_window_resizable
				--      Set the highdpi flag - this makes a big difference on Macs with
				-- retina displays, especially when using small window sizes.
			window_flags := window_flags | {SDL_WINDOW_FLAGS_ENUM_API}.sdl_window_allow_highdpi
			if fullscreen then
				if fullscreen_width = 0 and fullscreen_height = 0 then
						-- This window_flags means "Never change the screen resolution!
						-- Instead, draw to the entire screen by scaling the texture
						-- appropriately".
					window_flags := window_flags | {SDL_WINDOW_FLAGS_ENUM_API}.SDL_WINDOW_FULLSCREEN_DESKTOP
				else
					w := fullscreen_width;
					h := fullscreen_height;
					window_flags := window_flags | {SDL_WINDOW_FLAGS_ENUM_API}.SDL_WINDOW_FULLSCREEN
				end
			end
				-- skip borderless
				-- skip I_GetWindowPosition

				-- Create window and renderer contexts. We set the window title
				-- later anyway and leave the window position "undefined". If
				-- "window_flags" contains the fullscreen flag (see above), then
				-- w and h are ignored.

			if screen = Void then
				screen := {SDL_VIDEO}.sdl_create_window ("SDL EIFFEL DOOM", {SDL_CONSTANT_API}.sdl_windowpos_undefined, {SDL_CONSTANT_API}.sdl_windowpos_undefined, w, h, window_flags.to_natural_32)
				if screen = Void then
					{I_MAIN}.i_error ("Error creating window for video startup" + {SDL_ERROR}.sdl_get_error)
				end
				check attached screen as s then
					pixel_format := {SDL_VIDEO}.sdl_get_window_pixel_format (s)
				end

					-- skip I_InitWindowTitle
					-- skip I_InitWindowIcon
			end

				-- The SDL_RENDERER_TARGETTEXTURE flag is required to render the
				-- intermediate texture into the upscaled texture.
			renderer_flags := {SDL_RENDERER_FLAGS_ENUM_API}.SDL_RENDERER_TARGETTEXTURE
				-- skip vsync
				-- skip force sw render

			if attached renderer as r then
				{SDL_RENDER_FUNCTIONS_API}.sdl_destroy_renderer (r)
				texture := Void
				texture_upscaled := Void
			end
			check attached screen as s then
				renderer := {SDL_RENDER_FUNCTIONS_API}.sdl_create_renderer (s, -1, renderer_flags.to_natural_32)
			end

				-- skip try again without hw

			if renderer = Void then
				{I_MAIN}.i_error ("Error creating renderer for screen window " + {SDL_ERROR}.sdl_get_error)
			end
			check attached renderer as r then
					-- Important: Set the "logical size" of the rendering context. At the same
					-- time this also defines the aspect ratio that is preserved while scaling
					-- and stretching the texture into the window.
				if aspect_ratio_correct or integer_scaling then
					if {SDL_RENDER_FUNCTIONS_API}.sdl_render_set_logical_size (r, {DOOMDEF_H}.SCREENWIDTH, actualheight) /= 0 then
						{I_MAIN}.i_error ("Error setting logical size " + {SDL_ERROR}.sdl_get_error)
					end
				end

					-- Force integer scales for resolution-independent rendering.
				if {SDL_RENDER_FUNCTIONS_API}.sdl_render_set_integer_scale (r, if integer_scaling then 1 else 0 end) /= 0 then
					{I_MAIN}.i_error ("Error setting integer scale " + {SDL_ERROR}.sdl_get_error)
				end

					-- Blank out the full screen area in case there is any junk in
					-- the borders that won't otherwise be overwritten.

				if {SDL_RENDER_FUNCTIONS_API}.sdl_set_render_draw_color (r, (0).to_character_8, (0).to_character_8, (0).to_character_8, (255).to_character_8) /= 0 then
					{I_MAIN}.i_error ("Error setting render color " + {SDL_ERROR}.sdl_get_error)
				end
				if {SDL_RENDER_FUNCTIONS_API}.sdl_render_clear (r) /= 0 then
					{I_MAIN}.i_error ("Error render clear " + {SDL_ERROR}.sdl_get_error)
				end
				{SDL_RENDER_FUNCTIONS_API}.sdl_render_present (r)
			end

				-- Create the 8-bit paletted and the 32-bit RGBA screenbuffer surfaces.

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
				p := {SDL_SURFACE_FUNCTIONS_API}.sdl_create_rgbsurface (0, {DOOMDEF_H}.SCREENWIDTH, {DOOMDEF_H}.SCREENHEIGHT, bpp, rmask, gmask, bmask, amask)
				if p.is_default_pointer then
					i_main.i_error ("SDL_CreateRGBSurface failed" + {SDL_ERROR}.sdl_get_error)
				else
					create argbbuffer.make_by_pointer (p)
				end
				check attached argbbuffer as abb then
					if {SDL_SURFACE}.sdl_fill_rect (abb, Void, 0) < 0 then
						i_main.i_error ("Error SDL_FillRect" + {SDL_ERROR}.sdl_get_error)
					end
				end
			end
			if attached texture as t then
				{SDL_RENDER_FUNCTIONS_API}.sdl_destroy_texture (t)
			end

				-- Set the scaling quality for rendering the intermediate texture into
				-- the upscaled texture to "nearest", which is gritty and pixelated and
				-- resembles software scaling pretty well.

			if not {SDL_HINTS}.sdl_set_hint ({SDL_CONSTANT_API}.SDL_HINT_RENDER_SCALE_QUALITY, "nearest") then
				{I_MAIN}.i_error ("Error setting hint " + {SDL_ERROR}.sdl_get_error)
			end

				-- Create the intermediate texture that the RGBA surface gets loaded into.
				-- The SDL_TEXTUREACCESS_STREAMING flag means that this texture's content
				-- is going to change frequently.

			check attached renderer as r then
				texture := {SDL_RENDER}.sdl_create_texture (r, pixel_format, {SDL_TEXTURE_ACCESS_ENUM_API}.SDL_TEXTUREACCESS_STREAMING, {DOOMDEF_H}.SCREENWIDTH, {DOOMDEF_H}.SCREENHEIGHT)
			end

				-- Initially create the upscaled texture for rendering to screen
			create_upscaled_texture (True)
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
		do
				-- From chocolate doom

				-- skip devparm
			check attached screenbuffer as sb then
				if palette_to_set then
					check attached sb.format as f and then attached f.palette as p then
						set_sdl_palette
						palette_to_set := False
					end

						-- skip VGA porch flash
				end
			end
			check attached screenbuffer as sb and then attached argbbuffer as abb and then attached texture as t then
				check attached renderer as r and then attached texture_upscaled as tu then

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

	set_sdl_palette
		local
			mp: MANAGED_POINTER
			i: INTEGER
		do
			check attached screenbuffer as sb and then attached sb.format as f and then attached f.palette as p then
				create mp.make (256 * 4)
				from
					i := 0
				until
					i >= 256
				loop
					mp.put_natural_8 (palette [i].r.code.to_natural_8, 4 * i + 0)
					mp.put_natural_8 (palette [i].g.code.to_natural_8, 4 * i + 1)
					mp.put_natural_8 (palette [i].b.code.to_natural_8, 4 * i + 2)
					mp.put_natural_8 (palette [i].a.code.to_natural_8, 4 * i + 3)
					i := i + 1
				end
				if {SDL_PIXELS_FUNCTIONS_API}.c_SDL_Set_Palette_Colors (p.item, mp.item, 0, 256) < 0 then
					{I_MAIN}.i_error ("SDL_SetPaletteColors failed " + {SDL_ERROR}.sdl_get_error)
				end
			end
		end

end
