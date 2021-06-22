note
	description: "[
		p_enemy.c
		Enemy thinking, AI.
		Action Pointer Functions
		that are associated with states/frames
	]"

class
	P_ENEMY

create
	make

feature

	i_main: I_MAIN

	make (a_i_main: I_MAIN)
		do
			i_main := a_i_main
		end

feature

	soundtarget: detachable MOBJ_T

	P_NoiseAlert (target, emitter: MOBJ_T)
			-- If a monster yells at a player,
			-- it will alert other monsters to the player.
		do
			soundtarget := target
			i_main.r_main.validcount := i_main.r_main.validcount + 1
			check attached emitter.subsector as sub and then attached sub.sector as s then
				P_RecursiveSound (s, 0)
			end
		end

	P_RecursiveSound (sec: SECTOR_T; soundblocks: INTEGER)
			-- Called by P_NoiseAlert
			-- Recursively traverse adjacent sectors,
			-- sound blocking lines cut off traversal.
		local
			i: INTEGER
			c: LINE_T
			other: SECTOR_T
		do
				-- wake up all monsters in this sector
			if sec.validcount = i_main.r_main.validcount and sec.soundtraversed <= soundblocks + 1 then
					-- return. already flooded
			else
				sec.validcount := i_main.r_main.validcount
				sec.soundtraversed := soundblocks + 1
				sec.soundtarget := soundtarget
				from
					i := sec.lines.lower
				until
					i > sec.lines.upper
				loop
					c := sec.lines [i]
					if c.flags & {DOOMDATA_H}.ML_TWOSIDED = 0 then
							-- continue
					else
						i_main.p_maputl.P_LineOpening (c)
						if i_main.p_maputl.openrange <= 0 then
								-- continue. closed door
						else
							if i_main.p_setup.sides [c.sidenum [0]].sector = sec then
								other := i_main.p_setup.sides [c.sidenum [1]].sector
							else
								other := i_main.p_setup.sides [c.sidenum [0]].sector
							end
							if c.flags & {DOOMDATA_H}.ML_SOUNDBLOCK /= 0 then
								check attached other then
									if soundblocks = 0 then
										P_RecursiveSound (other, 1)
									else
										P_RecursiveSound (other, soundblocks)
									end
								end
							end
						end
					end
					i := i + 1
				end
			end
		end

feature

	A_OpenShotgun2 (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_LoadShotgun2 (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_CloseShotgun2 (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
		end

	A_Explode (thingy: MOBJ_T)
		do
				-- Stub
		end

	A_Pain (actor: MOBJ_T)
		do
				-- Stub
		end

	A_PlayerScream (mo: MOBJ_T)
		do
				-- Stub
		end

	A_Fall (actor: MOBJ_T)
		do
				-- Stub
		end

	A_XScream (actor: MOBJ_T)
		do
				-- Stub
		end

	A_Look (actor: MOBJ_T)
			-- Stay in state until a player is sighted
		do
				-- Stub
		end

	A_Chase (actor: MOBJ_T)
			-- Actor has a melee attack,
			-- so it tries to close as fast as possible
		do
				-- Stub
		end

	A_FaceTarget (actor: MOBJ_T)
		do
				-- Stub
		end

	A_PosAttack (actor: MOBJ_T)
		do
				-- Stub
		end

	A_Scream (actor: MOBJ_T)
		do
				-- Stub
		end

	A_SPosAttack (actor: MOBJ_T)
		do
				-- Stub
		end

	A_VileChase (actor: MOBJ_T)
			-- Check for resurrecting a body
		do
				-- Stub
		end

	A_VileStart (actor: MOBJ_T)
		do
				-- Stub
		end

	A_VileTarget (actor: MOBJ_T)
			-- Spawn the hellfire
		do
				-- Stub
		end

	A_VileAttack (actor: MOBJ_T)
		do
				-- Stub
		end

	A_StartFire (actor: MOBJ_T)
		do
				-- Stub
		end

	A_Fire (actor: MOBJ_T)
			-- Keep fire in front of player unless out of sight
		do
				-- Stub
		end

	A_FireCrackle (actor: MOBJ_T)
		do
				-- Stub
		end

	A_Tracer (actor: MOBJ_T)
		do
				-- Stub
		end

	A_SkelWhoosh (actor: MOBJ_T)
		do
				-- Stub
		end

	A_SkelFist (actor: MOBJ_T)
		do
				-- Stub
		end

	A_SkelMissile (actor: MOBJ_T)
		do
				-- Stub
		end

	A_FatRaise (actor: MOBJ_T)
		do
				-- Stub
		end

	A_FatAttack1 (actor: MOBJ_T)
		do
				-- Stub
		end

	A_FatAttack2 (actor: MOBJ_T)
		do
				-- Stub
		end

	A_FatAttack3 (actor: MOBJ_T)
		do
				-- Stub
		end

	A_BossDeath (mo: MOBJ_T)
			-- Possibly trigger special effects
			-- if on first boss level
		do
				-- Stub
		end

	A_CPosAttack (actor: MOBJ_T)
		do
				-- Stub
		end

	A_CPosRefire (actor: MOBJ_T)
		do
				-- Stub
		end

	A_TroopAttack (actor: MOBJ_T)
		do
				-- Stub
		end

	A_SargAttack (actor: MOBJ_T)
		do
				-- Stub
		end

	A_HeadAttack (actor: MOBJ_T)
		do
				-- Stub
		end

	A_BruisAttack (actor: MOBJ_T)
		do
				-- Stub
		end

	A_SkullAttack (actor: MOBJ_T)
		do
				-- Stub
		end

	A_Metal (mo: MOBJ_T)
		do
				-- Stub
		end

	A_SpidRefire (actor: MOBJ_T)
		do
				-- Stub
		end

	A_BabyMetal (mo: MOBJ_T)
		do
				-- Stub
		end

	A_BspiAttack (mo: MOBJ_T)
		do
				-- Stub
		end

	A_Hoof (mo: MOBJ_T)
		do
				-- Stub
		end

	A_CyberAttack (actor: MOBJ_T)
		do
				-- Stub
		end

	A_PainAttack (actor: MOBJ_T)
			-- Spawn a lost soul and launch it at the target
		do
				-- Stub
		end

	A_PainDie (actor: MOBJ_T)
		do
				-- Stub
		end

	A_KeenDie (mo: MOBJ_T)
			-- DOOM II special, map 32.
			-- Uses special tag 666.
		do
				-- Stub
		end

	A_BrainPain (mo: MOBJ_T)
		do
				-- Stub
		end

	A_BrainScream (mo: MOBJ_T)
		do
				-- Stub
		end

	A_BrainDie (mo: MOBJ_T)
		do
				-- Stub
		end

	A_BrainAwake (mo: MOBJ_T)
		do
				-- Stub
		end

	A_BrainSpit (mo: MOBJ_T)
		do
				-- Stub
		end

	A_SpawnSound (mo: MOBJ_T)
			-- Travelling cube sound
		do
				-- Stub
		end

	A_SpawnFly (mo: MOBJ_T)
		do
				-- Stub
		end

	A_BrainExplode (mo: MOBJ_T)
		do
				-- Stub
		end

end
