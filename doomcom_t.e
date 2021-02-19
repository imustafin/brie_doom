note
	description: "d_net.h"

class
	DOOMCOM_T

create
	make

feature

	make
		do
			create data.make
		end

feature

	id: INTEGER_64 -- supposed to be DOOMCOM_ID?

feature -- Info commont to all nodes.

	numnodes: INTEGER -- Console is allways node 0.

	ticdup: INTEGER -- Flag: 1 = no duplication, 2-5 = dup for slow nets.

feature -- Info specific to this node.

	numplayers: INTEGER

	consoleplayer: INTEGER

	data: DOOMDATA_T

end
