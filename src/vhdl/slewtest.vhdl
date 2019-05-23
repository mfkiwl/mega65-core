----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:30:37 12/10/2013 
-- Design Name: 
-- Module Name:    container - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use ieee.numeric_std.all;
use Std.TextIO.all;

library unisim;
use unisim.vcomponents.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity container is
  Port ( CLK_IN : STD_LOGIC;         
         
         ----------------------------------------------------------------------
         -- PMODs for LCD screen and associated things during testing
         ----------------------------------------------------------------------
         lcd_dclk : out std_logic := '0'
         
         );
end container;

architecture Behavioral of container is

  signal pixelclock : std_logic;
  signal cpuclock : std_logic;
  signal clock240 : std_logic;
  signal clock120 : std_logic;
  signal ethclock : std_logic;
  signal clock200 : std_logic;
  signal clock30 : std_logic;
  signal clock30in : std_logic := '0';
  signal clock30count : integer range 0 to 3 := 0;

  signal pal50_select : std_logic := '0';

begin
  
  dotclock1: entity work.dotclock100
    port map ( clk_in1 => CLK_IN,
               clock80 => pixelclock, -- 80MHz
               clock40 => cpuclock, -- 40MHz
               clock50 => ethclock,
               clock200 => clock200,
               clock120 => clock120,
               clock240 => clock240
               );


  -- Create BUFG'd 30MHz clock for LCD panel
  --------------------------------------
  clkin30_buf : IBUFG
  port map
   (O => clock30,
    I => clock30in);

  lcd_dclk <= clock30 when pal50_select='1' else cpuclock;
  
  process (clock240,pal50_select,clock30,clock30in)
  begin

    if rising_edge(clock240) then

      if (clock30count /= 3 ) then
        clock30count <= clock30count + 1;
      else
        clock30in <= not clock30in;
        clock30count <= 0;
      end if;
    end if;
  end process;
  
end Behavioral;