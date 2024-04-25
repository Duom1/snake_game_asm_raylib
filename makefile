SOURCE = main.s \
				 get_input.s \
				 draw_snake.s \
				 place_food.s \
				 draw_food.s \
				 eat_check.s \
				 move_snake.s \
				 update_snake_segments.s \
				 pos_check.s \
				 out_of_bounds.s \
				 self_hit.s
OBJS = $(SOURCE:.s=.o)
NAME = prog
DYNAMIC_LINKER = /lib64/ld-linux-x86-64.so.2
EXTRA =

.PHONY: clean debug def default test

def: $(NAME)
default: $(NAME)

$(NAME): $(OBJS)
	ld $(OBJS) $(EXTRA) -o $@ -lc -lm -lraylib -dynamic-linker $(DYNAMIC_LINKER)

%.o: %.s
	as $(EXTRA) -o $@ $< 

debug: EXTRA += -g
debug: $(NAME)

clean:
	rm -f $(OBJS) $(NAME) place_food_test.o place_food_test pos_check_test.o pos_check_test

test: EXTRA += -g
test: place_food_test.o place_food.o pos_check.o pos_check_test.o
	ld -g place_food_test.o place_food.o pos_check.o -o place_food_test -lc -lm -lraylib -dynamic-linker $(DYNAMIC_LINKER)
	ld -g pos_check_test.o pos_check.o -o pos_check_test -lc -lm -lraylib -dynamic-linker $(DYNAMIC_LINKER)

