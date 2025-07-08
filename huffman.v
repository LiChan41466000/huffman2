module huffman(clk, reset,gray_data , gray_valid, CNT_valid, CNT1, CNT2, CNT3, CNT4, CNT5, CNT6,
    code_valid, HC1, HC2, HC3, HC4, HC5, HC6,M1, M2, M3, M4, M5, M6 );

input clk;
input reset;
input gray_valid;
input [7:0] gray_data;
output reg CNT_valid;	
output  reg [7:0] CNT1, CNT2, CNT3, CNT4, CNT5, CNT6;
output reg code_valid;
output reg [7:0] HC1, HC2, HC3, HC4, HC5, HC6;
output reg [7:0] M1, M2, M3, M4, M5, M6;
//============================================
parameter idle       	 = 5'd0;   // idle
parameter rec        	 = 5'd1;   //reset 
parameter CNT_OUT    	 = 5'd2;   //send cnt to output
parameter ini_sort_1_1 	 = 5'd3;   //
parameter ini_sort_1_2 	 = 5'd4;   //
parameter ini_sort_2_1_1 = 5'd5;   //
parameter ini_sort_2_1_2 = 5'd6;   //
parameter ini_sort_2_2_1 = 5'd7;   //
parameter ini_sort_2_2_2 = 5'd8;   //
parameter ini_sort_3_1   = 5'd9;   //
parameter ini_sort_3_2   = 5'd10;   //
parameter ini_sort_3_3   = 5'd11;   //
parameter ini_sort_3_4   = 5'd12;   //
parameter ini_sort_3_5   = 5'd13;   //
parameter insert_1       = 5'd14;   //
parameter insert_2       = 5'd15;   //
parameter insert_3       = 5'd16;   //
parameter insert_4       = 5'd17;   //
parameter split          = 5'd18;   //
parameter done           = 5'd;  // 


//============================================
reg [4:0] cs,ns;
reg encoding_done,receive_done;
reg [6:0] A1,A2,A3,A4,A5,A6 [6:0];
reg [6:0] rec_count;
// =========================================== INDEX ==========================================
	//  - FSM done
	//  - CNT_valid
	//  - CNT1~6
//============================================
// FSM  done
always @ (*) begin
	case(cs)
		idle :
			if (gray_valid)
				ns = rec;
			else
				ns = idle;
		rec : //receive gray data
			if(!gray_valid) begin
				ns = CNT_OUT;
			end
			else begin
				ns = rec;
			end
			
		CNT_OUT :
			ns = encoding;
		ini_sort_1_1 :
			ns = ini_sort_1_2;
		ini_sort_1_2 :
			ns = ini_sort_2_1_1;
		ini_sort_2_1_2 :
			ns = ini_sort_2_2_1;
		ini_sort_2_2_1 :
			ns = ini_sort_2_2_2;
		ini_sort_2_2_2 :
			ns = ini_sort_3_1;
		ini_sort_3_1 :
			ns = ini_sort_3_2;
		ini_sort_3_2 :
			ns = ini_sort_3_3;
		ini_sort_3_3 :
			ns = ini_sort_3_4;
		ini_sort_3_4 :
			if(ini_sort_3_finish) begin 
				ns = insert_1;
			end 
			else
				ns = ini_sort_3_5
		ini_sort_3_5 :
			ns = insert_1;

		insert_1 :
			if(insert_1_finish) begin
				ns = insert_2;
			end
			else begin
				ns = insert_1;
			end

		insert_2 :
			if(insert_2_finish) begin
				ns = insert_3;
			end
			else begin
				ns = insert_2;
			end

		insert_3 :
			if(insert_3_finish) begin
				ns = insert_4;
			end
			else begin
				ns = insert_3;
			end

		insert_4 :
			ns = split;
		split:

		done :
			ns = done;
			
		
		default : begin
			ns = idle;
		end
	endcase
end

always @ (posedge clk) begin
	if(reset) cs <= idle;
	else cs <= ns;
end



//=======================================
//CNT_valid

always@(*) begin
	case(cs) 
		CNT_OUT :
			CNT_valid = 1'd1;
		
		default : begin
			CNT_valid = 1'd0;
		end
	endcase
end 



//=======================================
  //CNT1
