note
	description: "[
		r_sky.c
		Sky renderng. The DOOM sky is a texture map like any
		wall, wrapping around. A 1024 columns equal 360 degrees.
		The default sky map is 256 columns and repeats 4 times
		on a 320 screen?
	]"

class
	R_SKY

create
	make

feature

	make
		do
		end

feature

	SKYFLATNAME: STRING = "F_SKY1"

feature -- sky mapping

	skyflatnum: INTEGER assign set_skyflatnum

	set_skyflatnum (a_skyflatnum: like skyflatnum)
		do
			skyflatnum := a_skyflatnum
		end

	skytexture: INTEGER assign set_skytexture

	set_skytexture (a_skytexture: like skytexture)
		do
			skytexture := a_skytexture
		end

	skytexturemid: INTEGER

feature

	R_InitSkyMap
		do
			skytexturemid := 100 * {M_FIXED}.FRACUNIT
		end

end
