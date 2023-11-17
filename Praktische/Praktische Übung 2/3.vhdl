--Definition of the required components

Library IEEE;
use IEEE.std_logic_1164.all;

entity Mux2_1 is
port
(
in0,in1 : in STD_LOGIC;
s0 : in STD_LOGIC;
out0 : out STD_LOGIC
);
end Mux2_1;

architecture behavior of Mux2_1 is 
use IEEE.NUMERIC_STD.ALL;
signal inport : STD_LOGIC_VECTOR(1 downto 0);
signal selector : STD_LOGIC_VECTOR(0 downto 0);
begin
inport(0) <= in0;
inport(1) <= in1;
selector(0) <= s0;
MUX_process : process (selector, inport) 
variable selector_int : integer;
begin
    selector_int := to_integer(unsigned(selector));
    if selector_int < 2 then 
        out0 <= inport(selector_int);
-- pragma  synthesis_off 
    else
        out0 <= 'U';
-- pragma  synthesis_on 
    end if;
end process;
end behavior;

Library IEEE;
use IEEE.std_logic_1164.all;

entity D_CL_Reset_FF is
port
(
D,Clock,Reset : in STD_LOGIC;
Q : out STD_LOGIC := '0';
Q_inv : out STD_LOGIC := '1'
);
end D_CL_Reset_FF;

architecture behavior of D_CL_Reset_FF is 
  signal Q_intern : STD_LOGIC := '0';
begin
  D_FF_process : process(D, Clock, Q_intern, Reset)
  begin
    if Clock = '1' then
      Q_intern <= D;
    end if;
    if Reset = '1' then  -- Set
      Q_intern <= '0';
    end if;
  end process;
  Q     <=     Q_intern;
  Q_inv <= not Q_intern;
end behavior;

-- Circuit entity

Library IEEE;
use IEEE.std_logic_1164.all;

entity circuit_3 is
  port
  (
   sig_in_0,  sig_in_1,  sig_in_2,  sig_in_3 : in STD_LOGIC;
  sig_out_0 : out STD_LOGIC;
  sig_out_1 : out STD_LOGIC;
  sig_out_2 : out STD_LOGIC;
  sig_out_3 : out STD_LOGIC
  );
end circuit_3;

-- Structural description of the circuit

architecture structure of circuit_3 is

component Mux2_1
port
(
in0,in1 : in STD_LOGIC;
s0 : in STD_LOGIC;
out0 : out STD_LOGIC
);
end component;

component D_CL_Reset_FF
port
(
D,Clock,Reset : in STD_LOGIC;
Q : out STD_LOGIC := '0';
Q_inv : out STD_LOGIC := '1'
);
end component;

constant ConstLow : STD_LOGIC := '0';
constant ConstHigh : STD_LOGIC := '1';
signal MultiplexerGate0_out0 , MultiplexerGate0_out0_inverted , DFlipFlop0_out0 , DFlipFlop0_out0_inverted , DFlipFlop0_out1 , DFlipFlop0_out1_inverted , DFlipFlop1_out0 , DFlipFlop1_out0_inverted , DFlipFlop1_out1 , DFlipFlop1_out1_inverted , DFlipFlop2_out0 , DFlipFlop2_out0_inverted , DFlipFlop2_out1 , DFlipFlop2_out1_inverted , DFlipFlop3_out0 , DFlipFlop3_out0_inverted , DFlipFlop3_out1 , DFlipFlop3_out1_inverted : STD_LOGIC;
signal sig_in_0_inverted, sig_in_1_inverted, sig_in_2_inverted, sig_in_3_inverted : STD_LOGIC;

begin
MultiplexerGate0 : Mux2_1
 port map (
  in0 => DFlipFlop3_out0,
  in1 =>  sig_in_1,
  s0 =>  sig_in_0,
  out0 => MultiplexerGate0_out0);

DFlipFlop0 : D_CL_Reset_FF
 port map (
  D => MultiplexerGate0_out0,
  Clock =>  sig_in_2,
  Reset =>  sig_in_3,
  Q => DFlipFlop0_out0,
  Q_inv => DFlipFlop0_out1);

DFlipFlop1 : D_CL_Reset_FF
 port map (
  D => DFlipFlop0_out0,
  Clock =>  sig_in_2,
  Reset =>  sig_in_3,
  Q => DFlipFlop1_out0,
  Q_inv => DFlipFlop1_out1);

DFlipFlop2 : D_CL_Reset_FF
 port map (
  D => DFlipFlop1_out0,
  Clock =>  sig_in_2,
  Reset =>  sig_in_3,
  Q => DFlipFlop2_out0,
  Q_inv => DFlipFlop2_out1);

DFlipFlop3 : D_CL_Reset_FF
 port map (
  D => DFlipFlop2_out0,
  Clock =>  sig_in_2,
  Reset =>  sig_in_3,
  Q => DFlipFlop3_out0,
  Q_inv => DFlipFlop3_out1);

--Signal mapping
sig_out_0 <= DFlipFlop0_out0;
sig_out_1 <= DFlipFlop1_out0;
sig_out_2 <= DFlipFlop2_out0;
sig_out_3 <= DFlipFlop3_out0;
end structure;
