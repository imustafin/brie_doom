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

	make
		do
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
		do
				-- Stub
		end

end
