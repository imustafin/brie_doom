note
	description: "[
		hu_stuff.c
		Heads-up displays
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

	HU_Init
		do
				-- Stub
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
				-- Stub
		end

	HU_Erase
		do
			i_main.hu_lib.HUlib_eraseSText (w_message)
			i_main.hu_lib.HUlib_eraseIText (w_chat)
			i_main.hu_lib.HUlib_eraseTextLine (w_title)
		end

end
