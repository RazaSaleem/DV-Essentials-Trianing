///////////////////////////////////////////////////////////////////////////

//
// File name   : flipflop_test.sv
// Title       : Flipflop Testbench Module
// Project     : SystemVerilog Training
// Description : Defines the Flipflop testbench module
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

module testflop ();
  timeunit 1ns;
  logic reset;
  logic [7:0] qin,qout;
  // ---- clock generator code begin------
  `define PERIOD 10
  logic clk = 1'b1;
  
  
  always
    #(`PERIOD/2)clk = ~clk;
  
  
  // ---- clock generator code end------
  
  flipflop DUV(.*);
  
  
  
  //<add clocking block>
  
  
  clocking cb @ (posedge clk);
    
    
    default input #1step
    		output #3ns;
    
    
    input qout;
    output qin;
    output reset;
  
  endclocking
  
  
  //<add stimulus to drive clocking block>
  
  initial begin
    @(cb);
    cb.qin <= 0;
    
    cb.reset <= 1'b1;
    ##3 cb.reset <= 0;
    
    //---- Writing for loop ---- //
    
    for(int i =0; i<8; i++) begin
      @(cb);
      cb.qin <= i;
    end
    $finish;
    
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
   
  end
        
endmodule
