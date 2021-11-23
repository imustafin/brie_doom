note
	description: "Utils to make ref arrays"
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
	REF_ARRAY_CREATOR [G -> ANY create default_create end]

feature

	make_ref_array (count: INTEGER): ARRAY [G]
		local
			i: INTEGER
		do
			create Result.make_filled (create {G}, 0, count - 1)
			from
				i := 0
			until
				i = count
			loop
				Result [i] := create {G}
				i := i + 1
			end
		ensure
			instance_free: class
			{UTILS [G]}.invariant_ref_array (Result, count)
		end

end
