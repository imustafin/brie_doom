note
	description: "chocolate doom mus2mid, originally by Ben Ryves"
	license: "[
				Copyright (C) 1993-1996 by id Software, Inc.
				Copyright (C) 2005-2014 Simon Howard
				Copyright (C) 2006 Ben Ryves 2006
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
	MUS2MID

create
	make

feature

	NUM_CHANNELS: INTEGER = 16

	MIDI_PERCUSSION_CHAN: NATURAL_8 = 6

	MUS_PERCUSSION_CHAN: NATURAL_8 = 15

feature -- musevent, MUS event codes

	mus_releasekey: NATURAL_8 = 0x00

	mus_presskey: NATURAL_8 = 0x10

	mus_pitchwheel: NATURAL_8 = 0x20

	mus_systemevent: NATURAL_8 = 0x30

	mus_changecontroller: NATURAL_8 = 0x40

	mus_scoreend: NATURAL_8 = 0x60

feature -- midievent, MIDI event codes

	midi_releasekey: NATURAL_8 = 0x80

	midi_presskey: NATURAL_8 = 0x90

	midi_aftertouchkey: NATURAL_8 = 0xA0

	midi_changecontroller: NATURAL_8 = 0xB0

	midi_changepatch: NATURAL_8 = 0xC0

	midi_aftertouchchannel: NATURAL_8 = 0xD0

	midi_pitchwheel: NATURAL_8 = 0xE0

feature

		-- skip PACKED_STRUCT

feature

	write_midiheader
		do
			output.extend (('M').to_character_8.code.to_natural_8)
			output.extend (('T').to_character_8.code.to_natural_8)
			output.extend (('h').to_character_8.code.to_natural_8)
			output.extend (('d').to_character_8.code.to_natural_8)
				-- Header size
			output.extend (0)
			output.extend (0)
			output.extend (0)
			output.extend (0x06)
				-- Midi type (0)
			output.extend (0)
			output.extend (0)
				-- Number of tracks
			output.extend (0x00)
			output.extend (0x01)
				-- Resolution
			output.extend (0x00)
			output.extend (0x46)
				-- Start of track
			output.extend (('M').to_character_8.code.to_natural_8)
			output.extend (('T').to_character_8.code.to_natural_8)
			output.extend (('r').to_character_8.code.to_natural_8)
			output.extend (('k').to_character_8.code.to_natural_8)
				-- Placeholder for track length (4 bytes)
			output.extend (0x00)
			output.extend (0x00)
			output.extend (0x00)
			output.extend (0x00)
		end

	channelvelocities: ARRAY [NATURAL_8]
			-- Cached channel velocities
		do
			create Result.make_filled (127, 0, 15)
		end

	queuedtime: NATURAL_32
			-- Timestamps between sequences of MUS events

	controller_map: ARRAY [NATURAL_8]
		once
			create Result.make_filled (0, 0, 15 - 1)
			Result [0] := 0x00
			Result [1] := 0x20
			Result [2] := 0x01
			Result [3] := 0x07
			Result [4] := 0x0A
			Result [5] := 0x0B
			Result [6] := 0x5B
			Result [7] := 0x5D
			Result [8] := 0x40
			Result [9] := 0x43
			Result [10] := 0x78
			Result [11] := 0x7B
			Result [12] := 0x7E
			Result [13] := 0x7F
			Result [14] := 0x79
		end

	channel_map: ARRAY [INTEGER]
		once
			create Result.make_filled (-1, 0, NUM_CHANNELS - 1)
		end

