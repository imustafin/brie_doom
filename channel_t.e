note
	description: "s_sound.c"

class
	CHANNEL_T

create
	make

feature

	make
		do
		end

feature

	sfxinfo: detachable SFXINFO_T assign set_sfxinfo -- sound information (if null, channel avail.)

	set_sfxinfo (a_sfxinfo: like sfxinfo)
		do
			sfxinfo := a_sfxinfo
		end

	origin: detachable MOBJ_T -- origin of sound (orginally void*)

	handle: INTEGER -- handle of the sound being played

end
