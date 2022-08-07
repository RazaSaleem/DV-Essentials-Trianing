///////////////////////////////////////////////////////////////////////////

// File name   : top.sv
// Title       : top module for Memory labs 
// Project     : SystemVerilog Training
// Description : Defines the top module for memory labs
// Notes       :
// Memory Lab - top-level 
// A top-level module which instantiates the memory and mem_test modules
// 
///////////////////////////////////////////////////////////////////////////

module top;
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: logic and bit data types
bit         clk;

  myifa bus(clk);

// SYSTEMVERILOG:: implicit .* port connections
  mem_test test ( .busb(bus));

// SYSTEMVERILOG:: implicit .name port connections
  mem memory (.busa(bus));

always #5 clk = ~clk;
endmodule
