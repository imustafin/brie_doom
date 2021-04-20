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

	P_AddThinker (thinker: THINKER_T)
			-- Adds a new thinker at the end of the list
		do
			thinkercap.prev.next := thinker
			thinker.next := thinkercap
			thinker.prev := thinkercap.prev
			thinkercap.prev := thinker
		end

end
