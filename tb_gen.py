"""
Generator vstupov a ocakavanych vystupov pre cyklicky posuv 2
- 8-bitovy cyklicky posuv s vyberom smeru posuvu
"""

import numpy as np


TB_INPUT_NUM = "./gen_input_num.txt"
TB_INPUT_SH_AM = "./gen_input_sh_am.txt"
TB_INPUT_SH_DIR = "./gen_input_sh_dir.txt"
TB_EXP_OUTPUT = "./gen_exp_output.txt"


def gen_nums():
    with open ( TB_INPUT_NUM, "w" ) as tb_in:
        for i in range ( 256 ):
            print ( f"{i:08b}", file=tb_in )


def gen_shift_am():
    with open ( TB_INPUT_SH_AM, "w" ) as tb_am:
        for i in range ( 8 ):
            print ( f"{i:03b}", file=tb_am )


def gen_shift_dir():
    with open ( TB_INPUT_SH_DIR, "w" ) as tb_dir:
        for i in range ( 2 ):
            for j in range ( 8 ):
                for k in range ( 256 ):
                    print ( i, file=tb_dir )


def cyclic_shift(num : int, n):
    binary_num = '{0:08b}'.format(num)
    res = np.roll(list(binary_num), n) # tu potrebujem list ktory ma prvok ako binarnu hodnotu
    return ''.join(res)


def gen_exp_outputs():
    with open ( TB_EXP_OUTPUT, "w" ) as tb_outputs:
        for dir in range ( 2 ):
            for shift in range ( 8 ):
                for num in range ( 256 ):
                    if dir == 0:
                        print ( cyclic_shift ( num, shift ), file=tb_outputs ) # right shift
                    else:
                        print ( cyclic_shift ( num, -shift ), file=tb_outputs ) # left shift
                

def main ():
    gen_nums()
    gen_shift_am()
    gen_shift_dir()
    gen_exp_outputs()

if __name__ == "__main__":
    main()