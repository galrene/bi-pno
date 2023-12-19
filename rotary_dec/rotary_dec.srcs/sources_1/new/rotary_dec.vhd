library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ROTARY is
    port (
        ROTARY : in  std_logic_vector (2 downto 0);   -- rotary button  (left, right, push)
        REGX   : out std_logic_vector (7 downto 0);   -- X
        REGY   : out std_logic_vector (7 downto 0);   -- Y
        CLK    : in  std_logic;                       -- 100 MHz
        RESET  : in  std_logic
    );
end entity ROTARY;

architecture ROTARY_BODY of ROTARY is

    component DATAPATH is
        port (
            ROTARY    : in  STD_LOGIC_VECTOR ( 2 downto 0 );
            X         : in  STD_LOGIC; -- x := select reg x, not x := select reg y
            BTN       : out STD_LOGIC;
            REGX      : out STD_LOGIC_VECTOR ( 7 downto 0 );
            REGY      : out STD_LOGIC_VECTOR ( 7 downto 0 );
            CLK       : in  STD_LOGIC;
            RST_DP    : in  STD_LOGIC
        );
    end component DATAPATH;
    
    component CONTROLLER is
        port (
            BUT, CLK      : in  STD_LOGIC; 
            SEL_X         : out STD_LOGIC;
            RESET         : in  STD_LOGIC; -- externally activated reset
            RST_DP        : out STD_LOGIC  -- internal reset
        );
    end component CONTROLLER;
    
    signal SEL_X          : STD_LOGIC;
    signal RESET_DATAPATH : STD_LOGIC;
    signal BUTTON         : STD_LOGIC;
begin

    DATA_INST : DATAPATH port map (
        ROTARY => ROTARY,
        X      => SEL_X,
        BTN    => BUTTON,
        REGX   => REGX, 
        REGY   => REGY,
        CLK    => CLK,
        RST_DP => RESET_DATAPATH
    );
    
    CNTL_INST : CONTROLLER port map (
        BUT    => BUTTON,
        CLK    => CLK,
        SEL_X  => SEL_X,
        RESET  => RESET,
        RST_DP => RESET_DATAPATH
    );

end architecture ROTARY_BODY;
