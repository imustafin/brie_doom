note
	description: "[
		w_wad.c
		Handles WAD file header, directory, lump I/O.
	]"
	license: "[
		Copyright (C) 1993-1996 by id Software, Inc.
		Copyright (C) 2005-2014 Simon Howard
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
	W_WAD

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: like i_main)
		do
			i_main := a_i_main
		end

feature

	reloadname: detachable STRING

	reloadlump: INTEGER

feature

	lumpinfo: detachable ARRAY [LUMPINFO_T]

	lumpcache: detachable ARRAY [detachable MANAGED_POINTER]

feature

	W_InitMultipleFiles (a_filenames: LIST [STRING])
		do
			create lumpinfo.make_empty
			across
				a_filenames as filename
			loop
				W_AddFile (filename.item)
			end
			check attached lumpinfo as li then
				if li.is_empty then
					i_main.i_error ("W_InitFiles: no files found")
				end
				create lumpcache.make_filled (Void, 0, li.count)
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
			l_storehandle: detachable RAW_FILE
			start: INTEGER
		do
			if a_filename.starts_with ("~") then
				reloadname := a_filename.tail (a_filename.count - 1)
				check attached lumpinfo as li then
					reloadlump := li.count
				end
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
					-- copy l_fileinfo to lumpinfo
				check attached lumpinfo as l_lumpinfo then
					from
						i := 1 -- l_fileinfo is 1-indexed
						start := l_lumpinfo.upper
						l_lumpinfo.conservative_resize_with_default (create {LUMPINFO_T}.make ("UNUSED", Void, 0, 0), 0, l_lumpinfo.upper + l_fileinfo.count)
					until
						i > l_fileinfo.upper
					loop
						check attached lumpinfo as li then
							li [start + i - 1] := create {LUMPINFO_T}.make (l_fileinfo [i].name, l_storehandle, l_fileinfo [i].filepos, l_fileinfo [i].size)
						end
						i := i + 1
					end
				end
			end
		ensure
			attached lumpinfo as li and then {UTILS [LUMPINFO_T]}.all_different (li)
		end

	ExtractFileBase (a_filename: STRING): STRING
			-- Should return filename base with <= 8 chars
		local
			i: INTEGER
		do
			Result := ""
				-- back up until a \ or the start
			from
				i := a_filename.count
			until
				i = 1 or else (a_filename [i - 1] = '/' or a_filename [i - 1] = '\')
			loop
				i := i - 1
			end
			from
			until
				i > a_filename.count or else a_filename [i] = '.'
			loop
				Result.append_character (a_filename [i].as_upper)
				i := i + 1
			end
		ensure
			no_separators: not Result.has ('/') and not Result.has ('\')
			no_dots: not Result.has ('.')
			uppercase: Result.as_upper ~ Result
			substring: a_filename.as_upper.has_substring (Result)
			instance_free: class
		end

	W_CheckNumForName (name: STRING): INTEGER
			-- Returns -1 if name not found
		do
			check attached lumpinfo as li then
				from
					Result := li.upper
				until
					Result < 0 or else li [Result].name.is_case_insensitive_equal (name)
				loop
					Result := Result - 1
				end
			end
		ensure
			minus_one_if_not_present: attached lumpinfo as li and then across li as l all not l.item.name.is_case_insensitive_equal (name) end implies Result = -1
			index_if_present: Result > -1 implies attached lumpinfo as li and then li [Result].name.is_case_insensitive_equal (name)
		end

	W_CacheLumpName (name: STRING): MANAGED_POINTER
		do
			Result := W_CacheLumpNum (W_GetNumForName (name))
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

	W_CacheLumpNum (lump: INTEGER): MANAGED_POINTER
		do
			check attached lumpinfo as li then
				if lump > li.count then
					i_main.i_error ("W_CacheLumpNum: " + lump.out + " >= numlumps")
				end
			end
			if attached lumpcache as lc and then attached lc [lump] as l then
				Result := l
			else
					-- skip byte* ptr = Z_Malloc(W_LumpLength(lump), tag, &lumpcache[lump]);
				Result := W_ReadLump (lump)
				check attached lumpcache as lc then
					lc [lump] := Result
				end
			end
		ensure
			Result.count = W_LumpLength (lump)
		end

	W_LumpLength (lump: INTEGER): INTEGER
		do
			check attached lumpinfo as li then
				if lump > li.count then
					i_main.i_error ("W_LumpLength: " + lump.out + " >= numlumps")
				end
				Result := li [lump].size
			end
		end

	W_ReadLump (lump: INTEGER): MANAGED_POINTER
			-- Loads the lump and returns it
			-- (originally wrote to a given buffer which must be >= W_LumpLength)
		local
			l: LUMPINFO_T
			handle: RAW_FILE
		do
			check attached lumpinfo as li then
				if lump > li.upper then
					i_main.i_error ("W_ReadLump: " + lump.out + " >= numlumps")
				end
				l := li [lump]
			end

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

	W_ReleaseLumpNum (lump: INTEGER)
		do
				{NOT_IMPLEMENTED}.not_implemented ("W_ReleaseLumpNum", False)
		end

	W_Reload
		do
			if reloadname /= Void then
				{NOT_IMPLEMENTED}.not_implemented ("W_Reload", true)
			end
		end

end
