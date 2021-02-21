note
	description: "[
		w_wad.c
		Handles WAD file header, directory, lump I/O.
	]"

class
	W_WAD

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
			create lumpinfo.make (0)
		end

feature

	lumpinfo: ARRAYED_LIST [LUMPINFO_T]

feature

	W_InitMultipleFiles (a_filenames: LIST [STRING])
		do
			across
				a_filenames as filename
			loop
				W_AddFile (filename.item)
			end
		end

	W_AddFile (a_filename: STRING)
			--	// W_AddFile
			--// All files are optional, but at least one file must be
			--//  found (PWAD, if all required lumps are present).
			--// Files with a .wad extension are wadlink files
			--//  with multiple lumps.
			--// Other files are single lumps with the base filename
			--//  for the lump name.
			--//
			--// If filename starts with a tilde, the file is handled
			--//  specially to allow map reloads.
			--// But: the reload feature is a fragile hack...
		local
			l_file: RAW_FILE
			l_fileinfo: ARRAYED_LIST [FILELUMP_T]
			l_header: WADINFO_T
			i: INTEGER
		do
			if a_filename.starts_with ("~") then
				print ("~ wads not supprted yet%N")
				(create {DEVELOPER_EXCEPTION}).raise
			end
			create l_file.make_open_read (a_filename)
			if not l_file.exists then
				print (" could not open " + a_filename + "%N")
			else
				print (" adding " + a_filename + "%N")
				if not a_filename.ends_with ("wad") then
					create l_fileinfo.make (1)
					l_fileinfo.extend (create {FILELUMP_T}.make (0, l_file.file_info.size, ExtractFileBase (a_filename)))
				else
						-- WAD file
					create l_header.read_bytes (l_file)
					if not l_header.identification.starts_with ("IWAD") then
						if not l_header.identification.starts_with ("PWAD") then
							{I_MAIN}.i_error ("Wad file " + a_filename + " doesn't have IWAD or PWAD id%N")
						end
					end
					l_file.go (l_header.infotableofs)
					from
						i := 0
						create l_fileinfo.make (l_header.numlumps)
					until
						i >= l_header.numlumps
					loop
						l_fileinfo.extend (create {FILELUMP_T}.read_bytes (l_file))
						i := i + 1
					end
				end
				across
					l_fileinfo as fileinfo
				loop
					lumpinfo.extend (create {LUMPINFO_T}.make (fileinfo.item.name, -1, fileinfo.item.filepos, fileinfo.item.size))
				end
			end
		end

	ExtractFileBase (a_filename: STRING): STRING
			-- Should return filename base with <= 8 chars
		do
				-- Stub
			Result := a_filename
		end

	W_CheckNumForName (name: STRING): INTEGER
		do
				-- Stub
		end

	W_CacheLumpName (name: STRING; tag: INTEGER): PATCH_T -- originally returned void*
		do
			Result := W_CacheLumpNum (W_GetNumForName (name), tag)
		end

	W_GetNumForName (name: STRING): INTEGER
		do
			Result := W_CheckNumForName (name)
			if Result = -1 then
				i_main.i_error ("W_GetNumForName: " + name + " not found!")
			end
		end

	W_CacheLumpNum (lump: INTEGER; tag: INTEGER): PATCH_T -- originally returned void*
		do
				-- Stub
			create Result.make
		end

end
