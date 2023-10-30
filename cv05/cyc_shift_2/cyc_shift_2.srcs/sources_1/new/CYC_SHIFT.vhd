library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity CYC_SHIFT is
    port (
        INPUT    : in  STD_LOGIC_VECTOR ( 7 downto 0 );
        BUT_0    : in  STD_LOGIC;
        BUT_1    : in  STD_LOGIC;
        BUT_2    : in  STD_LOGIC;
        OUTPUT   : out STD_LOGIC_VECTOR ( 7 downto 0 );
        COPY_NUM : out STD_LOGIC_VECTOR ( 7 downto 0 );
        COPY_AM  : out STD_LOGIC_VECTOR ( 7 downto 0 );
        CLK      : in  STD_LOGIC;
    ); 
end CYC_SHIFT;

architecture CYC_SHIFT_BODY of CYC_SHIFT is
    component DATAPATH is
        port (
            INPUT     : in STD_LOGIC_VECTOR ( 7 downto 0 );
            LOAD_NUM  : in STD_LOGIC;
            SH_LEFT   : in STD_LOGIC;
            LOAD_AM   : in STD_LOGIC;
            SIG_SHIFT : in STD_LOGIC;
            OUTPUT    : out STD_LOGIC_VECTOR ( 7 downto 0 );
            CLK       : in STD_LOGIC
            -- COPY_NUM : out STD_LOGIC_VECTOR ( 7 downto 0 );
            -- COPY_AM : out STD_LOGIC_VECTOR ( 2 downto 0 );
        );
    end component DATAPATH;
    
    component CONTROLLER is
        port (
            BUT_0, BUT_1, BUT_2, CLK              : in std_logic; 
            LOAD_NUM, LOAD_AM, SH_LEFT, SIG_SHIFT : out std_logic
        );
    end component CONTROLLER;
begin
    DATA_INST : DATAPATH port map (
        INPUT     => INPUT;
        LOAD_NUM  => LOAD_NUM;
        SH_LEFT   => SHIFT_LEFT;
        LOAD_AM   => LOAD_AM;
        SIG_SHIFT => SIG_SHIFT;
        OUTPUT    => OUTPUT;
        CLK       => CLK;
    );

    CNTR_INST : CONTROLLER port map (
        BUT_0     => BUT_0;
        BUT_1     => BUT_1;
        BUT_2     => BUT_2;
        CLK       => CLK;
        LOAD_NUM  => LOAD_NUM;
        LOAD_AM   => LOAD_AM;
        SH_LEFT   => SH_LEFT;
        SIG_SHIFT => SIG_SHIFT;
    );
end architecture CYC_SHIFT_BODY;

---------------------------------------------

architecture SOFTWARE_MODEL of CYC_SHIFT is
begin

    SW_MODEL : process
        variable NUM, AM;
    begin
        wait until BUT_0 = '1';
        NUM := UNSIGNED(INPUT);
        COPY_NUM <= INPUT;
        wait until BUT_1 = '1' or BUT_2 = '1';
        if BUT_1 = '1' then

            OUTPUT <= ( NUM sll AM );
        else
            OUTPUT <= ( NUM << AM );
        end if;
    end process;

end architecture SOFTWARE_MODEL;