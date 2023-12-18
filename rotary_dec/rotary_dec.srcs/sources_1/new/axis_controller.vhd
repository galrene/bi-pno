library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity AXIS_CONTROLLER is
    port (
        BUT, CLK        : in  STD_LOGIC; 
        SEL_X           : out STD_LOGIC;
        RESET           : in  STD_LOGIC; -- externally activated reset
        RST_DATAPATH    : out STD_LOGIC  -- internal reset
    );
end entity AXIS_CONTROLLER;

architecture AXIS_CONTROLLER_BODY of AXIS_CONTROLLER is
    type T_STATE is ( X, DB_Y, Y, DB_X );
    signal STATE, NEXT_STATE : T_STATE;
begin
    OUTPUTS : process ( STATE )
    begin
        RST_DATAPATH   <= '0';
        SEL_X          <= '0';
        case STATE is
            when X =>       SEL_X          <= '1';
                            RST_DATAPATH   <= '1';
            when DB_Y =>    NULL;
            when Y =>       NULL;
            when DB_X =>    SEL_X          <= '1';
        end case;
    end process OUTPUTS;

    TRANSITIONS : process ( STATE, BUT )
    begin
        case STATE is
            when X      =>  if BUT = '0' then
                                NEXT_STATE <= X;
                            else
                                NEXT_STATE <= DB_Y;
                            end if;
            when DB_Y   =>  if BUT = '1' then
                                NEXT_STATE <= DB_Y;
                            else
                                NEXT_STATE <= Y;
                            end if;
            when Y      =>  if BUT = '0' then
                                NEXT_STATE <= Y;
                            else
                                NEXT_STATE <= DB_X;
                            end if;
            when DB_X   =>  if BUT = '1' then
                                NEXT_STATE <= DB_X;
                            else
                                NEXT_STATE <= X;
                            end if;
            end case;
    end process TRANSITIONS;

    REG_STATE : process ( CLK )
    begin
        if CLK = '1' and CLK'EVENT then
            if RESET = '1' then
                STATE <= X;
            else
                STATE <= NEXT_STATE;
            end if;
        end if;
    end process REG_STATE;

end architecture AXIS_CONTROLLER_BODY;