---
layout: post
title: Possible NPD with frontsector of line_t
tags: phase-1-bugs bugs phase-1
---
Doom uses a structure called *line* to define the structure of the maps.
It is assumed that each line always has a front sector and an optional
back sector. If a line has only the front sector, then it is a one-sided line.
If it has a back sector, then it is a two-sided line. Line structure
is represented in the code with
[`struct line_t`](https://github.com/id-Software/DOOM/blob/77735c3ff0772609e9c8d29e3ce2ab42ff54d20b/linuxdoom-1.10/r_defs.h#L179):

{% highlight c %}
typedef struct line_s
{
  ...
  // Front and back sector.
  // Note: redundant? Can be retrieved from SideDefs.
  sector_t*  frontsector;
  sector_t*  backsector;
  ...
} line_t;
{% endhighlight %}

In the code, dereferencing the `backsector` is usually preceded by a check
that `backsector` is not a null pointer. There are no such checks for
the `frontsector`. For example, this is illustrated in
[`P_GroupLines`](https://github.com/id-Software/DOOM/blob/77735c3ff0772609e9c8d29e3ce2ab42ff54d20b/linuxdoom-1.10/p_setup.c#L523):
{% highlight c %}
// count number of lines in each sector
li = lines;
total = 0;
for (i=0 ; i<numlines ; i++, li++)
{
  total++;
  li->frontsector->linecount++;

  if (li->backsector && li->backsector != li->frontsector)
  {
    li->backsector->linecount++;
    total++;
  }
}
{% endhighlight %}

However, when initializing line definitions, `frontsector` can be assigned
a null pointer in
[`P_LoadLineDefs`](https://github.com/id-Software/DOOM/blob/77735c3ff0772609e9c8d29e3ce2ab42ff54d20b/linuxdoom-1.10/p_setup.c#L423):

{% highlight c %}
ld->sidenum[0] = SHORT(mld->sidenum[0]);
ld->sidenum[1] = SHORT(mld->sidenum[1]);

if (ld->sidenum[0] != -1)
  ld->frontsector = sides[ld->sidenum[0]].sector;
else
  ld->frontsector = 0;

if (ld->sidenum[1] != -1)
  ld->backsector = sides[ld->sidenum[1]].sector;
else
  ld->backsector = 0;
{% endhighlight %}

Here, `mld` is the raw data read from the file and `ld` is the `line_t` being
constructed. When `sidenum[0]` is `-1`, null pointer is written to
`ld.frontsector`.


## Solutions in existing projects
Other source ports handle this situation differently. For example,
Mocha Doom issues a warning in
[one case](https://github.com/AXDOOMER/mochadoom/blob/a1c6b24747ed21d3912608c9f6dc712dc57ce9c9/src/p/BoomLevelLoader.java#L1029):
{% highlight java %}
/*
  * cph 2006/09/30 - our frontsector can be the second side of the
  * linedef, so must check for NO_INDEX in case we are incorrectly
  * referencing the back of a 1S line
  */
if (ldef.sidenum[side] != NO_INDEX) {
  li.frontsector = sides[ldef.sidenum[side]].sector;
} else {
  li.frontsector = null;
  System.err.printf("P_LoadZSegs: front of seg %i has no sidedef\n", i);
}
{% endhighlight %}

In the
[other case](https://github.com/AXDOOMER/mochadoom/blob/a1c6b24747ed21d3912608c9f6dc712dc57ce9c9/src/p/LevelLoader.java#L393)
it sets `null` as the `frontsector` value:

{% highlight java %}
// Front side defined without a valid frontsector.
if (ld.sidenum[0] != line_t.NO_INDEX) {
  ld.frontsector = sides[ld.sidenum[0]].sector;
  if (ld.frontsector == null) { // // Still null? Bad map. Map to dummy.
    ld.frontsector = dummy_sector;
  }
} else {
  ld.frontsector = null;
}
{% endhighlight %}

[Delphi Doom](https://github.com/jval1972/DelphiDoom/blob/5bf3eedfec9af85decdaac3a6bba675a6de0fc82/Doom/p_setup.pas#L1037)
also issues a warning and sets another sector as the `frontsector`:
{% highlight pascal %}
if (ld.sidenum[0] >= 0) and (ld.sidenum[0] < numsides) then
  ld.frontsector := sides[ld.sidenum[0]].sector
else
begin
  if devparm then
    printf('P_LoadLineDefs(): Line %d does has invalid front sidedef %d'#13#10, [i, ld.sidenum[0]]);
  ld.sidenum[0] := 0;
  ld.frontsector := sides[0].sector;
end;
{% endhighlight %}

## Our solution and Void Safety
Brie Doom's source code is written with Void Safety enabled, so we have to
decide if `frontsector` should indeed be `attached` and assigning `Void` to
it should be banned, or should it be `detached` and all dereferences will
be preceded with checking if `frontsector` is not `Void`. We cannot simply
ignore this problem by assigning `Void` in one place and just assuming
that it should not be `Void` in other places.

As a temporary solution for phase 1 we decided to leave
`frontsector` as `detached` to preserve
the original behaviour. All dereferences of `frontsector` first check
that it is not `Void`. Example in
[`P_GroupLines`](https://github.com/imustafin/brie_doom/blob/50f595c05fbbe59509f158bcea390bc908a500e7/brie_doom/p_setup.e):
{% highlight eiffel %}
-- count number of lines in each sector
total := 0
from
  i := 0
until
  i >= numlines
loop
  total := total + 1
  check attached lines [i].frontsector as frontsector then
    frontsector.linecount := frontsector.linecount + 1
  end
  if attached lines [i].backsector as bs and then bs /= lines [i].frontsector then
    bs.linecount := bs.linecount + 1
  end
  i := i + 1
end
{% endhighlight %}

This solution is not ideal as it increases the verbosity of the code.
Each access to `frontsector` has to be surrounded by a `check`.

In fact, this solution does not solve the real problem. What should the game
do with a malformed map data? Maybe it should refuse working with such incorrect
data altogether, maybe not. Changing this behaviour is left for phase 2
where we will revisit this problem again.
