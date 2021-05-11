note
	description: "[
		p_spr.c
		Weapon sprite animation, weapon objects.
		Action functions for weapons.
	]"

class
	P_SPR

feature

	A_Light0 (player: PLAYER_T; psp: PSPDEF_T)
		do
			player.extralight := 0
		ensure
			instance_free: class
		end

	A_Lower (player: PLAYER_T; psp: PSPDEF_T)
			-- Lowers current weapon,
			-- and changes weapon at bottom.
		do
				-- Stub
		end

	A_Punch (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_Refire (player: PLAYER_T; psp: PSPDEF_T)
			-- The player can re-fire the weapon
			-- without lowering it entirely.
		do
				-- Stub
		end

	A_FirePistol (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_Light1 (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_Light2 (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_FireShotgun (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_FireShotgun2 (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_CheckReload (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_FireCGun (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_GunFlash (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_FireMissile (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_Saw (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_FirePlasma (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_BFGSound (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_FireBFG (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_BFGSpray (mo: MOBJ_T)
			-- Spawn a BFG explosion on every monster in view
		do
				-- Stub
		end

end
