note
	description: "Buffer of pixel_t pixels"

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

	copy_from(other: PIXEL_T_BUFFER)
		require
			p.count = other.p.count
		do
			p.item.memory_copy (other.p.item, p.count)
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
		do
			p.put_natural_8 (v, i * pixel_t_size)
		end

	put_dpixel(v: NATURAL_16; i: INTEGER)
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