note
	description: "sounds.h"

class
	SFXINFO_T

create
	make

feature

	make (a_name: like name; a_singularity: like singularity; a_priority: like priority; a_link: like link; a_pitch: like pitch)
		do
			name := a_name
			singularity := a_singularity
			priority := a_priority
			link := a_link
			pitch := a_pitch
		end

feature

	name: detachable STRING -- up to 6-character name

	singularity: BOOLEAN -- Sfx singularity (one at a time) (originally int)

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

	lumpnum: INTEGER assign set_lumpnum -- lump number of sfx

	set_lumpnum (a_lumpnum: like lumpnum)
		do
			lumpnum := a_lumpnum
		end

end
