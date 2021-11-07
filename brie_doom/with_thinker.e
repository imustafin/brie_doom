note
	description: "Interface for classes having thinker"
	license: "[
		Copyright (C) 1993-1996 by id Software, Inc.
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

deferred class
	WITH_THINKER

feature

	thinker: THINKER_T assign set_thinker

	set_thinker (a_thinker: like thinker)
		do
			thinker := a_thinker
		end

feature

	make_thinker
		do
			create thinker.make
		end

end