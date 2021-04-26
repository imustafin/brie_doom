note
	description: "[
		p_enemy.c
		Enemy thinking, AI.
		Action Pointer Functions
		that are associated with states/frames
	]"

class
	P_ENEMY

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

	agent_a_look: PROCEDURE
		do
			Result := agent A_Look
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
