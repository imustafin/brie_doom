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

	make
		do
		end

feature

	HU_Init
		do
				-- Stub
		end

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

end
