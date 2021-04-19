note
	description: "statenum_t from info.h"

class
	STATENUM_T

feature -- statenum_t

	S_NULL: INTEGER = 0

	S_LIGHTDONE: INTEGER = 1

	S_PUNCH: INTEGER = 2

	S_PUNCHDOWN: INTEGER = 3

	S_PUNCHUP: INTEGER = 4

	S_PUNCH1: INTEGER = 5

	S_PUNCH2: INTEGER = 6

	S_PUNCH3: INTEGER = 7

	S_PUNCH4: INTEGER = 8

	S_PUNCH5: INTEGER = 9

	S_PISTOL: INTEGER = 10

	S_PISTOLDOWN: INTEGER = 11

	S_PISTOLUP: INTEGER = 12

	S_PISTOL1: INTEGER = 13

	S_PISTOL2: INTEGER = 14

	S_PISTOL3: INTEGER = 15

	S_PISTOL4: INTEGER = 16

	S_PISTOLFLASH: INTEGER = 17

	S_SGUN: INTEGER = 18

	S_SGUNDOWN: INTEGER = 19

	S_SGUNUP: INTEGER = 20

	S_SGUN1: INTEGER = 21

	S_SGUN2: INTEGER = 22

	S_SGUN3: INTEGER = 23

	S_SGUN4: INTEGER = 24

	S_SGUN5: INTEGER = 25

	S_SGUN6: INTEGER = 26

	S_SGUN7: INTEGER = 27

	S_SGUN8: INTEGER = 28

	S_SGUN9: INTEGER = 29

	S_SGUNFLASH1: INTEGER = 30

	S_SGUNFLASH2: INTEGER = 31

	S_DSGUN: INTEGER = 32

	S_DSGUNDOWN: INTEGER = 33

	S_DSGUNUP: INTEGER = 34

	S_DSGUN1: INTEGER = 35

	S_DSGUN2: INTEGER = 36

	S_DSGUN3: INTEGER = 37

	S_DSGUN4: INTEGER = 38

	S_DSGUN5: INTEGER = 39

	S_DSGUN6: INTEGER = 40

	S_DSGUN7: INTEGER = 41

	S_DSGUN8: INTEGER = 42

	S_DSGUN9: INTEGER = 43

	S_DSGUN10: INTEGER = 44

	S_DSNR1: INTEGER = 45

	S_DSNR2: INTEGER = 46

	S_DSGUNFLASH1: INTEGER = 47

	S_DSGUNFLASH2: INTEGER = 48

	S_CHAIN: INTEGER = 49

	S_CHAINDOWN: INTEGER = 50

	S_CHAINUP: INTEGER = 51

	S_CHAIN1: INTEGER = 52

	S_CHAIN2: INTEGER = 53

	S_CHAIN3: INTEGER = 54

	S_CHAINFLASH1: INTEGER = 55

	S_CHAINFLASH2: INTEGER = 56

	S_MISSILE: INTEGER = 57

	S_MISSILEDOWN: INTEGER = 58

	S_MISSILEUP: INTEGER = 59

	S_MISSILE1: INTEGER = 60

	S_MISSILE2: INTEGER = 61

	S_MISSILE3: INTEGER = 62

	S_MISSILEFLASH1: INTEGER = 63

	S_MISSILEFLASH2: INTEGER = 64

	S_MISSILEFLASH3: INTEGER = 65

	S_MISSILEFLASH4: INTEGER = 66

	S_SAW: INTEGER = 67

	S_SAWB: INTEGER = 68

	S_SAWDOWN: INTEGER = 69

	S_SAWUP: INTEGER = 70

	S_SAW1: INTEGER = 71

	S_SAW2: INTEGER = 72

	S_SAW3: INTEGER = 73

	S_PLASMA: INTEGER = 74

	S_PLASMADOWN: INTEGER = 75

	S_PLASMAUP: INTEGER = 76

	S_PLASMA1: INTEGER = 77

	S_PLASMA2: INTEGER = 78

	S_PLASMAFLASH1: INTEGER = 79

	S_PLASMAFLASH2: INTEGER = 80

	S_BFG: INTEGER = 81

	S_BFGDOWN: INTEGER = 82

	S_BFGUP: INTEGER = 83

	S_BFG1: INTEGER = 84

	S_BFG2: INTEGER = 85

	S_BFG3: INTEGER = 86

	S_BFG4: INTEGER = 87

	S_BFGFLASH1: INTEGER = 88

	S_BFGFLASH2: INTEGER = 89

	S_BLOOD1: INTEGER = 90

	S_BLOOD2: INTEGER = 91

	S_BLOOD3: INTEGER = 92

	S_PUFF1: INTEGER = 93

	S_PUFF2: INTEGER = 94

	S_PUFF3: INTEGER = 95

	S_PUFF4: INTEGER = 96

	S_TBALL1: INTEGER = 97

	S_TBALL2: INTEGER = 98

	S_TBALLX1: INTEGER = 99

	S_TBALLX2: INTEGER = 100

	S_TBALLX3: INTEGER = 101

	S_RBALL1: INTEGER = 102

	S_RBALL2: INTEGER = 103

	S_RBALLX1: INTEGER = 104

	S_RBALLX2: INTEGER = 105

	S_RBALLX3: INTEGER = 106

	S_PLASBALL: INTEGER = 107

	S_PLASBALL2: INTEGER = 108

	S_PLASEXP: INTEGER = 109

	S_PLASEXP2: INTEGER = 110

	S_PLASEXP3: INTEGER = 111

	S_PLASEXP4: INTEGER = 112

	S_PLASEXP5: INTEGER = 113

	S_ROCKET: INTEGER = 114

	S_BFGSHOT: INTEGER = 115

	S_BFGSHOT2: INTEGER = 116

	S_BFGLAND: INTEGER = 117

	S_BFGLAND2: INTEGER = 118

	S_BFGLAND3: INTEGER = 119

	S_BFGLAND4: INTEGER = 120

	S_BFGLAND5: INTEGER = 121

	S_BFGLAND6: INTEGER = 122

	S_BFGEXP: INTEGER = 123

	S_BFGEXP2: INTEGER = 124

	S_BFGEXP3: INTEGER = 125

	S_BFGEXP4: INTEGER = 126

	S_EXPLODE1: INTEGER = 127

	S_EXPLODE2: INTEGER = 128

	S_EXPLODE3: INTEGER = 129

	S_TFOG: INTEGER = 130

	S_TFOG01: INTEGER = 131

	S_TFOG02: INTEGER = 132

	S_TFOG2: INTEGER = 133

	S_TFOG3: INTEGER = 134

	S_TFOG4: INTEGER = 135

	S_TFOG5: INTEGER = 136

	S_TFOG6: INTEGER = 137

	S_TFOG7: INTEGER = 138

	S_TFOG8: INTEGER = 139

	S_TFOG9: INTEGER = 140

	S_TFOG10: INTEGER = 141

	S_IFOG: INTEGER = 142

	S_IFOG01: INTEGER = 143

	S_IFOG02: INTEGER = 144

	S_IFOG2: INTEGER = 145

	S_IFOG3: INTEGER = 146

	S_IFOG4: INTEGER = 147

	S_IFOG5: INTEGER = 148

	S_PLAY: INTEGER = 149

	S_PLAY_RUN1: INTEGER = 150

	S_PLAY_RUN2: INTEGER = 151

	S_PLAY_RUN3: INTEGER = 152

	S_PLAY_RUN4: INTEGER = 153

	S_PLAY_ATK1: INTEGER = 154

	S_PLAY_ATK2: INTEGER = 155

	S_PLAY_PAIN: INTEGER = 156

	S_PLAY_PAIN2: INTEGER = 157

	S_PLAY_DIE1: INTEGER = 158

	S_PLAY_DIE2: INTEGER = 159

	S_PLAY_DIE3: INTEGER = 160

	S_PLAY_DIE4: INTEGER = 161

	S_PLAY_DIE5: INTEGER = 162

	S_PLAY_DIE6: INTEGER = 163

	S_PLAY_DIE7: INTEGER = 164

	S_PLAY_XDIE1: INTEGER = 165

	S_PLAY_XDIE2: INTEGER = 166

	S_PLAY_XDIE3: INTEGER = 167

	S_PLAY_XDIE4: INTEGER = 168

	S_PLAY_XDIE5: INTEGER = 169

	S_PLAY_XDIE6: INTEGER = 170

	S_PLAY_XDIE7: INTEGER = 171

	S_PLAY_XDIE8: INTEGER = 172

	S_PLAY_XDIE9: INTEGER = 173

	S_POSS_STND: INTEGER = 174

	S_POSS_STND2: INTEGER = 175

	S_POSS_RUN1: INTEGER = 176

	S_POSS_RUN2: INTEGER = 177

	S_POSS_RUN3: INTEGER = 178

	S_POSS_RUN4: INTEGER = 179

	S_POSS_RUN5: INTEGER = 180

	S_POSS_RUN6: INTEGER = 181

	S_POSS_RUN7: INTEGER = 182

	S_POSS_RUN8: INTEGER = 183

	S_POSS_ATK1: INTEGER = 184

	S_POSS_ATK2: INTEGER = 185

	S_POSS_ATK3: INTEGER = 186

	S_POSS_PAIN: INTEGER = 187

	S_POSS_PAIN2: INTEGER = 188

	S_POSS_DIE1: INTEGER = 189

	S_POSS_DIE2: INTEGER = 190

	S_POSS_DIE3: INTEGER = 191

	S_POSS_DIE4: INTEGER = 192

	S_POSS_DIE5: INTEGER = 193

	S_POSS_XDIE1: INTEGER = 194

	S_POSS_XDIE2: INTEGER = 195

	S_POSS_XDIE3: INTEGER = 196

	S_POSS_XDIE4: INTEGER = 197

	S_POSS_XDIE5: INTEGER = 198

	S_POSS_XDIE6: INTEGER = 199

	S_POSS_XDIE7: INTEGER = 200

	S_POSS_XDIE8: INTEGER = 201

	S_POSS_XDIE9: INTEGER = 202

	S_POSS_RAISE1: INTEGER = 203

	S_POSS_RAISE2: INTEGER = 204

	S_POSS_RAISE3: INTEGER = 205

	S_POSS_RAISE4: INTEGER = 206

	S_SPOS_STND: INTEGER = 207

	S_SPOS_STND2: INTEGER = 208

	S_SPOS_RUN1: INTEGER = 209

	S_SPOS_RUN2: INTEGER = 210

	S_SPOS_RUN3: INTEGER = 211

	S_SPOS_RUN4: INTEGER = 212

	S_SPOS_RUN5: INTEGER = 213

	S_SPOS_RUN6: INTEGER = 214

	S_SPOS_RUN7: INTEGER = 215

	S_SPOS_RUN8: INTEGER = 216

	S_SPOS_ATK1: INTEGER = 217

	S_SPOS_ATK2: INTEGER = 218

	S_SPOS_ATK3: INTEGER = 219

	S_SPOS_PAIN: INTEGER = 220

	S_SPOS_PAIN2: INTEGER = 221

	S_SPOS_DIE1: INTEGER = 222

	S_SPOS_DIE2: INTEGER = 223

	S_SPOS_DIE3: INTEGER = 224

	S_SPOS_DIE4: INTEGER = 225

	S_SPOS_DIE5: INTEGER = 226

	S_SPOS_XDIE1: INTEGER = 227

	S_SPOS_XDIE2: INTEGER = 228

	S_SPOS_XDIE3: INTEGER = 229

	S_SPOS_XDIE4: INTEGER = 230

	S_SPOS_XDIE5: INTEGER = 231

	S_SPOS_XDIE6: INTEGER = 232

	S_SPOS_XDIE7: INTEGER = 233

	S_SPOS_XDIE8: INTEGER = 234

	S_SPOS_XDIE9: INTEGER = 235

	S_SPOS_RAISE1: INTEGER = 236

	S_SPOS_RAISE2: INTEGER = 237

	S_SPOS_RAISE3: INTEGER = 238

	S_SPOS_RAISE4: INTEGER = 239

	S_SPOS_RAISE5: INTEGER = 240

	S_VILE_STND: INTEGER = 241

	S_VILE_STND2: INTEGER = 242

	S_VILE_RUN1: INTEGER = 243

	S_VILE_RUN2: INTEGER = 244

	S_VILE_RUN3: INTEGER = 245

	S_VILE_RUN4: INTEGER = 246

	S_VILE_RUN5: INTEGER = 247

	S_VILE_RUN6: INTEGER = 248

	S_VILE_RUN7: INTEGER = 249

	S_VILE_RUN8: INTEGER = 250

	S_VILE_RUN9: INTEGER = 251

	S_VILE_RUN10: INTEGER = 252

	S_VILE_RUN11: INTEGER = 253

	S_VILE_RUN12: INTEGER = 254

	S_VILE_ATK1: INTEGER = 255

	S_VILE_ATK2: INTEGER = 256

	S_VILE_ATK3: INTEGER = 257

	S_VILE_ATK4: INTEGER = 258

	S_VILE_ATK5: INTEGER = 259

	S_VILE_ATK6: INTEGER = 260

	S_VILE_ATK7: INTEGER = 261

	S_VILE_ATK8: INTEGER = 262

	S_VILE_ATK9: INTEGER = 263

	S_VILE_ATK10: INTEGER = 264

	S_VILE_ATK11: INTEGER = 265

	S_VILE_HEAL1: INTEGER = 266

	S_VILE_HEAL2: INTEGER = 267

	S_VILE_HEAL3: INTEGER = 268

	S_VILE_PAIN: INTEGER = 269

	S_VILE_PAIN2: INTEGER = 270

	S_VILE_DIE1: INTEGER = 271

	S_VILE_DIE2: INTEGER = 272

	S_VILE_DIE3: INTEGER = 273

	S_VILE_DIE4: INTEGER = 274

	S_VILE_DIE5: INTEGER = 275

	S_VILE_DIE6: INTEGER = 276

	S_VILE_DIE7: INTEGER = 277

	S_VILE_DIE8: INTEGER = 278

	S_VILE_DIE9: INTEGER = 279

	S_VILE_DIE10: INTEGER = 280

	S_FIRE1: INTEGER = 281

	S_FIRE2: INTEGER = 282

	S_FIRE3: INTEGER = 283

	S_FIRE4: INTEGER = 284

	S_FIRE5: INTEGER = 285

	S_FIRE6: INTEGER = 286

	S_FIRE7: INTEGER = 287

	S_FIRE8: INTEGER = 288

	S_FIRE9: INTEGER = 289

	S_FIRE10: INTEGER = 290

	S_FIRE11: INTEGER = 291

	S_FIRE12: INTEGER = 292

	S_FIRE13: INTEGER = 293

	S_FIRE14: INTEGER = 294

	S_FIRE15: INTEGER = 295

	S_FIRE16: INTEGER = 296

	S_FIRE17: INTEGER = 297

	S_FIRE18: INTEGER = 298

	S_FIRE19: INTEGER = 299

	S_FIRE20: INTEGER = 300

	S_FIRE21: INTEGER = 301

	S_FIRE22: INTEGER = 302

	S_FIRE23: INTEGER = 303

	S_FIRE24: INTEGER = 304

	S_FIRE25: INTEGER = 305

	S_FIRE26: INTEGER = 306

	S_FIRE27: INTEGER = 307

	S_FIRE28: INTEGER = 308

	S_FIRE29: INTEGER = 309

	S_FIRE30: INTEGER = 310

	S_SMOKE1: INTEGER = 311

	S_SMOKE2: INTEGER = 312

	S_SMOKE3: INTEGER = 313

	S_SMOKE4: INTEGER = 314

	S_SMOKE5: INTEGER = 315

	S_TRACER: INTEGER = 316

	S_TRACER2: INTEGER = 317

	S_TRACEEXP1: INTEGER = 318

	S_TRACEEXP2: INTEGER = 319

	S_TRACEEXP3: INTEGER = 320

	S_SKEL_STND: INTEGER = 321

	S_SKEL_STND2: INTEGER = 322

	S_SKEL_RUN1: INTEGER = 323

	S_SKEL_RUN2: INTEGER = 324

	S_SKEL_RUN3: INTEGER = 325

	S_SKEL_RUN4: INTEGER = 326

	S_SKEL_RUN5: INTEGER = 327

	S_SKEL_RUN6: INTEGER = 328

	S_SKEL_RUN7: INTEGER = 329

	S_SKEL_RUN8: INTEGER = 330

	S_SKEL_RUN9: INTEGER = 331

	S_SKEL_RUN10: INTEGER = 332

	S_SKEL_RUN11: INTEGER = 333

	S_SKEL_RUN12: INTEGER = 334

	S_SKEL_FIST1: INTEGER = 335

	S_SKEL_FIST2: INTEGER = 336

	S_SKEL_FIST3: INTEGER = 337

	S_SKEL_FIST4: INTEGER = 338

	S_SKEL_MISS1: INTEGER = 339

	S_SKEL_MISS2: INTEGER = 340

	S_SKEL_MISS3: INTEGER = 341

	S_SKEL_MISS4: INTEGER = 342

	S_SKEL_PAIN: INTEGER = 343

	S_SKEL_PAIN2: INTEGER = 344

	S_SKEL_DIE1: INTEGER = 345

	S_SKEL_DIE2: INTEGER = 346

	S_SKEL_DIE3: INTEGER = 347

	S_SKEL_DIE4: INTEGER = 348

	S_SKEL_DIE5: INTEGER = 349

	S_SKEL_DIE6: INTEGER = 350

	S_SKEL_RAISE1: INTEGER = 351

	S_SKEL_RAISE2: INTEGER = 352

	S_SKEL_RAISE3: INTEGER = 353

	S_SKEL_RAISE4: INTEGER = 354

	S_SKEL_RAISE5: INTEGER = 355

	S_SKEL_RAISE6: INTEGER = 356

	S_FATSHOT1: INTEGER = 357

	S_FATSHOT2: INTEGER = 358

	S_FATSHOTX1: INTEGER = 359

	S_FATSHOTX2: INTEGER = 360

	S_FATSHOTX3: INTEGER = 361

	S_FATT_STND: INTEGER = 362

	S_FATT_STND2: INTEGER = 363

	S_FATT_RUN1: INTEGER = 364

	S_FATT_RUN2: INTEGER = 365

	S_FATT_RUN3: INTEGER = 366

	S_FATT_RUN4: INTEGER = 367

	S_FATT_RUN5: INTEGER = 368

	S_FATT_RUN6: INTEGER = 369

	S_FATT_RUN7: INTEGER = 370

	S_FATT_RUN8: INTEGER = 371

	S_FATT_RUN9: INTEGER = 372

	S_FATT_RUN10: INTEGER = 373

	S_FATT_RUN11: INTEGER = 374

	S_FATT_RUN12: INTEGER = 375

	S_FATT_ATK1: INTEGER = 376

	S_FATT_ATK2: INTEGER = 377

	S_FATT_ATK3: INTEGER = 378

	S_FATT_ATK4: INTEGER = 379

	S_FATT_ATK5: INTEGER = 380

	S_FATT_ATK6: INTEGER = 381

	S_FATT_ATK7: INTEGER = 382

	S_FATT_ATK8: INTEGER = 383

	S_FATT_ATK9: INTEGER = 384

	S_FATT_ATK10: INTEGER = 385

	S_FATT_PAIN: INTEGER = 386

	S_FATT_PAIN2: INTEGER = 387

	S_FATT_DIE1: INTEGER = 388

	S_FATT_DIE2: INTEGER = 389

	S_FATT_DIE3: INTEGER = 390

	S_FATT_DIE4: INTEGER = 391

	S_FATT_DIE5: INTEGER = 392

	S_FATT_DIE6: INTEGER = 393

	S_FATT_DIE7: INTEGER = 394

	S_FATT_DIE8: INTEGER = 395

	S_FATT_DIE9: INTEGER = 396

	S_FATT_DIE10: INTEGER = 397

	S_FATT_RAISE1: INTEGER = 398

	S_FATT_RAISE2: INTEGER = 399

	S_FATT_RAISE3: INTEGER = 400

	S_FATT_RAISE4: INTEGER = 401

	S_FATT_RAISE5: INTEGER = 402

	S_FATT_RAISE6: INTEGER = 403

	S_FATT_RAISE7: INTEGER = 404

	S_FATT_RAISE8: INTEGER = 405

	S_CPOS_STND: INTEGER = 406

	S_CPOS_STND2: INTEGER = 407

	S_CPOS_RUN1: INTEGER = 408

	S_CPOS_RUN2: INTEGER = 409

	S_CPOS_RUN3: INTEGER = 410

	S_CPOS_RUN4: INTEGER = 411

	S_CPOS_RUN5: INTEGER = 412

	S_CPOS_RUN6: INTEGER = 413

	S_CPOS_RUN7: INTEGER = 414

	S_CPOS_RUN8: INTEGER = 415

	S_CPOS_ATK1: INTEGER = 416

	S_CPOS_ATK2: INTEGER = 417

	S_CPOS_ATK3: INTEGER = 418

	S_CPOS_ATK4: INTEGER = 419

	S_CPOS_PAIN: INTEGER = 420

	S_CPOS_PAIN2: INTEGER = 421

	S_CPOS_DIE1: INTEGER = 422

	S_CPOS_DIE2: INTEGER = 423

	S_CPOS_DIE3: INTEGER = 424

	S_CPOS_DIE4: INTEGER = 425

	S_CPOS_DIE5: INTEGER = 426

	S_CPOS_DIE6: INTEGER = 427

	S_CPOS_DIE7: INTEGER = 428

	S_CPOS_XDIE1: INTEGER = 429

	S_CPOS_XDIE2: INTEGER = 430

	S_CPOS_XDIE3: INTEGER = 431

	S_CPOS_XDIE4: INTEGER = 432

	S_CPOS_XDIE5: INTEGER = 433

	S_CPOS_XDIE6: INTEGER = 434

	S_CPOS_RAISE1: INTEGER = 435

	S_CPOS_RAISE2: INTEGER = 436

	S_CPOS_RAISE3: INTEGER = 437

	S_CPOS_RAISE4: INTEGER = 438

	S_CPOS_RAISE5: INTEGER = 439

	S_CPOS_RAISE6: INTEGER = 440

	S_CPOS_RAISE7: INTEGER = 441

	S_TROO_STND: INTEGER = 442

	S_TROO_STND2: INTEGER = 443

	S_TROO_RUN1: INTEGER = 444

	S_TROO_RUN2: INTEGER = 445

	S_TROO_RUN3: INTEGER = 446

	S_TROO_RUN4: INTEGER = 447

	S_TROO_RUN5: INTEGER = 448

	S_TROO_RUN6: INTEGER = 449

	S_TROO_RUN7: INTEGER = 450

	S_TROO_RUN8: INTEGER = 451

	S_TROO_ATK1: INTEGER = 452

	S_TROO_ATK2: INTEGER = 453

	S_TROO_ATK3: INTEGER = 454

	S_TROO_PAIN: INTEGER = 455

	S_TROO_PAIN2: INTEGER = 456

	S_TROO_DIE1: INTEGER = 457

	S_TROO_DIE2: INTEGER = 458

	S_TROO_DIE3: INTEGER = 459

	S_TROO_DIE4: INTEGER = 460

	S_TROO_DIE5: INTEGER = 461

	S_TROO_XDIE1: INTEGER = 462

	S_TROO_XDIE2: INTEGER = 463

	S_TROO_XDIE3: INTEGER = 464

	S_TROO_XDIE4: INTEGER = 465

	S_TROO_XDIE5: INTEGER = 466

	S_TROO_XDIE6: INTEGER = 467

	S_TROO_XDIE7: INTEGER = 468

	S_TROO_XDIE8: INTEGER = 469

	S_TROO_RAISE1: INTEGER = 470

	S_TROO_RAISE2: INTEGER = 471

	S_TROO_RAISE3: INTEGER = 472

	S_TROO_RAISE4: INTEGER = 473

	S_TROO_RAISE5: INTEGER = 474

	S_SARG_STND: INTEGER = 475

	S_SARG_STND2: INTEGER = 476

	S_SARG_RUN1: INTEGER = 477

	S_SARG_RUN2: INTEGER = 478

	S_SARG_RUN3: INTEGER = 479

	S_SARG_RUN4: INTEGER = 480

	S_SARG_RUN5: INTEGER = 481

	S_SARG_RUN6: INTEGER = 482

	S_SARG_RUN7: INTEGER = 483

	S_SARG_RUN8: INTEGER = 484

	S_SARG_ATK1: INTEGER = 485

	S_SARG_ATK2: INTEGER = 486

	S_SARG_ATK3: INTEGER = 487

	S_SARG_PAIN: INTEGER = 488

	S_SARG_PAIN2: INTEGER = 489

	S_SARG_DIE1: INTEGER = 490

	S_SARG_DIE2: INTEGER = 491

	S_SARG_DIE3: INTEGER = 492

	S_SARG_DIE4: INTEGER = 493

	S_SARG_DIE5: INTEGER = 494

	S_SARG_DIE6: INTEGER = 495

	S_SARG_RAISE1: INTEGER = 496

	S_SARG_RAISE2: INTEGER = 497

	S_SARG_RAISE3: INTEGER = 498

	S_SARG_RAISE4: INTEGER = 499

	S_SARG_RAISE5: INTEGER = 500

	S_SARG_RAISE6: INTEGER = 501

	S_HEAD_STND: INTEGER = 502

	S_HEAD_RUN1: INTEGER = 503

	S_HEAD_ATK1: INTEGER = 504

	S_HEAD_ATK2: INTEGER = 505

	S_HEAD_ATK3: INTEGER = 506

	S_HEAD_PAIN: INTEGER = 507

	S_HEAD_PAIN2: INTEGER = 508

	S_HEAD_PAIN3: INTEGER = 509

	S_HEAD_DIE1: INTEGER = 510

	S_HEAD_DIE2: INTEGER = 511

	S_HEAD_DIE3: INTEGER = 512

	S_HEAD_DIE4: INTEGER = 513

	S_HEAD_DIE5: INTEGER = 514

	S_HEAD_DIE6: INTEGER = 515

	S_HEAD_RAISE1: INTEGER = 516

	S_HEAD_RAISE2: INTEGER = 517

	S_HEAD_RAISE3: INTEGER = 518

	S_HEAD_RAISE4: INTEGER = 519

	S_HEAD_RAISE5: INTEGER = 520

	S_HEAD_RAISE6: INTEGER = 521

	S_BRBALL1: INTEGER = 522

	S_BRBALL2: INTEGER = 523

	S_BRBALLX1: INTEGER = 524

	S_BRBALLX2: INTEGER = 525

	S_BRBALLX3: INTEGER = 526

	S_BOSS_STND: INTEGER = 527

	S_BOSS_STND2: INTEGER = 528

	S_BOSS_RUN1: INTEGER = 529

	S_BOSS_RUN2: INTEGER = 530

	S_BOSS_RUN3: INTEGER = 531

	S_BOSS_RUN4: INTEGER = 532

	S_BOSS_RUN5: INTEGER = 533

	S_BOSS_RUN6: INTEGER = 534

	S_BOSS_RUN7: INTEGER = 535

	S_BOSS_RUN8: INTEGER = 536

	S_BOSS_ATK1: INTEGER = 537

	S_BOSS_ATK2: INTEGER = 538

	S_BOSS_ATK3: INTEGER = 539

	S_BOSS_PAIN: INTEGER = 540

	S_BOSS_PAIN2: INTEGER = 541

	S_BOSS_DIE1: INTEGER = 542

	S_BOSS_DIE2: INTEGER = 543

	S_BOSS_DIE3: INTEGER = 544

	S_BOSS_DIE4: INTEGER = 545

	S_BOSS_DIE5: INTEGER = 546

	S_BOSS_DIE6: INTEGER = 547

	S_BOSS_DIE7: INTEGER = 548

	S_BOSS_RAISE1: INTEGER = 549

	S_BOSS_RAISE2: INTEGER = 550

	S_BOSS_RAISE3: INTEGER = 551

	S_BOSS_RAISE4: INTEGER = 552

	S_BOSS_RAISE5: INTEGER = 553

	S_BOSS_RAISE6: INTEGER = 554

	S_BOSS_RAISE7: INTEGER = 555

	S_BOS2_STND: INTEGER = 556

	S_BOS2_STND2: INTEGER = 557

	S_BOS2_RUN1: INTEGER = 558

	S_BOS2_RUN2: INTEGER = 559

	S_BOS2_RUN3: INTEGER = 560

	S_BOS2_RUN4: INTEGER = 561

	S_BOS2_RUN5: INTEGER = 562

	S_BOS2_RUN6: INTEGER = 563

	S_BOS2_RUN7: INTEGER = 564

	S_BOS2_RUN8: INTEGER = 565

	S_BOS2_ATK1: INTEGER = 566

	S_BOS2_ATK2: INTEGER = 567

	S_BOS2_ATK3: INTEGER = 568

	S_BOS2_PAIN: INTEGER = 569

	S_BOS2_PAIN2: INTEGER = 570

	S_BOS2_DIE1: INTEGER = 571

	S_BOS2_DIE2: INTEGER = 572

	S_BOS2_DIE3: INTEGER = 573

	S_BOS2_DIE4: INTEGER = 574

	S_BOS2_DIE5: INTEGER = 575

	S_BOS2_DIE6: INTEGER = 576

	S_BOS2_DIE7: INTEGER = 577

	S_BOS2_RAISE1: INTEGER = 578

	S_BOS2_RAISE2: INTEGER = 579

	S_BOS2_RAISE3: INTEGER = 580

	S_BOS2_RAISE4: INTEGER = 581

	S_BOS2_RAISE5: INTEGER = 582

	S_BOS2_RAISE6: INTEGER = 583

	S_BOS2_RAISE7: INTEGER = 584

	S_SKULL_STND: INTEGER = 585

	S_SKULL_STND2: INTEGER = 586

	S_SKULL_RUN1: INTEGER = 587

	S_SKULL_RUN2: INTEGER = 588

	S_SKULL_ATK1: INTEGER = 589

	S_SKULL_ATK2: INTEGER = 590

	S_SKULL_ATK3: INTEGER = 591

	S_SKULL_ATK4: INTEGER = 592

	S_SKULL_PAIN: INTEGER = 593

	S_SKULL_PAIN2: INTEGER = 594

	S_SKULL_DIE1: INTEGER = 595

	S_SKULL_DIE2: INTEGER = 596

	S_SKULL_DIE3: INTEGER = 597

	S_SKULL_DIE4: INTEGER = 598

	S_SKULL_DIE5: INTEGER = 599

	S_SKULL_DIE6: INTEGER = 600

	S_SPID_STND: INTEGER = 601

	S_SPID_STND2: INTEGER = 602

	S_SPID_RUN1: INTEGER = 603

	S_SPID_RUN2: INTEGER = 604

	S_SPID_RUN3: INTEGER = 605

	S_SPID_RUN4: INTEGER = 606

	S_SPID_RUN5: INTEGER = 607

	S_SPID_RUN6: INTEGER = 608

	S_SPID_RUN7: INTEGER = 609

	S_SPID_RUN8: INTEGER = 610

	S_SPID_RUN9: INTEGER = 611

	S_SPID_RUN10: INTEGER = 612

	S_SPID_RUN11: INTEGER = 613

	S_SPID_RUN12: INTEGER = 614

	S_SPID_ATK1: INTEGER = 615

	S_SPID_ATK2: INTEGER = 616

	S_SPID_ATK3: INTEGER = 617

	S_SPID_ATK4: INTEGER = 618

	S_SPID_PAIN: INTEGER = 619

	S_SPID_PAIN2: INTEGER = 620

	S_SPID_DIE1: INTEGER = 621

	S_SPID_DIE2: INTEGER = 622

	S_SPID_DIE3: INTEGER = 623

	S_SPID_DIE4: INTEGER = 624

	S_SPID_DIE5: INTEGER = 625

	S_SPID_DIE6: INTEGER = 626

	S_SPID_DIE7: INTEGER = 627

	S_SPID_DIE8: INTEGER = 628

	S_SPID_DIE9: INTEGER = 629

	S_SPID_DIE10: INTEGER = 630

	S_SPID_DIE11: INTEGER = 631

	S_BSPI_STND: INTEGER = 632

	S_BSPI_STND2: INTEGER = 633

	S_BSPI_SIGHT: INTEGER = 634

	S_BSPI_RUN1: INTEGER = 635

	S_BSPI_RUN2: INTEGER = 636

	S_BSPI_RUN3: INTEGER = 637

	S_BSPI_RUN4: INTEGER = 638

	S_BSPI_RUN5: INTEGER = 639

	S_BSPI_RUN6: INTEGER = 640

	S_BSPI_RUN7: INTEGER = 641

	S_BSPI_RUN8: INTEGER = 642

	S_BSPI_RUN9: INTEGER = 643

	S_BSPI_RUN10: INTEGER = 644

	S_BSPI_RUN11: INTEGER = 645

	S_BSPI_RUN12: INTEGER = 646

	S_BSPI_ATK1: INTEGER = 647

	S_BSPI_ATK2: INTEGER = 648

	S_BSPI_ATK3: INTEGER = 649

	S_BSPI_ATK4: INTEGER = 650

	S_BSPI_PAIN: INTEGER = 651

	S_BSPI_PAIN2: INTEGER = 652

	S_BSPI_DIE1: INTEGER = 653

	S_BSPI_DIE2: INTEGER = 654

	S_BSPI_DIE3: INTEGER = 655

	S_BSPI_DIE4: INTEGER = 656

	S_BSPI_DIE5: INTEGER = 657

	S_BSPI_DIE6: INTEGER = 658

	S_BSPI_DIE7: INTEGER = 659

	S_BSPI_RAISE1: INTEGER = 660

	S_BSPI_RAISE2: INTEGER = 661

	S_BSPI_RAISE3: INTEGER = 662

	S_BSPI_RAISE4: INTEGER = 663

	S_BSPI_RAISE5: INTEGER = 664

	S_BSPI_RAISE6: INTEGER = 665

	S_BSPI_RAISE7: INTEGER = 666

	S_ARACH_PLAZ: INTEGER = 667

	S_ARACH_PLAZ2: INTEGER = 668

	S_ARACH_PLEX: INTEGER = 669

	S_ARACH_PLEX2: INTEGER = 670

	S_ARACH_PLEX3: INTEGER = 671

	S_ARACH_PLEX4: INTEGER = 672

	S_ARACH_PLEX5: INTEGER = 673

	S_CYBER_STND: INTEGER = 674

	S_CYBER_STND2: INTEGER = 675

	S_CYBER_RUN1: INTEGER = 676

	S_CYBER_RUN2: INTEGER = 677

	S_CYBER_RUN3: INTEGER = 678

	S_CYBER_RUN4: INTEGER = 679

	S_CYBER_RUN5: INTEGER = 680

	S_CYBER_RUN6: INTEGER = 681

	S_CYBER_RUN7: INTEGER = 682

	S_CYBER_RUN8: INTEGER = 683

	S_CYBER_ATK1: INTEGER = 684

	S_CYBER_ATK2: INTEGER = 685

	S_CYBER_ATK3: INTEGER = 686

	S_CYBER_ATK4: INTEGER = 687

	S_CYBER_ATK5: INTEGER = 688

	S_CYBER_ATK6: INTEGER = 689

	S_CYBER_PAIN: INTEGER = 690

	S_CYBER_DIE1: INTEGER = 691

	S_CYBER_DIE2: INTEGER = 692

	S_CYBER_DIE3: INTEGER = 693

	S_CYBER_DIE4: INTEGER = 694

	S_CYBER_DIE5: INTEGER = 695

	S_CYBER_DIE6: INTEGER = 696

	S_CYBER_DIE7: INTEGER = 697

	S_CYBER_DIE8: INTEGER = 698

	S_CYBER_DIE9: INTEGER = 699

	S_CYBER_DIE10: INTEGER = 700

	S_PAIN_STND: INTEGER = 701

	S_PAIN_RUN1: INTEGER = 702

	S_PAIN_RUN2: INTEGER = 703

	S_PAIN_RUN3: INTEGER = 704

	S_PAIN_RUN4: INTEGER = 705

	S_PAIN_RUN5: INTEGER = 706

	S_PAIN_RUN6: INTEGER = 707

	S_PAIN_ATK1: INTEGER = 708

	S_PAIN_ATK2: INTEGER = 709

	S_PAIN_ATK3: INTEGER = 710

	S_PAIN_ATK4: INTEGER = 711

	S_PAIN_PAIN: INTEGER = 712

	S_PAIN_PAIN2: INTEGER = 713

	S_PAIN_DIE1: INTEGER = 714

	S_PAIN_DIE2: INTEGER = 715

	S_PAIN_DIE3: INTEGER = 716

	S_PAIN_DIE4: INTEGER = 717

	S_PAIN_DIE5: INTEGER = 718

	S_PAIN_DIE6: INTEGER = 719

	S_PAIN_RAISE1: INTEGER = 720

	S_PAIN_RAISE2: INTEGER = 721

	S_PAIN_RAISE3: INTEGER = 722

	S_PAIN_RAISE4: INTEGER = 723

	S_PAIN_RAISE5: INTEGER = 724

	S_PAIN_RAISE6: INTEGER = 725

	S_SSWV_STND: INTEGER = 726

	S_SSWV_STND2: INTEGER = 727

	S_SSWV_RUN1: INTEGER = 728

	S_SSWV_RUN2: INTEGER = 729

	S_SSWV_RUN3: INTEGER = 730

	S_SSWV_RUN4: INTEGER = 731

	S_SSWV_RUN5: INTEGER = 732

	S_SSWV_RUN6: INTEGER = 733

	S_SSWV_RUN7: INTEGER = 734

	S_SSWV_RUN8: INTEGER = 735

	S_SSWV_ATK1: INTEGER = 736

	S_SSWV_ATK2: INTEGER = 737

	S_SSWV_ATK3: INTEGER = 738

	S_SSWV_ATK4: INTEGER = 739

	S_SSWV_ATK5: INTEGER = 740

	S_SSWV_ATK6: INTEGER = 741

	S_SSWV_PAIN: INTEGER = 742

	S_SSWV_PAIN2: INTEGER = 743

	S_SSWV_DIE1: INTEGER = 744

	S_SSWV_DIE2: INTEGER = 745

	S_SSWV_DIE3: INTEGER = 746

	S_SSWV_DIE4: INTEGER = 747

	S_SSWV_DIE5: INTEGER = 748

	S_SSWV_XDIE1: INTEGER = 749

	S_SSWV_XDIE2: INTEGER = 750

	S_SSWV_XDIE3: INTEGER = 751

	S_SSWV_XDIE4: INTEGER = 752

	S_SSWV_XDIE5: INTEGER = 753

	S_SSWV_XDIE6: INTEGER = 754

	S_SSWV_XDIE7: INTEGER = 755

	S_SSWV_XDIE8: INTEGER = 756

	S_SSWV_XDIE9: INTEGER = 757

	S_SSWV_RAISE1: INTEGER = 758

	S_SSWV_RAISE2: INTEGER = 759

	S_SSWV_RAISE3: INTEGER = 760

	S_SSWV_RAISE4: INTEGER = 761

	S_SSWV_RAISE5: INTEGER = 762

	S_KEENSTND: INTEGER = 763

	S_COMMKEEN: INTEGER = 764

	S_COMMKEEN2: INTEGER = 765

	S_COMMKEEN3: INTEGER = 766

	S_COMMKEEN4: INTEGER = 767

	S_COMMKEEN5: INTEGER = 768

	S_COMMKEEN6: INTEGER = 769

	S_COMMKEEN7: INTEGER = 770

	S_COMMKEEN8: INTEGER = 771

	S_COMMKEEN9: INTEGER = 772

	S_COMMKEEN10: INTEGER = 773

	S_COMMKEEN11: INTEGER = 774

	S_COMMKEEN12: INTEGER = 775

	S_KEENPAIN: INTEGER = 776

	S_KEENPAIN2: INTEGER = 777

	S_BRAIN: INTEGER = 778

	S_BRAIN_PAIN: INTEGER = 779

	S_BRAIN_DIE1: INTEGER = 780

	S_BRAIN_DIE2: INTEGER = 781

	S_BRAIN_DIE3: INTEGER = 782

	S_BRAIN_DIE4: INTEGER = 783

	S_BRAINEYE: INTEGER = 784

	S_BRAINEYESEE: INTEGER = 785

	S_BRAINEYE1: INTEGER = 786

	S_SPAWN1: INTEGER = 787

	S_SPAWN2: INTEGER = 788

	S_SPAWN3: INTEGER = 789

	S_SPAWN4: INTEGER = 790

	S_SPAWNFIRE1: INTEGER = 791

	S_SPAWNFIRE2: INTEGER = 792

	S_SPAWNFIRE3: INTEGER = 793

	S_SPAWNFIRE4: INTEGER = 794

	S_SPAWNFIRE5: INTEGER = 795

	S_SPAWNFIRE6: INTEGER = 796

	S_SPAWNFIRE7: INTEGER = 797

	S_SPAWNFIRE8: INTEGER = 798

	S_BRAINEXPLODE1: INTEGER = 799

	S_BRAINEXPLODE2: INTEGER = 800

	S_BRAINEXPLODE3: INTEGER = 801

	S_ARM1: INTEGER = 802

	S_ARM1A: INTEGER = 803

	S_ARM2: INTEGER = 804

	S_ARM2A: INTEGER = 805

	S_BAR1: INTEGER = 806

	S_BAR2: INTEGER = 807

	S_BEXP: INTEGER = 808

	S_BEXP2: INTEGER = 809

	S_BEXP3: INTEGER = 810

	S_BEXP4: INTEGER = 811

	S_BEXP5: INTEGER = 812

	S_BBAR1: INTEGER = 813

	S_BBAR2: INTEGER = 814

	S_BBAR3: INTEGER = 815

	S_BON1: INTEGER = 816

	S_BON1A: INTEGER = 817

	S_BON1B: INTEGER = 818

	S_BON1C: INTEGER = 819

	S_BON1D: INTEGER = 820

	S_BON1E: INTEGER = 821

	S_BON2: INTEGER = 822

	S_BON2A: INTEGER = 823

	S_BON2B: INTEGER = 824

	S_BON2C: INTEGER = 825

	S_BON2D: INTEGER = 826

	S_BON2E: INTEGER = 827

	S_BKEY: INTEGER = 828

	S_BKEY2: INTEGER = 829

	S_RKEY: INTEGER = 830

	S_RKEY2: INTEGER = 831

	S_YKEY: INTEGER = 832

	S_YKEY2: INTEGER = 833

	S_BSKULL: INTEGER = 834

	S_BSKULL2: INTEGER = 835

	S_RSKULL: INTEGER = 836

	S_RSKULL2: INTEGER = 837

	S_YSKULL: INTEGER = 838

	S_YSKULL2: INTEGER = 839

	S_STIM: INTEGER = 840

	S_MEDI: INTEGER = 841

	S_SOUL: INTEGER = 842

	S_SOUL2: INTEGER = 843

	S_SOUL3: INTEGER = 844

	S_SOUL4: INTEGER = 845

	S_SOUL5: INTEGER = 846

	S_SOUL6: INTEGER = 847

	S_PINV: INTEGER = 848

	S_PINV2: INTEGER = 849

	S_PINV3: INTEGER = 850

	S_PINV4: INTEGER = 851

	S_PSTR: INTEGER = 852

	S_PINS: INTEGER = 853

	S_PINS2: INTEGER = 854

	S_PINS3: INTEGER = 855

	S_PINS4: INTEGER = 856

	S_MEGA: INTEGER = 857

	S_MEGA2: INTEGER = 858

	S_MEGA3: INTEGER = 859

	S_MEGA4: INTEGER = 860

	S_SUIT: INTEGER = 861

	S_PMAP: INTEGER = 862

	S_PMAP2: INTEGER = 863

	S_PMAP3: INTEGER = 864

	S_PMAP4: INTEGER = 865

	S_PMAP5: INTEGER = 866

	S_PMAP6: INTEGER = 867

	S_PVIS: INTEGER = 868

	S_PVIS2: INTEGER = 869

	S_CLIP: INTEGER = 870

	S_AMMO: INTEGER = 871

	S_ROCK: INTEGER = 872

	S_BROK: INTEGER = 873

	S_CELL: INTEGER = 874

	S_CELP: INTEGER = 875

	S_SHEL: INTEGER = 876

	S_SBOX: INTEGER = 877

	S_BPAK: INTEGER = 878

	S_BFUG: INTEGER = 879

	S_MGUN: INTEGER = 880

	S_CSAW: INTEGER = 881

	S_LAUN: INTEGER = 882

	S_PLAS: INTEGER = 883

	S_SHOT: INTEGER = 884

	S_SHOT2: INTEGER = 885

	S_COLU: INTEGER = 886

	S_STALAG: INTEGER = 887

	S_BLOODYTWITCH: INTEGER = 888

	S_BLOODYTWITCH2: INTEGER = 889

	S_BLOODYTWITCH3: INTEGER = 890

	S_BLOODYTWITCH4: INTEGER = 891

	S_DEADTORSO: INTEGER = 892

	S_DEADBOTTOM: INTEGER = 893

	S_HEADSONSTICK: INTEGER = 894

	S_GIBS: INTEGER = 895

	S_HEADONASTICK: INTEGER = 896

	S_HEADCANDLES: INTEGER = 897

	S_HEADCANDLES2: INTEGER = 898

	S_DEADSTICK: INTEGER = 899

	S_LIVESTICK: INTEGER = 900

	S_LIVESTICK2: INTEGER = 901

	S_MEAT2: INTEGER = 902

	S_MEAT3: INTEGER = 903

	S_MEAT4: INTEGER = 904

	S_MEAT5: INTEGER = 905

	S_STALAGTITE: INTEGER = 906

	S_TALLGRNCOL: INTEGER = 907

	S_SHRTGRNCOL: INTEGER = 908

	S_TALLREDCOL: INTEGER = 909

	S_SHRTREDCOL: INTEGER = 910

	S_CANDLESTIK: INTEGER = 911

	S_CANDELABRA: INTEGER = 912

	S_SKULLCOL: INTEGER = 913

	S_TORCHTREE: INTEGER = 914

	S_BIGTREE: INTEGER = 915

	S_TECHPILLAR: INTEGER = 916

	S_EVILEYE: INTEGER = 917

	S_EVILEYE2: INTEGER = 918

	S_EVILEYE3: INTEGER = 919

	S_EVILEYE4: INTEGER = 920

	S_FLOATSKULL: INTEGER = 921

	S_FLOATSKULL2: INTEGER = 922

	S_FLOATSKULL3: INTEGER = 923

	S_HEARTCOL: INTEGER = 924

	S_HEARTCOL2: INTEGER = 925

	S_BLUETORCH: INTEGER = 926

	S_BLUETORCH2: INTEGER = 927

	S_BLUETORCH3: INTEGER = 928

	S_BLUETORCH4: INTEGER = 929

	S_GREENTORCH: INTEGER = 930

	S_GREENTORCH2: INTEGER = 931

	S_GREENTORCH3: INTEGER = 932

	S_GREENTORCH4: INTEGER = 933

	S_REDTORCH: INTEGER = 934

	S_REDTORCH2: INTEGER = 935

	S_REDTORCH3: INTEGER = 936

	S_REDTORCH4: INTEGER = 937

	S_BTORCHSHRT: INTEGER = 938

	S_BTORCHSHRT2: INTEGER = 939

	S_BTORCHSHRT3: INTEGER = 940

	S_BTORCHSHRT4: INTEGER = 941

	S_GTORCHSHRT: INTEGER = 942

	S_GTORCHSHRT2: INTEGER = 943

	S_GTORCHSHRT3: INTEGER = 944

	S_GTORCHSHRT4: INTEGER = 945

	S_RTORCHSHRT: INTEGER = 946

	S_RTORCHSHRT2: INTEGER = 947

	S_RTORCHSHRT3: INTEGER = 948

	S_RTORCHSHRT4: INTEGER = 949

	S_HANGNOGUTS: INTEGER = 950

	S_HANGBNOBRAIN: INTEGER = 951

	S_HANGTLOOKDN: INTEGER = 952

	S_HANGTSKULL: INTEGER = 953

	S_HANGTLOOKUP: INTEGER = 954

	S_HANGTNOBRAIN: INTEGER = 955

	S_COLONGIBS: INTEGER = 956

	S_SMALLPOOL: INTEGER = 957

	S_BRAINSTEM: INTEGER = 958

	S_TECHLAMP: INTEGER = 959

	S_TECHLAMP2: INTEGER = 960

	S_TECHLAMP3: INTEGER = 961

	S_TECHLAMP4: INTEGER = 962

	S_TECH2LAMP: INTEGER = 963

	S_TECH2LAMP2: INTEGER = 964

	S_TECH2LAMP3: INTEGER = 965

	S_TECH2LAMP4: INTEGER = 966

	NUMSTATES: INTEGER = 967

end
