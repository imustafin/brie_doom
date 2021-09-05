note
	description: "[
		z_zone.c
		Zone Memory Allocation. Neat.
	]"

class
	Z_ZONE

create
	make

feature

	make
		do
		end

feature

	Z_Init
		do
				-- Stub
		end

	Z_CheckHeap
		do
				-- Stub
		end

	Z_FreeTags (lowtag, hightag: INTEGER)
		do
				-- Stub
		end

feature -- ZONE MEMORY

	PU_CACHE: INTEGER = 101

	PU_STATIC: INTEGER = 1

	PU_LEVEL: INTEGER = 50 -- static until level exited

	PU_PURGELEVEL: INTEGER = 100

end
