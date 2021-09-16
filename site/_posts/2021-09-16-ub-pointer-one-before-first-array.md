---
layout: post
title: UB with pointer to one-before-first of array
tags: ['phase-1-bugs', 'bugs', 'phase-1']
---
The C standard defines that it is an undefined behaviour to subtract one from
a pointer pointing to the start of an array.

> C17 6.5.6/8
>
> If both the pointer operand and the result point to elements of the same
> array object, or one past the last element of the array object, the evaluation
> shall not produce an overflow; otherwise, the behavior is undefined.


Such undefined behaviour
occurs in
[`R_SortVisSprites`](https://github.com/id-Software/DOOM/blob/77735c3ff0772609e9c8d29e3ce2ab42ff54d20b/linuxdoom-1.10/r_things.c#L787):

{% highlight c %}
for (ds=vissprites ; ds<vissprite_p ; ds++)
{
  ds->next = ds+1;
  ds->prev = ds-1;
}

vissprites[0].prev = &unsorted;

{% endhighlight %}

In this example, `vissprites` is an array of type `vissprite_t` and `ds` is a pointer
to `vissprite_t`.

On the first iteration of the loop, when `ds == vissprites` the
expression `ds-1` is computed. Such computation produces an undefined behaviour.

Such undefined behaviour was identified in Eiffel due to a precondition
violation in the utility methods we developed used to
replicate the pointer arithmetic on arrays.

We can see that the value of the illegal pointer is not actually used and the
line `vissprites[0].prev = &unsorted` writes a legal pointer instead of the illegal
one.

As a fix
[for this bug](https://github.com/imustafin/brie_doom/blob/50f595c05fbbe59509f158bcea390bc908a500e7/brie_doom/render/r_things.e#L268),
we add an additional check to verify that it is not the
first iteration of the loop and that it is legal to subtract one from `ds`:

{% highlight eiffel %}
from
  create ds.make (vissprites.lower, vissprites)
until
  ds.index >= vissprite_p
loop
  ds.this.next := (ds + 1).this
  if ds.index /= 0 then
    ds.this.prev := (ds - 1).this
  end
  ds := ds + 1
end
  
vissprites [0].prev := unsorted
{% endhighlight %}
