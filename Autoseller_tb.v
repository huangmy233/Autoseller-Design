`timescale 1ns/1ps
module Autoseller_tb;
  reg rst, clk; 
  reg start;
  reg cancel;
  reg [1:0] Key_in; 
  wire [1:0] coin_val; 
  wire hold_ind; 
  wire charge_ind; 
  wire drinktk_ind;
  wire [6:0] HEX0,HEX1;
  wire [2:0] charge_val;
  initial clk=0;
  always #500 clk=~clk;
  initial
  begin
  rst=1;
  start=0; cancel=1;
  Key_in=2'b11;
  #20 rst=0;
  #25 rst=1;
  #50 start=1;
  #1000 Key_in=2'b01;
  #1000 Key_in=2'b11;
  #1000 Key_in=2'b01;
  #1000 Key_in=2'b11;
  #1000 Key_in=2'b01;
  #1000 Key_in=2'b11;
  #1000 cancel=0;
  #1000 cancel=1; Key_in=2'b10;
  #1000 Key_in=2'b11;
  #1000 Key_in=2'b01;
  #1000 Key_in=2'b11;
  #1000 Key_in=2'b01;
  #1000 Key_in=2'b11;
  #1000 cancel=0;
  #1000 cancel=1; Key_in=2'b10;
  #1000 Key_in=2'b11;
  #1000 Key_in=2'b01;
  #1000 Key_in=2'b11;
  #1000 cancel=0; start=0;
  #1000 cancel=1;
  #1000 start=1;  Key_in=2'b10;
  #1000 Key_in=2'b11;
  #1000 Key_in=2'b10;
  #1000 Key_in=2'b11;
  #1000 Key_in=2'b10;
  #1000 Key_in=2'b11;
  #1000 Key_in=2'b10;
  #1000 Key_in=2'b11;
  #1000 Key_in=2'b01;
  #1000 Key_in=2'b11;
  #1000 start=0;
  #1000 $stop;
  end 
 Autoseller u0 (clk,rst,start,cancel,Key_in,hold_ind,charge_ind,drinktk_ind,charge_val,coin_val,HEX0,HEX1);
endmodule
