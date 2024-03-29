
///////////////////////////////////////////////////////////////////////////
// File name   : mem.sv
// Title       : Memory Module
// Project     : SystemVerilog Training

// Description : Defines the memory module
// Notes       :
// Synchronous 8x32 Memory Design
// Specification:
//  Memory is 8-bits wide and address range is 0 to 31.
//  Memory access is synchronous.
//  Write data into the memory on posedge of clk when write=1
//  Place memory[addr] onto data bus on posedge of clk when read=1
//  The read and write signals should not be simultaneously high.
// 
///////////////////////////////////////////////////////////////////////////

// Code your design here
module mem (
  		input		clk ,
  		input		read ,
  		input		write ,
        input logic [4:0] addr ,
        input logic [7:0] data_in ,
  		output logic [7:0] data_out 
  
);
  
  // SYSTEMVERILOG: timeunit and timeprecision specification
  timeunit 1ns;
  timeprecision 100ps;
  
  //SYSTEMVERILOG: logic data type
  logic [7:0] memory [0:31] ;
  
  always @ (posedge clk)
    if (write &&  !read)
      
      #1 memory[addr] <= data_in;
  
  always_ff @ (posedge clk iff ((read == '1)&&(write == '0)) )
    data_out <= memory[addr];
  
endmodule
