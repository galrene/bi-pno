library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity BARREL_SHIFTER is
    port (
        S_NUM : in STD_LOGIC_VECTOR ( 7 downto 0 );
        S_AM  : in STD_LOGIC_VECTOR ( 2 downto 0 ); -- shift amount
        S_RES : out STD_LOGIC_VECTOR ( 7 downto 0 )
    );
end entity BARREL_SHIFTER;

architecture BARREL_SHIFTER_BODY of BARREL_SHIFTER is
    signal S_NUM_SHIFTED_BY_4       : STD_LOGIC_VECTOR ( 7 downto 0 );
    signal A_OUT_B_IN               : STD_LOGIC_VECTOR ( 7 downto 0 );
    signal A_OUT_B_IN_SHIFTED_BY_2  : STD_LOGIC_VECTOR ( 7 downto 0 );
    signal B_OUT_C_IN               : STD_LOGIC_VECTOR ( 7 downto 0 );
    signal B_OUT_C_IN_SHIFTED_BY_1  : STD_LOGIC_VECTOR ( 7 downto 0 );
    ------------------------------------------------------------------
    component MUX_16_8 is
        port (
            A   : in STD_LOGIC_VECTOR ( 7 downto 0 );
            B   : in STD_LOGIC_VECTOR ( 7 downto 0 );
            SIG : in STD_LOGIC;
            Y   : out STD_LOGIC_VECTOR ( 7 downto 0 )
        );
    end component MUX_16_8;   
begin
    S_NUM_SHIFTED_BY_4      <= ( S_NUM(3 downto 0)      & S_NUM(7 downto 4) );
    A_OUT_B_IN_SHIFTED_BY_2 <= ( A_OUT_B_IN(1 downto 0) & A_OUT_B_IN(7 downto 2) );
    B_OUT_C_IN_SHIFTED_BY_1 <= ( B_OUT_C_IN(0)          & B_OUT_C_IN(7 downto 1) );

    -- MUX A
    SHIFT_BY_4 : MUX_16_8 port map (
        A   => S_NUM,
        B   => S_NUM_SHIFTED_BY_4,
        SIG => S_AM(2),
        Y   => A_OUT_B_IN
    );
    -- MUX B
    SHIFT_BY_2 : MUX_16_8 port map (
        A   => A_OUT_B_IN,
        B   => A_OUT_B_IN_SHIFTED_BY_2,
        SIG => S_AM(1),
        Y   => B_OUT_C_IN
    );
    -- MUX C
    SHIFT_BY_1 : MUX_16_8 port map (
        A   => B_OUT_C_IN,
        B   => B_OUT_C_IN_SHIFTED_BY_1,
        SIG => S_AM(0),
        Y   => S_RES
    );
end architecture BARREL_SHIFTER_BODY;
