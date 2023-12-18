----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/18/2023 01:24:00 AM
-- Design Name: 
-- Module Name: ROTARY_DEC - ROTARY_DEC_BODY
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


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
end ROTARY;

architecture ROTARY_DEC_BODY of ROTARY_DEC is

begin

    

end ROTARY_DEC_BODY;