always@(posedge clk) begin
	if (reset) begin
		CNT1 <= 8'd0;
	end
	else if (gray_valid && gray_data==8'd1) begin
		CNT1 <= CNT1+8'd1;
	end
	else begin
		CNT1 <= CNT1;
	end
end
  
 //=======================================
  //CNT2
always@(posedge clk) begin
	if (reset) begin
		CNT2 <= 8'd0;
	end
	else if (gray_valid && gray_data==8'd2) begin
		CNT2 <= CNT2+8'd1;
	end
	else begin
		CNT2 <= CNT2;
	end
end
 
//=======================================
  //CNT3
always@(posedge clk) begin
	if (reset) begin
		CNT3 <= 8'd0;
	end
	else if (gray_valid && gray_data==8'd3) begin
		CNT3 <= CNT3+8'd1;
	end
	else begin
		CNT3 <= CNT3;
	end
end

//=======================================
  //CN4
always@(posedge clk) begin
	if (reset) begin
		CNT4 <= 8'd0;
	end
	else if (gray_valid && gray_data==8'd4) begin
		CNT4 <= CNT4+8'd1;
	end
	else begin
		CNT4 <= CNT4;
	end
end

//=======================================
  //CNT5
always@(posedge clk) begin
	if (reset) begin
		CNT5 <= 8'd0;
	end
	else if (gray_valid && gray_data==8'd5) begin
		CNT5 <= CNT5 + 8'd1;
	end
	else begin
		CNT5 <= CNT5;
	end
end
  
//=======================================
  //CNT6
always@(posedge clk) begin
	if (reset) begin
		CNT6 <= 8'd0;
	end
	else if (gray_valid && gray_data==8'd6) begin
		CNT6 <= CNT6+8'd1;
	end
	else begin
		CNT6 <= CNT6;
	end
end
  
  
endmodule


module sorting (cs,clk,reset,CNT1, CNT2, CNT3, CNT4, CNT5, CNT6, ini_sort_3_finish, insert_1_finish, insert_2_finish,insert_3_finish   );
//process sort and merge algo in ini sort state
//process insertion algo in the following state
//using cs to control
input clk;
input reset;
input [4:0] cs;
input [7:0] CNT1, CNT2, CNT3, CNT4, CNT5, CNT6;
output ini_sort_3_finish;
output insert_1_finish,insert_2_finish,insert_3_finish;

wire com_out_1;
wire equal_signal_1;
wire com1_is_zero_1;
wire com2_is_zero_1;
wire [7:0] merge_cnt;
wire [7:0] merge_index;


//wire com_out_2;
//wire equal_signal_2;
//wire com4_is_zero;
//wire com5_is_zero;

reg [7:0] com_in1,com_in2;
//reg [5:0] com_in4,com_in5;
reg [7:0] TABLE1 [6:1][2:1];//table for ini sort;[6:1]means symbol order 6-1 from cnt big to small;[2:1]的[2]代表index;[1]代表總計的cnt
reg [7:0] TABLE2 [5:1][2:1];//table for sort
reg [7:0] TABLE3 [4:1][2:1];//table for sort
reg [7:0] TABLE4 [3:1][2:1];//table for sort
reg [7:0] TABLE5 [2:1][2:1];//table for sort
reg [7:0] temp   [6:1][2:1];

////判斷邏輯////共用部分////
reg [7:0] 
//com_set_1////
assign com_out_1 = (com_in1 < com_in2)? 1:0;
assign equal_signal_1 = (com_in1 == com_in2)?1:0;
assign com_index = (com_index_1 < com_index_2)?1:0;//機率一樣時，小的放下面
assign com1_is_zero_1 = !(|com_in1);//1代表全0,0代表有一
assign com2_is_zero_1 = !(|com_in2);//1代表全0,0代表有一

assign merge_cnt = merge_cnt_1 + merge_cnt_2;
assign merge_index = merge_index_1 + merge_index_2;
// =========================================== INDEX ==========================================
	//  - com_in1
	//  - com_in2
	//  - merge_cnt_1
	//  - merge_cnt_2
	//  - merge_index_1
	//  - merge_index_2
//============================================



///com_in1 and 2
always@(*) begin
case (cs) begin
	ini_sort_1_1 : begin
		com_in1 = CNT2;
		com_in2 = CNT3;
		end
	ini_sort_1_2 : begin
		com_in1 = CNT5;
		com_in2 = CNT6;
	end
	ini_sort_2_1_1 : begin
		com_in1 = TABLE1 [1][1];
		com_in2 = TABLE1 [2][1];
	end
	ini_sort_2_1_2 : begin
		com_in1 = TABLE1 [1][1];
		com_in2 = TABLE1 [2][1];
	end
	ini_sort_2_2_1 : begin
		com_in1 = TABLE1 [4][1];
		com_in2 = TABLE1 [5][1];
	end





endcase

end





endmodule

