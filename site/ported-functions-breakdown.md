---
layout: page
title: Ported Functions Breakdown
date: 2021-09-08
last_modified_at: 2021-11-07
description: |
  Statistics of which functions are ported from C Doom to Eiffel Brie Doom
---
What functions were already ported from C to Eiffel in Brie Doom.

The code is analyzed using [CCCC](http://sarnold.github.io/cccc/).


CCCC has found {{ site.data.functions_ported.total_c }} functions in the original code.
Out of them, {{ site.data.functions_ported.ported }} functions
({{ site.data.functions_ported.ported_ratio }}%) were ported.

CCCC has estimated that the original C code is
{{ site.data.functions_ported.c_loc}} LOC. The current Eiffel
code is {{ site.data.functions_ported.e_loc }} LOC. Considering
that {{ site.data.functions_ported.ported_ratio }}% of functions
are ported, we can estimate that the full Eiffel port can be around
{{ site.data.functions_ported.e_estimation }} LOC.

Table below lists the ported functions. The first column contains the
original name of the function which is a link to the original
C function definition. Other links show the ported Eiffel features
which implement the C function.

The next two columns _C_ and _Eiffel_ display the lines of
code in the original function and the port.

The last column _Ratio_ is the increase factor of porting the C function
to Eiffel.

In the end of the table there is a list of functions which are not ported
yet.

The _Moved_ section of the table lists the functions which will
not be ported with the explanation of this decision. Mostly this
is because some functions are already implemented either in Eiffel
or in SDL.

<table class="w-full">
  <thead>
    <tr class="bg-california-600 text-white font-bold">
      <td class="pl-2">Function</td>
      <td>C</td>
      <td>Eiffel</td>
      <td class="pr-2">Ratio</td>
    </tr>
  </thead>
  {% for row in site.data.functions_ported.joined %}
    <tr class="bg-california-100 hover:bg-california-200">
      <td class="pl-2">
        <a href="{{
                'https://github.com/id-Software/DOOM/blob/master/linuxdoom-1.10/'
                | append: row.cfunc.cfile
                | append: '#L'
                | append: row.cfunc.cline
                  }}">{{ row.cfunc.cname_orig }}</a><br>
        {% for efunc in row.eifs %}
        <a href="{{
                '/documentation/'
                | append: efunc.cluster
                | append: '.html'
                | append: '#f_'
                | append: efunc.name
                | downcase
                | relative_url
                }}">{<!-- -->{{ efunc.class}}<!-- -->}.{{efunc.name}}</a>
        
        {% endfor %}
      </td>
      <td>{{ row.cfunc.cloc }}</td>
      <td>{{ row.eif_loc }}</td>
      <td class="pr-2">{{ row.c_to_e }}</td>
    </tr>
  {% endfor %}
  <tr class="bg-california-600 text-white font-bold text-center">
    <td colspan="4">Stubbed</td>
  </tr>
  {% for row in site.data.functions_ported.stubs %}
    <tr class="bg-california-100 hover:bg-california-200">
      <td class="pl-2">
        <a href="{{
                'https://github.com/id-Software/DOOM/blob/master/linuxdoom-1.10/'
                | append: row.cfunc.cfile
                | append: '#L'
                | append: row.cfunc.cline
                  }}">{{ row.cfunc.cname_orig }}</a><br>
        {% for efunc in row.eifs %}
        <a href="{{
                '/documentation/'
                | append: efunc.cluster
                | append: '.html'
                | append: '#f_'
                | append: efunc.name
                | downcase
                | relative_url
                }}">{<!-- -->{{ efunc.class}}<!-- -->}.{{efunc.name}}</a>
        
        {% endfor %}
      </td>
      <td>{{ row.cfunc.cloc }}</td>
      <td>{{ row.eif_loc }}</td>
      <td class="pr-2">{{ row.c_to_e }}</td>
    </tr>
  {% endfor %}
  <tr class="bg-california-600 text-white font-bold text-center">
    <td colspan="4">Moved</td>
  </tr>
  {% for row in site.data.functions_ported.moved %}
    <tr class="bg-california-100 hover:bg-california-200">
      <td class="pl-2">
        <a href="{{
                  'https://github.com/id-Software/DOOM/blob/master/linuxdoom-1.10/'
                  | append: row.cfile
                  | append: '#L'
                  | append: row.cline
                  }}">{{ row.cname_orig }}</a>
      </td>
      <td colspan="3">
        {{ row.explanation }}
      </td>
    </tr>
  {% endfor %}
  <tr class="bg-california-600 text-white font-bold text-center">
    <td colspan="4">Not yet ported</td>
  </tr>
  {% for row in site.data.functions_ported.not_ported %}
    <tr class="bg-california-100 hover:bg-california-200">
      <td class="pl-2">
        <a href="{{
                'https://github.com/id-Software/DOOM/blob/master/linuxdoom-1.10/'
                | append: row.cfile
                | append: '#L'
                | append: row.cline
                }}">{{ row.cname_orig }}</a>
      </td>
      <td>—</td>
      <td>—</td>
      <td>—</td>
    </tr>
  {% endfor %}
</table>
