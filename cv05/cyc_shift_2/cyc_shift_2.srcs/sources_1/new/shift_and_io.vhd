library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity SHIFT_AND_IO is
   port (
      SWITCH     : in  STD_LOGIC_VECTOR (7 downto 0);
      BUT_0       : in  STD_LOGIC;
      BUT_1       : in  STD_LOGIC;
      BUT_2       : in  STD_LOGIC;
      BUT_3       : in  STD_LOGIC;
      SEGMENT    : out STD_LOGIC_VECTOR (6 downto 0);    -- 7 segments of the display
      DP         : out STD_LOGIC;                        -- floating point
      DIGIT      : out STD_LOGIC_VECTOR (3 downto 0);    -- 4 digits of the display
      CLK        : in  STD_LOGIC
   );
end entity SHIFT_AND_IO;

architecture SHIFT_AND_IO_BODY of SHIFT_AND_IO is
    component CYC_SHIFT is
        port (
            INPUT    : in  STD_LOGIC_VECTOR ( 7 downto 0 );
            BUT_0    : in  STD_LOGIC;
            BUT_1    : in  STD_LOGIC;
            BUT_2    : in  STD_LOGIC;
            OUTPUT   : out STD_LOGIC_VECTOR ( 7 downto 0 );
            CLK      : in  STD_LOGIC;
            -----------------------------------------------
            COPY_NUM : out STD_LOGIC_VECTOR ( 7 downto 0 );
            COPY_AM  : out STD_LOGIC_VECTOR ( 2 downto 0 );
            COPY_DIR : out STD_LOGIC 
        ); 
    end component CYC_SHIFT;
    
   component HEX2SEG is
      port (
         DATA     : in  STD_LOGIC_VECTOR (15 downto 0);   -- input data for display ( NUM(8), SHIFT_DIR(1), SHIFT_AM(3) ) 
         CLK      : in  STD_LOGIC;
         SEGMENT  : out STD_LOGIC_VECTOR (6 downto 0);    -- 7 segments of the display
         DP       : out STD_LOGIC;                        -- floating point
         DIGIT    : out STD_LOGIC_VECTOR (3 downto 0)     -- 4 digits of the display
      );
   end component HEX2SEG;
   -- signals --
   signal OUTPUT            : STD_LOGIC_VECTOR (7 downto 0);
   signal DATA              : STD_LOGIC_VECTOR (15 downto 0);  -- result, display data
   signal COPY_NUM          : STD_LOGIC_VECTOR (7 downto 0);   -- input operands copy
   signal COPY_AM           : STD_LOGIC_VECTOR (2 downto 0);    
   signal COPY_DIR          : STD_LOGIC;                       -- direction indicator copy
   
   signal ZEROES             : STD_LOGIC_VECTOR ( 7 downto 0 );
begin
   ZEROES <= (others => '0');
   
   SHIFT_INST : CYC_SHIFT port map (
                  INPUT    => SWITCH,
                  BUT_0    => BUT_0,
                  BUT_1    => BUT_1,
                  BUT_2    => BUT_2,
                  OUTPUT   => OUTPUT,
                  COPY_NUM => COPY_NUM,
                  COPY_AM  => COPY_AM,
                  COPY_DIR => COPY_DIR,
                  CLK      => CLK
                );
   
   DISP_INST : HEX2SEG port map (
                  DATA     => DATA,
                  CLK      => CLK,
                  SEGMENT  => SEGMENT,
                  DP       => DP,
                  DIGIT    => DIGIT
               );
    
    
   -- BTN3 switches between output or original input operands (number shift, shift direction, shift amount)
   DISPLAY_MUX : process (BUT_3, OUTPUT, COPY_NUM, COPY_AM, COPY_DIR, ZEROES)
   begin
      if BUT_3 = '0' then
         DATA <= ZEROES & OUTPUT;
      else
         DATA <= ("0000" & COPY_NUM & COPY_DIR & COPY_AM);
      end if; 
   end process DISPLAY_MUX;


end architecture SHIFT_AND_IO_BODY;
