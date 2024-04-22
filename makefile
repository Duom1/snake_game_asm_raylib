SOURCE = main.s \
				 get_input.s \
				 draw_snake.s \
				 place_food.s \
				 draw_food.s \
				 eat_check.s \
				 move_snake.s \
				 update_snake_segments.s
OBJS = $(SOURCE:.s=.o)
NAME = prog
DYNAMIC_LINKER = /lib64/ld-linux-x86-64.so.2
EXTRA =

.PHONY: clean debug

$(NAME): $(OBJS)
	ld $(OBJS) $(EXTRA) -o $@ -lc -lm -lraylib -dynamic-linker $(DYNAMIC_LINKER)

debug: EXTRA += -g
debug: $(NAME)

place_food_test: EXTRA += -g
place_food_test: place_food_test.o place_food.o
	ld -g place_food_test.o place_food.o -o $@ -lc -lm -lraylib -dynamic-linker $(DYNAMIC_LINKER)

%.o: %.s
	as $(EXTRA) -o $@ $< 

clean:
	rm -f $(OBJS) $(NAME) place_food_test.o
