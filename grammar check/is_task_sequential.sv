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
