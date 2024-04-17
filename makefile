SOURCE = main.s
OBJS = $(SOURCE:.s=.o)
NAME = prog

.PHONY: clean

$(NAME): $(OBJS)
	ld $(OBJS) -o $@ -lc -lm -lraylib -dynamic-linker /lib64/ld-linux-x86-64.so.2

%.o: %.s
	as -o $@ $<

clean:
	rm -f $(OBJS) $(NAME)
