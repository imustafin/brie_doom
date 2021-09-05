note
	description: "Utils to make ref arrays"

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
