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
			create lumpcache.make (0)
		end

feature

	reloadname: detachable STRING

	reloadlump: INTEGER

feature

	lumpinfo: ARRAYED_LIST [LUMPINFO_T] -- indexed from 1

	lumpcache: ARRAYED_LIST [detachable MANAGED_POINTER] -- indexed from 1

feature

	W_InitMultipleFiles (a_filenames: LIST [STRING])
		do
				-- skip numlumps = 0;
				-- skip lumpinfo = malloc(1);

			across
				a_filenames as filename
			loop
				W_AddFile (filename.item)
			end
			if lumpinfo.is_empty then
				i_main.i_error ("W_InitFiles: no files found")
			end

				-- set up caching
				-- skip int size = numlumps * sizeof(*lumpcache)

				-- lumpcache = malloc(size);
				-- memset(lumpcache, 0, size);
			create lumpcache.make_filled (lumpinfo.count)
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
			l_storehandle: detachable RAW_FILE
		do
			if a_filename.starts_with ("~") then
				reloadname := a_filename.tail (a_filename.count - 1)
				reloadlump := lumpinfo.count
			end
			create l_file.make_open_read (a_filename)
			if not l_file.is_open_read then
				print (" could not open " + a_filename + "%N")
			else
				print (" adding " + a_filename + "%N")
				if not a_filename.as_upper.ends_with ("WAD") then
					create l_fileinfo.make (1)
					l_fileinfo.extend (create {FILELUMP_T}.make (0, l_file.file_info.size, ExtractFileBase (a_filename)))
				else
						-- WAD file
					create l_header.read_bytes (l_file)
					if not l_header.identification.as_upper.starts_with ("IWAD") then
						if not l_header.identification.as_upper.starts_with ("PWAD") then
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
				l_storehandle := if attached reloadname then Void else l_file end
				across
					l_fileinfo as fileinfo
				loop
					lumpinfo.extend (create {LUMPINFO_T}.make (fileinfo.item.name, l_storehandle, fileinfo.item.filepos, fileinfo.item.size))
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
			-- Returns -1 if name not found
		do
			from
				Result := lumpinfo.upper
			until
				Result <= 0 or else lumpinfo [Result].name ~ name
			loop
				Result := Result - 1
			end
			Result := Result - 1
		ensure
			minus_one_if_not_present: across lumpinfo as l all l.item.name /~ name end implies Result = -1
			index_if_present: Result > -1 implies lumpinfo [Result + 1].name ~ name
		end

	W_CacheLumpName (name: STRING; tag: INTEGER): MANAGED_POINTER
		do
			Result := W_CacheLumpNum (W_GetNumForName (name), tag)
		ensure
			Result.count = W_LumpLength (W_GetNumForName (name))
		end

	W_GetNumForName (name: STRING): INTEGER
		do
			Result := W_CheckNumForName (name)
			if Result = -1 then
				i_main.i_error ("W_GetNumForName: " + name + " not found!")
			end
		end

	W_CacheLumpNum (lump: INTEGER; tag: INTEGER): MANAGED_POINTER
		do
			if lump >= lumpinfo.count then
				i_main.i_error ("W_CacheLumpNum: " + lump.out + " >= numlumps")
			end
			if attached lumpcache [lump + 1] as l then
				Result := l
			else
					-- skip byte* ptr = Z_Malloc(W_LumpLength(lump), tag, &lumpcache[lump]);
				Result := W_ReadLump (lump)
				lumpcache [lump + 1] := Result
			end
		ensure
			Result.count = W_LumpLength (lump)
		end

	W_LumpLength (lump: INTEGER): INTEGER
		do
			if lump >= lumpinfo.count then
				i_main.i_error ("W_LumpLength: " + lump.out + " >= numlumps")
			end
			Result := lumpinfo [lump + 1].size
		end

	W_ReadLump (lump: INTEGER): MANAGED_POINTER
			-- Loads the lump and returns it
			-- (originally wrote to a given buffer which must be >= W_LumpLength)
		local
			l: LUMPINFO_T
			handle: RAW_FILE
		do
			if lump >= lumpinfo.count then
				i_main.i_error ("W_ReadLump: " + lump.out + " >= numlumps")
			end
			l := lumpinfo [lump + 1]

				-- ??? I_BeginRead ();

			if not attached l.handle then
				check attached reloadname as rn then
					create handle.make_open_read (rn)
					if not handle.is_open_read then
						i_main.i_error ("W_ReadLump: couldn't open " + rn)
					end
				end
			else
				handle := l.handle
			end
			check handle /= Void then
				handle.go (l.position)
				create Result.make (l.size)
				handle.read_to_managed_pointer (Result, 0, l.size)
				if not attached l.handle then
					handle.close
				end
			end

				-- ??? I_EndRead ();
		ensure
			Result.count = W_LumpLength (lump)
		end

end
