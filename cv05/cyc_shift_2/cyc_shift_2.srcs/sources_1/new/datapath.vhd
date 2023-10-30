library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity DATAPATH is
    port (
        INPUT     : in STD_LOGIC_VECTOR ( 7 downto 0 );
        LOAD_NUM  : in STD_LOGIC;
        SH_LEFT   : in STD_LOGIC;
        LOAD_AM   : in STD_LOGIC;
        SIG_SHIFT : in STD_LOGIC;
        OUTPUT    : out STD_LOGIC_VECTOR ( 7 downto 0 );
        CLK       : in STD_LOGIC
        -- COPY_IN : out STD_LOGIC_VECTOR ( 7 downto 0 );
        -- COPY_AM : out STD_LOGIC_VECTOR ( 2 downto 0 );
    );
end entity DATAPATH;

architecture DATAPATH_BODY of DATAPATH is

    signal S_NUM       : STD_LOGIC_VECTOR ( 7 downto 0 );
    signal S_AM        : STD_LOGIC_VECTOR ( 2 downto 0 );
    signal S_AM_NO_DIR : STD_LOGIC_VECTOR ( 2 downto 0 );
    signal S_RES       : STD_LOGIC_VECTOR ( 7 downto 0 );

begin


    NUM_REG : process ( CLK )
    begin
        if CLK = '1' and CLK'EVENT then
            if LOAD_NUM = '1' then
                S_NUM <= INPUT;
            end if;
        end if;
    end process NUM_REG;

    -- register storing shift amount
    SH_AM_REG : process ( CLK )
    begin
        if CLK = '1' and CLK'EVENT then
            if LOAD_AM = '1' then
                S_AM_NO_DIR <= INPUT ( 2 downto 0 );
            end if;
        end if;
    end process SH_AM_REG;
    
    -- process deciding shift direction
    SH_DIR : process ( S_AM_NO_DIR )
    begin
        S_AM <= S_AM_NO_DIR;
        if SH_LEFT = '1' then
            -- converting to two's complement converts a right shift to a left shift
            S_AM <= STD_LOGIC_VECTOR ( not ( UNSIGNED ( S_AM_NO_DIR ) )
                                       + 1 );
        end if;
    end process SH_DIR;

    
    RES_REG : process ( CLK )
    begin
        if CLK = '1' and CLK'EVENT then
            if SIG_SHIFT = '1' then
                OUTPUT <= S_RES;
            end if;
        end if;
    end process RES_REG;

end architecture DATAPATH_BODY;
