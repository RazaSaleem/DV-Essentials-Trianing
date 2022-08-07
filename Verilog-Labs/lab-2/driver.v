// Code your design here
module driver #(parameter WIDTH=8) (data_en, data_in, data_out);
  input 			  data_en;
  input [WIDTH-1:0]   data_in;
  output [WIDTH-1:0]  data_out;
  reg [WIDTH-1:0]     data_out;
  
  assign data_out = data_en ? data_in : 'bz;
 
endmodule
