note
	description: "[
		p_tick.c
		Archiving: SaveGame I/O.
		Thinker, Ticker.
	]"

class
	P_TICK

create
	make

feature

	make
		do
			create thinkercap.make
		end

feature

	thinkercap: THINKER_T
			-- Both the head and tail of the thinker list.

	leveltime: INTEGER assign set_leveltime

	set_leveltime (a_leveltime: like leveltime)
		do
			leveltime := a_leveltime
		end

feature

	P_InitThinkers
		do
			thinkercap.next := thinkercap
			thinkercap.prev := thinkercap
		end

end