feature

	WriteTime (a_time: NATURAL_32)
			-- Write timestamp to a MIDI file
		local
			buffer: NATURAL_32
			writeval: NATURAL_8
			done: BOOLEAN
			time: NATURAL_32
		do
			time := a_time
			from
				buffer := time & 0x7F
				time := time |>> 7
			until
				time = 0
			loop
				buffer := buffer |<< 8
				buffer := buffer | ((time & 0x7F) | 0x80)
				time := time |>> 7
			end
			from
				done := False
			until
				done
			loop
				writeval := buffer.to_natural_8 & 0xFF
				output.extend (writeval)

					-- return true if writing was not successful (when?)

				if buffer & 0x80 /= 0 then
					buffer := buffer |>> 8
				else
					queuedtime := 0
					done := True
				end
			end
		end

	WriteEndTrack
			-- Write the end of track marker
		do
			WriteTime (queuedtime)
			output.extend (0xFF)
			output.extend (0x2F)
			output.extend (0x00)
		end

	WritePressKey (channel, key, velocity: NATURAL_8)
			-- Write a key press event
		do
			WriteTime (queuedtime)
			output.extend (midi_presskey | channel)
			output.extend (key & 0x7F)
			output.extend (velocity & 0x7F)
		end

	WriteReleaseKey (channel, key: NATURAL_8)
			-- Write a key release event
		do
			WriteTime (queuedtime)
			output.extend (midi_releasekey | channel)
			output.extend (key & 0x7F)
			output.extend (0)
		end

	WritePitchWheel (channel: NATURAL_8; wheel: INTEGER_16)
			-- Write a pitch/bend event
		do
			WriteTime (queuedtime)
			output.extend (midi_pitchwheel | channel)
			output.extend ((wheel).to_natural_8 & 0x7F)
			output.extend ((wheel |>> 7).to_natural_8 & 0x7F)
		end

	WriteChangePatch (channel, patch: NATURAL_8)
			-- Write a patch change event
		do
			WriteTime (queuedtime)
			output.extend (midi_changepatch | channel)
			output.extend (patch & 0x7F)
		end

	WriteChangeController_Valued (channel, control, value: NATURAL_8)
			-- Write a valued controller change event
		local
			working: NATURAL_8
		do
			WriteTime (queuedtime)
			output.extend (midi_changecontroller | channel)
			output.extend (control & 0x7F)

				-- Quirk in vanilla DOOM? MUS controller values should be
				-- 7-bit, not 8-bit
			working := value

				-- Fix on said quirk to stop MIDI players from complaining
				-- that the value is out of range:
			if (working & 0x80) /= 0 then
				working := 0x7F
			end
			output.extend (working)
		end

	WriteChangeController_Valueless (channel, control: NATURAL_8)
			-- Write a valueless controller change event
		do
			WriteChangeController_Valued (channel, control, 0)
		end

feature

	AllocateMIDIChannel: NATURAL_8
			-- Allocate a free MIDI channel
		local
			max: INTEGER
			i: INTEGER
		do
				-- Find the current highest-allocated channel
			from
				max := -1
				i := 0
			until
				i >= NUM_CHANNELS
			loop
				if channel_map [i] > max then
					max := channel_map [i]
				end
				i := i + 1
			end

				-- max is now equal to the highest-allocated MIDI channel.
				-- We can now allocate the next available channel.
				-- This also works if no channels are currently allocated (max = -1)

			Result := (max + 1).as_natural_8

				-- Don't allocate the MIDI percussion channel!
			if Result = MIDI_PERCUSSION_CHAN then
				Result := Result + 1
			end
		ensure
			Result >= 0
			Result < NUM_CHANNELS
		end

	GetMIDIChannel (mus_channel: INTEGER): NATURAL_8
			-- Given a MUS channel number, get the MIDI channel number to use
			-- in the outputted file
		do
			if mus_channel = MUS_PERCUSSION_CHAN then
				Result := MIDI_PERCUSSION_CHAN
			else
					-- If a MIDI channel hasn't been allocated for this MUS channel yet,
					-- allocate the next free MIDI channel.
				if channel_map [mus_channel] = -1 then
					channel_map [mus_channel] := AllocateMIDIChannel

						-- First time using the channel, send an "all notes off"
						-- event. This fixes "The D_DDTBLU disease" described here:
						-- https://www.doomworld.com/vb/source-ports/66802-the
					WriteChangeController_Valueless (channel_map [mus_channel].as_natural_8, 0x7b)
				end
				Result := channel_map [mus_channel].as_natural_8
			end
		end

