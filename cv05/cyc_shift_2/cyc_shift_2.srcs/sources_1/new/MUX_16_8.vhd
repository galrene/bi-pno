library IEEE;
use IEEE.std_logic_1164.all;
entity MUX_16_8 is
    port (
        A   : in std_logic_vector ( 7 downto 0 );
        B   : in std_logic_vector ( 7 downto 0 );
        SIG : in std_logic;
        Y   : out std_logic_vector ( 7 downto 0 )
    );
end entity MUX_16_8;

architecture MUX_16_8_BODY of MUX_16_8 is
begin

    MUX : process ( A, B, SIG )
    begin
        if SIG = '0' then
            Y <= A;
        else
            Y <= B;
        end if;
    end process MUX;

end architecture MUX_16_8_BODY;