note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_W_WAD

inherit

	EQA_TEST_SET

feature -- Test ExtractFileBase

	test_file_base_of_bare_path_is_same
		do
			assert("same string uppercase", "DOOM1" ~ {W_WAD}.ExtractFileBase("doom1.wad"))
		end

	test_file_base_of_subdir_is_strips_path
		do
			assert("only base", "P1M1-897" ~ {W_WAD}.ExtractFileBase("./demos/p1m1-897/p1m1-897.lmp"))
		end

end
