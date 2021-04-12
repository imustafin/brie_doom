# Brie Doom
DOOM source port in Eiffel with SDL2

Brie is pronounced */briː/* like Brie cheese :cheese:

Based on https://github.com/makava/sdldoom-1.10-mod with occasional peeks at https://github.com/chocolate-doom/chocolate-doom

## Requirements
* My wrap_sdl fork https://github.com/imustafin/wrap_sdl

## Troubleshooting

### No music
Depending on the configured music device, Brie Doom might use MIDI output 
for music. In this case, check the correspondent SDL Mixer env vars like:
* `SDL_SOUNDFONTS` for setting the path to the soundfont.
Fluid R3 General MIDI Soundfont is known to work.
Set it like `SDL_SOUNDFONTS=/usr/share/soundfonts/FluidR3_GM.sf2`.
