class Combine
  def initialize(c_loc, c_funcs, eif_funcs)
    @c_loc = c_loc
    @c_funcs = c_funcs
    @eif_funcs = eif_funcs
  end

  def functions_ported
    moved = []
    joined = []
    stubs = []
    not_ported = []

    @c_funcs.each do |cfunc|
      cname = cfunc['cname']

      moved_expl = MOVED_EXPL[cname]
      if moved_expl
        moved << {
          **cfunc,
          explanation: moved_expl
        }

        next
      end

      eifs = @eif_funcs[cname]
      if eifs
        eif_loc = eifs.map { |x| x['loc'] }.sum
        c_to_e_frac = eif_loc.to_f / cfunc['cloc']

        data = {
          eif_loc: eif_loc,
          c_to_e_frac: c_to_e_frac,
          c_to_e: c_to_e_frac.round(1),
          eifs: eifs,
          cfunc: cfunc
        }

        any_stub = eifs.any? { |x| x['stub'] }

        if any_stub
          stubs << data
        else
          joined << data
        end

        next
      end

      not_ported << cfunc
    end

    moved = moved.sort_by { |x| [x[:c_to_e_frac], x[:cloc]] }.reverse
    stubs = stubs.sort_by { |x| [x[:c_to_e_frac], x[:cloc]] }.reverse
    joined = joined.sort_by { |x| [x[:c_to_e_frac], x[:cloc]] }.reverse

    e_loc = 26579 # Lines of Code for brie_doom cluster

    ported_ratio = ((joined.count + moved.count).to_f / @c_funcs.count)
    e_estimation = (e_loc / ported_ratio).ceil


    {
      total_c: @c_funcs.count,
      ported: joined.count + moved.count,
      ported_ratio: (ported_ratio * 100).round(2),
      stubbed_ratio: (stubs.count.to_f / @c_funcs.count * 100).round(2),
      c_loc: @c_loc,
      e_loc: e_loc,
      e_estimation: e_estimation,
      moved: moved,
      joined: joined,
      stubs: stubs,
      not_ported: not_ported
    }
  end

  ZONE = 'Zone memory management, replaced with Eiffel memory model'

  MOVED_EXPL = {
    'Expand4' => 'Video upscaling, covered by SDL',
    'AllocLow' => 'DOS memory allocation, not needed in Eiffel',
    'I_BaseTiccmd' => 'Simplified out',
    'BeginRead' => 'Originally empty, simplified out',
    'I_EndRead' => 'Originally empty, simplified out',
    'GetHeapSize' => 'Originally unused',
    'I_HandleSoundTimer' => 'Originally unused',
    'InitMusic' => 'Originally empty, simplified out',
    'I_QrySongPlaying' => 'Originally unused',
    'SetSfxVolume' => 'Originally unused',
    'I_SoundDelTimer' => 'Not needed with SDL',
    'SoundSetTimer' => 'Not needed with SDL',
    'I_SubmitSound' => 'Not needed with SDL',
    'ZoneBase' => 'Memory management, not needed in Eiffel',
    'InitExpand' => 'Video upscaling, covered by SDL',
    'InitExpand2' => 'Video upscaling, covered by SDL',
    'SwapLONG' => 'File endianness handling, replaced with Eiffel features',
    'SwapSHORT' => 'File endianness handling, replaced with Eiffel features',
    'addsfx' => 'Sound handling, covered by SDL',
    'createnullcursor' => 'X11 video output code, replaced with SDL',
    'filelength' => 'Get file length, replaced with Eiffel features',
    'getsfx' => 'Legacy sound interface, replaced with SDL',
    'grabsharedmemory' => 'X11 video handling, replaced with SDL',
    'myioctl' => 'Legacy sound interface, replaced with SDL',
    'strupr' => 'Upcase a string, replaced with Eiffel features',
    'Z_ChangeTag2' => 'Zone memory management, replaced with Eiffel GC',
    'Z_CheckHeap' => ZONE,
    'Z_ClearZone' => ZONE,
    'Z_DumpHeap' => ZONE,
    'Z_FileDumpHeap' => ZONE,
    'Z_Free' => ZONE,
    'Z_FreeMemory' => ZONE,
    'Z_FreeTags' => ZONE,
    'Z_Init' => ZONE,
    'Z_Malloc' => ZONE
  }.transform_keys(&:downcase)
end
