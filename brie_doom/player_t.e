note
	description: "d_player.h"
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
	PLAYER_T

inherit

	POWERTYPE_T

create
	make

feature

	make
		local
			i: INTEGER
		do
			create psprites.make_filled (create {PSPDEF_T}, 0, {P_PSPR}.NUMPSPRITES - 1)
			from
				i := 0
			until
				i > psprites.upper
			loop
				psprites [i] := create {PSPDEF_T}
				i := i + 1
			end
			psprites.compare_objects
			create cards.make_filled (False, 0, {CARD_T}.numcards - 1)
			mo := Void
			playerstate := 0
			extralight := 0
			create frags.make_filled (0, 0, {DOOMDEF_H}.MAXPLAYERS - 1)
			killcount := 0
			secretcount := 0
			itemcount := 0
			fixedcolormap := 0
			health := 0
			refire := 0
			message := Void
			damagecount := 0
			bonuscount := 0
			viewheight := 0
			readyweapon := 0
			pendingweapon := 0
			viewz := 0
			create weaponowned.make_filled (False, 0, {WEAPONTYPE_T}.NUMWEAPONS - 1)
			create ammo.make_filled (0, 0, {AMMOTYPE_T}.NUMAMMO - 1)
			create maxammo.make_filled (0, 0, {AMMOTYPE_T}.NUMAMMO - 1)
			create cmd
			create powers.make_filled (0, 0, NUMPOWERS - 1)
		end

	reset
		do
			make
		ensure
				-- as_if_newly_created: Current.is_equal( create {PLAYER_T}.make)
		end

feature -- playerstate_t

	PST_LIVE: INTEGER = 0 -- Playing or camping.

	PST_DEAD: INTEGER = 1 -- Dead on the ground, view follows killer.

	PST_REBORN: INTEGER = 2 -- Ready to restart/respawn???

feature

	backpack: BOOLEAN assign set_backpack

	set_backpack (a_backpack: like backpack)
		do
			backpack := a_backpack
		end

	powers: ARRAY [INTEGER]

	bob: FIXED_T assign set_bob
			-- bounded/scaled total momentum

	deltaviewheight: FIXED_T assign set_deltaviewheight
			-- Bob/squat speed.

	set_deltaviewheight (a_deltaviewheight: like deltaviewheight)
		do
			deltaviewheight := a_deltaviewheight
		end

	set_bob (a_bob: like bob)
		do
			bob := a_bob
		end

	mo: detachable MOBJ_T assign set_mo

	set_mo (a_mo: like mo)
		do
			mo := a_mo
		end

	playerstate: INTEGER assign set_playerstate

	set_playerstate (a_playerstate: like playerstate)
		do
			playerstate := a_playerstate
		end

	extralight: INTEGER assign set_extralight -- So gun flashes light up areas

	set_extralight (a_extralight: like extralight)
		do
			extralight := a_extralight
		end

	frags: ARRAY [INTEGER]

	killcount: INTEGER assign set_killcount

	set_killcount (a_killcount: like killcount)
		do
			killcount := a_killcount
		end

	secretcount: INTEGER assign set_secretcount

	set_secretcount (a_secretcount: like secretcount)
		do
			secretcount := a_secretcount
		end

	itemcount: INTEGER assign set_itemcount

	set_itemcount (a_itemcount: like itemcount)
		do
			itemcount := a_itemcount
		end

	fixedcolormap: INTEGER assign set_fixedcolormap
			-- Current PLAYPAL, ???
			-- can be set to REDCOLORMAP for pain, etc.

	set_fixedcolormap (a_fixedcolormap: like fixedcolormap)
		do
			fixedcolormap := fixedcolormap
		end

	health: INTEGER assign set_health

	set_health (a_health: like health)
		do
			health := a_health
		end

	refire: INTEGER assign set_refire
			-- Refired shots are less accurate

	set_refire (a_refire: like refire)
		do
			refire := a_refire
		end

	message: detachable STRING assign set_message
			-- Hint messages

	set_message (a_message: like message)
		do
			message := a_message
		end

	damagecount: INTEGER assign set_damagecount

	set_damagecount (a_damagecount: like damagecount)
		do
			damagecount := a_damagecount
		end

	bonuscount: INTEGER assign set_bonuscount

	set_bonuscount (a_bonuscount: like bonuscount)
		do
			bonuscount := a_bonuscount
		end

	viewheight: FIXED_T assign set_viewheight
			-- Base height above floor for viewz

	set_viewheight (a_viewheight: like viewheight)
		do
			viewheight := a_viewheight
		end

	psprites: ARRAY [PSPDEF_T]
			-- Overlay view sprites (gun, etc.)

	readyweapon: INTEGER assign set_readyweapon

	set_readyweapon (a_readyweapon: like readyweapon)
		do
			readyweapon := a_readyweapon
		end

	pendingweapon: INTEGER assign set_pendingweapon
			-- Is wp_nochange if not changing

	set_pendingweapon (a_pendingweapon: like pendingweapon)
		do
			pendingweapon := a_pendingweapon
		end

	cards: ARRAY [BOOLEAN]

	attackdown: BOOLEAN assign set_attackdown
			-- originally int, True if button down last tic.

	set_attackdown (a_attackdown: like attackdown)
		do
			attackdown := a_attackdown
		end

	usedown: BOOLEAN assign set_usedown
			-- originally int, True if button down last tic.

	set_usedown (a_usedown: like usedown)
		do
			usedown := a_usedown
		end

	weaponowned: ARRAY [BOOLEAN]

	ammo: ARRAY [INTEGER]

	maxammo: ARRAY [INTEGER]

	cmd: TICCMD_T

	cheats: INTEGER
			-- Bit flags, for cheats and debug.

	didsecret: BOOLEAN assign set_didsecret
			-- True if secret level has been done.

	set_didsecret (a_didsecret: like didsecret)
		do
			didsecret := a_didsecret
		end

	armortype: INTEGER assign set_armortype
			-- Armor type is 0-2

	set_armortype (a_armortype: like armortype)
		do
			armortype := a_armortype
		end

	armorpoints: INTEGER assign set_armorpoints

	set_armorpoints (a_armorpoints: like armorpoints)
		do
			armorpoints := a_armorpoints
		end

	attacker: detachable MOBJ_T assign set_attacker
			-- Who did damage (NULL for floors/ceilings).

	set_attacker (a_attacker: like attacker)
		do
			attacker := a_attacker
		end

feature -- POV

	viewz: FIXED_T assign set_viewz -- Focal origin above r.z

	set_viewz (a_viewz: like viewz)
		do
			viewz := a_viewz
		end

invariant
	psprites.lower = 0
	psprites.count = {P_PSPR}.NUMPSPRITES
	psprites.object_comparison
	cards.lower = 0
	cards.count = {CARD_T}.NUMCARDS
	weaponowned.lower = 0
	weaponowned.count = {WEAPONTYPE_T}.NUMWEAPONS
	ammo.lower = 0
	ammo.count = {AMMOTYPE_T}.NUMAMMO
	maxammo.lower = 0
	maxammo.count = {AMMOTYPE_T}.NUMAMMO
	powers.lower = 0 and powers.count = NUMPOWERS

end
