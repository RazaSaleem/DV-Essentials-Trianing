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
bit         debug = 1;
logic [7:0] rdata;      // stores data read from memory for checking

// Monitor Results
  initial begin
      $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
      #40000ns $display ( "MEMORY TEST TIMEOUT" );
      $finish;
    end
  
  
  logic [7:0] mem_t [0:31];
  bit	done;
  bit	m;
  
  class randomclass;
    randc bit [4:0] addr_rn;
    rand bit [7:0] data_rn;
    
    function new (input bit [4:0] a, bit [7:0] b);
      addr_rn = a;
      data_rn = b;
    endfunction
    
    
    constraint c1 {addr_rn >= 0; addr_rn <=31;}
    constraint c2 {data_rn >= 8'h21; data_rn <= 8'h7E;}
    constraint c3 {data_rn dist {['h41: 'h5a]:=80, ['h61: 'h7a]:=20};}
    
  endclass : randomclass
  
  randomclass RNC;

initial
  begin: memtest
  int error_status;
    error_status = 0;
    RNC = new (0, 0);

    $display("Clear Memory Test");
// writing zero to every address location
    for (int i = 0; i< 32; i++)
      begin
        mbus.write_mem (i, '0);
        mem_t[i] = 'h00;
      end
    
    for (int i = 0; i<32; i++)
      begin 
        //Reading the every address location
        mbus.read_mem (i, rdata);
        
       // check each memory location for data = 'h00
        if(rdata !== 'h00) error_status++;
        //error_status = checkit (i, rdata, 8'h00);
      end
    
// SYSTEMVERILOG: void function
    printstatus(error_status);

    $display("Data = Address Test");
    
// SYSTEMVERILOG: enhanced for loop
    for (int i = 0; i< 32; i++)
      begin
        done = RNC.randomize();
        
        if(done)
          begin
            mbus.write_mem (RNC.addr_rn, RNC.data_rn);
            mem_t [RNC.addr_rn] = RNC.data_rn;
            $display("1 = %d, done =%d", i, done);
          end
      end
    
    for (int i = 0; i<32; i++)
      begin
        //Read every address location
       mbus.read_mem (i, rdata);
       // check each memory location for data = address
        if(rdata !== mem_t[i]) error_status++;
        $display("mem_t = %c rdata = %c", mem_t[i], rdata);
   
      end
// SYSTEMVERILOG: void function
    printstatus(error_status);

    $finish;
  end




// SYSTEMVERILOG: void function
function void printstatus(input int status);
if (status == 0)
   $display("Test Passed - No Errors!");
else
   $display("Test Failed with %d Errors", status);
endfunction

endmodule
