//If always uses two argument divided by comma, 
//does it mean block will be executed when one of arguments is satisfied?
// --> YES. comma(,) is same with "or"
`timescale 1ns / 100ps

module test;
  reg clk;
  reg nclk;
  reg[4:0] count;

  initial begin
    count = 0;
    clk = 0;
    nclk = 1;
  end

  always@(*) begin
     #5 clk <= ~clk;
     #5 nclk <= ~nclk;
  end

  always@ (posedge clk, negedge nclk) 
    begin
    if(count < 10) begin 
      count <= count + 1; 
    end  
  end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    # 120
    $finish();
  end 
endmodule
