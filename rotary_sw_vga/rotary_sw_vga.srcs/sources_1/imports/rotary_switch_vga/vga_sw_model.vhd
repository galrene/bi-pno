library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity VGA is
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
end entity VGA;

architecture SOFTWARE_MODEL of VGA is
    
    -- quantities in pixels
    constant VISIBLE_SCREEN_WIDTH      : NATURAL := 640;
    constant H_BACK_PORCH              : NATURAL := 16;
    constant H_FRONT_PORCH             : NATURAL := 16;
    constant HSYNC_PULSE_WIDTH         : NATURAL := 128;

    constant VISIBLE_SCREEN_HEIGHT     : NATURAL := 480;
    constant V_BACK_PORCH              : NATURAL := 29;
    constant V_FRONT_PORCH             : NATURAL := 10;
    constant VSYNC_PULSE_WIDTH         : NATURAL := 2;
begin
    --NOTE: H_SYNC and V_SYNC are active on 0
    PIXEL_GEN : process
        variable VGA_X                     : NATURAL := 0;
        variable VGA_Y                     : NATURAL := 0;
    begin

        -- every 4 clock cycles, advance the local counters - simulates 25MHz clock
        -- vga_clk = '0'
        for i in 0 to 2 loop
            wait until CLK = '1' and CLK'event;
        end loop;
        
        VGA_RED   <= '0';
        VGA_GREEN <= '0';
        VGA_BLUE  <= '0';
        VGA_HSYNC <= '1';
        VGA_VSYNC <= '1';

        if VGA_X = UNSIGNED(REGX) + H_BACK_PORCH + HSYNC_PULSE_WIDTH then
            -- when at the given X coord, generate a white pixel
            VGA_RED   <= '1';
            VGA_GREEN <= '1';
            VGA_BLUE  <= '1';
        end if;
        if VGA_Y = UNSIGNED(REGY) + V_BACK_PORCH + VSYNC_PULSE_WIDTH then
            -- when at the given Y coordinate, generate a whole white line
            VGA_RED   <= '1';
            VGA_GREEN <= '1';
            VGA_BLUE  <= '1';
        end if;
        -- when at end of line, start new line
        if VGA_X >= H_BACK_PORCH + VISIBLE_SCREEN_WIDTH + H_FRONT_PORCH then
            VGA_HSYNC <= '0';
        end if;    
            -- when at end of frame, start new frame
        if VGA_Y >= V_BACK_PORCH + VISIBLE_SCREEN_HEIGHT + V_FRONT_PORCH then
            VGA_VSYNC <= '0';
        end if;
        
        -- increment local counters
        if VGA_X = H_BACK_PORCH + VISIBLE_SCREEN_WIDTH + H_FRONT_PORCH + HSYNC_PULSE_WIDTH then
            VGA_X := 0;
            if VGA_Y = V_BACK_PORCH + VISIBLE_SCREEN_HEIGHT + V_FRONT_PORCH + VSYNC_PULSE_WIDTH then
                VGA_Y := 0;
            else
                VGA_Y := VGA_Y + 1;
            end if;
        else
            VGA_X := VGA_X + 1;
        end if;
        
        --vga_clk = '1'
        for i in 0 to 2 loop
            wait until CLK = '1' and CLK'event;
        end loop;

    end process PIXEL_GEN;
end architecture SOFTWARE_MODEL;