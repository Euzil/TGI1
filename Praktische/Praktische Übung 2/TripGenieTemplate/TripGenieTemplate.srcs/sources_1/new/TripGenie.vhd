----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.04.2019 11:49:30
-- Design Name: 
-- Module Name: TripGenie - Behavioral
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

    
entity TripGenies is
    PORT(
        Hooterville : IN STD_LOGIC;
        Mayberry : IN STD_LOGIC;
        SilerCity : IN STD_LOGIC;
        MtPilot : IN STD_LOGIC;
        Hwy1 : OUT STD_LOGIC;
        Hwy2 : OUT STD_LOGIC;
        Hwy3 : OUT STD_LOGIC;
        Hwy4 : OUT STD_LOGIC;
        Hwy5 : OUT STD_LOGIC;
        Hwy6 : OUT STD_LOGIC
    );
end TripGenies;

architecture Behavioral of TripGenies is
signal highways : STD_LOGIC_VECTOR(5 downto 0);
signal cities : STD_LOGIC_VECTOR(3 downto 0);
begin
    
    
cities <=  Hooterville & Mayberry & MtPilot & SilerCity;
Hwy1 <= highways(5);
Hwy2 <= highways(4);
Hwy3 <= highways(3);
Hwy4 <= highways(2);
Hwy5 <= highways(1);
Hwy6 <= highways(0);

process (cities)

begin
	CASE cities IS
	 -- START fuegen sie hier ihren VHDL Code ein
	 -- Die Ordnung der Staedte ist Hooterville, Mayberry, Mt. Pilot, Siler City
	 -- Die Ordnung der Highways ist 1,2,3,4,5,6

	 -- ENDE  fuegen sie hier ihren VHDL Code ein	
	  WHEN "0011"=> highways <= "000001";
	  WHEN "0101"=> highways <= "101000";
	  WHEN "0110"=> highways <= "110000";
	  WHEN "1001"=> highways <= "001000";
	  WHEN "1010"=> highways <= "010000";
	  WHEN "1100"=> highways <= "100000";
	  WHEN others => highways <= (others=> '0');
	 END CASE;
		
end process;
end Behavioral;