feature

	ReadMusHeader (header: MUSHEADER)
		do
			header.id [0] := read_natural_8
			header.id [1] := read_natural_8
			header.id [2] := read_natural_8
			header.id [3] := read_natural_8
			header.scorelength := read_natural_16
			header.scorestart := read_natural_16
			header.primarychannels := read_natural_16
			header.secondarychannels := read_natural_16
			header.instrumentcount := read_natural_16
		end

	mus2mid
			-- Read a MUS file from a stream (musinput) and output a MIDI file to
			-- a stream (midioutput)
		local
			musfileheader: MUSHEADER -- Header for the MUS file
			eventdescriptor: NATURAL_8
			hitscoreend: BOOLEAN -- Flag for when the score end marker is hit

			working: NATURAL_8 -- Temp working byte
			timedelay: NATURAL_32 -- Used in building up time delays

			eventdone: BOOLEAN -- did we hit eventdescriptor & 0x80
			timedone: BOOLEAN -- di we hit timedelay & 0x80
		do
			create musfileheader
			ReadMusHeader (musfileheader)

				-- skip CHECK_MUS_HEADER

				-- Seek to where the data is held
			pos := musfileheader.scorestart

				-- So, we can assume the MUS file is faintly legit.
				-- Let's start writing MIDI data...

			write_midiheader
			from
			until
				hitscoreend
			loop
					-- Handle a block of events
				from
					eventdone := False
				until
					hitscoreend or eventdone
				loop
					eventdescriptor := read_natural_8
					hitscoreend := read_event (eventdescriptor)
					if (eventdescriptor & 0x80) /= 0 then
						eventdone := True
					end
				end

					-- Now we need to read the time code:
				if not hitscoreend then
					from
						timedelay := 0
						timedone := False
					until
						timedone
					loop
						working := read_natural_8
						timedelay := timedelay * 128 + (working & 0x7F)
						if working & 0x80 = 0 then
							timedone := True
						end
					end
					queuedtime := queuedtime + timedelay
				end
			end
				-- End of track
			WriteEndTrack

				-- Write the track size into the stream
			output [19] := (tracksize |>> 24).to_natural_8 & 0xff
			output [20] := (tracksize |>> 16).to_natural_8 & 0xff
			output [21] := (tracksize |>> 8).to_natural_8 & 0xff
			output [22] := tracksize.to_natural_8 & 0xff
		end

	tracksize: NATURAL_32
		do
			Result := output.count.as_natural_32 - 22 -- midiheader length
		end

	read_event (eventdescriptor: NATURAL_8): BOOLEAN
			-- Read one event, return true if it was score end
		local
			channel: NATURAL_8 -- Channel number
			event: NATURAL_8
			key: NATURAL_8
			controllernumber: NATURAL_8
			controllervalue: NATURAL_8
		do
			channel := getmidichannel (eventdescriptor & 0x0F)
			event := eventdescriptor & 0x70
			if event = mus_releasekey then
				key := read_natural_8
				WriteReleaseKey (channel, key)
			elseif event = mus_presskey then
				key := read_natural_8
				if key & 0x80 /= 0 then
					channelvelocities [channel] := read_natural_8 & 0x7F
				end
				WritePressKey (channel, key, channelvelocities [channel])
			elseif event = mus_pitchwheel then
				key := read_natural_8
				WritePitchWheel (channel, key.to_integer_16 * 64)
			elseif event = mus_systemevent then
				controllernumber := read_natural_8
				check
					controllernumber >= 10 and controllernumber <= 14
				end
				WriteChangeController_Valueless (channel, controller_map [controllernumber])
			elseif event = mus_changecontroller then
				controllernumber := read_natural_8
				controllervalue := read_natural_8
				if controllernumber = 0 then
					WriteChangePatch (channel, controllervalue)
				else
					check
						controllernumber >= 1 and controllernumber <= 9
					end
					WriteChangeController_Valued (channel, controller_map [controllernumber], controllervalue)
				end
			elseif event = mus_scoreend then
				Result := True
			else
				{I_MAIN}.i_error ("Unknown event " + event.out)
			end
		end

feature

	make (a_input: MANAGED_POINTER)
		do
			create output.make (0)
			input := a_input
			pos := 0
		end

	fill_output
		do
			mus2mid
		end

	output: ARRAYED_LIST [NATURAL_8]

	input: MANAGED_POINTER

feature

	pos: INTEGER

	read_natural_16: NATURAL_16
		do
			Result := input.read_natural_16_le (pos)
			pos := pos + {PLATFORM}.integer_16_bytes
		end

	read_natural_8: NATURAL_8
		do
			Result := input.read_natural_8_le (pos)
			pos := pos + {PLATFORM}.character_8_bytes
		end

end
