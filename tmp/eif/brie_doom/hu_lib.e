note
	description: "[
		hu_lib.c
		heads-up text and input code
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
	HU_LIB

create
	make

feature

	make
		do
		end

feature

	HUlib_eraseSText (s: HU_STEXT_T)
		do
			{NOT_IMPLEMENTED}.not_implemented ("HUlib_eraseSText", False)
		end

	HUlib_eraseIText (it: HU_ITEXT_T)
		do
			{NOT_IMPLEMENTED}.not_implemented ("HUlib_erasIText", False)
		end

	HUlib_eraseTextLine (l: HU_TEXTLINE_T)
			-- sorta called by HU_Erase and just better darn get things straight
		do
			{NOT_IMPLEMENTED}.not_implemented ("HUlib_eraseTextLine", False)
		end

end
