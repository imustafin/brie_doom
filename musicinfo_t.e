note
	description: "chocolate doom i_sound.h"

class
	MUSICINFO_T

create
	make

feature

	make (a_name: STRING; a_lumpnum: INTEGER; a_data, a_handle: detachable ANY)
		do
			name := a_name
			lumpnum := a_lumpnum
			data := a_data
			handle := a_handle
		end

feature

	name: STRING -- up to 6-character name

	lumpnum: INTEGER assign set_lumpnum -- lump number of music

	set_lumpnum (a_lumpnum: like lumpnum)
		do
			lumpnum := a_lumpnum
		end

	data: detachable ANY assign set_data -- music data

	set_data (a_data: like data)
		do
			data := a_data
		end

	handle: detachable ANY assign set_handle -- music handle once registered

	set_handle (a_handle: like handle)
		do
			handle := a_handle
		end

end
