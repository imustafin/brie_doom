note
	description: "chocolate doom mus2mid.c"
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
	MUSHEADER

feature

	id: ARRAY [NATURAL_8]
		once
			create Result.make_filled (0, 0, 3)
		end

	scorelength: NATURAL_16 assign set_scorelength

	set_scorelength (a_scorelength: like scorelength)
		do
			scorelength := a_scorelength
		end

	scorestart: NATURAL_16 assign set_scorestart

	set_scorestart (a_scorestart: like scorestart)
		do
			scorestart := a_scorestart
		end

	primarychannels: NATURAL_16 assign set_primarychannels

	set_primarychannels (a_primarychannels: like primarychannels)
		do
			primarychannels := a_primarychannels
		end

	secondarychannels: NATURAL_16 assign set_secondarychannels

	set_secondarychannels (a_secondarychannels: like secondarychannels)
		do
			secondarychannels := a_secondarychannels
		end

	instrumentcount: NATURAL_16 assign set_instrumentcount

	set_instrumentcount (a_instrumentcount: like instrumentcount)
		do
			instrumentcount := a_instrumentcount
		end

end
