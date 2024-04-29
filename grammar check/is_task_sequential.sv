// Are commands of task executed sequentially?
// --> Yes. Unlike normal Verilog block, task acts like function of programming language.
//          In other words, it executes its commands one by one.
`timescale 1ns / 100ps

class testc;
  
  reg 
  
  task testt;
    $display("checkpoint 1");
    $display("checkpoint 2");
    $display("checkpoint 3");
    $display("checkpoint 4");
    $display("checkpoint 5");
  endtask;
endclass;

module testm;
  testc realtc;

  initial begin  
    realtc = new();
    realtc.testt();
  end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    # 120
    $finish();
  end 
endmodule
