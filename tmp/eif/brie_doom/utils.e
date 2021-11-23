note
	description: "Just utils"
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
	UTILS [G]

feature

	first_index (ar: ARRAY [G]; v: G): INTEGER
			-- First index of item `i = v` in `ar` or `ar.upper + 1` if not found
		do
			from
				Result := ar.lower
			until
				Result > ar.upper or else ar [Result] = v
			loop
				Result := Result + 1
			end
		ensure
			Result > ar.upper implies across ar as ari all ari.item /= v end
			Result /= ar.upper implies ar [Result] = v and across ar.subarray (ar.lower, Result - 1) as ari2 all ari2.item /= v end
			instance_free: class
		end

	all_different (ar: ARRAY [G]): BOOLEAN
		local
			i: INTEGER
		do
			Result := True
			from
				i := ar.lower
			until
				not Result or i > ar.upper
			loop
				Result := across ar.subarray (i + 1, ar.upper) as it all it.item /= Void implies it.item /= ar [i] end
				i := i + 1
			end
		ensure
			instance_free: class
			true_for_empty: ar.count = 0 implies Result
		end

	invariant_ref_array (ar: ARRAY [G]; count: INTEGER): BOOLEAN
			-- Lower is 0, count is correct, all references are different
		local
			i: INTEGER
		do
			Result := ar.lower = 0 and ar.count = count and all_different (ar)
		ensure
			lower_not_zero_gives_false: ar.lower /= 0 implies Result = False
			incorrect_count_gives_false: ar.count /= count implies Result = False
			not_all_different_gives_false: not all_different (ar) implies Result = False
			instance_free: class
		end

end
