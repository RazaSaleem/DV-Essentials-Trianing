///////////////////////////////////////////////////////////////////////////

//
// File name   : top.sv
// Title       : top Module for memory
// Project     : SystemVerilog Training

// Description : Defines the top module for memory with interface, clk port,
// modport and methods
// Notes       :
// Memory Lab - top-level
// A top-level module which instantiates the memory and mem_test modules
//
///////////////////////////////////////////////////////////////////////////
`include "mem_intf.sv"


module top;
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: logic and bit data types
logic clk = 0;

always #5 clk = ~clk;

// SYSTEMVERILOG: interface instance
mem_intf mbus (clk);

mem_test mtest (.mbus(mbus.tb));

mem m1  (.mbus(mbus.mem));

endmodule
