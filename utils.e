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

end
