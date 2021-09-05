note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_FIXED_T

inherit

	EQA_TEST_SET

feature -- Test routines

	test_abs_ref2_of_negative
		note
			testing: "covers/{FIXED_T}.abs_ref2"
		local
			x, y: FIXED_T
		do
			x := -1
			y := x.abs
			assert ("equal to positive", y = 1)
			assert ("not equal to negative", y /= -1)
		end

	test_abs_ref2_of_positive
		note
			testing: "covers/{FIXED_T}.abs_ref2"
		local
			x, y: FIXED_T
		do
			x := 1
			y := x.abs
			assert ("equal to positive", y = 1)
			assert ("not equal to negative", y /= -1)
			assert ("equal to original", x = y)
		end

end
