entitiy VGA is
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
end entitiy VGA;

architecture SOFTWARE_MODEL of VGA is
    variable VGA_X                     : INTEGER := 0;
    variable VGA_Y                     := 0;

    signal   CLK_DIVIDER               : INTEGER := 0;
    signal   VGA_CLK                   : std_logic;
    constant PIXEL_PERIOD              = 1 / 25e6; -- in seconds
    
    -- in pixels
    constant VISIBLE_SCREEN_WIDTH      = 640;
    constant H_BACK_PORCH              = 16;
    constant H_FRONT_PORCH             = 16;
    constant HSYNC_PULSE_WIDTH         = 128;

    constant VISIBLE_SCREEN_HEIGHT     = 480;
    constant V_BACK_PORCH              = 29;
    constant V_FRONT_PORCH             = 10;
    constant VSYNC_PULSE_WIDTH         = 2;
begin
--NOTE: H_SYNC and V_SYNC are active on 0
    
    -- quarter the period of the main clock
    VGA_CLK : process (CLK)
    begin 
        if CLK = '1' and CLK'event then  
            if RESET = '1' then
                CLK_DIVIER <= 0;
                VGA_CLK <= '0';    
            else
                CLK_DIVIDER <= CLK_DIVIDER + 1;
            end if;
            if CLK_DIVIDER = 2 then
                CLK_DIVIDER <= 0;
                VGA_CLK <= not VGA_CLK;
            end if;
        end if;
    end process;


    INTERAL_COUNTERS : process (VGA_CLK)
    begin
       if VGA_CLK = '1' and VGA_CLK'event then
            if RESET = '1' then
                VGA_X     :=  0;
                VGA_Y     :=  0;
                VGA_HSYNC := '1';
                VGA_VSYNC := '1';
            elsif VGA_X = H_BACK_PORCH + VISIBLE_SCREEN_WIDTH + H_FRONT_PORCH + HSYNC_PULSE_WIDTH then
                VGA_X := 0;
                if VGA_Y = V_BACK_PORCH + VISIBLE_SCREEN_HEIGHT + V_FRONT_PORCH + VSYNC_PULSE_WIDTH then
                    VGA_Y := 0;
                else
                    VGA_Y := VGA_Y + 1;
                end if;
            else
                VGA_X := VGA_X + 1;
            end if;
       end if;
    end process;

    

    PIXEL_GEN : process (VGA_CLK)
    if VGA_Y = REGY + V_BACK_PORCH + VSYNC_PULSE_WIDTH then
    -- when at the given Y coordinate, generate a whole white line
       VGA_RED   = '1';
       VGA_GREEN = '1';
       VGA_BLUE  = '1';
       wait for VISIBLE_SCREEN_WIDTH * PIXEL_PERIOD;
       VGA_RED   = '0';
       VGA_GREEN = '0';
       VGA_BLUE  = '0';
    elsif VGA_X = REGX + H_BACK_PORCH + HSYNC_PULSE_WIDTH then
    -- when at the given X coord, generate a white pixel
       VGA_RED   = '1';
       VGA_GREEN = '1';
       VGA_BLUE  = '1';
       wait for PIXEL_PERIOD;
       VGA_RED   = '0';
       VGA_GREEN = '0';
       VGA_BLUE  = '0';
    end if;
    -- when at end of line, start new line
    if VGA_X = H_BACK_PORCH + VISIBLE_SCREEN_WIDTH + H_FRONT_PORCH then
       VGA_HSYNC = '0';
       wait for HSYNC_PULSE_WIDTH * PIXEL_PERIOD;
       VGA_HSYNC = '1';
    end if;    
    -- when at end of frame, start new frame
    if VGA_Y = V_BACK_PORCH + VISIBLE_SCREEN_HEIGHT + V_FRONT_PORCH then
       VGA_VSYNC = '0';
       wait for VSYNC_PULSE_WIDTH * PIXEL_PERIOD;
       VGA_VSYNC = '1';
    end if;
    end process PIXEL_GEN;
end architecture SOFTWARE_MODEL;