note
	description: "[
		spritedef_t from r_defs.h
		
		A sprite definition:
		a number of animation frames
	]"

class
	SPRITEDEF_T

feature

	numframes: INTEGER assign set_numframes

	set_numframes (a_numframes: like numframes)
		do
			numframes := a_numframes
		end

	spriteframes: detachable ARRAY [SPRITEFRAME_T] assign set_spriteframes

	set_spriteframes (a_spriteframes: like spriteframes)
		do
			spriteframes := a_spriteframes
		end

end
