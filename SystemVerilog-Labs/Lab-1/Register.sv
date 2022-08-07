// Code your design here
module register (
  output logic  [7:0] out ,
  input  logic  [7:0] data ,
  input				  clk  ,
  input               enable ,
  input               rst_
				
);
  
  
  timeunit 1ns;
  timeprecision 100ps;
  
  always_ff @ (posedge clk, negedge rst_)
    if(!rst_)
      out <= 0;
  else if (enable)
    out <= data;
  else 
    out <= data;
endmodule
