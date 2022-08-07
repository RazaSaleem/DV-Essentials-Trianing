///////////////////////////////////////////////////////////////////////////
//
// File name   : mem_test.sv
// Title       : Memory Testbench Module
// Project     : SystemVerilog Training
// Description : Defines the Memory testbench module
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

// Code your testbench here
// or browse Examples

`include "top.sv"
module mem_test ( input logic  clk,
                  output logic read,
                  output logic write,
                  output logic [4:0] addr,
                  output logic [7:0] data_in,   // data TO memory
                 input wire [7:0] data_out      // data FROM memory 
                );
  
  //SYSTEMVERILOG: timeunit and timeprecision specification
  timeunit 1ns;
  timeprecision 1ns;
  
  // SYSTEMVERILOG: new data types -bit, logic
  
  bit		   debug = 1;
  logic [7:0]  rdata;		//stores data read from memory for checking
  
  
  //Monitor Results
  initial begin
    $timeformat (-9, 0, " ns", 9 );
    
    #40000ns
    $display ( "MEMORY TEST TIMEOUT" );
    $finish;
  end
  
  initial
    begin : memtest
      int error_status;
      error_status = 0;
      $display("Clear Memory Test" );
      
      for(int i = 0; i < 32; i++)
        //Write zero data to every address location
        write_mem(i,0, 1);
       
        for (int i = 0; i < 32; i++)
          begin
            // Read every address location
            read_mem(i, rdata, 1);
                        
            // check each memory location  for data = 'h00
            if (data_out !== 8'h00) error_status++;
            

            
          end
      
      // print results of test
      print_status(error_status);
      error_status=0;
      $display( "Data = Address Test" );
      
      for (int i = 0; i < 32; i++)
        // Write data  = address to every address location
        write_mem(i,i,1);
      
        for (int i = 0; i < 32; i++)
          begin
            // Read every address location
            read_mem(i, rdata,1);
            
            // check each memory location for data = address
            if (data_out !== i) error_status++;
          end
      
      // print results of test
      print_status(error_status);
      $finish;
      
    end
  
  // add read_mem and write_mem tasks
  task write_mem (
    input logic [4:0] wr_addr, 
    input logic [7:0] wr_data,
  	input int debug = 0);
    @ (negedge clk);
    read =0;
    write = 1;
    data_in = wr_data;
    addr = wr_addr;
    @ (posedge clk);
    if (debug)
      $display ("address = %d Data = %d Write=%b Read=%b Clock=%b", addr, data_in, write, read, clk);
  endtask : write_mem
  
  
  task read_mem(
    input logic [4:0] rd_addr,
    output logic [7:0] rd_data,
  	input int debug = 0);
    @(negedge clk);
    read = 1;
    write = 0;
    addr = rd_addr;
    @ (posedge clk);
    #1ns;
    rdata = data_out;
    
    if (debug)
      $display ("address = %d Data = %d Write=%b Read=%b Clock=%b", addr, data_out, write, read, clk);
    
  endtask : read_mem
  
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #100;
  end
  
  // add result print function
  function void print_status (int error_count);
  if (error_count)
    $display( "Test FAILED WITH %d error", error_count);
  else
    $display ("MEMORY TEST PASSED");
  endfunction
endmodule
 
