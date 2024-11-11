`timescale 1ns/1ps
module Autoseller(clk,rst,start,cancel,Key_in,hold_ind,charge_ind,drinktk_ind,charge_val,coin_val,take,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7);
  input clk, rst, take;//时钟，复位 拨动开关1，取饮料 按钮开关0
  input start, cancel;//开始 拨动开关0，取消操作 按钮开关1
  input [1:0] Key_in;//按钮23标志
  output hold_ind, charge_ind, drinktk_ind;//占用绿LED0，找钱标志 绿LED1，取饮料标志 绿LED2
  output [2:0] charge_val;//找零标记，红LED012
  output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;//数码管：01 现有金额，23 取消后找回金额，45 取饮料后剩余金额和互动，67 Hi打招呼
  output [1:0] coin_val;//按钮23，投入0.5/1
  reg hold_ind, charge_ind, drinktk_ind;
  reg [2:0] charge_val;
  reg [3:0] currentstate, nextstate;
  reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  reg cnt_en, next_en;
  wire [1:0] coin_val;
  wire [6:0] HEX6, HEX7;
  //状态分配
  parameter S0=4'b0000; parameter S1=4'b0001; 
  parameter S2=4'b0010; parameter S3=4'b0011; 
  parameter S4=4'b0100; parameter S5=4'b0101;
  parameter S6=4'b0110; parameter S7=4'b0111;
  parameter S8=4'b1000;
  //七段数码管
  parameter Non  = 7'b111_1111;
  parameter Hih  = 7'b000_1001;
  parameter Hii  = 7'b100_1111;
  parameter Zero = 7'b100_0000;
  parameter One  = 7'b111_1001;
  parameter Two  = 7'b010_0100;
  parameter Three= 7'b011_0000;
  parameter Five = 7'b001_0010;
  parameter Six  = 7'b000_0010;
  //按键消抖;
  vib_eli u1(.clk(clk),.rst(rst),.key_in(Key_in[0]),.out(coin_val[0]));
  vib_eli u2(.clk(clk),.rst(rst),.key_in(Key_in[1]),.out(coin_val[1]));
//  always @(posedge clk or negedge rst)
//   begin 
//	  if(!rst) delay_50m<=21'd0;
//	  else if(delay_en)
//		 begin 
//		  if(delay_50m!=21'd2499999)
//		    delay_50m<=delay_50m+21'd1;
//		  else delay_50m<=21'd0;
//		 end
//	  else delay_50m<=21'd0;
//	end
//	
//  always @(posedge clk or negedge rst)
//    begin
//	   if(!rst)
//		  begin
//		   coin_val<=2'b00;
//			delay_en<=1'b0;
//		  end
//		else if(Key_in!=2'b11)
//		  begin
//		   coin_temp1<=Key_in;
//			delay_en<=1'b1;
//		   if(delay_50m==21'd2499999)
//			  begin
//			   coin_temp2<=Key_in;
//				if(coin_temp2==coin_temp1)
//				  begin
//				   coin_val[0]<=~coin_temp2[0];
//					coin_val[1]<=~coin_temp2[1];
//				  end
//				else coin_val<=2'b00;
//			  end
//			else coin_val<=2'b00;
//		  end
//		else coin_val<=2'b00;
//	 end
//
//      assign  coin_val[0]=~Key_in[0];
//	     assign  coin_val[1]=~Key_in[1];	 
   assign HEX7=Hih;
	assign HEX6=Hii;
	
  always @(posedge clk or negedge rst)//状态转移
   if(!rst) nextstate<=S0;
   else case (currentstate)
         S0: if(start)
			     begin
			      if(!cancel) nextstate<=S0;
               else if(coin_val==2'b01) nextstate<=S1;
               else if(coin_val==2'b10) nextstate<=S2;
				  end
				 else nextstate=S0;
	      S1: if(!cancel) nextstate<=S0;
             else if(coin_val==2'b01) nextstate<=S2;
             else if(coin_val==2'b10) nextstate<=S3; 
         S2: if(!cancel) nextstate<=S0; 
             else if(coin_val==2'b01) nextstate<=S3;
             else if(coin_val==2'b10) nextstate<=S4; 
         S3: if(!cancel) nextstate<=S0; 
             else if(coin_val==2'b01) nextstate<=S4;
             else if(coin_val==2'b10) nextstate<=S5;
         S4: if(!cancel) nextstate<=S0; 
             else if(coin_val==2'b01) nextstate<=S5;
             else if(coin_val==2'b10) nextstate<=S6; 
         S5: if(!cancel) nextstate<=S0; 
             else if(take==1'd0) nextstate<=S7;
             else  nextstate<=S5; 
         S6: if(!cancel) nextstate<=S0; 
             else if(take==1'd0) nextstate<=S8;
             else  nextstate<=S6; 
			S7: if(start)
			     begin
			      if(!cancel) nextstate<=S0;
               else if(coin_val==2'b01) nextstate<=S1;
               else if(coin_val==2'b10) nextstate<=S2;
				  end
				 else nextstate=S7;
			S8: if(!cancel) nextstate<=S0;
             else if(coin_val==2'b01) nextstate<=S2;
             else if(coin_val==2'b10) nextstate<=S3;
         default:  nextstate<=S0; 
        endcase
  always @(posedge clk or negedge rst)
    if (!rst) 
      currentstate <= S0; 
	 else if (!cancel)
	   currentstate <= S0;
    else 
      currentstate <= nextstate;
		
//  always @(currentstate or rst or start or cancel or coin_val)
//   if(!rst) nextstate=S0;
//   else case (currentstate)
//         S0: if(start)
//			     begin
//			      if(!cancel) nextstate=S0;
//               else if(coin_val==2'b01) nextstate=S1;
//               else if(coin_val==2'b10) nextstate=S2;
//				  end
//	      S1: if(!cancel) nextstate=S0;
//             else if(coin_val==2'b01) nextstate=S2;
//             else if(coin_val==2'b10) nextstate=S3; 
//         S2: if(!cancel) nextstate=S0; 
//             else if(coin_val==2'b01) nextstate=S3;
//             else if(coin_val==2'b10) nextstate=S4; 
//         S3: if(!cancel) nextstate=S0; 
//             else if(coin_val==2'b01) nextstate=S4;
//             else if(coin_val==2'b10) nextstate=S5;
//         S4: if(!cancel) nextstate=S0; 
//             else if(coin_val==2'b01) nextstate=S5;
//             else if(coin_val==2'b10) nextstate=S6; 
//         S5:  nextstate=S0; 
//         S6:  nextstate=S0; 
//         default: nextstate=S0; 
//        endcase
		  
  always @ (currentstate)
   if ((currentstate == S0)||(currentstate == S7)) hold_ind = 1'b0; 
   else hold_ind = 1'b1; 
  always @ (currentstate)
   if ((currentstate == S5 )||(currentstate == S6)) 
   drinktk_ind = 1'b1; 
   else drinktk_ind = 1'b0; 
  always @ (currentstate)
   if ((currentstate == S0)||(currentstate == S7)) charge_ind= 1'b0; 
   else charge_ind= 1'b1;
  always @ (posedge clk) 
    begin
     case (currentstate)
	   S0: charge_val<= 3'b000;
      S1: charge_val<= 3'b001;
      S2: charge_val<= 3'b010;
      S3: charge_val<= 3'b011;
      S4: charge_val<= 3'b100;
		S5: charge_val<= 3'b101;
		S6: charge_val<= 3'b110;
		S7: charge_val<= 3'b000;
      S8: charge_val<= 3'b001;
      default: charge_val<= 3'b000;
     endcase
    end 
	
  always @(posedge clk or negedge rst)//显示模块
	 if (!rst)
	  begin
	     HEX5 <= Non;
	     HEX4 <= Non;
	     HEX3 <= Zero;
	     HEX2 <= Zero;
		  HEX1 <= Zero;
	     HEX0 <= Zero;
	  end
	 else if (!cancel)
	  begin
	     HEX5 <= Non;
	     HEX4 <= Non;
	     HEX3 <= Zero;
	     HEX2 <= Zero;
		  HEX1 <= Zero;
	     HEX0 <= Zero;
	  end
	 else if (currentstate == S0)
	  begin
	     HEX5 <= Non;
	     HEX4 <= Non;
	     HEX3 <= Zero;
	     HEX2 <= Zero;
		  HEX1 <= Zero;
	     HEX0 <= Zero;
	  end
	 else if (currentstate == S1)
	  begin
	     HEX5 <= Non;
	     HEX4 <= Non;
	     HEX3 <= Zero;
	     HEX2 <= Five;
		  HEX1 <= Zero;
	     HEX0 <= Five;
	  end
	 else if (currentstate == S2)
	  begin
	     HEX5 <= Non;
	     HEX4 <= Non;
	     HEX3 <= One;
	     HEX2 <= Zero;
		  HEX1 <= One;
	     HEX0 <= Zero;
	  end
	 else if (currentstate == S3)
	  begin
	     HEX5 <= Non;
	     HEX4 <= Non;
	     HEX3 <= One;
	     HEX2 <= Five;
		  HEX1 <= One;
	     HEX0 <= Five;
	  end
	 else if (currentstate == S4)
	  begin
	     HEX5 <= Non;
	     HEX4 <= Non;
	     HEX3 <= Two;
	     HEX2 <= Zero;
		  HEX1 <= Two;
	     HEX0 <= Zero;
	  end
	 else if (currentstate == S5)
	  begin
	     HEX5 <= Zero;
	     HEX4 <= Zero;
	     HEX3 <= Two;
	     HEX2 <= Five;
		  HEX1 <= Two;
	     HEX0 <= Five;
	  end
	 else if (currentstate == S6)
	  begin
	     HEX5 <= Zero;
	     HEX4 <= Five;
	     HEX3 <= Three;
	     HEX2 <= Zero;
		  HEX1 <= Three;
	     HEX0 <= Zero;
	  end
	 else if (currentstate == S7)
	  begin
	     HEX5 <= Six;
	     HEX4 <= Six;
	     HEX3 <= Zero;
	     HEX2 <= Zero;
		  HEX1 <= Zero;
	     HEX0 <= Zero;
	  end
	 else if (currentstate == S8)
	  begin
	     HEX5 <= Six;
	     HEX4 <= Six;
	     HEX3 <= Zero;
	     HEX2 <= Five;
		  HEX1 <= Zero;
	     HEX0 <= Five;
	  end
	 else 
	  begin
	     HEX5 <= Non;
	     HEX4 <= Non;
	     HEX3 <= Zero;
	     HEX2 <= Zero;
		  HEX1 <= Zero;
	     HEX0 <= Zero;
		 end

endmodule