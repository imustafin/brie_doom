note
	description: "Utility class to read WAD contents"
	license: "[
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
	WAD_READER

feature

	read_array_integer_16 (m: MANAGED_POINTER): ARRAY [INTEGER_16]
		require
			divisible_by_integer_16_size: m.count \\ 2 = 0
		local
			i: INTEGER
		do
			create Result.make_filled (0, 0, m.count // 2 - 1)
			from
				i := 0
			until
				i > Result.upper
			loop
				Result [i] := m.read_integer_16_le (i * 2)
				i := i + 1
			end
		ensure
			instance_free: class
			Result.lower = 0
			Result.count = m.count // 2
		end

end
