// Code your design here
// Code your design here
module alu #( parameter WIDTH=8) (in_a, in_b, a_is_zero, opcode, alu_out);
  
  
  input	 [WIDTH-1:0]	in_a;
  input  [WIDTH-1:0]	in_b;
  input	 [	   2:0] 	opcode;
  output reg			a_is_zero;
  output [WIDTH-1:0] 	alu_out;
  reg	 [WIDTH-1:0] 	alu_out;
  
  
  localparam  HLT = 0,
  			  SKZ = 1,
  			  ADD = 2,
  			  AND = 3,
  			  XOR = 4,
  			  LDA = 5,
  			  STO = 6,
  			  JMP = 7;
  
  
  always @ (*) begin
    a_is_zero = (in_a == 0);
    case(opcode)
      HLT :
        alu_out = in_a;
      SKZ :
        alu_out = in_a;
      ADD :
        alu_out = in_a + in_b;
      AND :
        alu_out = in_a & in_b;
      XOR :
        alu_out = in_a ^ in_b;
      LDA :
        alu_out = in_b;
      STO :
        alu_out = in_a;
      JMP :
        alu_out = in_a;
      default :
        alu_out = 0;
    endcase
  end
endmodule
