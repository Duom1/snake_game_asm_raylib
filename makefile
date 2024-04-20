SOURCE = main.s \
				 get_input.s \
				 draw_snake.s \
				 place_food.s \
				 draw_food.s
OTHERFILES = const_def.s \
						 color_def.s \
						 dir_def.s \
						 key_def.s
OBJS = $(SOURCE:.s=.o)
NAME = prog
DYNAMIC_LINKER = /lib64/ld-linux-x86-64.so.2

.PHONY: clean

$(NAME): $(OBJS) $(OTHERFILES)
	ld $(OBJS) -o $@ -lc -lm -lraylib -dynamic-linker $(DYNAMIC_LINKER)

%.o: %.s
	as -o $@ $<

clean:
	rm -f $(OBJS) $(NAME)
