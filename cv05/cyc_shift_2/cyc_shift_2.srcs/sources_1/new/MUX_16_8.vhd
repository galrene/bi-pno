library IEEE;
use IEEE.std_logic_1164.all;
entity MUX_16_8 is
    port (
        A   : in std_logic_vector ( 7 downto 0 );
        B   : in std_logic_vector ( 7 downto 0 );
        SIG : in std_logic;
        Y   : out std_logic_vector ( 7 downto 0 );
    );
end entity MUX_16_8;

architecture MUX_16_8_BODY of MUX_16_8 is
begin

    MUX : process ( A, B, SIG )
    begin
        case SIG is
            when '0' => 
                Y <= A;
            when '1' => 
                Y <= B;
        end case;
    end process MUX;

end architecture MUX_16_8_BODY;