note
	description: "chocolate doom i_sdlsound.c"

class
	ALLOCATED_SOUND_T

create
	make

feature

	make
		do
			create chunk.make
		end

feature

	sfxinfo: detachable SFXINFO_T assign set_sfxinfo

	set_sfxinfo (a_sfxinfo: like sfxinfo)
		do
			sfxinfo := a_sfxinfo
		end

	chunk: MIX_CHUNK_STRUCT_API

	use_count: INTEGER assign set_use_count

	set_use_count (a_use_count: like use_count)
		do
			use_count := a_use_count
		end

	pitch: INTEGER assign set_pitch

	set_pitch (a_pitch: like pitch)
		do
			pitch := a_pitch
		end

	prev: detachable ALLOCATED_SOUND_T assign set_prev

	set_prev (a_prev: like prev)
		do
			prev := a_prev
		end

	next: detachable ALLOCATED_SOUND_T assign set_next

	set_next (a_next: like next)
		do
			next := a_next
		end

end
