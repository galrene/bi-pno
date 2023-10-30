library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity CONTROLLER is
    port (
        BUT_0, BUT_1, BUT_2, CLK              : in std_logic; 
        LOAD_NUM, LOAD_AM, SH_LEFT, SIG_SHIFT : out std_logic
    );
end entity CONTROLLER;

architecture CONTROLLER_BODY of CONTROLLER is
    type T_STATE is ( WAIT_1, NUM, WAIT_2, AMOUNT, AMOUNT_AND_LEFT, SHIFT );
    signal STATE, NEXT_STATE : T_STATE;
begin
    OUTPUTS : process ( STATE, BUT_0, BUT_1, BUT_2 )
    begin
        LOAD_NUM  <= '0';
        LOAD_AM   <= '0';
        SH_LEFT   <= '0';
        SIG_SHIFT <= '0';
        case STATE is
            when WAIT_1 => 
                null;
            when NUM =>
                LOAD_NUM <= '1';
            when WAIT_2 =>
                null;
            when AMOUNT =>
                LOAD_AM <= '1';
            when AMOUNT_AND_LEFT =>
                LOAD_AM <= '1';
                SH_LEFT <= '1';
            when SHIFT =>
                SIG_SHIFT <= '1';
        end case;
    end process OUTPUTS;
    
    TRANSITIONS : process ( STATE, BUT_0, BUT_1, BUT_2 )
    begin
        -- NEXT_STATE <= STATE;
        case STATE is
            when WAIT_1 =>
                if BUT_0 = '0' then
                    NEXT_STATE <= WAIT_1;
                elsif BUT_0 = '1' then
                    NEXT_STATE <= NUM;
                end if;
            when NUM =>
                    if 
        end case;
    end process TRANSITIONS;

end architecture CONTROLLER_BODY;
