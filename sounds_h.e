note
	description: "sounds.h"

class
	SOUNDS_H

feature -- sfxenum_t

	sfx_None: INTEGER = 0

	sfx_pistol: INTEGER = 1

	sfx_shotgun: INTEGER = 2

	sfx_sgcock: INTEGER = 3

	sfx_dshtgun: INTEGER = 4

	sfx_dbopn: INTEGER = 5

	sfx_dbcls: INTEGER = 6

	sfx_dbload: INTEGER = 7

	sfx_plasma: INTEGER = 8

	sfx_bfg: INTEGER = 9

	sfx_sawup: INTEGER = 10

	sfx_sawidl: INTEGER = 11

	sfx_sawful: INTEGER = 12

	sfx_sawhit: INTEGER = 13

	sfx_rlaunc: INTEGER = 14

	sfx_rxplod: INTEGER = 15

	sfx_firsht: INTEGER = 16

	sfx_firxpl: INTEGER = 17

	sfx_pstart: INTEGER = 18

	sfx_pstop: INTEGER = 19

	sfx_doropn: INTEGER = 20

	sfx_dorcls: INTEGER = 21

	sfx_stnmov: INTEGER = 22

	sfx_swtchn: INTEGER = 23

	sfx_swtchx: INTEGER = 24

	sfx_plpain: INTEGER = 25

	sfx_dmpain: INTEGER = 26

	sfx_popain: INTEGER = 27

	sfx_vipain: INTEGER = 28

	sfx_mnpain: INTEGER = 29

	sfx_pepain: INTEGER = 30

	sfx_slop: INTEGER = 31

	sfx_itemup: INTEGER = 32

	sfx_wpnup: INTEGER = 33

	sfx_oof: INTEGER = 34

	sfx_telept: INTEGER = 35

	sfx_posit1: INTEGER = 36

	sfx_posit2: INTEGER = 37

	sfx_posit3: INTEGER = 38

	sfx_bgsit1: INTEGER = 39

	sfx_bgsit2: INTEGER = 40

	sfx_sgsit: INTEGER = 41

	sfx_cacsit: INTEGER = 42

	sfx_brssit: INTEGER = 43

	sfx_cybsit: INTEGER = 44

	sfx_spisit: INTEGER = 45

	sfx_bspsit: INTEGER = 46

	sfx_kntsit: INTEGER = 47

	sfx_vilsit: INTEGER = 48

	sfx_mansit: INTEGER = 49

	sfx_pesit: INTEGER = 50

	sfx_sklatk: INTEGER = 51

	sfx_sgtatk: INTEGER = 52

	sfx_skepch: INTEGER = 53

	sfx_vilatk: INTEGER = 54

	sfx_claw: INTEGER = 55

	sfx_skeswg: INTEGER = 56

	sfx_pldeth: INTEGER = 57

	sfx_pdiehi: INTEGER = 58

	sfx_podth1: INTEGER = 59

	sfx_podth2: INTEGER = 60

	sfx_podth3: INTEGER = 61

	sfx_bgdth1: INTEGER = 62

	sfx_bgdth2: INTEGER = 63

	sfx_sgtdth: INTEGER = 64

	sfx_cacdth: INTEGER = 65

	sfx_skldth: INTEGER = 66

	sfx_brsdth: INTEGER = 67

	sfx_cybdth: INTEGER = 68

	sfx_spidth: INTEGER = 69

	sfx_bspdth: INTEGER = 70

	sfx_vildth: INTEGER = 71

	sfx_kntdth: INTEGER = 72

	sfx_pedth: INTEGER = 73

	sfx_skedth: INTEGER = 74

	sfx_posact: INTEGER = 75

	sfx_bgact: INTEGER = 76

	sfx_dmact: INTEGER = 77

	sfx_bspact: INTEGER = 78

	sfx_bspwlk: INTEGER = 79

	sfx_vilact: INTEGER = 80

	sfx_noway: INTEGER = 81

	sfx_barexp: INTEGER = 82

	sfx_punch: INTEGER = 83

	sfx_hoof: INTEGER = 84

	sfx_metal: INTEGER = 85

	sfx_chgun: INTEGER = 86

	sfx_tink: INTEGER = 87

	sfx_bdopn: INTEGER = 88

	sfx_bdcls: INTEGER = 89

	sfx_itmbk: INTEGER = 90

	sfx_flame: INTEGER = 91

	sfx_flamst: INTEGER = 92

	sfx_getpow: INTEGER = 93

	sfx_bospit: INTEGER = 94

	sfx_boscub: INTEGER = 95

	sfx_bossit: INTEGER = 96

	sfx_bospn: INTEGER = 97

	sfx_bosdth: INTEGER = 98

	sfx_manatk: INTEGER = 99

	sfx_mandth: INTEGER = 100

	sfx_sssit: INTEGER = 101

	sfx_ssdth: INTEGER = 102

	sfx_keenpn: INTEGER = 103

	sfx_keendt: INTEGER = 104

	sfx_skeact: INTEGER = 105

	sfx_skesit: INTEGER = 106

	sfx_skeatk: INTEGER = 107

	sfx_radio: INTEGER = 108

	NUMSFX: INTEGER = 109

