SOURCE = main.s \
				 get_input.s
OBJS = $(SOURCE:.s=.o)
NAME = prog

.PHONY: clean

$(NAME): $(OBJS)
	ld $^ -o $@ -lc -lm -lraylib -dynamic-linker /lib64/ld-linux-x86-64.so.2 -g 

%.o: %.s
	as -o $@ $< -g

clean:
	rm -f $(OBJS) $(NAME)
