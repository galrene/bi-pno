library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity QUADRATURE_DEC is
    port (
        A, B, CLK, RESET : in STD_LOGIC;
        INC, EN          : out STD_LOGIC -- increment/decrement, enable counting
    );
end QUADRATURE_DEC;

architecture QUADRATURE_DEC_BODY of QUADRATURE_DEC is
    signal A_12   : STD_LOGIC; -- wire between reg_a_1 and reg_a_2
    signal A_23   : STD_LOGIC; -- all others analogous
    signal A_3OUT : STD_LOGIC;
    
    signal B_12   : STD_LOGIC;
    signal B_23   : STD_LOGIC;
    signal B_3OUT : STD_LOGIC;
begin

    INC <= A_23 xor B_3OUT;
    EN  <= B_23 xor A_23 xor A_3OUT xor B_3OUT;

    ----------------------------------------

    REG_A_1 : process ( CLK )
    begin
        if CLK = '1' and CLK'EVENT then
            if RESET = '1' then
                A_12 <= '0';
            else
                A_12 <= A;
            end if;
        end if;
    end process REG_A_1;

    REG_A_2 : process ( CLK )
    begin
        if CLK = '1' and CLK'EVENT then
            if RESET = '1' then
                A_23 <= '0';
            else
                A_23 <= A_12;
            end if;
        end if;
    end process REG_A_2;

    REG_A_3 : process ( CLK )
    begin
        if CLK = '1' and CLK'EVENT then
            if RESET = '1' then
                A_3OUT <= '0';
            else
                A_3OUT <= A_23;
            end if;
        end if;
    end process REG_A_3;

    ----------------------------------------

    REG_B_1 : process ( CLK )
    begin
        if CLK = '1' and CLK'EVENT then
            if RESET = '1' then
                B_12 <= '0';
            else
                B_12 <= B;
            end if;
        end if;
    end process REG_B_1;
    
    REG_B_2 : process ( CLK )
    begin
        if CLK = '1' and CLK'EVENT then
            if RESET = '1' then
                B_23 <= '0';
            else
                B_23 <= B_12;
            end if;
        end if;
    end process REG_B_2;

    REG_B_3 : process ( CLK )
    begin
        if CLK = '1' and CLK'EVENT then
            if RESET = '1' then
                B_3OUT <= '0';
            else
                B_3OUT <= B_23;
            end if;
        end if;
    end process REG_B_3;

    ----------------------------------------
end QUADRATURE_DEC_BODY;