feature -- musicenum_t

	mus_None: INTEGER = 0

	mus_e1m1: INTEGER = 1

	mus_e1m2: INTEGER = 2

	mus_e1m3: INTEGER = 3

	mus_e1m4: INTEGER = 4

	mus_e1m5: INTEGER = 5

	mus_e1m6: INTEGER = 6

	mus_e1m7: INTEGER = 7

	mus_e1m8: INTEGER = 8

	mus_e1m9: INTEGER = 9

	mus_e2m1: INTEGER = 10

	mus_e2m2: INTEGER = 11

	mus_e2m3: INTEGER = 12

	mus_e2m4: INTEGER = 13

	mus_e2m5: INTEGER = 14

	mus_e2m6: INTEGER = 15

	mus_e2m7: INTEGER = 16

	mus_e2m8: INTEGER = 17

	mus_e2m9: INTEGER = 18

	mus_e3m1: INTEGER = 19

	mus_e3m2: INTEGER = 20

	mus_e3m3: INTEGER = 21

	mus_e3m4: INTEGER = 22

	mus_e3m5: INTEGER = 23

	mus_e3m6: INTEGER = 24

	mus_e3m7: INTEGER = 25

	mus_e3m8: INTEGER = 26

	mus_e3m9: INTEGER = 27

	mus_inter: INTEGER = 28

	mus_intro: INTEGER = 29

	mus_bunny: INTEGER = 30

	mus_victor: INTEGER = 31

	mus_introa: INTEGER = 32

	mus_runnin: INTEGER = 33

	mus_stalks: INTEGER = 34

	mus_countd: INTEGER = 35

	mus_betwee: INTEGER = 36

	mus_doom: INTEGER = 37

	mus_the_da: INTEGER = 38

	mus_shawn: INTEGER = 39

	mus_ddtblu: INTEGER = 40

	mus_in_cit: INTEGER = 41

	mus_dead: INTEGER = 42

	mus_stlks2: INTEGER = 43

	mus_theda2: INTEGER = 44

	mus_doom2: INTEGER = 45

	mus_ddtbl2: INTEGER = 46

	mus_runni2: INTEGER = 47

	mus_dead2: INTEGER = 48

	mus_stlks3: INTEGER = 49

	mus_romero: INTEGER = 50

	mus_shawn2: INTEGER = 51

	mus_messag: INTEGER = 52

	mus_count2: INTEGER = 53

	mus_ddtbl3: INTEGER = 54

	mus_ampie: INTEGER = 55

	mus_theda3: INTEGER = 56

	mus_adrian: INTEGER = 57

	mus_messg2: INTEGER = 58

	mus_romer2: INTEGER = 59

	mus_tense: INTEGER = 60

	mus_shawn3: INTEGER = 61

	mus_openin: INTEGER = 62

	mus_evil: INTEGER = 63

	mus_ultima: INTEGER = 64

	mus_read_m: INTEGER = 65

	mus_dm2ttl: INTEGER = 66

	mus_dm2int: INTEGER = 67

	NUMMUSIC: INTEGER = 68

end
