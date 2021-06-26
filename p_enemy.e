note
	description: "[
		p_enemy.c
		Enemy thinking, AI.
		Action Pointer Functions
		that are associated with states/frames
	]"

class
	P_ENEMY

inherit

	SFXENUM_T

	MOBJTYPE_T

	MOBJFLAG_T

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
			print ("A_OpenShotgun2 is not implemented%N")
		end

	A_LoadShotgun2 (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
			print ("A_LoadShotgun2 is not implemented%N")
		end

	A_CloseShotgun2 (player: PLAYER_T; psp: PSPDEF_T)
		do
				-- Stub
			print ("A_CloseShotgun2 is not implmented%N")
		end

	A_Explode (thingy: MOBJ_T)
		do
				-- Stub
			print ("A_Explode is not implemented%N")
		end

	A_Pain (actor: MOBJ_T)
		do
			check attached actor.info as info then
				if info.painsound /= 0 then
					i_main.s_sound.s_startsound (actor, info.painsound)
				end
			end
		end

	A_PlayerScream (mo: MOBJ_T)
		local
			sound: INTEGER
		do
			sound := sfx_pldeth
			if i_main.doomstat_h.gamemode = {GAME_MODE_T}.commercial and mo.health < -50 then
					-- IF THE PLAYER DIES
					-- LESS THAN -50% WITHOUT GIBBING
				sound := sfx_pdiehi
			end
			i_main.s_sound.s_startsound (mo, sound)
		end

	A_Fall (actor: MOBJ_T)
		do
				-- actor is on ground, it can be walked over
			actor.flags := actor.flags & {P_MOBJ}.MF_SOLID.bit_not
				-- So change this if corpse objects
				-- are meant to be obstacles
		end

	A_XScream (actor: MOBJ_T)
		do
			i_main.s_sound.s_startsound (actor, sfx_slop)
		end

	A_Look (actor: MOBJ_T)
			-- Stay in state until a player is sighted
		local
			targ: MOBJ_T
			seeyou: BOOLEAN
			returned: BOOLEAN
			sound: INTEGER
		do
			actor.threshold := 0 -- any shot will wake up
			check attached actor.subsector as sub and then attached sub.sector as sec then
				targ := sec.soundtarget
			end
			if attached targ and then targ.flags & MF_SHOOTABLE /= 0 then
				actor.target := targ
				if actor.flags & MF_AMBUSH /= 0 then
					if i_main.p_sight.P_CheckSight (actor, targ) then
						seeyou := True
					end
				else
					seeyou := True
				end
			end
			if not seeyou then
				if not P_LookForPlayers (actor, False) then
						-- return
					returned := True
				end
			end
			if not returned then
					-- go into chase state
				check attached actor.info as i then
					if i.seesound /= 0 then
						if i.seesound = sfx_posit1 or i.seesound = sfx_posit2 or i.seesound = sfx_posit3 then
							sound := sfx_posit1 + i_main.m_random.P_Random \\ 3
						elseif i.seesound = sfx_bgsit1 or i.seesound = sfx_bgsit2 then
							sound := sfx_bgsit1 + i_main.m_random.P_Random \\ 2
						else
							sound := i.seesound
						end
						if actor.type = MT_SPIDER or actor.type = MT_CYBORG then
								-- full volume
							i_main.s_sound.s_startsound (Void, sound)
						else
							i_main.s_sound.s_startsound (actor, sound)
						end
					end
					i_main.p_mobj.P_SetMobjState (actor, i.seestate).do_nothing
				end
			end
		end

	P_LookForPlayers (actor: MOBJ_T; allaround: BOOLEAN): BOOLEAN
			-- If allaround is false, only look 180 degrees in front.
			-- Returns true if a player is targeted.
		local
			c: INTEGER
			stop: INTEGER
			player: PLAYER_T
			an: ANGLE_T
			dist: FIXED_T
			returned: BOOLEAN
			continue: BOOLEAN
		do
			c := 0
			stop := (actor.lastlook - 1) & 3
			from
			until
				returned
			loop
				continue := False
				if not i_main.g_game.playeringame [actor.lastlook] then
						-- continue
				else
					c := c + 1
					if c = 3 or actor.lastlook = stop then
							-- done looking
						Result := False
						returned := True
					else
						player := i_main.g_game.players [actor.lastlook]
						if player.health <= 0 then
								-- continue (dead)
						else
							check attached player.mo as mo then
								if not i_main.p_sight.P_CheckSight (actor, mo) then
										-- continue (out of sight)
								else
									if not allaround then
										an := i_main.r_main.R_PointToAngle2 (actor.x, actor.y, mo.x, mo.y) - actor.angle
										if an > {R_MAIN}.ANG90 and an < {R_MAIN}.ANG270 then
											dist := i_main.p_maputl.P_AproxDistance (mo.x - actor.x, mo.y - actor.y)
												-- if real close, react anyway
											if dist > {P_LOCAL}.MELEERANGE then
												continue := True -- behind back
											end
										end
									end
									if not continue then
										actor.target := player.mo
										Result := True
										returned := True
									end
								end
							end
						end
					end
				end
				if not returned then
					actor.lastlook := (actor.lastlook + 1) & 3
				end
			end
			if not returned then
				Result := False
			end
		end

	A_Chase (actor: MOBJ_T)
			-- Actor has a melee attack,
			-- so it tries to close as fast as possible
		local
			delta: INTEGER_64
			returned: BOOLEAN
		do
			check attached actor.info as ainfo then
				if actor.reactiontime /= 0 then
					actor.reactiontime := actor.reactiontime - 1
				end
					-- modify target threshold
				if actor.threshold /= 0 then
					if actor.target = Void or (attached actor.target as t and then t.health <= 0) then
						actor.threshold := 0
					else
						actor.threshold := actor.threshold - 1
					end
				end
					-- turn towards movement direction if not there yet
				if actor.movedir < 8 then
					actor.angle := actor.angle & ((7).to_natural_32 |<< 29)
					delta := (actor.angle.to_natural_64 - (actor.movedir |<< 29).to_natural_64).to_integer_64
					if delta > 0 then
						actor.angle := actor.angle - {R_MAIN}.ANG90 // (2).to_natural_32
					elseif delta < 0 then
						actor.angle := actor.angle + {R_MAIN}.ANG90 // (2).to_natural_32
					end
				end
				if actor.target = Void or else (attached actor.target as t and then t.flags & MF_SHOOTABLE = 0) then
						-- look for a new target
					if P_LookForPlayers (actor, True) then
							-- got a new target
					else
						i_main.p_mobj.p_setmobjstate (actor, ainfo.spawnstate).do_nothing
					end
				else
						-- do not attack twice in a row
					if actor.flags & MF_JUSTATTACKED /= 0 then
						actor.flags := actor.flags & MF_JUSTATTACKED.bit_not
						if i_main.g_game.gameskill /= {DOOMDEF_H}.sk_nightmare and not i_main.d_doom_main.fastparm then
							P_NewChaseDir (actor)
						end
					else
							-- check for melee attack
						if ainfo.meleestate /= 0 and P_CheckMeleeRange (actor) then
							if ainfo.attacksound /= 0 then
								i_main.s_sound.s_startsound (actor, ainfo.attacksound)
							end
							i_main.p_mobj.p_setmobjstate (actor, ainfo.meleestate).do_nothing
						else
								-- check for missile attack
							if ainfo.missilestate /= 0 then
								if i_main.g_game.gameskill < {DOOMDEF_H}.sk_nightmare and not i_main.d_doom_main.fastparm and actor.movecount /= 0 then
										-- goto nomissile
								elseif not P_CheckMissileRange (actor) then
										-- goto nomissile
								else
									i_main.p_mobj.p_setmobjstate (actor, ainfo.missilestate).do_nothing
									actor.flags := actor.flags | MF_JUSTATTACKED
									returned := True
								end
								if not returned then
										-- nomissile
										-- possibly choose another target
									check attached actor.target as t then
										if i_main.g_game.netgame and actor.threshold = 0 and not i_main.p_sight.P_CheckSight (actor, t) then
											if P_LookForPlayers (actor, True) then
												returned := True -- got a new target
											end
										end
									end
								end
								if not returned then
										-- chase towards player
									actor.movecount := actor.movecount - 1
									if actor.movecount < 0 or not P_Move (actor) then
										P_NewChaseDir (actor)
									end
										-- make active sound
									if ainfo.activesound /= 0 and i_main.m_random.p_random < 3 then
										i_main.s_sound.s_startsound (actor, ainfo.activesound)
									end
								end
							end
						end
					end
				end
			end
		end

	P_NewChaseDir (actor: MOBJ_T)
		do
				-- Stub
			print ("P_NewChaseDir not implemented%N")
		end

	P_CheckMeleeRange (actor: MOBJ_T): BOOLEAN
		local
			dist: FIXED_T
		do
			if attached actor.target as pl then
				dist := i_main.p_maputl.P_AproxDistance (pl.x - actor.x, pl.y - actor.y)
				check attached pl.info as i then
					if dist >= {P_LOCAL}.MELEERANGE - 20 * {M_FIXED}.fracunit + i.radius then
						Result := False
					else
						if not i_main.p_sight.P_CheckSight (actor, pl) then
							Result := False
						else
							Result := True
						end
					end
				end
			else
				Result := False
			end
		end

	P_CheckMissileRange (actor: MOBJ_T): BOOLEAN
		local
			dist: FIXED_T
			returned: BOOLEAN
		do
			check attached actor.target as t and then attached actor.info as i then
				if not i_main.p_sight.P_CheckSight (actor, t) then
					Result := False
				elseif actor.flags & MF_JUSTHIT /= 0 then
						-- the target just hit the enemy,
						-- so fight back!
					actor.flags := actor.flags & MF_JUSTHIT.bit_not
					Result := True
				elseif actor.reactiontime /= 0 then
					Result := False -- do not attack yet
				else
						-- OPTIMIZE: get this from a global checksight
					dist := i_main.p_maputl.p_aproxdistance (actor.x - t.x, actor.y - t.y) - 64 * {M_FIXED}.fracunit
					if i.meleestate = 0 then
						dist := dist - 128 * {M_FIXED}.fracunit -- no melee attack, so fire more
					end
					dist := dist |>> 16
					if actor.type = MT_VILE then
						if dist > 14 * 64 then
							Result := False -- too far away
							returned := True
						end
					elseif actor.type = MT_UNDEAD then
						if dist < 196 then
							Result := False -- close for fist attack
						else
							dist := dist |>> 1
						end
					elseif actor.type = MT_CYBORG or actor.type = MT_SPIDER or actor.type = MT_SKULL then
						dist := dist |>> 1
					end
					if not returned then
						if dist > 200 then
							dist := 200
						end
						if actor.type = MT_CYBORG and dist > 160 then
							dist := 160
						end
						if i_main.m_random.p_random < dist then
							Result := False
						else
							Result := True
						end
					end
				end
			end
		end

	P_Move(actor: MOBJ_T): BOOLEAN
		do
			-- Stub
			print("P_Move is not implemented%N")
		end

	A_FaceTarget (actor: MOBJ_T)
		do
				-- Stub
			print ("A_FaceTarget is not implemented%N")
		end

	A_PosAttack (actor: MOBJ_T)
		do
				-- Stub
			print ("A_PosAttack is not implemented%N")
		end

	A_Scream (actor: MOBJ_T)
		local
			sound: INTEGER
			returned: BOOLEAN
		do
			check attached actor.info as i then
				if i.deathsound = 0 then
					returned := True
				elseif i.deathsound = sfx_podth1 or i.deathsound = sfx_podth2 or i.deathsound = sfx_podth3 then
					sound := sfx_podth1 + i_main.m_random.p_random \\ 3
				elseif i.deathsound = sfx_bgdth1 or i.deathsound = sfx_bgdth2 then
					sound := sfx_bgdth1 + i_main.m_random.p_random \\ 2
				else
					sound := i.deathsound
				end
			end
			if not returned then
					-- Check for bosses
				if actor.type = MT_SPIDER or actor.type = MT_CYBORG then
					i_main.s_sound.s_startsound (Void, sound)
				else
					i_main.s_sound.s_startsound (actor, sound)
				end
			end
		end

	A_SPosAttack (actor: MOBJ_T)
		do
				-- Stub
			print ("A_SPosAttack is not implemented%N")
		end

	A_VileChase (actor: MOBJ_T)
			-- Check for resurrecting a body
		do
				-- Stub
			print ("A_VileChase is not implemented%N")
		end

	A_VileStart (actor: MOBJ_T)
		do
				-- Stub
			print ("A_VileStart is not implemented%N")
		end

	A_VileTarget (actor: MOBJ_T)
			-- Spawn the hellfire
		do
				-- Stub
			print ("A_VileTarget is not implemented%N")
		end

	A_VileAttack (actor: MOBJ_T)
		do
				-- Stub
			print ("A_VileAttack is not implemented%N")
		end

	A_StartFire (actor: MOBJ_T)
		do
				-- Stub
			print ("A_StartFire is not implemented%N")
		end

	A_Fire (actor: MOBJ_T)
			-- Keep fire in front of player unless out of sight
		do
				-- Stub
			print ("A_Fire is not implemented%N")
		end

	A_FireCrackle (actor: MOBJ_T)
		do
				-- Stub
			print ("A_FireCrackle is not implemented%N")
		end

	A_Tracer (actor: MOBJ_T)
		do
				-- Stub
			print ("A_Tracer is not implemented%N")
		end

	A_SkelWhoosh (actor: MOBJ_T)
		do
				-- Stub
			print ("A_SkelWhoosh is not implemented%N")
		end

	A_SkelFist (actor: MOBJ_T)
		do
				-- Stub
			print ("A_SkelFist is not implemented%N")
		end

	A_SkelMissile (actor: MOBJ_T)
		do
				-- Stub
			print ("A_SkelMissile is not implemented%N")
		end

	A_FatRaise (actor: MOBJ_T)
		do
				-- Stub
			print ("A_FatRaise is not implemented%N")
		end

	A_FatAttack1 (actor: MOBJ_T)
		do
				-- Stub
			print ("A_FatAttack1 is not implemented%N")
		end

	A_FatAttack2 (actor: MOBJ_T)
		do
				-- Stub
			print ("A_FatAttack2 is not implemented%N")
		end

	A_FatAttack3 (actor: MOBJ_T)
		do
				-- Stub
			print ("A_FatAttack3 is not implemented%N")
		end

	A_BossDeath (mo: MOBJ_T)
			-- Possibly trigger special effects
			-- if on first boss level
		do
				-- Stub
			print ("A_BossDeath is not implemented%N")
		end

	A_CPosAttack (actor: MOBJ_T)
		do
				-- Stub
			print ("A_CPosAttack is not implemented%N")
		end

	A_CPosRefire (actor: MOBJ_T)
		do
				-- Stub
			print ("A_CPosRefire is not implemented%N")
		end

	A_TroopAttack (actor: MOBJ_T)
		do
				-- Stub
			print ("A_TroopAttack is not implemented%N")
		end

	A_SargAttack (actor: MOBJ_T)
		do
				-- Stub
			print ("A_SargAttack is not implemented%N")
		end

	A_HeadAttack (actor: MOBJ_T)
		do
				-- Stub
			print ("A_HeadAttack is not implemented%N")
		end

	A_BruisAttack (actor: MOBJ_T)
		do
				-- Stub
			print ("A_BruisAttack is not implemented%N")
		end

	A_SkullAttack (actor: MOBJ_T)
		do
				-- Stub
			print ("A_SkullAttack is not implemented%N")
		end

	A_Metal (mo: MOBJ_T)
		do
				-- Stub
			print ("A_Metal is not implemented%N")
		end

	A_SpidRefire (actor: MOBJ_T)
		do
				-- Stub
			print ("A_SpidRefire is not implemented%N")
		end

	A_BabyMetal (mo: MOBJ_T)
		do
				-- Stub
			print ("A_BabyMetal is not implemented%N")
		end

	A_BspiAttack (mo: MOBJ_T)
		do
				-- Stub
			print ("A_BspiAttack is not implemented%N")
		end

	A_Hoof (mo: MOBJ_T)
		do
				-- Stub
			print ("A_Hoof is not implemented%N")
		end

	A_CyberAttack (actor: MOBJ_T)
		do
				-- Stub
			print ("A_CyberAttack is not implemented%N")
		end

	A_PainAttack (actor: MOBJ_T)
			-- Spawn a lost soul and launch it at the target
		do
				-- Stub
			print ("A_PainAttack is not implemented%N")
		end

	A_PainDie (actor: MOBJ_T)
		do
				-- Stub
			print ("A_PainDie is not implemented%N")
		end

	A_KeenDie (mo: MOBJ_T)
			-- DOOM II special, map 32.
			-- Uses special tag 666.
		do
				-- Stub
			print ("A_KeenDie is not implemented%N")
		end

	A_BrainPain (mo: MOBJ_T)
		do
				-- Stub
			print ("A_BrainPain is not implemented%N")
		end

	A_BrainScream (mo: MOBJ_T)
		do
				-- Stub
			print ("A_BrainScream is not implemented%N")
		end

	A_BrainDie (mo: MOBJ_T)
		do
				-- Stub
			print ("A_BrainDie is not implemented%N")
		end

	A_BrainAwake (mo: MOBJ_T)
		do
				-- Stub
			print ("A_BrainAwake is not implemented%N")
		end

	A_BrainSpit (mo: MOBJ_T)
		do
				-- Stub
			print ("A_BrainSpit is not implemented%N")
		end

	A_SpawnSound (mo: MOBJ_T)
			-- Travelling cube sound
		do
				-- Stub
			print ("A_SpawnSound is not implemented%N")
		end

	A_SpawnFly (mo: MOBJ_T)
		do
				-- Stub
			print ("A_SpawnFly is not implemented%N")
		end

	A_BrainExplode (mo: MOBJ_T)
		do
				-- Stub
			print ("A_BrainExplode is not implemented%N")
		end

end
