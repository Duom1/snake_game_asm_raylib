# snake game
my attempt at writing a snake game in gnu x86 64 asembly

files that end with "def.s" are files that define things like colors, constants and keys.

my personal best is 83 on 14x10 size

## make better:

- [x] draw_snake.s
- [x] get_input.s
- [x] out_of_bounds.s
- [ ] place_food.s: ignores the head(index 0 off by one error), could use registers instead of the stack
- [ ] make it so that the player cannot turn into it self
- [ ] remove useless variable to snakepointer
- [ ] both tests
