note
	description: "Buffer of pixel_t pixels"
	license: "[
				Copyright (C) 1993-1996 by id Software, Inc.
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
	PIXEL_T_BUFFER

create
	make, share_from_pointer

feature

	make (num_pixels: INTEGER)
			-- Allocate new memory for `num_pixels` pixels
		do
			create p.make (num_pixels * pixel_t_size)
		end

	share_from_pointer (a_pointer: POINTER; len: INTEGER)
			-- Share from pointer, `len` is in bytes
		do
			create p.share_from_pointer (a_pointer, len)
		end

feature

	p: MANAGED_POINTER

feature

	fill_zero
		do
			p.item.memory_set (0, p.count)
		end

	copy_from (other: PIXEL_T_BUFFER)
		require
			p.count = other.p.count
		do
			copy_from_count (other, p.count)
		end

	copy_from_count (other: PIXEL_T_BUFFER; count: INTEGER)
		require
			p.count >= count
			other.p.count >= count
		do
			p.item.memory_copy (other.p.item, count)
		end

feature

	plus alias "+" (offset: INTEGER): PIXEL_T_BUFFER
		require
			offset >= 0
		do
			create Result.share_from_pointer (p.item + offset, p.count - offset)
		end

feature

	item_dpixel (i: INTEGER): NATURAL_16
		do
			Result := p.read_natural_16 (i * dpixel_t_size)
		end

	item (i: INTEGER): NATURAL_8
		do
			Result := p.read_natural_8 (i * pixel_t_size)
		end

	put (v: NATURAL_8; i: INTEGER)
			-- put i-th pixel
		do
			p.put_natural_8 (v, i * pixel_t_size)
		end

	put_dpixel (v: NATURAL_16; i: INTEGER)
		do
			p.put_natural_16 (v, i * dpixel_t_size)
		end

feature

	pixel_t_size: INTEGER
			-- Get actual C size of pixel_t (which is typedef uint8_t pixel_t)
		external
			"C inline"
		alias
			"sizeof (uint8_t)"
		ensure
			instance_free: class
		end

	dpixel_t_size: INTEGER
			-- Get actual C size of dpixel_t (which is typedef uint16_t dpixel_t)
		external
			"C inline"
		alias
			"sizeof (uint16_t)"
		ensure
			instance_free: class
		end

invariant
	pixel_t_correct_type: pixel_t_size = {MANAGED_POINTER}.natural_8_bytes
	dpixel_t_correct_type: dpixel_t_size = {MANAGED_POINTER}.natural_16_bytes

end
