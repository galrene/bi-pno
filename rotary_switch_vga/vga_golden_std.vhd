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

architecture SOFTWARE_MODEL of SERIAL_MULTIPLIER is
    -- variable VGA_X:= 0, VGA_Y:= 0;
    -- constant VGA_CLOCK = CLK / 4 -- VGA_CLK == 25MHz
    -- constant SCREEN_WIDTH       = 640;
    -- constant SCREEN_HEIGHT      = 480;
    -- constant H_BACK_PORCH       = 16;
    -- constant H_FRONT_PORCH      = 16;
    -- constant HSYNC_PULSE_WIDTH = 128;
    -- gen_white_pixel()
    --    VGA_RED   = '1';
    --    VGA_GREEN = '1';
    --    VGA_BLUE  = '1';
    --    wait for one VGA_CLOCK;
    --    VGA_RED   = '0';
    --    VGA_GREEN = '0';
    --    VGA_BLUE  = '0';

    -- gen_white_line()
    --    VGA_RED   = '1';
    --    VGA_GREEN = '1';
    --    VGA_BLUE  = '1';
    --    wait for SCREEN_WIDTH * VGA_CLOCK;
    --    VGA_RED   = '0';
    --    VGA_GREEN = '0';
    --    VGA_BLUE  = '0';
begin

    SW_MODEL : process
    -- if VGA_Y = Y then                     -- ked si na suradnici danej Y, generuj pixely cely riadok
    --    gen_white_line();
    -- elsif VGA_X = X + H_BACK_PORCH then   -- ked si na suradnici danej X, vygeneruj biely pixel
    --    gen_white_pixel();
    -- end if;
    -- 
    -- if VGA_X = H_BACK_PORCH + SCREEN_WIDTH + H_FRONT_PORCH then -- ked si na konci riadku, zacni pisat novy riadok
    --     VGA_HSYNC = '1';
    --     wait for HSYNC_PULSE_WIDTH;
    --     VGA_HSYNC = '0';
    -- end if;

    -- if VGA_Y == ...
        