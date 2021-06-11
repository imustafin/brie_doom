note
	description: "Just utils"

class
	UTILS [G]

feature

	first_index (ar: ARRAY [G]; v: G): INTEGER
		do
			from
				Result := ar.lower
			until
				Result = ar.upper or else ar [Result] = v
			loop
				Result := Result + 1
			end
		ensure
			Result = ar.upper implies across ar as ari all ari.item /= v end
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
