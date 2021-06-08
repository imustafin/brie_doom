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

	invariant_ref_array (ar: ARRAY [G]; count: INTEGER): BOOLEAN
			-- Lower is 0, count is correct, all references are different
		local
			i: INTEGER
		do
			Result := ar.lower = 0 and ar.count = count
			from
				i := 0
			until
				not Result or i >= ar.count
			loop
				Result := across ar.subarray (i + 1, ar.upper) as it all it.item /= Void implies it.item /= ar [i] end
				i := i + 1
			end
		ensure
			lower_not_zero_gives_false: ar.lower /= 0 implies Result = False
			incorrect_count_gives_false: ar.count /= count implies Result = False
			instance_free: class
		end
end
