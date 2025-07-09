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
parameter ini_sort_3_2   = 5'd10;  //
parameter ini_sort_3_3   = 5'd11;  //
parameter ini_sort_3_4   = 5'd12;  //
parameter ini_sort_3_5   = 5'd13;  //
parameter insert_ini_1   = 5'd14;  //
parameter insert_1       = 5'd15;  //
parameter insert_ini_2   = 5'd16;  //
parameter insert_2       = 5'd17;  //
parameter insert_ini_3   = 5'd18;  //
parameter insert_3       = 5'd19;  //
parameter insert_ini_4   = 5'd20;  //其實不需要這個狀態，只是方便程式可讀性以及方便共用combinational邏輯!
parameter insert_4       = 5'd21;  //
parameter split          = 5'd22;  //
parameter done           = 5'd23;  // 


//============================================
reg [4:0] cs,ns;
reg encoding_done,receive_done;
reg [6:0] A1,A2,A3,A4,A5,A6 [6:0];
reg [6:0] rec_count;
// =========================================== INDEX ==========================================
	//  - FSM done
	//  - CNT_valid
	//  - CNT1~6
//============================================ INDEX ==========================================
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
				ns = insert_ini_1;
			end 
			else
				ns = ini_sort_3_5
		ini_sort_3_5 :
			ns = insert_ini_1;

		insert_ini_1:
			ns = insert_1;

		insert_1 :
			if(insert_1_finish) begin
				ns = insert_ini_2;
			end
			else begin
				ns = insert_1;
			end

		insert_ini_2 :
			ns = insert_2;

		insert_2 :
			if(insert_2_finish) begin
				ns = insert_ini_3;
			end
			else begin
				ns = insert_2;
			end
		insert_ini_3 :
			ns = insert_3;

		insert_3 :
			if(insert_3_finish) begin
				ns = insert_ini_4;
			end
			else begin
				ns = insert_3;
			end

		insert_ini_4 :
			ns = insert_4;

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


module sorting (cs,clk,reset,CNT1, CNT2, CNT3, CNT4, CNT5, CNT6, ini_sort_3_finish, insert_1_finish, insert_2_finish,insert_3_finish,
	code_valid, HC1, HC2, HC3, HC4, HC5, HC6,M1, M2, M3, M4, M5, M6 	   );
//process sort and merge algo in ini sort state
//process insertion algo in the following state
//using cs to control
input clk;
input reset;
input [4:0] cs;
input [7:0] CNT1, CNT2, CNT3, CNT4, CNT5, CNT6;
output reg ini_sort_3_finish;
output reg insert_1_finish,insert_2_finish,insert_3_finish;
output reg code_valid;
output reg [7:0] HC1, HC2, HC3, HC4, HC5, HC6;
output reg [7:0] M1, M2, M3, M4, M5, M6;


wire com_out_1;
wire equal_signal_1;
wire com1_is_zero_1;
wire com2_is_zero_1;
wire [7:0] merge_cnt;
wire [7:0] merge_index;
wire [7:0] which_one_have_be_put;


////////注意每個index也是開到8bit是可以再優化，但因為寫法方便先暫用陣列
reg [7:0] com_in1,com_in2;
//reg [5:0] com_in4,com_in5;
reg [7:0] TABLE1 [6:1][2:1];//table for ini sort;[6:1]means symbol order 6-1 from cnt big to small;[2:1]的[2]代表index;[1]代表總計的cnt
reg [7:0] TABLE2 [5:1][2:1];//table for sort
reg [7:0] TABLE3 [4:1][2:1];//table for sort
reg [7:0] TABLE4 [3:1][2:1];//table for sort
reg [7:0] TABLE5 [2:1][2:1];//table for sort
reg [7:0] temp   [6:1][2:1];

////判斷邏輯////共用部分////
reg [7:0] com_index_2,com_index_1;
//com_set_1////
assign com_out_1 = (com_in1 < com_in2)? 1:0;
assign equal_signal_1 = (com_in1 == com_in2)?1:0;
assign com_index = (com_index_1 < com_index_2)?1:0;//機率一樣時，大的放下面
assign com1_is_zero_1 = !(|com_in1);//1代表全0,0代表有一
assign com2_is_zero_1 = !(|com_in2);//1代表全0,0代表有一

////找出兩個比較項中，出現次數比較小的項目;若相等，則找出index較大的項目
assign which_one_have_be_put = (equal_signal_1)? ((com_index)?com_in2:com_in1) :((com_out_1)?com_in1:com_in2);
assign which_index_have_be_put = (equal_signal_1)? ((com_index)?com_index_2:com_index_1) :((com_out_1)?com_index_1:com_index_2);
////找出兩個比較項中，出現次數比較大的項目;若相等，則找出index較小的項目
assign the_inverse_one_have_be_put = (equal_signal_1)? ((com_index)?com_index_1:com_index_2) :((com_out_1)?com_index_2:com_index_1);
assign the_inverse_index_have_be_put = (equal_signal_1)? ((com_index)?com_index_1:com_index_2) :((com_out_1)?com_index_2:com_index_2);

