APP = uart
NAME = ${APP}.bin
SRC = ${APP}.s
REMOVE = rm -rf $(1)

all:
	vasm6502_oldstyle -Fbin -dotdir -c02 $(SRC) -o $(NAME)
clean:
	$(call REMOVE,*.bin)
re: clean all
view:
	hexdump -C $(NAME)
upload:
	minipro -p AT28C256 -w ${NAME}
