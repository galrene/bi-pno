library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.all;                                        -- for the FILE data type and related operations

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

    -- signals
    signal TB_REGX      : std_logic_vector (7 downto 0);
    signal TB_REGY      : std_logic_vector (7 downto 0);
    signal TB_VGA_RED   : std_logic;
    signal TB_VGA_GREEN : std_logic;
    signal TB_VGA_BLUE  : std_logic;
    signal TB_VGA_HSYNC : std_logic;
    signal TB_VGA_VSYNC : std_logic;
    signal TB_CLK       : std_logic;
    signal TB_RESET     : std_logic;
    
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
    end process;  

    DUT: VGA
        port map (
            REGX      => TB_REGX,
            REGY      => TB_REGY,
            VGA_RED   => TB_VGA_RED,
            VGA_GREEN => TB_VGA_GREEN,
            VGA_BLUE  => TB_VGA_BLUE,
            VGA_HSYNC => TB_VGA_HSYNC,
            VGA_VSYNC => TB_VGA_VSYNC,
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

        for A in 0 to 255 loop
            for B in 0 to 255 loop
                wait until TB_CLK = '1';
                
                TB_REGX <= std_logic_vector(to_unsigned(A, 8));
                wait for 30 ns;
                TB_REGY <= std_logic_vector(to_unsigned(B, 8));
                wait for 10*CLK_PERIOD;

                -- assert all VGA signals
                -- TODO

            end loop;
        end loop;

    end process STIMULI_GEN;