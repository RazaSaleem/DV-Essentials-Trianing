interface myifa(input bit clk);
  logic read;
  logic write;
  logic [4:0] addr;
  logic [7:0] data_in;
  logic [7:0] data_out;
  
  modport Memory (input clk, read, write, addr, data_in, output data_out);
  
  modport Memory_test (input data_out, clk, output read, write, addr, data_in, import write_mem, read_mem);
  
    
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
    rd_data = data_out;
    
    if (debug)
      $display ("address = %d Data = %d Write=%b Read=%b Clock=%b", addr, data_out, write, read, clk);
    
  endtask : read_mem
  
endinterface : myifa
