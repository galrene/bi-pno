"""
Generator vstupov a ocakavanych vystupov pre cyklicky posuv 2
- 8-bitovy cyklicky posuv s vyberom smeru posuvu
"""

import numpy as np


TB_INPUT = "./gen_input.txt"
TB_EXP_OUTPUT = "./gen_exp_output.txt"

def cyclic_shift(num : int, n):
    binary_num = '{0:08b}'.format(num)
    res = np.roll(list(binary_num), n)
    return ''.join(res)


def gen():
    with open ( TB_INPUT, "w" ) as tb_inputs:
        with open ( TB_EXP_OUTPUT, "w" ) as tb_outputs:
            for dir in range ( 2 ):
                for shift in range ( 8 ):
                    for num in range ( 256 ):
                        tb_inputs.write( f"{num:08b} {dir} {shift:03b}\n" )
                        if dir == 0:
                            print ( cyclic_shift ( num, shift ), file=tb_outputs ) # right shift
                        else:
                            print ( cyclic_shift ( num, -shift ), file=tb_outputs ) # left shift
                

def main ():
    gen()

if __name__ == "__main__":
    main()