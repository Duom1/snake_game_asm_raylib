SOURCE = main.s \
				 get_input.s \
				 draw_snake.s \
				 place_food.s \
				 draw_food.s \
				 eat_check.s \
				 move_snake.s \
				 update_snake_segments.s
OTHERFILES = const_def.s \
						 color_def.s \
						 dir_def.s \
						 key_def.s
OBJS = $(SOURCE:.s=.o)
NAME = prog
DYNAMIC_LINKER = /lib64/ld-linux-x86-64.so.2
EXTRA =

.PHONY: clean

$(NAME): $(OBJS) $(OTHERFILES)
	ld $(OBJS) $(EXTRA) -o $@ -lc -lm -lraylib -dynamic-linker $(DYNAMIC_LINKER)

debug: EXTRA += -g
debug: $(NAME)

%.o: %.s
	as $(EXTRA) -o $@ $< 

clean:
	rm -f $(OBJS) $(NAME)
