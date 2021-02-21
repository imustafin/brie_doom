note
	description: "sounds.h"

class
	SFXINFO_T

create
	make

feature

	make
		do
		end

feature

	name: detachable STRING -- up to 6-character name

	singularity: INTEGER -- Sfx singularity (one at a time)

	priority: INTEGER -- Sfx priority

	link: detachable SFXINFO_T -- referenced sound if a link

	pitch: INTEGER -- pitch if a link

	volume: INTEGER -- volume if a link

	data: detachable ANY -- sound data (orignally void*)

	usefulness: INTEGER assign set_usefulness
			-- this is checked every second to see if sound can be thrown out
			-- (if 0, then decrement,
			--  if -1, then throw out,
			--  if > 0, then it is in use)

	set_usefulness (a_usefulness: like usefulness)
		do
			usefulness := a_usefulness
		end

	lumpnum: INTEGER -- lump number of sfx

end
