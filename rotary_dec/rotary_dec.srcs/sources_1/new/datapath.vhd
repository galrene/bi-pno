library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity DATAPATH is
    port (
        ROTARY    : in  STD_LOGIC_VECTOR ( 2 downto 0 );
        X         : in  STD_LOGIC; -- x := select reg x, not x := select reg y
        BTN       : out STD_LOGIC;
        REGX      : out STD_LOGIC_VECTOR ( 7 downto 0 );
        REGY      : out STD_LOGIC_VECTOR ( 7 downto 0 );
        CLK       : in  STD_LOGIC;
        RST_DP    : in  STD_LOGIC
    );
end entity DATAPATH;

architecture DATAPATH_BODY of DATAPATH is
    component QUADRATURE_DEC is
        port (
            A, B, CLK, RESET : in STD_LOGIC;
            INC, EN          : out STD_LOGIC -- increment/decrement, enable counting
        );
    end component QUADRATURE_DEC;

    component Debouncer is
        port ( 
            clk  : in  STD_LOGIC;
            -- signals from the pmod
            Ain  : in  STD_LOGIC; 
            Bin  : in  STD_LOGIC;
            -- debounced signals 
            Aout : out STD_LOGIC;
            Bout : out STD_LOGIC
        );
    end component Debouncer;
    
    component SYNCHRONIZER is
        port (
            SIG         : in  STD_LOGIC;
            SYNCED_SIG  : out STD_LOGIC;
            CLK         : in  STD_LOGIC;
            RST_DP      : in  STD_LOGIC
        );
    end component SYNCHRONIZER;

    signal REGX_SIG        : STD_LOGIC_VECTOR ( 7 downto 0 );
    signal REGY_SIG        : STD_LOGIC_VECTOR ( 7 downto 0 );
    -- debounced inputs
    signal A_DB            : STD_LOGIC;
    signal B_DB            : STD_LOGIC;
    signal BTN_SIG         : STD_LOGIC;
    signal INCREMENT       : STD_LOGIC;
    signal ENABLE_COUNTING : STD_LOGIC;
begin

    REGX <= REGX_SIG;
    REGY <= REGY_SIG;

    POS_X_REG : process ( CLK )
    begin
        if CLK = '1' and CLK'EVENT then
            if RST_DP = '1' then
                REGX_SIG <= ( others => '0');
            elsif ENABLE_COUNTING = '1' and X = '1' then
            -- at posedge, when X register is selected and counting is enabled
                if INCREMENT = '1' then
                    REGX_SIG <= STD_LOGIC_VECTOR(UNSIGNED(REGX_SIG) + 1);
                else
                    REGX_SIG <= STD_LOGIC_VECTOR(UNSIGNED(REGX_SIG) - 1);
                end if;
            end if;
        end if;
    end process POS_X_REG;

    POS_Y_REG : process ( CLK )
    begin
        if CLK = '1' and CLK'EVENT then
            if RST_DP = '1' then
                REGY_SIG <= (others => '0');
            elsif ENABLE_COUNTING = '1' and X = '0' then
            -- at posedge, when X register is selected and counting is enabled
                if INCREMENT = '1' then
                    REGY_SIG <= STD_LOGIC_VECTOR(UNSIGNED(REGY_SIG) + 1);
                else
                    REGY_SIG <= STD_LOGIC_VECTOR(UNSIGNED(REGY_SIG) - 1);
                end if;
            end if;
        end if;
    end process POS_Y_REG;
    
    -------------------------------------

    QUAD_DEC : QUADRATURE_DEC port map (
        A     => A_DB,
        B     => B_DB,
        CLK   => CLK,
        RESET => RST_DP,
        INC   => INCREMENT,
        EN    => ENABLE_COUNTING
    );

    DEBOUNCE : Debouncer port map (
        CLK  => CLK,
        Ain  => ROTARY(0),
        Bin  => ROTARY(1),
        Aout => A_DB,
        Bout => B_DB
    );
    
    BTN <= BTN_SIG;

    SYNCHRONIZER : SYNCHRONIZER port map (
        SIG        => ROTARY(2),
        SYNCED_SIG => BTN_SIG,
        CLK        => CLK,
        RST_DP     => RST_DP
    );
end architecture DATAPATH_BODY;
