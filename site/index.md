---
layout: page
title: "Welcome to Brie Doom!"
date: 2021-09-07
last_modified_at: 2021-11-07
---
Brie Doom is a source port of the original Doom source code from C to Eiffel.
The aim is to produce idiomatic object-oriented Eiffel code with contracts
while maintaining the original experience of playing vanilla Doom.

This project is an example of applying
[Design by Contract](https://en.wikipedia.org/wiki/Design_by_contract) (DbC)
in game development.
Already in the current phase of development we managed to find
several bugs in the original game thanks to DbC.

Brie Dooom uses SDL2 library instead of the original X11. The SDL2 support
is based on
[Chocolate Doom](https://www.chocolate-doom.org/).

Converting procedual C code to the object-oriented paradigm of Eiffel
introduces several challenges. Examples of such challenges are known
in scientific literature. Also, some specifics of converting Doom to non-C
languages are also presented on Mocha Doom website's
[Programming page](http://mochadoom.sourceforge.net/tech.html).

Brie is pronounced /briː/ like in Brie cheese.

Stay tuned for further updates!

## Development Progress

### Phase 1: Direct Port (in progress)
In the first phase, we try to port the game while preserving
as much of the original code structure as possible.

<div class="w-full bg-california-200 h-6 flex">
  <div
    class="bg-california-500 text-center text-white h-full text-base"
    style="width: {{ site.data.functions_ported.ported_ratio }}%;"
  >
    {{ site.data.functions_ported.ported_ratio }}%
  </div>
  <div
    class="bg-california-400 text-center text-white h-full text-base"
    style="width: {{ site.data.functions_ported.stubbed_ratio }}%;"
  >
    {{ site.data.functions_ported.stubbed_ratio }}%
  </div>
</div>

Currently {{ site.data.functions_ported.ported_ratio }}% of the original functions
are ported in Eiffel.
Additionally, {{ site.data.functions_ported.stubbed_ratio }}%
function are stubbed.

Not all original functions are counted, though. Some of them are
are related to X11 which is replaced with SDL2 in the port.

See the
[Ported Functions Breakdown](ported-functions-breakdown)
page for a detailed analysis.

Also, see the [Performance](performance)
page for FPS comparison of the port with different contract sets.

### Phase 2: Refactoring (not started)
In the second phase, we will refactor the code to improve quality.

The main objective of this project is improving quality of the original code.
In the context of
[ISO 25010](https://iso25000.com/index.php/en/iso-25000-standards/iso-25010)
quality model, we mostly aim at improving the overall _maintainability_
and _functional stability_.
To achieve these goals we will use features and principles implemented in
Eiffel such as Design by Contract, Void Safety, Command-Query Separation
and OOP practices overall.

Implementing these principles will require modification of the original
code structure such as extracting more classes, converting functions
to commands or queries, rethinking module obligations for implementing
concise but effective contracts.

## Posts

<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
