---
layout: page
title: Performance
---
This page presents and discusses the performance of the port.

While contracts provide a way to find bugs in the code,
they are checked in runtime. This has a performance cost.

To measure the performance impact we run the game several times
with different sets of contractss enabled. However, 
we should run the program with the same inputs each time. To achieve this
we can use Doom's [demo][demo] mechanism.

A _demo_ is a record of game inputs per each frame. We can record
the demo once and play several times with different executables
having different contracts enabled. We have recorded a demo of playing
the first level and we will use it as an example in the following sections.

To measure the performance we will measure the time it took to run the game
logic and draw the result on the screen for each frame during the gameplay.
The multiplicative inverse of this measure gives the more commonly used
measure called _frame rate_ expressed in _frames per second_ (FPS).

Now we know _what_ to measure, let's discuss the _how_.

## Removing contracts from the code
Game development focuses mainly on the _fun_ of the game. This means
that during development, the developed game is play-tested often.

Since contract checking has a performance cost, we need to run the game
without contract checking. This can be achieved by compiling
without the `-keep` parameter:
```bash
ec -finalize -c_compile
```

Running the finalized version with assertions discarded gives the following
times to render each frame:

{% svg perf_plots/no_contracts.svg %}

The demo starts with the initial wipe sequence (_wipe 1_), then the first
level is played (_level 1_). When the level exit button is pressed, there is
another wipe sequence (_wipe 2_) and the level intermission screen is
drawn (_intermission 1_). After another wipe (_wipe 3_) the next
level starts (_level 2_).

The _35 FPS reference_ line shows the ideal time to render each frame
to achieve the intended 35 FPS of the original game. We see that all sections
are below the reference line, so **game with contracts disabled is
performant enough**.

We see that wipes and intermissions are much cheaper to draw than the
level gameplay. Because of that all next plots will show only the _level_
section of the first level.

## Keep assertions, but do not check them
In the next sections we will measure the impact of different types of contracts.
For that we will need to add the `-keep` parameter when compiling. In this 
section we will compare the performance of the program with assertions removed
from the executable (no `-keep`) and with assertions kept in the executable
but not executed (with `-keep`).

```bash
ec -finalize -keep -c_compile
```

{% svg perf_plots/keep_vs_no_keep.svg %}

We can see that just enabling `-keep` without enabling the checks
**decreases the performance {{ site.data.perf.no_keep_vs_keep_fps }} times**
(average FPS goes down from {{ site.data.perf.no_keep_fps }}
to
{{ site.data.perf.keep_fps }}).

This is because the `-keep` parameter enables the collection of some
debug information and disables some optimizations.

Enabling assertions will decrease the performance even further. This
means that playtesting the game with contracts enabled will have a very
noticeable performance degradation, which can make such testing infeasible.

## Check all contracts
In this section we will compare the cost of checking all contracts present
in the game.

{% svg perf_plots/all.svg %}

The plot shows that checking all contracts has a high cost. This
**decreases the performance {{ site.data.perf.keep_vs_all_fps }} times**
({{ site.data.perf.keep_fps }} FPS with contracts compiled but disabled
compared
{{ site.data.perf.all_fps }} FPS with contracts compiled and checked).


## Contract impact per cluster
In this section we will compare the impact of enabling contracts per cluster.
This means that all contracts are disabled except the contracts of one
specific cluster.

{% svg perf_plots/per_cluster.svg %}

This plot shows that contract checking of clusters `render` and `math` have
the biggest impact on the performance. Indeed, `render` cluster is responsible
for the 3D rendering which is the most computationally expensive part
of the game. The `math` cluster is responsible for the implementation of
the fixed point arithmetics which is used throughout the game.

Let us zoom into the other clusters:

{% svg perf_plots/per_cluster2.svg %}

Out of the clusters present in this plot the most expensive cluster
is the `root` cluster which is responsible for the main game logic. Most notably
this includes the collision detection (did something bump into an obstacle),
line of sight checks (can someone see something or is there
an obstacle blocking the sight).

## Conclusion
Game development is often done iteratively: implement something, test it,
keep if it is _fun_ to play. With the focus being on the _fun_, less time
is left for _correctness_ of the code.

While Design by Contract can help developers to develop correct programs,
it does not replace testing. Sadly, it is currently not possible to integrate
contract checking into playtesting without sacrificing performance for
this project.

It is still possible to check contracts after the playtesting session by
recording the inputs and replaying them later with contract checking enabled.

To speed things up, it is possible to disable contracts for parts of the
system which are shown to be more or less bug-free. If the development
of the core 3D rendering engine is finished and was tested, why test
it again? We can shorten the feedback loop by checking contracts
of the actively developed parts of the program.


[demo]: https://doomwiki.org/wiki/Demo

