note
	description: "Summary description for {TEST_NUMBER_CONVERSIONS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_NUMBER_CONVERSIONS

inherit

	EQA_TEST_SET

feature

	neg_int_to_natural
		local
			int: INTEGER
			nat: NATURAL
		do
			int := -1
			nat := int.to_natural_32
			assert ("same bits", int.to_hex_string ~ nat.to_hex_string)
		end

	neg_int_as_natural
		local
			int: INTEGER
			nat: NATURAL
		do
			int := -1
			nat := int.as_natural_32
			print(int.to_hex_string + "%N")
			print(nat.to_hex_string + "%N")
			assert ("same bits", int.to_hex_string ~ nat.to_hex_string)
		end

end
