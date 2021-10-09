note
	description: "[
		s_sound.c
		none
	]"
	license: "[
		Copyright (C) 1993-1996 by id Software, Inc.
		Copyright (C) 2005-2014 Simon Howard
		Copyright (C) 2021 Ilgiz Mustafin

		This program is free software; you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation; either version 2 of the License, or
		(at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License along
		with this program; if not, write to the Free Software Foundation, Inc.,
		51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
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
			snd_SfxVolume := 15
			snd_MusicVolume := 15
		end

feature

	snd_SfxVolume: INTEGER assign set_snd_SfxVolume

	set_snd_SfxVolume (a_snd_SfxVolume: like snd_SfxVolume)
		do
			snd_SfxVolume := a_snd_SfxVolume
		end

	S_SetSfxVolume (volume: INTEGER)
		require
			volume >= 0 and volume <= 127
		do
			if volume < 0 or volume > 127 then
				i_main.i_error ("Attempt to set sfx volume at " + volume.out)
			end
			snd_SfxVolume := volume
		end

	snd_MusicVolume: INTEGER assign set_snd_MusicVolume

	set_snd_MusicVolume (a_snd_MusicVolume: like snd_MusicVolume)
		do
			snd_MusicVolume := a_snd_MusicVolume
		end

	S_SetMusicVolume (volume: INTEGER)
		require
			volume >= 0 and volume <= 127
		do
			if volume < 0 or volume > 127 then
				i_main.i_error ("Attempt to set music volume at " + volume.out + "%N")
			end
			i_main.i_sound.I_SetMusicVolume (127)
			i_main.i_sound.I_SetMusicVolume (volume)
			snd_MusicVolume := volume
		end

feature

	mus_paused: BOOLEAN -- whether songs are mus_paused

	mus_playing: detachable MUSICINFO_T

feature -- following is set by the defaults code in M_Misc

	numChannels: INTEGER assign set_numChannels -- number of channels available

	set_numChannels (a_numChannels: like numChannels)
		do
			numChannels := a_numChannels
		end

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
		local
			i: INTEGER
		do
			print ("S_Init: default sfx volume " + sfxVolume.out + "%N")

				-- Whatever these did with DMX, these are rather dummies now.
			i_main.i_sound.I_SetChannels
			S_SetSfxVolume (sfxVolume)
				-- No music with Linux - another dummy.
			S_SetMusicVolume (musicVolume)

				-- Allocating the internal channels for mixing
				-- (the maximum number of sounds rendered
				-- simultaneosly) within zone memory.
			create channels.make_filled (create {CHANNEL_T}.make, 0, numchannels - 1)
			from
				i := 0
			until
				i >= numchannels
			loop
				channels [i] := create {CHANNEL_T}.make

					-- Free all channels for use
				channels [i].sfxinfo := Void
				i := i + 1
			end

				-- no sounds are playing, and they are not mus_paused
			mus_paused := False
			from
				i := 1
			until
				i >= {SOUNDS_H}.NUMSFX
			loop
				{SOUNDS_H}.S_sfx [i].lumpnum := -1
				{SOUNDS_H}.S_sfx [i].usefulness := -1
				i := i + 1
			end
		end

feature

	S_PauseSound
		do
			if mus_playing /= Void and not mus_paused then
				i_main.i_sound.i_pausesong
				mus_paused := True
			end
		end

	S_ResumeSound
		do
			if mus_playing /= Void and mus_paused then
				i_main.i_sound.i_resumesong
				mus_paused := False
			end
		end

feature

	S_UpdateSounds (listener: detachable MOBJ_T)
			-- Updates music & sounds
			-- from chocolate doom
		local
			audible: BOOLEAN
			cnum: INTEGER
			volume: INTEGER_32_REF
			sep: INTEGER_32_REF
			c: CHANNEL_T
			l_stopped: BOOLEAN
		do
			i_main.i_sound.I_UpdateSound
			from
				cnum := 0
			until
				cnum >= numChannels
			loop
				l_stopped := False
				c := channels [cnum]
				if attached c.sfxinfo as sfx then
					if i_main.i_sound.I_SoundIsPlaying (c.handle) then
							-- initialize parameters.
						volume := snd_SfxVolume
						sep := NORM_SEP
						if attached sfx.link then
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
								check attached listener as l then
									audible := S_AdjustSoundParams (listener, origin, volume, sep)
								end
								if not audible then
									S_StopChannel (cnum)
								else
									i_main.i_sound.I_UpdateSoundParams (c.handle, volume, sep)
								end
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

	S_StartSound (origin_p: detachable ANY; sfx_id: INTEGER)
		local
			sfx: SFXINFO_T
			origin: MOBJ_T
			rc: BOOLEAN
			sep, pitch, cnum, volume: INTEGER
			ignore: BOOLEAN
		do
			print("S_StartSound not imlemented%N")
				--			create origin.make (origin_p) -- Stub origin
			volume := snd_SfxVolume

				-- check for bogus sound #
			if sfx_id < 1 or sfx_id > {SOUNDS_H}.NUMSFX then
				{I_MAIN}.i_error ("Bad sfx #:" + sfx_id.out)
			end
			sfx := {SOUNDS_H}.S_sfx [sfx_id]

				-- Initialize sound parameters
			pitch := NORM_PITCH
			if attached sfx.link as link then
				volume := volume + sfx.volume
				pitch := sfx.pitch
				if volume < 1 then
						-- return
					ignore := True
				else
					if volume > snd_SfxVolume then
						volume := snd_SfxVolume
					end
				end
			end
			if not ignore then
					-- Check to see if it is audible,
					--  and if not, modify the params
				if attached origin and then origin /= i_main.g_game.players [i_main.g_game.consoleplayer].mo then
					check attached i_main.g_game.players [i_main.g_game.consoleplayer].mo as mo then
						rc := S_AdjustSoundParams (mo, origin, volume, sep)
						if origin.x = mo.x and origin.y = mo.y then
							sep := NORM_SEP
						end
					end
					if not rc then
						ignore := True
					end
				else
					sep := NORM_SEP
				end
			end
			if not ignore then
					-- hacks to vary the sfx pitches
				if sfx_id >= {SOUNDS_H}.sfx_sawup and sfx_id <= {SOUNDS_H}.sfx_sawhit then
					pitch := pitch + 8 - (i_main.m_random.M_Random & 15)
				elseif sfx_id /= {SOUNDS_H}.sfx_itemup and sfx_id /= {SOUNDS_H}.sfx_tink then
					pitch := pitch + 16 - (i_main.m_random.M_Random & 31)
				end
				pitch := pitch.min (255).max (0) -- originally Clamp (pitch)

					-- kill old sound
				S_StopSound (origin)

					-- try to find a channel
				cnum := S_GetChannel (origin, sfx)
				if cnum < 0 then
					ignore := True
				end
			end
			if not ignore then
					-- increase the usefulness
				sfx.usefulness := (sfx.usefulness + 1).max (1)
				if sfx.lumpnum < 0 then
					sfx.lumpnum := i_main.i_sound.I_GetSfxLumpNum (sfx)
				end
				channels [cnum].pitch := pitch
				channels [cnum].handle := i_main.i_sound.I_StartSound (sfx, cnum, volume, sep, channels [cnum].pitch)
			end
		end

	S_GetChannel (origin: detachable MOBJ_T; sfxinfo: SFXINFO_T): INTEGER
			-- If none available, return -1. Otherwise channel #.
		local
			c: CHANNEL_T
			found: BOOLEAN
		do
				-- Find an open channel
			from
				Result := 0
			until
				found or Result > channels.upper
			loop
				if channels [Result].sfxinfo = Void then
					found := True
				elseif attached origin and then channels [Result].origin = origin then
					S_StopChannel (Result)
					found := True
				else
					Result := Result + 1
				end
			end

				-- None available
			if Result > channels.upper then
					-- Look for lower priority
				from
					Result := 0
					found := False
				until
					found or Result > channels.upper
				loop
					if attached channels [Result].sfxinfo as csfxinfo and then csfxinfo.priority >= sfxinfo.priority then
						found := True
					else
						Result := Result + 1
					end
				end
				if Result > channels.upper then
						-- No lower priority
					Result := -1
				else
						-- Otherwise, kick out lower priority
					S_StopChannel (Result)
				end
			end
			if Result /= -1 then
				c := channels [Result]

					-- channel is decided to be Result.
				c.sfxinfo := sfxinfo
				c.origin := origin
			end
		end

	S_StopSound (origin: detachable MOBJ_T)
		local
			cnum: INTEGER
			done: BOOLEAN
		do
			from
				cnum := 0
			until
				not done or cnum > channels.upper
			loop
				if channels [cnum].sfxinfo /= Void and channels [cnum].origin = origin then
					S_StopChannel (cnum)
					done := True
				end
				cnum := cnum + 1
			end
		end

	S_StartMusic (m_id: INTEGER)
		do
			S_ChangeMusic (m_id, False)
		end

	S_ChangeMusic (a_musicnum: INTEGER; looping: BOOLEAN)
		local
			music: MUSICINFO_T
			musicnum: INTEGER
			handle: ANY
		do
			musicnum := a_musicnum
				-- The DOOM IWAD file has two versions of the intro music: d_intro
				-- and d_introa. The latter is used for OPL playback.

			if musicnum = {SOUNDS_H}.mus_intro and (i_Main.i_sound.snd_musicdevice = {I_SOUND}.SNDDEVICE_ADLIB or i_main.i_sound.snd_musicdevice = {I_SOUND}.SNDDEVICE_SB) and i_main.w_wad.W_CheckNumForName ("D_INTROA") >= 0 then
				musicnum := {SOUNDS_H}.mus_introa
			end
			if musicnum <= {SOUNDS_H}.mus_None or musicnum >= {SOUNDS_H}.NUMMUSIC then
				{I_MAIN}.i_error ("Bad music number " + musicnum.out)
			else
				music := {SOUNDS_H}.S_music [musicnum]
			end
			check attached music as m then
				if mus_playing = m then
						-- return
				else
						-- shutdown old music
					S_StopMusic

						-- get lumpnum if neccessary
					if m.lumpnum = 0 then
						m.lumpnum := i_main.w_wad.W_GetNumForName ("d_" + m.name)
					end
					m.data := i_main.w_wad.W_CacheLumpNum (m.lumpnum, {Z_ZONE}.PU_STATIC)
					handle := i_main.i_sound.I_RegisterSong (m.data, i_main.w_wad.W_LumpLength (m.lumpnum))
					m.handle := handle
					i_main.i_sound.I_PlaySong (handle, looping)
					mus_playing := m
				end
			end
		end

	S_StopMusic
		do
			if attached mus_playing as m then
				if mus_paused then
					i_main.i_sound.I_ResumeSong
				end
				i_main.i_sound.I_StopSong
				i_main.i_sound.I_UnRegisterSong (m.handle)
				i_main.w_wad.W_ReleaseLumpNum (m.lumpnum)
				m.data := Void
				mus_playing := Void
			end
		end

	S_StopChannel (cnum: INTEGER)
			-- from chocolate doom
		local
			c: CHANNEL_T
			i: INTEGER
		do
			c := channels [cnum]
			if attached c.sfxinfo as sfxinfo then
					-- stop the sound playing
				if i_main.i_sound.I_SoundIsPlaying (c.handle) then
					i_main.i_sound.i_stopsound (c.handle)
				end

					-- check to see if other channels are playing the sound

				from
					i := 0
				until
					i > channels.upper or else (cnum /= i and c.sfxinfo = channels [i].sfxinfo)
				loop
					i := i + 1
				end

					-- degrade usefulness of sound data
				if attached c.sfxinfo as si then
					si.usefulness := si.usefulness - 1
				end
				c.sfxinfo := Void
				c.origin := Void
			end
		end

	S_AdjustSoundParams (listener: MOBJ_T; source: MOBJ_T; vol, sep: INTEGER_32_REF): BOOLEAN
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

	S_Start
			-- Per level startup code.
			-- Kills playing sounds at start of level,
			-- determines music if any, changes music.
		local
			cnum: INTEGER
			mnum: INTEGER
			spmus: ARRAY [INTEGER]
		do
				-- kill all playing sounds at start of level
				-- (trust me - a good idea)
			from
				cnum := 0
			until
				cnum >= numChannels
			loop
				if channels [cnum].sfxinfo /= Void then
					S_StopChannel (cnum)
				end
				cnum := cnum + 1
			end

				-- start new music for the level
			mus_paused := False
			if i_main.doomstat_h.gamemode = {GAME_MODE_T}.commercial then
				mnum := {SOUNDS_H}.mus_runnin + i_main.g_game.gamemap - 1
			else
				spmus := << --
					-- Song - Who? - Where?
				{SOUNDS_H}.mus_e3m4, -- American e4m1
 {SOUNDS_H}.mus_e3m2, -- Romero e4m2
 {SOUNDS_H}.mus_e3m3, -- Shawn e4m3
 {SOUNDS_H}.mus_e1m5, -- American e4m4
 {SOUNDS_H}.mus_e2m7, -- Tim 	e4m5
 {SOUNDS_H}.mus_e2m4, -- Romero	e4m6
 {SOUNDS_H}.mus_e2m6, -- J.Anderson	e4m7 CHIRON.WAD
 {SOUNDS_H}.mus_e2m5, -- Shawn	e4m8
 {SOUNDS_H}.mus_e1m9 -- Tim		e4m9
				>>
				if i_main.g_game.gameepisode < 4 then
					mnum := {SOUNDS_H}.mus_e1m1 + (i_main.g_game.gameepisode - 1) * 9 + i_main.g_game.gamemap - 1
				else
					mnum := spmus [i_main.g_game.gamemap - 1]
				end
			end
			S_ChangeMusic (mnum, True)
		end

end
