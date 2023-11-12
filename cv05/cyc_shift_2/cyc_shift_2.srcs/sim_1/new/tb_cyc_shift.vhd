----------------------------------------------------------------------------------
-- Description: Testbench using externally pre-generated stimuli
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.all;                                        -- pro datovy typ FILE a praci s nim

entity TB_CYC_SHIFT is
end entity TB_CYC_SHIFT;

architecture TB_CYC_SHIFT_BODY of TB_CYC_SHIFT is
    component CYC_SHIFT is
        port (
            INPUT    : in  STD_LOGIC_VECTOR ( 7 downto 0 );
            BUT_0    : in  STD_LOGIC;
            BUT_1    : in  STD_LOGIC;
            BUT_2    : in  STD_LOGIC;
            OUTPUT   : out STD_LOGIC_VECTOR ( 7 downto 0 );
            CLK      : in  STD_LOGIC;
            -----------------------------------------------
            COPY_NUM : out STD_LOGIC_VECTOR ( 7 downto 0 );
            COPY_AM  : out STD_LOGIC_VECTOR ( 2 downto 0 );
            COPY_DIR : out STD_LOGIC 
        ); 
    end component CYC_SHIFT;
    
    signal TB_INPUT      :  STD_LOGIC_VECTOR (7 downto 0);   -- data input (board switches)
    signal TB_BUT_0      :  STD_LOGIC;
    signal TB_BUT_1      :  STD_LOGIC;
    signal TB_BUT_2      :  STD_LOGIC;
    signal TB_OUTPUT     :  STD_LOGIC_VECTOR (7 downto 0);  -- result
    signal TB_COPY_NUM   :  STD_LOGIC_VECTOR (7 downto 0);   -- copy of number to shift
    signal TB_COPY_AM    :  STD_LOGIC_VECTOR (7 downto 0);   -- copy of shift amount
    signal TB_COPY_DIR   :  STD_LOGIC; -- shift direction
    signal TB_CLK        :  STD_LOGIC;
    
    constant CLK_PERIOD : time := 10 ns;
begin

    DUT : CYC_SHIFT port map (
        INPUT    => TB_INPUT,
        BUT_0    => TB_BUT_0,
        BUT_1    => TB_BUT_1,
        BUT_2    => TB_BUT_2, 
        OUTPUT   => TB_OUTPUT,
        COPY_NUM => TB_COPY_NUM,
        COPY_AM  => TB_COPY_AM,
        COPY_DIR => TB_COPY_DIR,
        CLK      => TB_CLK
    );

    -- clock generator
   CLK_GEN : process
   begin
      TB_CLK <= '0';
      wait for CLK_PERIOD / 2;
      TB_CLK <= '1';
      wait for CLK_PERIOD / 2;
   end process CLK_GEN;

   -- reset generator?

   STIMULI_GEN : process
      file     NUMBER   : TEXT is in "/home/galrene/school/pno/gen_input_num.txt";
      file     DIR      : TEXT is in "/home/galrene/school/pno/gen_input_sh_dir.txt";
      file     AMOUNT   : TEXT is in "/home/galrene/school/pno/gen_input_sh_am.txt";
      file     RESULT   : TEXT is in "/home/galrene/school/pno/gen_exp_output.txt";
      variable NUMBER_LINE, DIR_LINE,
               AMOUNT_LINE, RESULT_LINE : LINE;

      variable NUMBER_BV, RESULT_BV : BIT_VECTOR ( 7 downto 0 );
      variable AMOUNT_BV            : BIT_VECTOR ( 2 downto 0 );
      variable DIR_BV               : BIT_VECTOR ( 0 downto 0 );
      
      variable NUMBER_VEC, RESULT_VEC : STD_LOGIC_VECTOR ( 7 downto 0 );
      variable AMOUNT_VEC             : STD_LOGIC_VECTOR ( 2 downto 0 );
      variable DIR_VEC                : STD_LOGIC_VECTOR ( 0 downto 0 );
   begin
    TB_BUT_0 <= '0';
    TB_BUT_1 <= '0';
    TB_BUT_2 <= '0';
    wait for 33 ns;

    while not ENDFILE(DIR) loop
        
        wait until TB_CLK = '1';
        readline(NUMBER, NUMBER_LINE);
        readline(DIR, DIR_LINE);
        readline(AMOUNT, AMOUNT_LINE);
        read(NUMBER_LINE, NUMBER_BV);
        read(DIR_LINE, DIR_BV);
        read(AMOUNT_LINE, AMOUNT_BV);
        read(RESULT_LINE, RESULT_BV);
        NUMBER_VEC          := To_StdLogicVector(NUMBER_BV);
        DIR_VEC             := To_StdLogicVector(DIR_BV);
        AMOUNT_VEC          := To_StdLogicVector(AMOUNT_BV);
        RESULT_VEC          := To_StdLogicVector(RESULT_BV);

        -- input the number to be shifted
        TB_INPUT <= NUMBER_VEC;
        wait for 50 ns;
        TB_BUT_0 <= '1';
        wait for 50 ns;
        TB_BUT_0 <= '0';

        wait for 55 ns;
        
        -- input the shift amount
        TB_INPUT <= AMOUNT_VEC;
      
        wait for 50 ns;
        
        -- choose shift direction
        if DIR_VEC(0) = '1' then
            TB_BUT_1 <= '1';
            wait for 50 ns;
            TB_BUT_1 <= '0';
        else
            TB_BUT_2 <= '1';
            wait for 50 ns;
            TB_BUT_2 <= '0';
        end if;
        
        -- wait for result
        wait for 10*CLK_PERIOD;
        
        assert TB_OUTPUT = RESULT_VEC
            report "ERROR: Inputs: "
            & integer'image(TO_INTEGER(UNSIGNED(NUMBER_VEC)))
            & integer'image(TO_INTEGER(UNSIGNED(DIR_VEC)))
            & integer'image(TO_INTEGER(UNSIGNED(AMOUNT_VEC)))
            & ", Output: " & integer'image(TO_INTEGER(UNSIGNED(TB_OUTPUT)))
            &"; Expected: " & integer'image(TO_INTEGER(UNSIGNED(RESULT_VEC)))
            severity error;

    end loop;

    assert FALSE
           report "END OF SIMULATION"
           severity failure;

   end process STIMULI_GEN;

end architecture TB_CYC_SHIFT_BODY;
