# Brie Doom website
This is the source code for the Brie Doom website.

## Running website

Install ruby dependencies

``` sh
bundle install
```

Generate performance plots

``` sh
bundle exec rake performance
```

Compute ported functions breakdown

``` sh
bundle exec rake loc:combine[brie_doom]
```
