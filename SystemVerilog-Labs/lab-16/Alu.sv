// Code your design here
`include "typedefs.sv"
import typedefs::*;
module alu (
  output logic [7:0]  out	,
  output logic		  zero	,
  input	 logic		  clk	,
  input	 logic [7:0]  accum ,
  input  logic [7:0]  data	,
  input  opcode_t  opcode
);
  
  timeunit 1ns;
  timeprecision 100ps;
  
  
  always @ (negedge clk)
    unique case ( opcode )
      ADD : out <= accum + data;
      AND : out <= accum & data;
      XOR : out <= accum ^ data;
      LDA : out <=		   data;
      HLT,
      SKZ,
      JMP,
      STO : out <= accum;
    endcase
  
  always_comb
    zero = ~(|accum);
  
endmodule
