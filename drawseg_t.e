note
	description: "drawseg_t from r_defs.h"

class
	DRAWSEG_T

create
	make

feature

	make
		do
		end

feature

	curline: detachable SEG_T assign set_curline

	set_curline (a_curline: like curline)
		do
			curline := a_curline
		end

	x1: INTEGER assign set_x1

	set_x1 (a_x1: like x1)
		do
			x1 := x1
		end

	x2: INTEGER assign set_x2

	set_x2 (a_x2: like x2)
		do
			x2 := a_x2
		end

	scale1: FIXED_T assign set_scale1

	set_scale1 (a_scale1: like scale1)
		do
			scale1 := a_scale1
		end

	scale2: FIXED_T assign set_scale2

	set_scale2 (a_scale2: like scale2)
		do
			scale2 := a_scale2
		end

	scalestep: FIXED_T assign set_scalestep

	set_scalestep (a_scalestep: like scalestep)
		do
			scalestep := a_scalestep
		end

	silhouette: INTEGER assign set_silhouette
			-- 0=none, 1=bottom, 2=top, 3=both

	set_silhouette (a_silhouette: like silhouette)
		do
			silhouette := a_silhouette
		end

	bsilheight: FIXED_T assign set_bsilheight
			-- do not clip sprites above this

	set_bsilheight (a_bsilheight: like bsilheight)
		do
			bsilheight := a_bsilheight
		end

	tsilheight: FIXED_T assign set_tsilheight
			-- do not clip sprites below this

	set_tsilheight (a_tsilheight: like tsilheight)
		do
			tsilheight := a_tsilheight
		end

		-- Pointers to lists for sprite clipping
		-- all three adjusted so [x1] is first value

	sprtopclip: detachable INDEX_IN_ARRAY[INTEGER_16] assign set_sprtopclip

	set_sprtopclip (a_sprtopclip: like sprtopclip)
		do
			sprtopclip := a_sprtopclip
		end

	sprbottomclip: detachable INDEX_IN_ARRAY [INTEGER_16] assign set_sprbottomclip

	set_sprbottomclip (a_sprbottomclip: like sprbottomclip)
		do
			sprbottomclip := a_sprbottomclip
		end

	maskedtexturecol: detachable INDEX_IN_ARRAY[INTEGER_16] assign set_maskedtexturecol

	set_maskedtexturecol (a_maskedtexturecol: like maskedtexturecol)
		do
			maskedtexturecol := a_maskedtexturecol
		end

end
