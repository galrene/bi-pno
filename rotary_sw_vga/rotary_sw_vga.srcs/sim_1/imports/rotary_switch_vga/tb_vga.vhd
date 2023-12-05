library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_VGA is
end entity TB_VGA;

architecture TB_VGA_BODY of TB_VGA is
    component VGA is
        port (
           REGX      : in  std_logic_vector (7 downto 0); -- X
           REGY      : in  std_logic_vector (7 downto 0); -- Y
           VGA_RED   : out std_logic;
           VGA_GREEN : out std_logic;
           VGA_BLUE  : out std_logic;
           VGA_HSYNC : out std_logic;
           VGA_VSYNC : out std_logic;
           CLK       : in  std_logic;                     -- 100 MHz
           RESET     : in  std_logic
        );
    end component VGA;
    
    -- to be switched out for the real device
    for DUT : VGA use entity work.VGA(VGA_BODY) port map (
        REGX        => REGX,
        REGY        => REGY,
        VGA_RED     => VGA_RED,
        VGA_GREEN   => VGA_GREEN,
        VGA_BLUE    => VGA_BLUE,
        VGA_HSYNC   => VGA_HSYNC,
        VGA_VSYNC   => VGA_VSYNC,
        CLK         => CLK,
        RESET       => RESET
    );
    -- architecture SOFTWARE_MODEL contains the golden standard
    for GOLDEN : VGA use entity work.VGA(SOFTWARE_MODEL) port map (
        REGX        => REGX,
        REGY        => REGY,
        VGA_RED     => VGA_RED,
        VGA_GREEN   => VGA_GREEN,
        VGA_BLUE    => VGA_BLUE,
        VGA_HSYNC   => VGA_HSYNC,
        VGA_VSYNC   => VGA_VSYNC,
        CLK         => CLK,
        RESET       => RESET
    );

    -- signals
    signal TB_REGX              : std_logic_vector (7 downto 0);
    signal TB_REGY              : std_logic_vector (7 downto 0);
    
    signal TB_VGA_RED_DUT       : std_logic;
    signal TB_VGA_GREEN_DUT     : std_logic;
    signal TB_VGA_BLUE_DUT      : std_logic;
    signal TB_VGA_HSYNC_DUT     : std_logic;
    signal TB_VGA_VSYNC_DUT     : std_logic;

    signal TB_VGA_RED_GOLDEN    : std_logic;
    signal TB_VGA_GREEN_GOLDEN  : std_logic;
    signal TB_VGA_BLUE_GOLDEN   : std_logic;
    signal TB_VGA_HSYNC_GOLDEN  : std_logic;
    signal TB_VGA_VSYNC_GOLDEN  : std_logic;
    
    signal TB_CLK               : std_logic;
    signal TB_RESET             : std_logic;
    
    -- constants
    constant CLK_PERIOD : time := 10 ns; -- 100 Mhz CLK
