// Code your design here
module multiplexor (sel, in0, in1, mux_out);
  parameter WIDTH=5;
  input sel;
  input [WIDTH-1:0] in0, in1;
  output [WIDTH-1:0] mux_out;
  reg [WIDTH-1:0] mux_out;
  
  always @ (in0, in1, sel) begin
    if(sel)
      mux_out = in1;
    else
      mux_out = in0;
      
  end
endmodule
