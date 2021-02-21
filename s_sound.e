note
	description: "[
		s_sound.c
		none
	]"

class
	S_SOUND

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			create channels.make_empty
		end

feature

	snd_SfxVolume: INTEGER = 15

	snd_MusicVolume: INTEGER = 15

feature -- following is set by the defaults code in M_Misc

	numChannels: INTEGER -- number of channels available

feature

	channels: ARRAY [CHANNEL_T] -- the set of channels available

feature -- Adjustible by menu.

	NORM_PITCH: INTEGER = 128

	NORM_PRIORITY: INTEGER = 64

	NORM_SEP: INTEGER = 128

	S_STEREO_SWING: INTEGER
		once
			Result := 96 * 0x10000
		end

	S_CLOSE_DIST: INTEGER
			-- Distance tp origin when sounds should be maxed out.
			-- This should relate to movement clipping resolution
			-- (see BLOCKMAP handling).
			-- // Originally: (200*0x10000).
		once
			Result := 160 * 0x10000
		end

	S_ATTENUATOR: INTEGER
		once
			Result := (S_CLIPPING_DIST - S_CLOSE_DIST) |>> {M_FIXED}.FRACBITS
		end

feature

	S_CLIPPING_DIST: INTEGER
			-- when to clip out sounds
			-- Does not fit the large outdoor areas
		once
			Result := 1200 * 0x10000
		end

feature

	S_Init (sfxVolume: INTEGER; musicVolume: INTEGER)
			-- Initializes sound stuff, including volume
			-- Sets channels, SFX and music volume,
			--  allocates channel buffer, sets S_sfx lookup.
		do
				-- Stub
		end

feature

	S_UpdateSounds (listener: MOBJ_T)
			-- Updates music & sounds
		local
			audible: BOOLEAN
			cnum: INTEGER
			volume: INTEGER_32_REF
			sep: INTEGER_32_REF
			pitch: INTEGER_32_REF
			l_sfx_detachable: SFXINFO_T
			c: CHANNEL_T
			l_stopped: BOOLEAN
		do
			from
				cnum := 0
			until
				cnum >= numChannels
			loop
				l_stopped := False
				c := channels [cnum]
				l_sfx_detachable := c.sfxinfo
				if attached l_sfx_detachable as sfx then
					if i_main.i_sound.I_SoundIsPlaying (c.handle) then
							-- initialize parameters.
						volume := snd_SfxVolume
						pitch := NORM_PITCH
						sep := NORM_SEP
						if attached sfx.link then
							pitch := sfx.pitch
							volume := volume + sfx.volume
							if volume < 1 then
								S_StopChannel (cnum)
								l_stopped := True -- continue;
							elseif volume > snd_SfxVolume then
								volume := snd_SfxVolume
							end
						end
						if not l_stopped then
								-- check non-local sounds for distance clipping
								--  or modify their params
							if attached c.origin as origin and then listener /= origin then
								audible := S_AdjustSoundParams (listener, origin, volume, sep, pitch)
							end
							if not audible then
								S_StopChannel (cnum)
							else
								i_main.i_sound.I_UpdateSoundParams (c.handle, volume, sep, pitch)
							end
						end
					else
							-- if channel is allocated but sound has stopped,
							--  free it
						S_StopChannel (cnum)
					end
				end
				cnum := cnum + 1
			end
		end

	S_StartSound (origin: detachable ANY; sfx_id: INTEGER)
		do
			S_StartSoundAtVolume (origin, sfx_id, snd_SfxVolume)
		end

	S_StartSoundAtVolume (origin: detachable ANY; sfx_id: INTEGER; volume: INTEGER)
		do
				-- Stub
		end

	S_StartMusic (m_id: INTEGER)
		do
			S_ChangeMusic (m_id, False)
		end

	S_ChangeMusic (musicnum: INTEGER; looping: BOOLEAN)
		do
				-- Stub
		end

	S_StopChannel (cnum: INTEGER)
		local
			c: CHANNEL_T
		do
			c := channels [cnum]
			if attached c.sfxinfo as sfxinfo then
				if i_main.i_sound.I_SoundIsPlaying (c.handle) then
					sfxinfo.usefulness := sfxinfo.usefulness - 1
					c.sfxinfo := Void
				end
			end
		end

	S_AdjustSoundParams (listener: MOBJ_T; source: MOBJ_T; vol, sep, pitch: INTEGER_32_REF): BOOLEAN
			-- (originally returned int)
			-- Changes volume, stereo-separation, and pith variables
			--  from the norm of a sound effect to be played.
			-- If the sound is not audible, returns False (originally 0).
			-- Otherwise, modifies parameters and returns True (originally 1).
		local
			approx_dist: FIXED_T
			adx: FIXED_T
			ady: FIXED_T
			angle: ANGLE_T
		do
				-- calculate the distance to sound origin
				--  and clip it if necessary
			adx := (listener.x - source.x).abs
			ady := (listener.y - source.y).abs

				-- From _GG1_ p.428. Approx. euclidean distance fast
			approx_dist := adx + ady - (adx.min (ady) |>> 1)
			if i_main.g_game.gamemap /= 8 and approx_dist > S_CLIPPING_DIST then
				Result := False
			else
				angle := i_main.r_main.R_PointToAngle2 (listener.x, listener.y, source.x, source.y)
				if angle > listener.angle then
					angle := angle - listener.angle
				else
					angle := angle + (({NATURAL} 0xffffffff) - listener.angle)
				end
				angle := angle |>> {TABLES}.ANGLETOFINESHIFT

					-- stereo separation
				sep.set_item ((128 - ({M_FIXED}.FixedMul (S_STEREO_SWING, {TABLES}.finesine [angle])) |>> {M_FIXED}.FRACBITS).as_integer_32)

					-- volume calculation
				if approx_dist < S_CLOSE_DIST then
					vol.set_item (snd_SfxVolume)
				elseif i_main.g_game.gamemap = 8 then
					if approx_dist > S_CLIPPING_DIST then
						approx_dist := S_CLIPPING_DIST
					end
					vol.set_item ((vol * (15 + ((snd_SfxVolume - 15) * ((S_CLIPPING_DIST - approx_dist) |>> {M_FIXED}.FRACBITS)) // S_ATTENUATOR)).as_integer_32)
				else
					vol.set_item ((vol * ((snd_SfxVolume * ((S_CLIPPING_DIST - approx_dist) |>> {M_FIXED}.FRACBITS)) // S_ATTENUATOR)).as_integer_32)
				end
				Result := vol > 0
			end
		end
end