begin

    -- clock generator
    CLK_GEN : process
    begin
        TB_CLK <= '0';
        wait for CLK_PERIOD / 2;
        TB_CLK <= '1';
        wait for CLK_PERIOD / 2;
    end process CLK_GEN;

    -- reset generator
    RESET_GEN : process
        begin
        wait for 30 ns;
        TB_RESET <= '0';   
        wait for 30 ns;
        TB_RESET <= '1';   
        wait for 30 ns;
        TB_RESET <= '0';
        wait;
    end process RESET_GEN;

    DUT : VGA
        port map (
            REGX      => TB_REGX,
            REGY      => TB_REGY,
            VGA_RED   => TB_VGA_RED_DUT,
            VGA_GREEN => TB_VGA_GREEN_DUT,
            VGA_BLUE  => TB_VGA_BLUE_DUT,
            VGA_HSYNC => TB_VGA_HSYNC_DUT,
            VGA_VSYNC => TB_VGA_VSYNC_DUT,
            CLK       => TB_CLK,
            RESET     => TB_RESET
        );
    
    GOLDEN : VGA
        port map (
            REGX      => TB_REGX,
            REGY      => TB_REGY,
            VGA_RED   => TB_VGA_RED_GOLDEN,
            VGA_GREEN => TB_VGA_GREEN_GOLDEN,
            VGA_BLUE  => TB_VGA_BLUE_GOLDEN,
            VGA_HSYNC => TB_VGA_HSYNC_GOLDEN,
            VGA_VSYNC => TB_VGA_VSYNC_GOLDEN,
            CLK       => TB_CLK,
            RESET     => TB_RESET
        );


    STIMULI_GEN : process
    begin

        wait until TB_RESET = '1';
        TB_REGX <= (others => '0');
        TB_REGY <= (others => '0');
        wait until TB_RESET = '0';
        wait for 33 ns;
    
        assert FALSE
            report "-----BEGIN SIMULATION-----"
            severity note;
        
        -- generate input values for VGA
        for X in 0 to 255 loop
            for Y in 0 to 255 loop
                wait until TB_CLK = '1';
                
                TB_REGX <= std_logic_vector(to_unsigned(X, 8));
                wait for 30 ns;
                TB_REGY <= std_logic_vector(to_unsigned(Y, 8));
                wait for 10*CLK_PERIOD;

                -- assert all VGA signals of SW model = VHDL model
                assert TB_VGA_RED_DUT = TB_VGA_RED_GOLDEN
                    report "VGA_RED: Vstupy: " & integer'image(A) & " "&integer'image(B) & ", Vystup: " & integer'image(TO_INTEGER(UNSIGNED(TB_OUTPUT_DUT))) & "; Ocekavam: " & integer'image(TO_INTEGER(UNSIGNED(TB_OUTPUT_GOLDEN))) 
                    severity error;
                assert TB_VGA_GREEN_DUT = TB_VGA_GREEN_GOLDEN
                    report "VGA_GREEN: Vstupy: " & integer'image(A) & " "&integer'image(B) & ", Vystup: " & integer'image(TO_INTEGER(UNSIGNED(TB_OUTPUT_DUT))) & "; Ocekavam: " & integer'image(TO_INTEGER(UNSIGNED(TB_OUTPUT_GOLDEN))) 
                    severity error;
                assert TB_VGA_BLUE_DUT = TB_VGA_BLUE_GOLDEN
                    report "VGA_BLUE: Vstupy: " & integer'image(A) & " "&integer'image(B) & ", Vystup: " & integer'image(TO_INTEGER(UNSIGNED(TB_OUTPUT_DUT))) & "; Ocekavam: " & integer'image(TO_INTEGER(UNSIGNED(TB_OUTPUT_GOLDEN))) 
                    severity error;
                assert TB_VGA_HSYNC_DUT = TB_VGA_HSYNC_GOLDEN
                    report "VGA_HSYNC: Vstupy: " & integer'image(A) & " "&integer'image(B) & ", Vystup: " & integer'image(TO_INTEGER(UNSIGNED(TB_OUTPUT_DUT))) & "; Ocekavam: " & integer'image(TO_INTEGER(UNSIGNED(TB_OUTPUT_GOLDEN))) 
                    severity error;
                assert TB_VGA_VSYNC_DUT = TB_VGA_VSYNC_GOLDEN
                    report "VGA_VSYNC: Vstupy: " & integer'image(A) & " "&integer'image(B) & ", Vystup: " & integer'image(TO_INTEGER(UNSIGNED(TB_OUTPUT_DUT))) & "; Ocekavam: " & integer'image(TO_INTEGER(UNSIGNED(TB_OUTPUT_GOLDEN))) 
                    severity error;

            end loop;
        end loop;
        
        assert FALSE
            report "-----END OF SIMULATION-----"
            severity failure;
    
    end process STIMULI_GEN;
end architecture TB_VGA_BODY;