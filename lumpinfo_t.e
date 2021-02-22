note
	description: "w_wad.h"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LUMPINFO_T

create
	make

feature

	name: STRING

	handle: detachable RAW_FILE

	position: INTEGER

	size: INTEGER

feature

	make (a_name: like name; a_handle: like handle; a_position: like position; a_size: like size)
		do
			name := a_name
			handle := a_handle
			position := a_position
			size := a_size
		end

end
