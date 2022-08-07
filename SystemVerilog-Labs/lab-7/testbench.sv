// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
///////////////////////////////////////////////////////////////////////////

//
// File name   : mem_test.sv
// Title       : Memory Testbench Module
// Project     : SystemVerilog Training
// Description : Defines the Memory testbench module
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////
`include "top.sv"
`include "ifa.sv"
module mem_test (
                  myifa.Memory_test busb
                 
                );
  
  //SYSTEMVERILOG: timeunit and timeprecision specification
  timeunit 1ns;
  timeprecision 1ns;
  
  // SYSTEMVERILOG: new data types -bit, logic
  
  bit		   debug = 1;
  logic [7:0]  rdata ;		//stores data read from memory for checking
  
  
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
        busb.write_mem(i,0, 1);
       
        for (int i = 0; i < 32; i++)
          begin
            // Read every address location
            busb.read_mem(i, rdata, 1);
                        
            // check each memory location  for data = 'h00
            if (busb.data_out !== 8'h00) error_status++;

            
          end
      
      // print results of test
      print_status(error_status);
      error_status=0;
      $display( "Data = Address Test" );
      
      for (int i = 0; i < 32; i++)
        // Write data  = address to every address location
        busb.write_mem(i,i,1);
      
        for (int i = 0; i < 32; i++)
          begin
            // Read every address location
            busb.read_mem(i, rdata,1);
            
            // check each memory location for data = address
            if (busb.data_out !== i) error_status++;
          end
      
      // print results of test
      print_status(error_status);
      $finish;
      
    end

  
  // add result print function
  function void print_status (int error_count);
  if (error_count)
    $display( "Test FAILED WITH %d error", error_count);
  else
    $display ("MEMORY TEST PASSED");
  endfunction
endmodule
