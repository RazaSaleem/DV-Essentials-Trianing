///////////////////////////////////////////////////////////////////////////

// File name   : mem_test.sv
// Title       : Memory Testbench Module
// Project     : SystemVerilog Training
// Description : Defines the Memory interface testbench module  with class randomization
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

logic [7:0] rand_data; // stores data to write to memory
logic [7:0] rdata;      // stores data read from memory for checking

bit ok; // stores return value from randomize

  typedef enum bit[1:0] {AC, UCP, LCP, UCLC} CON_t;

class mem_class;
  rand  bit [7:0] data_rn;
  randc bit [4:0] addr_rn;

  CON_t cntrl;

  constraint DATAdist { cntrl == AC 	-> data_rn inside {[8'h20:8'h7F]};
                        cntrl == UCP    -> data_rn inside {[8'h41:8'h5A]};
                        cntrl == LCP    -> data_rn inside {[8'h61:8'h7A]};
                        cntrl == UCLC   -> data_rn dist {[8'h41:8'h5a]:=4, [8'h61:8'h7a]:=1};}

  function new (input bit a = 0, b = 0);
  data_rn = a;
  addr_rn = b;
 endfunction

endclass

mem_class memrnd;

// Covergroup declaration

covergroup Cg1;
  caddr_rn:  coverpoint mbus.addr_rn;
  cdatin: coverpoint mbus.data_in{
          bins LCP = {[8'h41:8'h5a]};
          bins UCP = {[8'h61:8'h7a]};
          bins restof = default;
          }
  cdatout:coverpoint mbus.data_out{
          bins LCP = {[8'h41:8'h5a]};
          bins UCP = {[8'h61:8'h7a]};
          bins restof = default;
          }
endgroup : Cg1

// covergroup instance
  Cg1 coverrand = new();


// Monitor Results
  initial begin
      $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
      #40000ns $display ( "MEMORY TEST TIMEOUT" );
      $finish;
    end

initial
  begin: memtest
  int error_status;
  //coverrand.stop();
    $display("Clear Memory Test");
// SYSTEMVERILOG: enhanced for loop
    for (int i = 0; i< 32; i++)
       mbus.write_mem (i, 0, 0);
    for (int i = 0; i<32; i++)
      begin 
       mbus.read_mem (i, rdata, 0);
       // check each memory location for data = 'h00
       error_status = checkit (i, rdata, 8'h00);
      end
// SYSTEMVERILOG: void function
    printstatus(error_status);

    $display("Data = Address Test");
// SYSTEMVERILOG: enhanced for loop
    for (int i = 0; i< 32; i++)
       mbus.write_mem (i, i,0);
    for (int i = 0; i<32; i++)
      begin
       mbus.read_mem (i, rdata,0);
       // check each memory location for data = address
       error_status = checkit (i, rdata, i);
      end
// SYSTEMVERILOG: void function
    printstatus(error_status);

    memrnd = new(0,0);

    //coverrand.start();
    $display("Random Data Test - Upper/Lower case distribution");
    memrnd.cntrl = UCLC;
    for (int i = 0; i< 32; i++)
    begin
      ok = memrnd.randomize();
      mbus.write_mem (memrnd.addr_rn, memrnd.data_rn, 1);
      mbus.read_mem  (memrnd.addr_rn, rdata, 1);
      error_status = checkit (memrnd.addr_rn, rdata, memrnd.data_rn);
       coverrand.sample();
    end
    printstatus(error_status);

    $finish;
  end

function int checkit (input [4:0] address,
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
endfunction: checkit

// SYSTEMVERILOG: void function
function void printstatus(input int status);
if (status == 0)
   $display("Test Passed - No Errors!");
else
   $display("Test Failed with %d Errors", status);
endfunction

endmodule
