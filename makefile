SOURCE = ftest.s
OBJS = $(SOURCE:.s=.o)
NAME = prog

.PHONY: clean

$(NAME): $(OBJS)
	ld $(OBJS) -o $@ -lc -no-pie -dynamic-linker /lib64/ld-linux-x86-64.so.2 #-lm -lraylib 

%.o: %.s
	as -o $@ $<

clean:
	rm -f $(OBJS) $(NAME)
