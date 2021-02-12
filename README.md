# sdl-eiffel-doom
SDL Doom rewrite in Eiffel

Based on https://github.com/makava/sdldoom-1.10-mod

## Requirements
* [wrap_sdl](https://github.com/eiffel-wrap-c/wrap_sdl)

### Installing wrap_sdl
On my system (Arch Linux) SDL2 headers were located not in `/usr/local/include`
but in `/usr/include`, so I had to change this path in several locations:
* `sdl/generator.sh`: change `--full-header` value to `/usr/include/SDL2/SDL.h`
* `sdl_image/generator.sh`: change `--full-header` value to `/usr/include/SDL2/SDL_image.h`
* `sdl_image/sdl_image.ecf`: strip `/local` from paths
* `sdl/wrap_sdl2.ecf`: strip `/local` from paths
