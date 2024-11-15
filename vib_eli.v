module vib_eli(clk,rst,key_in,out);//按键消抖
  input clk,rst,key_in;
  output reg out;
  reg st_flag;
  reg [19:0]cnt_20m;
  reg flag;//标记位，防止多次操作
  parameter DELAY=20'd999999;
  
  always @(posedge clk or negedge rst)
  begin
     if(!rst) begin
	     cnt_20m <= 20'd0;
		  flag <= 1'b0;
	  end
	  else if(cnt_20m==DELAY) begin
	     cnt_20m <= 20'd0;
		  flag <= 1'b1;
	  end
	  else if(key_in==1'b0) cnt_20m <= cnt_20m+1'b1;
	  else begin
	     cnt_20m <= 20'd0;
		  flag <= 1'b0;
	  end
  end
  
  always @(posedge clk or negedge rst)
  begin
     if(!rst) st_flag <= 1'b0;
	  else if((key_in==1'b0)&&(cnt_20m==DELAY)) st_flag <= 1'b1;
	  else st_flag <= 1'b0;
  end
  
  always @(posedge clk or negedge rst)//按下按键产生一个周期高脉冲信号
  begin
     if(!rst) out<=1'b0;
	  else if((st_flag==1'b0)&&(cnt_20m==DELAY)&&(flag==1'b0)) out<=1'b1;
	  else out<=1'b0;
  end
  endmodule