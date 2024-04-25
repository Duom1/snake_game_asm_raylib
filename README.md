# snake game

My attempt at writing a snake game in gnu x86 64 asembly.

My personal best is 83 on 14x10 size.

## Project structure

All the files for this project are located in the root directory.
There are no folders (exept for .git, of course).
Files that end with "def.s" are files that define things like colors, constants and keys.
This project uses make as the build system in makefile.

## Make better:

- [x] draw_snake.s
- [x] get_input.s
- [x] out_of_bounds.s
- [x] place_food.s: ignores the head(index 0 off by one error), ~~could use registers instead of the stack~~
- [x] make it so that the player cannot turn into it self
- [x] remove useless variable to snakepointer
- [x] both tests
