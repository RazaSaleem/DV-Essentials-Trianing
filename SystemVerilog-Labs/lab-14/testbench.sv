// Code your testbench here
// or browse Examples

///////////////////////////////////////////////////////////////////////////

//
// File name   : mem_test.sv
// Title       : Memory Testbench Module
// Project     : SystemVerilog Training

// Description : Defines the Memory interface testbench module with 
// clk port, modport and methods
// Notes       :
// Memory Specification: 8x32 memory
//   Memory is 8-bits wide and address range is 0 to 31.
//   Memory access is synchronous.
//   The Memory is written on the positive edge of clk when "write" is high.
//   Memory data is driven onto the "data" bus when "read" is high.
//   The "read" and "write" signals should not be simultaneously high.
//
///////////////////////////////////////////////////////////////////////////
`include "top.sv"
module mem_test ( 
                  mem_intf.tb mbus
                );
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: new data types - bit ,logic
  logic [7:0] rn_data; // stores data to write tto memory
bit         debug = 1;
logic [7:0] rdata;      // stores data read from memory for checking


  
  
  
  bit	done;
 
  
  class class_mem;
    randc bit [4:0] addr_rn;
    rand bit [7:0] data_rn;
    bit [7:0] rdata;
    
    
    //virtual interface
    virtual mem_intf mem_vif;
    
    
    function new (input bit [4:0] a, bit [7:0] b);
      addr_rn = a;
      data_rn = b;
    endfunction
    
    

    constraint c3 {data_rn dist {['h41: 'h5a]:=80, ['h61: 'h7a]:=20};}
    
    function void configure(virtual mem_intf vif);
      mem_vif = vif;
      if(mem_vif == null) $display("mem_vif configure error");
    endfunction
      
        
          // SYSTEMVERILOG: default task input argument values
  task write_mem (input debug = 0);
      @(negedge mem_vif.clk);
      mem_vif.write <= 1;
      mem_vif.read  <= 0;
      mem_vif.addr  <= addr_rn;
      mem_vif.data_in  <= data_rn;
      @(negedge mem_vif.clk);
      mem_vif.write <= 0;
      if (debug == 1)
        $display("Write - Address:%d  Data:%h", addr_rn, data_rn);
    endtask
  
  // SYSTEMVERILOG: default task input argument values
  task read_mem (input debug = 0);
     @(negedge mem_vif.clk);
     mem_vif.write <= 0;
     mem_vif.read  <= 1;
     mem_vif.addr  <= addr_rn;
     @(negedge mem_vif.clk);
     mem_vif.read <= 0;
     rdata = mem_vif.data_out;
     if (debug == 1) 
       $display("Read  - Address:%d  Data:%c", addr_rn, rdata);
  endtask
        
        
    
  endclass : class_mem
      
      
      // Monitor Results
  initial begin
      $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
      #40000ns $display ( "MEMORY TEST TIMEOUT" );
      $finish;
    end
  
      
   //declare class_mem class   
  class_mem memrnd;

initial
  begin: memtest
  int error_status;
    
    // "clearing the memory" and "data = address" tests removed
   
    memrnd = new (0, 0);
    memrnd.configure(mbus);

    $display("Random Data Test");

    for (int i = 0; i< 32; i++)
      begin
        done = memrnd.randomize();
        memrnd.write_mem(1);
        memrnd.read_mem(1);
        error_status = checkfn (memrnd.addr_rn, memrnd.rdata, memrnd.data_rn);
      end
    
    // SYSTEMVERILOG: void function
    printstatus(error_status);
    $finish;
  end
      
      function int checkfn (input [4:0] address,
                      input [7:0] actual, expected);
  static int error_status;   // static variable
  if (actual !== expected) begin
    $display("ERROR:  Address:%h  Data:%h  Expected:%h",
                address, actual, expected);
// SYSTEMVERILOG: post-increment
     error_status++;
   end
// SYSTEMVERILOG: function return
   return (error_status);
endfunction: checkfn
   



// SYSTEMVERILOG: void function
function void printstatus(input int status);
if (status == 0)
   $display("Test Passed - No Errors!");
else
   $display("Test Failed with %d Errors", status);
endfunction

endmodule
