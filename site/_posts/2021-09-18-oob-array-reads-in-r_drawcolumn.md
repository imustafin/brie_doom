---
layout: post
title: OOB array reads in R_DrawColumn
tags: phase-1-bugs bugs phase-1
---
In some circumstances there is an out of bounds array read in
[`R_DrawColumn`](https://github.com/id-Software/DOOM/blob/77735c3ff0772609e9c8d29e3ce2ab42ff54d20b/linuxdoom-1.10/r_draw.c#L105):

{% highlight c %}
// Determine scaling,
//  which is the only mapping to be done.
fracstep = dc_iscale; 
frac = dc_texturemid + (dc_yl-centery)*fracstep; 

// Inner loop that does the actual texture mapping,
//  e.g. a DDA-lile scaling.
// This is as fast as it gets.
do 
{
  // Re-map color indices from wall texture column
  //  using a lighting/special effects LUT.
  *dest = dc_colormap[dc_source[(frac>>FRACBITS)&127]];

  dest += SCREENWIDTH; 
  frac += fracstep;

} while (count--); 
{% endhighlight %}

The offending expression is `dc_source[(frac>>FRACBITS)&127]`. The `dc_source`
variable is a pointer to a column of what to draw on the screen.
Usually it has 128 elements, so truncating it with `&127` is preventing
the OOB accesses. However, in some cases `dc_source` can point to a shorter
array which leads to OOB reads.

This bug was found with the help of contracts in the classes we wrote for
emulating C pointer arithmetic,
namely
[`BYTE_SEQUENCE`](https://github.com/imustafin/brie_doom/blob/50f595c05fbbe59509f158bcea390bc908a500e7/brie_doom/byte_sequence.e)
and
[`MANAGED_POINTER_WITH_OFFSET`](https://github.com/imustafin/brie_doom/blob/50f595c05fbbe59509f158bcea390bc908a500e7/brie_doom/pointers/managed_pointer_with_offset.e).
The contract is a precondition for the access operation, it checks that the
requested index is a valid index (not out of bounds).

As a
[temporary fix](https://github.com/imustafin/brie_doom/blob/ef087a9da170d90f48598b876e96bdda30e21763/brie_doom/render/r_draw.e#L212)
for this problem we first check if the access is valid
and only then we read from the array. If the access is invalid, we draw a
placeholder pixel with the color number `0`. This fix did not lead to any
visible changes in the game video output.

{% highlight eiffel %}
check attached dc_source as dcs then
  i := (frac |>> {M_FIXED}.FRACBITS) & 127
  if dcs.valid_index (i) then
    dc_source_val := dcs [i]
  else
    print ("R_DrawColumn: dc_source read out of bounds [" + i.out + "]%N")
    dc_source_val := 0
  end
end
check attached dc_colormap as dc_cmap then
  val := dc_cmap [dc_source_val]
end
dest.put (val, ofs)
{% endhighlight %}

Such check might incur some performance cost and just hides the presence of
this bug. A proper fix would require some code modifications in several places
of the code, but we avoid them in phase 1 and leave them for phase 2.
