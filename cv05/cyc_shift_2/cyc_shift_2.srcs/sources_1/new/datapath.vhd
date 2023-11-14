library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity DATAPATH is
    port (
        INPUT     : in  STD_LOGIC_VECTOR ( 7 downto 0 );
        LOAD_NUM  : in  STD_LOGIC;
        SH_LEFT   : in  STD_LOGIC;
        LOAD_AM   : in  STD_LOGIC;
        SIG_SHIFT : in  STD_LOGIC;
        OUTPUT    : out STD_LOGIC_VECTOR ( 7 downto 0 );
        CLK       : in  STD_LOGIC;
        RESET     : in  STD_LOGIC;
        ------------------------------------------------
        COPY_NUM   : out STD_LOGIC_VECTOR ( 7 downto 0 );
        COPY_AM    : out STD_LOGIC_VECTOR ( 2 downto 0 );
        COPY_DIR   : out STD_LOGIC -- direction of the shift, not really a copy since an "original" doesn't exist (handled by an internal signal)
                                   -- '0' == right shift, '1' == left shift
    );
end entity DATAPATH;

architecture DATAPATH_BODY of DATAPATH is
    
    component BARREL_SHIFTER is
        port (
            S_NUM : in  STD_LOGIC_VECTOR ( 7 downto 0 );
            S_AM  : in  STD_LOGIC_VECTOR ( 2 downto 0 ); -- shift amount
            S_RES : out STD_LOGIC_VECTOR ( 7 downto 0 )
        );
    end component BARREL_SHIFTER;    
    
    signal NUM                 : STD_LOGIC_VECTOR ( 7 downto 0 );
    signal SH_AMOUNT           : STD_LOGIC_VECTOR ( 2 downto 0 );
    signal SH_AMOUNT_NO_DIR    : STD_LOGIC_VECTOR ( 2 downto 0 ); -- raw SH_AMOUNT before deciding which direction to shift in  
    signal RES                 : STD_LOGIC_VECTOR ( 7 downto 0 );

begin

    -- register that loads the number for shifting
    NUM_REG : process ( CLK )
    begin
        if CLK = '1' and CLK'EVENT then
            if LOAD_NUM = '1' then
                NUM <= INPUT;
                ---
                COPY_NUM <= INPUT;
            end if;
        end if;
    end process NUM_REG;

    -- register storing shift amount
    SH_AM_REG : process ( CLK )
    begin
        if CLK = '1' and CLK'EVENT then
            if LOAD_AM = '1' then
                SH_AMOUNT_NO_DIR <= INPUT ( 2 downto 0 );
                ---
                COPY_AM <= INPUT ( 2 downto 0 );
            end if;
        end if;
    end process SH_AM_REG;
    
    -- process deciding shift direction
    SH_DIR : process ( SH_AMOUNT_NO_DIR, SH_LEFT )
    begin
        SH_AMOUNT <= SH_AMOUNT_NO_DIR;
        COPY_DIR <= '0';
        if SH_LEFT = '1' then
            -- converting to two's complement converts a right shift to a left shift
            SH_AMOUNT <= STD_LOGIC_VECTOR ( UNSIGNED ( not SH_AMOUNT_NO_DIR ) +  1 );
            ---
            COPY_DIR <= '1'; 
        end if;
    end process SH_DIR;

    -- barrel shifter
    BAR : BARREL_SHIFTER port map (
        S_NUM => NUM,
        S_AM  => SH_AMOUNT,
        S_RES => RES
    );
    
    -- register storing the shift result    
    RES_REG : process ( CLK )
    begin
        if CLK = '1' and CLK'EVENT then
            if RESET = '1' then
                OUTPUT <= ( others => '0' );
                elsif SIG_SHIFT = '1' then
                OUTPUT <= RES;
            end if;
        end if;
    end process RES_REG;

end architecture DATAPATH_BODY;