assign merge_cnt = merge_cnt_1 + merge_cnt_2;
assign merge_index = merge_index_1 + merge_index_2;
// =========================================== INDEX ==========================================
	//  - com_in1 & 2 com_index_1 & 2
	//  - 
	//  - merge_cnt_1
	//  - merge_cnt_2
	//  - merge_index_1
	//  - merge_index_2
//============================================



///com_in1 and 2 ///com_index
always@(*) begin
case (cs) 
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
		com_index_1 = TABLE1 [1][2];
		com_in2 = TABLE1 [2][1];
		com_index_2 = TABLE1 [2][2];
	end
	ini_sort_2_1_2 : begin
		com_in1 = TABLE1 [1][1];
		com_index_1 = TABLE1 [1][2];
		com_in2 = TABLE1 [2][1];
		com_index_2 = TABLE1 [2][2];
	end
	ini_sort_2_2_1 : begin
		com_in1 = TABLE1 [4][1];
		com_index_1 = TABLE1 [4][2];
		com_in2 = TABLE1 [5][1];
		com_index_2 = TABLE1 [5][2];
	end
	ini_sort_2_2_2 : begin
		com_in1 = TABLE1 [4][1];
		com_index_1 = TABLE1 [4][2];
		com_in2 = TABLE1 [5][1];
		com_index_2 = TABLE1 [5][2];
	end
	ini_sort_3_1 : begin
		com_in1 = temp [1][1];
		com_index_1 = temp [1][2];
		com_in2 = temp [4][1];
		com_index_2 = temp [4][2];
	end
	ini_sort_3_2 : begin
		com_in1 = temp [1][1];
		com_index_1 = temp [1][2];
		com_in2 = temp [4][1];
		com_index_2 = temp [4][2];

	end
	ini_sort_3_3 : begin
		com_in1 = temp [1][1];
		com_index_1 = temp [1][2];
		com_in2 = temp [4][1];
		com_index_2 = temp [4][2];

	end
	ini_sort_3_4 : begin
		com_in1 = temp [1][1];
		com_index_1 = temp [1][2];
		com_in2 = temp [4][1];
		com_index_2 = temp [4][2];
	end
	ini_sort_3_5 : begin
		com_in1 = temp [1][1];
		com_index_1 = temp [1][2];
		com_in2 = temp [4][1];
		com_index_2 = temp [4][2];
	end
	default : begin
		com_in1 = temp [1][1];
		com_index_1 = temp [1][2];
		com_in2 = temp [2][1];
		com_index_2 = temp [2][2];
	end
endcase
end

///merge cnt1&2 merge idx 1& 2///
always@(*) begin
	case(cs)
		insert_ini_1: begin
			merge_cnt_1 <= TABLE1[1][1];
			merge_cnt_2 <= TABLE1[2][1];
			merge_index_1 <= TABLE1[1][2];
			merge_index_2 <= TABLE1[2][2];
		end
		insert_ini_2: begin
			merge_cnt_1 <= TABLE2[1][1];
			merge_cnt_2 <= TABLE2[2][1];
			merge_index_1 <= TABLE2[1][2];
			merge_index_2 <= TABLE2[2][2];
		end


	endcase
end




///temp///
integer i;

always@(posedge clk) begin
	if (reset) begin
		for (i = 1; i <= 6; i = i + 1) begin
			temp[i][1] <= 8'd0;
			temp[i][2] <= 8'd0;
		end
	end

	else begin
		case (cs)
			ini_sort_2_1_1: begin
				temp[1][1] <= which_one_have_be_put;
				temp[1][2] <= which_index_have_be_put;
			end
			ini_sort_2_1_2: begin
				temp[2][1] <= which_one_have_be_put;
				temp[2][2] <= which_index_have_be_put;
				temp[3][1] <= the_inverse_one_have_be_put;
				temp[3][2] <= the_inverse_index_have_be_put;
			end
			ini_sort_2_2_1 : begin
				temp[4][1] <= which_one_have_be_put;
				temp[4][2] <= which_index_have_be_put;
			end
			ini_sort_2_2_2: begin
				temp[5][1] <= which_one_have_be_put;
				temp[5][2] <= which_index_have_be_put;
				temp[6][1] <= the_inverse_one_have_be_put;
				temp[6][2] <= the_inverse_index_have_be_put;
			end
			insert_1 : begin
				
			end
			insert_2 : begin
				
			end




		endcase
	end

end








endmodule

