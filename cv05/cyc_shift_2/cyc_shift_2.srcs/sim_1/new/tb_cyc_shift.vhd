----------------------------------------------------------------------------------
-- Description: Testbench using externally pre-generated stimuli
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.all;                                        -- for the FILE data type and related operations

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
            RESET    : in  STD_LOGIC;
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
    signal TB_OUTPUT     :  STD_LOGIC_VECTOR (7 downto 0);   -- result
    signal TB_COPY_NUM   :  STD_LOGIC_VECTOR (7 downto 0);   -- copy of number to shift
    signal TB_COPY_AM    :  STD_LOGIC_VECTOR (2 downto 0);   -- copy of shift amount
    signal TB_COPY_DIR   :  STD_LOGIC; -- shift direction
    signal TB_CLK        :  STD_LOGIC;
    signal TB_RESET      :  STD_LOGIC;
    
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
        CLK      => TB_CLK,
        RESET    => TB_RESET
    );

    -- clock generator
   CLK_GEN : process
   begin
      TB_CLK <= '0';
      wait for CLK_PERIOD / 2;
      TB_CLK <= '1';
      wait for CLK_PERIOD / 2;
   end process CLK_GEN;

   -- reset generator
   RESET_GEN : process
   begin
      wait for 30 ns;
      TB_RESET <= '0';   
      wait for 30 ns;
      TB_RESET <= '1';   
      wait for 30 ns;
      TB_RESET <= '0';
      wait;
   end process;  

   STIMULI_GEN : process
      file     INPUTS   : TEXT is in "/home/galrene/school/pno/gen_input.txt";
      file     RESULTS   : TEXT is in "/home/galrene/school/pno/gen_exp_output.txt";
      variable INPUT_LINE, RESULT_LINE : LINE;

      variable NUMBER_BV, RESULT_BV : BIT_VECTOR ( 7 downto 0 );
      variable AMOUNT_BV            : BIT_VECTOR ( 2 downto 0 );
      variable DIR_BV               : BIT_VECTOR ( 0 downto 0 );
      
      variable NUMBER_VEC, RESULT_VEC : STD_LOGIC_VECTOR ( 7 downto 0 );
      variable AMOUNT_VEC             : STD_LOGIC_VECTOR ( 2 downto 0 );
      variable DIR_VEC                : STD_LOGIC_VECTOR ( 0 downto 0 );
   begin
    wait until TB_RESET = '1';
    TB_BUT_0 <= '0';
    TB_BUT_1 <= '0';
    TB_BUT_2 <= '0';
    wait until TB_RESET = '0';
    wait for 33 ns;

    assert FALSE
           report "-----BEGIN SIMULATION-----"
           severity note;

    while not ENDFILE(INPUTS) loop
        
        wait until TB_CLK = '1';
        readline(INPUTS, INPUT_LINE);
        readline(RESULTS, RESULT_LINE);
        read(INPUT_LINE, NUMBER_BV);
        read(INPUT_LINE, DIR_BV);
        read(INPUT_LINE, AMOUNT_BV);
        read(RESULT_LINE, RESULT_BV);
        NUMBER_VEC          := To_StdLogicVector(NUMBER_BV);
        DIR_VEC             := To_StdLogicVector(DIR_BV);
        AMOUNT_VEC          := To_StdLogicVector(AMOUNT_BV);
        RESULT_VEC          := To_StdLogicVector(RESULT_BV);

        -- input the number to be shifted
        TB_INPUT <= NUMBER_VEC;
        wait for 23 ns;
        TB_BUT_0 <= '1';
        wait for 33 ns;
        TB_BUT_0 <= '0';

        wait for 55 ns;
        
        -- input the shift amount
        TB_INPUT <= "00000" & AMOUNT_VEC;
      
        wait for 23 ns;
        
        -- choose shift direction
        -- if shift right, press but_1, else press but_2
        if DIR_VEC(0) = '0' then 
            TB_BUT_1 <= '1';
            wait for 33 ns;
            TB_BUT_1 <= '0';
        else
            TB_BUT_2 <= '1';
            wait for 33 ns;
            TB_BUT_2 <= '0';
        end if;
        
        -- wait for result
        wait for 10*CLK_PERIOD;
        
        assert TB_OUTPUT = RESULT_VEC
            report
              "N(" & integer'image(TO_INTEGER(UNSIGNED(NUMBER_VEC)))
            & ")D(" & integer'image(TO_INTEGER(UNSIGNED(DIR_VEC)))
            & ")A(" & integer'image(TO_INTEGER(UNSIGNED(AMOUNT_VEC)))
            & "), Output: " & integer'image(TO_INTEGER(UNSIGNED(TB_OUTPUT)))
            &"; Expected: " & integer'image(TO_INTEGER(UNSIGNED(RESULT_VEC)))
            severity error;

    end loop;

    assert FALSE
           report "-----END OF SIMULATION-----"
           severity failure;

   end process STIMULI_GEN;

end architecture TB_CYC_SHIFT_BODY;
