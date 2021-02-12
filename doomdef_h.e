note
	description: "[
		doomdef.h
		Internally used data structures for virtually everything,
		 key definitions, lots of other stuff.
	]"

class
	DOOMDEF_H

create
	make

feature

	make
		do
		end

feature

	SCREENWIDTH: INTEGER = 320

	SCREENHEIGHT: INTEGER = 200

feature -- skill_t

	sk_baby: INTEGER = 0

	sk_easy: INTEGER = 1

	sk_medium: INTEGER = 2

	sk_hard: INTEGER = 3

	sk_nightmare: INTEGER = 4

end
