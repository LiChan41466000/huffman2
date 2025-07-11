module huffman(clk, reset,gray_data , gray_valid, CNT_valid, CNT1, CNT2, CNT3, CNT4, CNT5, CNT6,
    code_valid, HC1, HC2, HC3, HC4, HC5, HC6,M1, M2, M3, M4, M5, M6 );

input clk;
input reset;
input gray_valid;
input [7:0] gray_data;
output reg CNT_valid;	
output reg [7:0] CNT1, CNT2, CNT3, CNT4, CNT5, CNT6;
output reg code_valid;
output [7:0] HC1, HC2, HC3, HC4, HC5, HC6;
output [7:0] M1, M2, M3, M4, M5, M6;
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
parameter split_1        = 5'd22;  //
parameter split_2        = 5'd23;  //
parameter split_3        = 5'd24;  //
parameter split_4        = 5'd25;  //
parameter split_5        = 5'd26;  //
parameter code_valid_OUT = 5'd27;  //
parameter done           = 5'd28;  // 


//============================================
reg [4:0] cs,ns;
reg encoding_done,receive_done;
reg [6:0] A1,A2,A3,A4,A5,A6 [6:0];
reg [6:0] rec_count;
wire ini_sort_3_finish,insert_3_finish,insert_1_finish,insert_2_finish;
// =========================================== INDEX ==========================================
	//  - FSM done
	//  - CNT_valid
	//  - CNT1~6
	//  - code_valid
    //  - sorting module 

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
			ns = ini_sort_1_1;
		ini_sort_1_1 :
			ns = ini_sort_1_2;
		ini_sort_1_2 :
			ns = ini_sort_2_1_1;
		ini_sort_2_1_1 :
			ns = ini_sort_2_1_2;

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
				ns = ini_sort_3_5;
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
			ns = split_1;
		split_1:
			ns = split_2;
		split_2:
			ns = split_3;
		split_3:
			ns = split_4;
		split_4:
			ns = split_5;
		split_5:
			ns = code_valid_OUT;
		code_valid_OUT:
			ns = done;
		
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
  
//code valid///////////////
always@(posedge clk) begin
	if (reset) begin
		code_valid <= 1'b0;
	end
	else if(cs == code_valid_OUT) begin
		code_valid <= 1'b1;
	end
	else if(cs == done) begin
		code_valid <= 1'b0;
	end

end

//sorting module//////
sorting ST0 (.cs(cs),.clk(clk),.reset(reset),.CNT1(CNT1), .CNT2(CNT2), .CNT3(CNT3), .CNT4(CNT4), .CNT5(CNT5), .CNT6(CNT6)
, .ini_sort_3_finish(ini_sort_3_finish), .insert_1_finish(insert_1_finish), .insert_2_finish(insert_2_finish), .insert_3_finish(insert_3_finish)
, .HC1(HC1), .HC2(HC2), .HC3(HC3), .HC4(HC4), .HC5(HC5), .HC6(HC6), .M1(M1), .M2(M2), .M3(M3), .M4(M4), .M5(M5), .M6(M6)
);

  
endmodule


module sorting (cs,clk,reset, CNT1, CNT2, CNT3, CNT4, CNT5, CNT6, ini_sort_3_finish, insert_1_finish, insert_2_finish,insert_3_finish,
	HC1, HC2, HC3, HC4, HC5, HC6, M1, M2, M3, M4, M5, M6);
//process sort and merge algo in ini sort state
//process insertion algo in the following state
//using cs to control
input clk;
input reset;
input [4:0] cs;
input [7:0] CNT1, CNT2, CNT3, CNT4, CNT5, CNT6;
output reg ini_sort_3_finish;
output reg insert_1_finish,insert_2_finish,insert_3_finish;
//output reg code_valid;
output reg [7:0] HC1, HC2, HC3, HC4, HC5, HC6;
output reg [7:0] M1, M2, M3, M4, M5, M6;


wire com_out_1;
wire equal_signal_1;
wire com1_is_zero_1;
wire com2_is_zero_1;
wire [7:0] merge_cnt;
wire [7:0] merge_index;
wire [7:0] which_one_have_be_put, which_index_have_be_put, the_inverse_one_have_be_put, the_inverse_index_have_be_put;
wire which_reg_should_be_replaced;


////////注意每個index也是開到8bit是可以再優化，但因為寫法方便先暫用陣列
reg [7:0] com_in1,com_in2;
//reg [5:0] com_in4,com_in5;
reg [7:0] TABLE1 [6:1][2:1];//table for ini sort;[6:1]means symbol order 6-1 from cnt big to small;[2:1]的[2]代表index;[1]代表總計的cnt
reg [7:0] TABLE2 [5:1][2:1];//table for sort
reg [7:0] TABLE3 [4:1][2:1];//table for sort
reg [7:0] TABLE4 [3:1][2:1];//table for sort
reg [7:0] TABLE5 [2:1][2:1];//table for sort
reg [7:0] temp   [6:1][2:1];
reg [7:0] merge_cnt_1,merge_cnt_2,merge_index_1,merge_index_2;

////判斷邏輯////共用部分////
reg [7:0] com_index_2,com_index_1;
//com_set_1////
assign com_out_1 = (com_in1 < com_in2)? 1:0;
assign equal_signal_1 = (com_in1 == com_in2)?1:0;
assign com_index = (com_index_1[5:0] < com_index_2[5:0])?1:0;//機率一樣時，大的放下面
assign com1_is_zero_1 = !(|com_index_1);//1代表全0,0代表有一
assign com2_is_zero_1 = !(|com_index_2);//1代表全0,0代表有一，用index比較是怕測資有任一symbol都沒有出現

////找出兩個比較項中，出現次數比較小的項目;若相等，則找出index較大的項目
assign which_one_have_be_put = (equal_signal_1)? ((com_index)?com_in2:com_in1) :((com_out_1)?com_in1:com_in2);
assign which_index_have_be_put = (equal_signal_1)? ((com_index)?com_index_2:com_index_1) :((com_out_1)?com_index_1:com_index_2);
////在ini_sort_2_1_1及2_2_1中，記憶哪一個reg該被大的覆蓋，若1代表覆蓋com_in1代表的TABLE1暫存。反之亦然
assign which_reg_should_be_replaced = (equal_signal_1)? ((com_index)?0:1) :((com_out_1)?1:0);



////找出兩個比較項中，出現次數比較大的項目;若相等，則找出index較小的項目
assign the_inverse_one_have_be_put = (equal_signal_1)? ((com_index)?com_in1:com_in2) :((com_out_1)?com_in2:com_in1);
assign the_inverse_index_have_be_put = (equal_signal_1)? ((com_index)?com_index_1:com_index_2) :((com_out_1)?com_index_2:com_index_1);

assign merge_cnt = merge_cnt_1 + merge_cnt_2;
assign merge_index = merge_index_1 + merge_index_2;


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
parameter split_1        = 5'd22;  //
parameter split_2        = 5'd23;  //
parameter split_3        = 5'd24;  //
parameter split_4        = 5'd25;  //
parameter split_5        = 5'd26;  //
parameter code_valid_OUT = 5'd27;  //
parameter done           = 5'd28;  // 


parameter symbol1 		= 8'b00000001;
parameter symbol2 		= 8'b00000010;
parameter symbol3 		= 8'b00000100;
parameter symbol4 		= 8'b00001000;
parameter symbol5 		= 8'b00010000;
parameter symbol6 		= 8'b00100000;


// =========================================== INDEX ==========================================
	//  - com_in1 & 2 com_index_1 & 2
	//  - merge cnt1&2 merge idx 1& 2
	//  - TABLE1-6
	//  - symbol split1-6
	//  - 
	//  - 
//============================================ INDEX ==========================================



///com_in1 and 2 ///com_index
always@(*) begin
case (cs) 
	ini_sort_1_1 : begin
		com_in1 	<= CNT2;
		com_in2 	<= CNT3;
		com_index_1 <= symbol2;
		com_index_2 <= symbol3;

		end
	ini_sort_1_2 : begin
		com_in1 	<= CNT5;
		com_in2 	<= CNT6;
		com_index_1 <= symbol5;
		com_index_2 <= symbol6;
	end
	ini_sort_2_1_1 : begin
		com_in1 	<= TABLE1 [1][1];
		com_index_1 <= TABLE1 [1][2];
		com_in2 	<= TABLE1 [2][1];
		com_index_2 <= TABLE1 [2][2];
	end
	ini_sort_2_1_2 : begin
		com_in1 	<= TABLE1 [1][1];
		com_index_1 <= TABLE1 [1][2];
		com_in2 	<= TABLE1 [2][1];
		com_index_2 <= TABLE1 [2][2];
	end
	ini_sort_2_2_1 : begin
		com_in1 	<= TABLE1 [4][1];
		com_index_1 <= TABLE1 [4][2];
		com_in2 	<= TABLE1 [5][1];
		com_index_2 <= TABLE1 [5][2];
	end
	ini_sort_2_2_2 : begin
		com_in1 	<= TABLE1 [4][1];
		com_index_1 <= TABLE1 [4][2];
		com_in2 	<= TABLE1 [5][1];
		com_index_2 <= TABLE1 [5][2];
	end
	ini_sort_3_1 : begin
		com_in1 	<= temp [1][1];
		com_index_1 <= temp [1][2];
		com_in2 	<= temp [4][1];
		com_index_2 <= temp [4][2];
	end
	ini_sort_3_2 : begin
		com_in1 	<= temp [1][1];
		com_index_1 <= temp [1][2];
		com_in2 	<= temp [4][1];
		com_index_2 <= temp [4][2];

	end
	ini_sort_3_3 : begin
		com_in1 	<= temp [1][1];
		com_index_1 <= temp [1][2];
		com_in2 	<= temp [4][1];
		com_index_2 <= temp [4][2];

	end
	ini_sort_3_4 : begin
		com_in1 	<= temp [1][1];
		com_index_1 <= temp [1][2];
		com_in2 	<= temp [4][1];
		com_index_2 <= temp [4][2];
	end
	ini_sort_3_5 : begin
		com_in1 	<= temp [1][1];
		com_index_1 <= temp [1][2];
		com_in2 	<= temp [4][1];
		com_index_2 <= temp [4][2];
	end

	default : begin ///////   insert   階段全都是比較temp[1] & [2]
		com_in1 	<= temp [1][1];
		com_index_1 <= temp [1][2];
		com_in2 	<= temp [2][1];
		com_index_2 <= temp [2][2];
	end
endcase
end

///merge cnt1&2 merge idx 1& 2///
always@(*) begin
	case(cs)
		insert_ini_1: begin
			merge_cnt_1 	<= TABLE1[1][1];
			merge_cnt_2 	<= TABLE1[2][1];
			merge_index_1 <= TABLE1[1][2];
			merge_index_2 <= TABLE1[2][2];
		end
		insert_ini_2: begin
			merge_cnt_1 	<= TABLE2[1][1];
			merge_cnt_2 	<= TABLE2[2][1];
			merge_index_1 <= TABLE2[1][2];
			merge_index_2 <= TABLE2[2][2];
		end
		insert_ini_3: begin
			merge_cnt_1 	<= TABLE3[1][1];
			merge_cnt_2 	<= TABLE3[2][1];
			merge_index_1 <= TABLE3[1][2];
			merge_index_2 <= TABLE3[2][2];
		end
		insert_ini_4: begin
			merge_cnt_1 	<= TABLE4[1][1];
			merge_cnt_2 	<= TABLE4[2][1];
			merge_index_1 <= TABLE4[1][2];
			merge_index_2 <= TABLE4[2][2];
		end

	endcase
end

//ini_sort_3_finish
always@(*) begin
	case(cs)
		ini_sort_3_4: begin
			if(!(|temp[1][2]) || !(|temp[4][2])) begin //先判斷是否兩組比較暫存是否有一組全0,若有拉起結束訊號
				ini_sort_3_finish <=1'd1;
			end
			else begin
				ini_sort_3_finish <=1'd0;
			end
		end

		default :
			ini_sort_3_finish <=1'd0;
	endcase
end

//		insert_1_finish
always@(*) begin
	case(cs)
		insert_1 : begin
			if(com1_is_zero_1 && com2_is_zero_1) begin
				insert_1_finish <= 1'd1;
			end
			else begin
				insert_1_finish <= 1'd0;
			end
		end
		default : begin
			insert_1_finish <= 1'd0;
		end

	endcase
end

//		insert_2_finish
always@(*) begin
	case(cs)
		insert_2 : begin
			if(com1_is_zero_1 && com2_is_zero_1) begin
				insert_2_finish <= 1'd1;
			end
			else begin
				insert_2_finish <= 1'd0;
			end
		end
		default : begin
			insert_2_finish <= 1'd0;
		end

	endcase
end
//		insert_3_finish
always@(*) begin
	case(cs)
		insert_3 : begin
			if(com1_is_zero_1 && com2_is_zero_1) begin
				insert_3_finish <= 1'd1;
			end
			else begin
				insert_3_finish <= 1'd0;
			end
		end
		default : begin
			insert_3_finish <= 1'd0;
		end

	endcase
end

///temp reg & insert_finish signal//
integer i;

always@(posedge clk) begin
	if (reset) begin
		for (i = 1; i <= 6; i = i + 1) begin
			temp[i][1] <= 8'd0;
			temp[i][2] <= 8'd0;
		end
//		ini_sort_3_finish <= 1'd0;
//		insert_1_finish   <= 1'd0;
//		insert_2_finish   <= 1'd0;
//		insert_3_finish   <= 1'd0;
	end

	else begin

		if(cs == insert_1 || cs == insert_2 || cs == insert_3 || cs == insert_4) begin
//			if(com1_is_zero_1 && com2_is_zero_1) begin
//				case(cs)
//					insert_1 :
//						insert_1_finish <= 1'd1;
//					insert_2 :
//						insert_2_finish <= 1'd1;
//					insert_3 :
//						insert_3_finish <= 1'd1;
//				endcase
//			end
//			else 
			if(com1_is_zero_1 && !com2_is_zero_1) begin //代表合併項已經被放入table，temp6:2直接右移，temp[2]要放進tanl2
				temp[6][1] <= 8'd0;
				temp[6][2] <= 8'd0;
				temp[5][1] <= temp[6][1];
				temp[5][2] <= temp[6][2];
				temp[4][1] <= temp[5][1];
				temp[4][2] <= temp[5][2];
				temp[3][1] <= temp[4][1];
				temp[3][2] <= temp[4][2];
				temp[2][1] <= temp[3][1];
				temp[2][2] <= temp[3][2];
			end
			else if ((!com1_is_zero_1 && com2_is_zero_1) || equal_signal_1 || com_out_1) begin
				 //第一個判斷代表temp6:2已全被放到table裡面，直接把temp1丟去table並更新為0就好,下一周期就會觸發判斷全0
				 //第二個判斷代表temp[1]和temp[2]皆不是0並相等，直接把合併後的項temp[1]丟進去table並且把temp[1]更新為0(此處描述temp暫存器故僅更新為0)
				 //第三個判斷代表若temp[1]<temp[2]且都不是0，把temp[1]的項丟進去table並更新為0
				temp[1][1] <= 8'd0;
				temp[1][2] <= 8'd0;
			end
			else if (!com_out_1) begin //代表若temp[1]>temp[2]且都不是0，把temp[2]放進table並右移temp6:2
				temp[6][1] <= 8'd0;
				temp[6][2] <= 8'd0;
				temp[5][1] <= temp[6][1];
				temp[5][2] <= temp[6][2];
				temp[4][1] <= temp[5][1];
				temp[4][2] <= temp[5][2];
				temp[3][1] <= temp[4][1];
				temp[3][2] <= temp[4][2];
				temp[2][1] <= temp[3][1];
				temp[2][2] <= temp[3][2];
			end


		end


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

			ini_sort_3_1 : begin
				case(which_reg_should_be_replaced)	
					1'b1 : begin//成立代表temp[1]被放入table1內，故位移temp[3-1]
						temp[3][1] <= 8'd0;
						temp[3][2] <= 8'd0;
						temp[2][1] <= temp[3][1];
						temp[2][2] <= temp[3][2];
						temp[1][1] <= temp[2][1];
						temp[1][2] <= temp[2][2];
					end
					1'b0 : begin//代表temp [4]被放入table1內，故位移temp[6-4]
						temp[6][1] <= 8'd0;
						temp[6][2] <= 8'd0;
						temp[5][1] <= temp[6][1];
						temp[5][2] <= temp[6][2];
						temp[4][1] <= temp[5][1];
						temp[4][2] <= temp[5][2];
					end
				endcase
			end
			ini_sort_3_2 : begin
				case(which_reg_should_be_replaced)	
					1'b1 : begin//成立代表temp[1]被放入table1內，故位移temp[3-1]
						temp[3][1] <= 8'd0;
						temp[3][2] <= 8'd0;
						temp[2][1] <= temp[3][1];
						temp[2][2] <= temp[3][2];
						temp[1][1] <= temp[2][1];
						temp[1][2] <= temp[2][2];
					end
					1'b0 : begin//代表temp [4]被放入table1內，故位移temp[6-4]
						temp[6][1] <= 8'd0;
						temp[6][2] <= 8'd0;
						temp[5][1] <= temp[6][1];
						temp[5][2] <= temp[6][2];
						temp[4][1] <= temp[5][1];
						temp[4][2] <= temp[5][2];
					end
				endcase
			end
			ini_sort_3_3 : begin
				case(which_reg_should_be_replaced)	
					1'b1 : begin//成立代表temp[1]被放入table1內，故位移temp[3-1]
						temp[3][1] <= 8'd0;
						temp[3][2] <= 8'd0;
						temp[2][1] <= temp[3][1];
						temp[2][2] <= temp[3][2];
						temp[1][1] <= temp[2][1];
						temp[1][2] <= temp[2][2];
					end
					1'b0 : begin//代表temp [4]被放入table1內，故位移temp[6-4]
						temp[6][1] <= 8'd0;
						temp[6][2] <= 8'd0;
						temp[5][1] <= temp[6][1];
						temp[5][2] <= temp[6][2];
						temp[4][1] <= temp[5][1];
						temp[4][2] <= temp[5][2];
					end
				endcase
			end
			ini_sort_3_4 : begin
//				if(!(|temp[1][2]) || !(|temp[4][2])) begin //先判斷是否兩組比較暫存是否有一組全0,若有拉起結束訊號
//					ini_sort_3_finish <=1'd1;
//				end
///				else begin
					case(which_reg_should_be_replaced)	
						1'b1 : begin//成立代表temp[1]被放入table1內，故位移temp[3-1]
							temp[3][1] <= 8'd0;
							temp[3][2] <= 8'd0;
							temp[2][1] <= temp[3][1];
							temp[2][2] <= temp[3][2];
							temp[1][1] <= temp[2][1];
							temp[1][2] <= temp[2][2];
						end
						1'b0 : begin//代表temp [4]被放入table1內，故位移temp[6-4]
							temp[6][1] <= 8'd0;
							temp[6][2] <= 8'd0;
							temp[5][1] <= temp[6][1];
							temp[5][2] <= temp[6][2];
							temp[4][1] <= temp[5][1];
							temp[4][2] <= temp[5][2];
						end
					endcase

				end
//			end

			insert_ini_1 : begin
				temp[1][1] <= merge_cnt;
				temp[1][2] <= merge_index;
				temp[2][1] <= TABLE1[3][1];
				temp[2][2] <= TABLE1[3][2];
				temp[3][1] <= TABLE1[4][1];
				temp[3][2] <= TABLE1[4][2];
				temp[4][1] <= TABLE1[5][1];
				temp[4][2] <= TABLE1[5][2];
				temp[5][1] <= TABLE1[6][1];
				temp[5][2] <= TABLE1[6][2];
				temp[6][1] <= 8'd0;
				temp[6][2] <= 8'd0;

			end
			insert_ini_2 : begin
				temp[1][1] <= merge_cnt;
				temp[1][2] <= merge_index;
				temp[2][1] <= TABLE2[3][1];
				temp[2][2] <= TABLE2[3][2];
				temp[3][1] <= TABLE2[4][1];
				temp[3][2] <= TABLE2[4][2];
				temp[4][1] <= TABLE2[5][1];
				temp[4][2] <= TABLE2[5][2];
				temp[5][1] <= 8'd0;
				temp[5][2] <= 8'd0;
				temp[6][1] <= 8'd0;
				temp[6][2] <= 8'd0;
			end
			insert_ini_3 : begin
				temp[1][1] <= merge_cnt;
				temp[1][2] <= merge_index;
				temp[2][1] <= TABLE3[3][1];
				temp[2][2] <= TABLE3[3][2];
				temp[3][1] <= TABLE3[4][1];
				temp[3][2] <= TABLE3[4][2];
				temp[4][1] <= 8'd0;
				temp[4][2] <= 8'd0;
				temp[5][1] <= 8'd0;
				temp[5][2] <= 8'd0;
				temp[6][1] <= 8'd0;
				temp[6][2] <= 8'd0;
			end
			insert_ini_4 : begin
				temp[1][1] <= merge_cnt;
				temp[1][2] <= merge_index;
				temp[2][1] <= TABLE4[3][1];
				temp[2][2] <= TABLE4[3][2];
				temp[3][1] <= 8'd0;
				temp[3][2] <= 8'd0;
				temp[4][1] <= 8'd0;
				temp[4][2] <= 8'd0;
				temp[5][1] <= 8'd0;
				temp[5][2] <= 8'd0;
				temp[6][1] <= 8'd0;
				temp[6][2] <= 8'd0;
			end


		endcase
	end

end

///TABLE1-6

always@(posedge clk) begin
	if (reset) begin
		for (i = 1; i <= 6; i = i + 1) begin
			TABLE1[i][1] <= 8'd0;
			TABLE1[i][2] <= 8'd0;
		end
		for (i = 1; i <= 5; i = i+1) begin
			TABLE2[i][1] <= 8'd0;
			TABLE2[i][2] <= 8'd0;
		end
		for (i = 1; i <= 4; i = i+1) begin
			TABLE3[i][1] <= 8'd0;
			TABLE3[i][2] <= 8'd0;
		end
		for (i = 1; i <= 3; i = i+1) begin
			TABLE4[i][1] <= 8'd0;
			TABLE4[i][2] <= 8'd0;
		end
		for (i = 1; i <= 2; i = i+1) begin
			TABLE5[i][1] <= 8'd0;
			TABLE5[i][2] <= 8'd0;
		end

	end

	else begin
		case(cs)
			ini_sort_1_1 : begin
				TABLE1[1][1] <= CNT1;
				TABLE1[1][2] <= symbol1;
				TABLE1[2][1] <= which_one_have_be_put;
				TABLE1[2][2] <= which_index_have_be_put;
				TABLE1[3][1] <= the_inverse_one_have_be_put;
				TABLE1[3][2] <= the_inverse_index_have_be_put;
			end

			ini_sort_1_2 : begin
				TABLE1[4][1] <= CNT4;
				TABLE1[4][2] <= symbol4;
				TABLE1[5][1] <= which_one_have_be_put;
				TABLE1[5][2] <= which_index_have_be_put;
				TABLE1[6][1] <= the_inverse_one_have_be_put;
				TABLE1[6][2] <= the_inverse_index_have_be_put;
			end

			ini_sort_2_1_1 : begin
				if(which_reg_should_be_replaced) begin //若成立代表[1]的被放進temp reg，故用[3]取代
					TABLE1[1][1] <= TABLE1[3][1];
					TABLE1[1][2] <= TABLE1[3][2];
				end
				else begin
					TABLE1[2][1] <= TABLE1[3][1];
					TABLE1[2][2] <= TABLE1[3][2];
				end
			end

			ini_sort_2_2_1 : begin
				if(which_reg_should_be_replaced) begin //若成立代表[4]的被放進temp reg，故用[6]取代
					TABLE1[4][1] <= TABLE1[6][1];
					TABLE1[4][2] <= TABLE1[6][2];
				end
				else begin
					TABLE1[5][1] <= TABLE1[6][1];
					TABLE1[5][2] <= TABLE1[6][2];
				end

			end
			ini_sort_3_1 : begin
				TABLE1[1][1] <= which_one_have_be_put;
				TABLE1[1][2] <= which_index_have_be_put;
			end

			ini_sort_3_2 : begin
				TABLE1[2][1] <= which_one_have_be_put;
				TABLE1[2][2] <= which_index_have_be_put;
			end

			ini_sort_3_3 : begin
				TABLE1[3][1] <= which_one_have_be_put;
				TABLE1[3][2] <= which_index_have_be_put;
			end

			ini_sort_3_4 : begin
				if(com1_is_zero_1) begin //先判斷是否兩組比較暫存是否有一組全0,若有把另一邊全輸入到table
					TABLE1[4][1] <= temp[4][1]; 
					TABLE1[4][2] <= temp[4][2];
					TABLE1[5][1] <= temp[5][1]; 
					TABLE1[5][2] <= temp[5][2];
					TABLE1[6][1] <= temp[6][1]; 
					TABLE1[6][2] <= temp[6][2];
				end

				else if (com2_is_zero_1) begin
					TABLE1[4][1] <= temp[1][1]; 
					TABLE1[4][2] <= temp[1][2];
					TABLE1[5][1] <= temp[2][1]; 
					TABLE1[5][2] <= temp[2][2];
					TABLE1[6][1] <= temp[3][1]; 
					TABLE1[6][2] <= temp[3][2];

				end

				else begin //若無則正常排序
					TABLE1[4][1] <= which_one_have_be_put;
					TABLE1[4][2] <= which_index_have_be_put;
				end
			end


			ini_sort_3_5 : begin
				TABLE1[5][1] <= which_one_have_be_put;
				TABLE1[5][2] <= which_index_have_be_put;
				TABLE1[6][1] <= the_inverse_one_have_be_put;
				TABLE1[6][2] <= the_inverse_index_have_be_put;
			end

			insert_1 : begin
				if(com1_is_zero_1 && com2_is_zero_1)begin
					TABLE2[5][1] <= TABLE2[5][1];
					TABLE2[5][2] <= TABLE2[5][2];
					TABLE2[4][1] <= TABLE2[4][1];
					TABLE2[4][2] <= TABLE2[4][2];
					TABLE2[3][1] <= TABLE2[3][1];
					TABLE2[3][2] <= TABLE2[3][2];
					TABLE2[2][1] <= TABLE2[2][1];
					TABLE2[2][2] <= TABLE2[2][2];
					TABLE2[1][1] <= TABLE2[1][1];
					TABLE2[1][2] <= TABLE2[1][2];
				end

				else begin
					if(com1_is_zero_1 && !com2_is_zero_1)begin
						TABLE2[5][1] <= temp[2][1];
						TABLE2[5][2] <= temp[2][2];
					end
					else if(!com1_is_zero_1 && com2_is_zero_1) begin
						TABLE2[5][1] <= temp[1][1];
						TABLE2[5][2] <= temp[1][2];
					end
					else begin
						if (equal_signal_1)begin			////////////////////////
							TABLE2[5][1] <= merge_cnt;		//MODIFY HERE !!!!!!!!//
							TABLE2[5][2] <= merge_index;	////////////////////////
						end	

						else begin
							TABLE2[5][1] <= which_one_have_be_put;
							TABLE2[5][2] <= which_index_have_be_put;
						end
					end
					TABLE2[4][1] <= TABLE2[5][1];
					TABLE2[4][2] <= TABLE2[5][2];
					TABLE2[3][1] <= TABLE2[4][1];
					TABLE2[3][2] <= TABLE2[4][2];
					TABLE2[2][1] <= TABLE2[3][1];
					TABLE2[2][2] <= TABLE2[3][2];
					TABLE2[1][1] <= TABLE2[2][1];
					TABLE2[1][2] <= TABLE2[2][2];
					end
			end

			insert_2 : begin
				if(com1_is_zero_1 && com2_is_zero_1)begin
					TABLE3[4][1] <= TABLE3[4][1];
					TABLE3[4][2] <= TABLE3[4][2];
					TABLE3[3][1] <= TABLE3[3][1];
					TABLE3[3][2] <= TABLE3[3][2];
					TABLE3[2][1] <= TABLE3[2][1];
					TABLE3[2][2] <= TABLE3[2][2];
					TABLE3[1][1] <= TABLE3[1][1];
					TABLE3[1][2] <= TABLE3[1][2];
				end

				else begin
					if(com1_is_zero_1 && !com2_is_zero_1)begin
						TABLE3[4][1] <= temp[2][1];
						TABLE3[4][2] <= temp[2][2];
					end
					else if(!com1_is_zero_1 && com2_is_zero_1) begin
						TABLE3[4][1] <= temp[1][1];
						TABLE3[4][2] <= temp[1][2];
					end
					else begin
						if(equal_signal_1)begin				////////////////////////
							TABLE3[4][1] <= merge_cnt;		//MODIFY HERE !!!!!!!!//
							TABLE3[4][2] <= merge_index;   ////////////////////////
						end

						else begin
							TABLE3[4][1] <= which_one_have_be_put;
							TABLE3[4][2] <= which_index_have_be_put;
						end
					end
					TABLE3[3][1] <= TABLE3[4][1];
					TABLE3[3][2] <= TABLE3[4][2];
					TABLE3[2][1] <= TABLE3[3][1];
					TABLE3[2][2] <= TABLE3[3][2];
					TABLE3[1][1] <= TABLE3[2][1];
					TABLE3[1][2] <= TABLE3[2][2];
				end
			end

			insert_3 : begin
				if(com1_is_zero_1 && com2_is_zero_1)begin
					TABLE4[3][1] <= TABLE4[3][1];
					TABLE4[3][2] <= TABLE4[3][2];
					TABLE4[2][1] <= TABLE4[2][1];
					TABLE4[2][2] <= TABLE4[2][2];
					TABLE4[1][1] <= TABLE4[1][1];
					TABLE4[1][2] <= TABLE4[1][2];
				end


				else begin
					if(com1_is_zero_1 && !com2_is_zero_1)begin
						TABLE4[3][1] <= temp[2][1];
						TABLE4[3][2] <= temp[2][2];
					end
					else if(!com1_is_zero_1 && com2_is_zero_1) begin
						TABLE4[3][1] <= temp[1][1];
						TABLE4[3][2] <= temp[1][2];
					end
					else begin
						if(equal_signal_1)begin				////////////////////////
							TABLE4[3][1] <= merge_cnt;		//MODIFY HERE !!!!!!!!//
							TABLE4[3][2] <= merge_index;	////////////////////////
						end
						else begin
						TABLE4[3][1] <= which_one_have_be_put;
						TABLE4[3][2] <= which_index_have_be_put;
						end
					end
					//TABLE4[3][1] <= which_one_have_be_put;
					//TABLE4[3][2] <= which_index_have_be_put;
					TABLE4[2][1] <= TABLE4[3][1];
					TABLE4[2][2] <= TABLE4[3][2];
					TABLE4[1][1] <= TABLE4[2][1];
					TABLE4[1][2] <= TABLE4[2][2];
				end
			end
			insert_4 : begin
				TABLE5[1][1] <= which_one_have_be_put;
				TABLE5[1][2] <= which_index_have_be_put;
				TABLE5[2][1] <= the_inverse_one_have_be_put;
				TABLE5[2][2] <= the_inverse_index_have_be_put;
			end
		endcase
	end
end


/////////symbol1 split////////
always@(posedge clk) begin
	if(reset) begin
		HC1 <= 8'd0;
		M1  <= 8'd0;
	end
	else begin
		case(cs)
			split_1 : begin
				if(TABLE5[2][2][0] == 1'd1) begin
					HC1 <= {HC1[6:0],1'b0};
					M1  <= {M1[6:0],1'b1};
				end
				else if(TABLE5[1][2][0] == 1'd1) begin
					HC1 <= {HC1[6:0],1'b1};
					M1  <= {M1[6:0],1'b1};
				end
			end

			split_2 : begin
				if(TABLE4[2][2][0] == 1'd1) begin
					HC1 <= {HC1[6:0],1'b0};
					M1  <= {M1[6:0],1'b1};
				end
				else if(TABLE4[1][2][0] == 1'd1) begin
					HC1 <= {HC1[6:0],1'b1};
					M1  <= {M1[6:0],1'b1};
				end
				else begin
					HC1 <= HC1;
					M1  <= M1;
				end
			end
			split_3 : begin
				if(TABLE3[2][2][0] == 1'd1) begin
					HC1 <= {HC1[6:0],1'b0};
					M1  <= {M1[6:0],1'b1};
				end
				else if(TABLE3[1][2][0] == 1'd1) begin
					HC1 <= {HC1[6:0],1'b1};
					M1  <= {M1[6:0],1'b1};
				end
				else begin
					HC1 <= HC1;
					M1  <= M1;
				end
			end
			split_4 : begin
				if(TABLE2[2][2][0] == 1'd1) begin
					HC1 <= {HC1[6:0],1'b0};
					M1  <= {M1[6:0],1'b1};
				end
				else if(TABLE2[1][2][0] == 1'd1) begin
					HC1 <= {HC1[6:0],1'b1};
					M1  <= {M1[6:0],1'b1};
				end
				else begin
					HC1 <= HC1;
					M1  <= M1;
				end
			end
			split_5 : begin
				if(TABLE1[2][2][0] == 1'd1) begin
					HC1 <= {HC1[6:0],1'b0};
					M1  <= {M1[6:0],1'b1};
				end
				else if(TABLE1[1][2][0] == 1'd1) begin
					HC1 <= {HC1[6:0],1'b1};
					M1  <= {M1[6:0],1'b1};
				end
				else begin
					HC1 <= HC1;
					M1  <= M1;
				end
			end
		endcase
	end

end


/////////symbol2 split////////
always@(posedge clk) begin
	if(reset) begin
		HC2 <= 8'd0;
		M2  <= 8'd0;
	end
	else begin
		case(cs)
			split_1 : begin
				if(TABLE5[2][2][1] == 1'd1) begin
					HC2 <= {HC2[6:0],1'b0};
					M2  <= {M2[6:0],1'b1};
				end
				else if(TABLE5[1][2][1] == 1'd1) begin
					HC2 <= {HC2[6:0],1'b1};
					M2  <= {M2[6:0],1'b1};
				end
			end

			split_2 : begin
				if(TABLE4[2][2][1] == 1'd1) begin
					HC2 <= {HC2[6:0],1'b0};
					M2  <= {M2[6:0],1'b1};
				end
				else if(TABLE4[1][2][1] == 1'd1) begin
					HC2 <= {HC2[6:0],1'b1};
					M2  <= {M2[6:0],1'b1};
				end
				else begin
					HC2 <= HC2;
					M2  <= M2;
				end
			end
			split_3 : begin
				if(TABLE3[2][2][1] == 1'd1) begin
					HC2 <= {HC2[6:0],1'b0};
					M2  <= {M2[6:0],1'b1};
				end
				else if(TABLE3[1][2][1] == 1'd1) begin
					HC2 <= {HC2[6:0],1'b1};
					M2  <= {M2[6:0],1'b1};
				end
				else begin
					HC2 <= HC2;
					M2  <= M2;
				end
			end
			split_4 : begin
				if(TABLE2[2][2][1] == 1'd1) begin
					HC2 <= {HC2[6:0],1'b0};
					M2  <= {M2[6:0],1'b1};
				end
				else if(TABLE2[1][2][1] == 1'd1) begin
					HC2 <= {HC2[6:0],1'b1};
					M2  <= {M2[6:0],1'b1};
				end
				else begin
					HC2 <= HC2;
					M2  <= M2;
				end
			end
			split_5 : begin
				if(TABLE1[2][2][1] == 1'd1) begin
					HC2 <= {HC2[6:0],1'b0};
					M2  <= {M2[6:0],1'b1};
				end
				else if(TABLE1[1][2][1] == 1'd1) begin
					HC2 <= {HC2[6:0],1'b1};
					M2  <= {M2[6:0],1'b1};
				end
				else begin
					HC2 <= HC2;
					M2  <= M2;
				end
			end
		endcase
	end
end


/////////symbol3 split////////
always@(posedge clk) begin
	if(reset) begin
		HC3 <= 8'd0;
		M3  <= 8'd0;
	end
	else begin
		case(cs)
			split_1 : begin
				if(TABLE5[2][2][2] == 1'd1) begin
					HC3 <= {HC3[6:0],1'b0};
					M3  <= {M3[6:0],1'b1};
				end
				else if(TABLE5[1][2][2] == 1'd1) begin
					HC3 <= {HC3[6:0],1'b1};
					M3  <= {M3[6:0],1'b1};
				end
			end

			split_2 : begin
				if(TABLE4[2][2][2] == 1'd1) begin
					HC3 <= {HC3[6:0],1'b0};
					M3  <= {M3[6:0],1'b1};
				end
				else if(TABLE4[1][2][2] == 1'd1) begin
					HC3 <= {HC3[6:0],1'b1};
					M3  <= {M3[6:0],1'b1};
				end
				else begin
					HC3 <= HC3;
					M3  <= M3;
				end
			end
			split_3 : begin
				if(TABLE3[2][2][2] == 1'd1) begin
					HC3 <= {HC3[6:0],1'b0};
					M3  <= {M3[6:0],1'b1};
				end
				else if(TABLE3[1][2][2] == 1'd1) begin
					HC3 <= {HC3[6:0],1'b1};
					M3  <= {M3[6:0],1'b1};
				end
				else begin
					HC3 <= HC3;
					M3  <= M3;
				end
			end
			split_4 : begin
				if(TABLE2[2][2][2] == 1'd1) begin
					HC3 <= {HC3[6:0],1'b0};
					M3  <= {M3[6:0],1'b1};
				end
				else if(TABLE2[1][2][2] == 1'd1) begin
					HC3 <= {HC3[6:0],1'b1};
					M3  <= {M3[6:0],1'b1};
				end
				else begin
					HC3 <= HC3;
					M3  <= M3;
				end
			end
			split_5 : begin
				if(TABLE1[2][2][2] == 1'd1) begin
					HC3 <= {HC3[6:0],1'b0};
					M3  <= {M3[6:0],1'b1};
				end
				else if(TABLE1[1][2][2] == 1'd1) begin
					HC3 <= {HC3[6:0],1'b1};
					M3  <= {M3[6:0],1'b1};
				end
				else begin
					HC3 <= HC3;
					M3  <= M3;
				end
			end
		endcase
	end
end


/////////symbol4 split////////
always@(posedge clk) begin
	if(reset) begin
		HC4 <= 8'd0;
		M4  <= 8'd0;
	end
	else begin
		case(cs)
			split_1 : begin
				if(TABLE5[2][2][3] == 1'd1) begin
					HC4 <= {HC4[6:0],1'b0};
					M4  <= {M4[6:0],1'b1};
				end
				else if(TABLE5[1][2][3] == 1'd1) begin
					HC4 <= {HC4[6:0],1'b1};
					M4  <= {M4[6:0],1'b1};
				end
			end

			split_2 : begin
				if(TABLE4[2][2][3] == 1'd1) begin
					HC4 <= {HC4[6:0],1'b0};
					M4  <= {M4[6:0],1'b1};
				end
				else if(TABLE4[1][2][3] == 1'd1) begin
					HC4 <= {HC4[6:0],1'b1};
					M4  <= {M4[6:0],1'b1};
				end
				else begin
					HC4 <= HC4;
					M4  <= M4;
				end
			end
			split_3 : begin
				if(TABLE3[2][2][3] == 1'd1) begin
					HC4 <= {HC4[6:0],1'b0};
					M4  <= {M4[6:0],1'b1};
				end
				else if(TABLE3[1][2][3] == 1'd1) begin
					HC4 <= {HC4[6:0],1'b1};
					M4  <= {M4[6:0],1'b1};
				end
				else begin
					HC4 <= HC4;
					M4  <= M4;
				end
			end
			split_4 : begin
				if(TABLE2[2][2][3] == 1'd1) begin
					HC4 <= {HC4[6:0],1'b0};
					M4  <= {M4[6:0],1'b1};
				end
				else if(TABLE2[1][2][3] == 1'd1) begin
					HC4 <= {HC4[6:0],1'b1};
					M4  <= {M4[6:0],1'b1};
				end
				else begin
					HC4 <= HC4;
					M4  <= M4;
				end
			end
			split_5 : begin
				if(TABLE1[2][2][3] == 1'd1) begin
					HC4 <= {HC4[6:0],1'b0};
					M4  <= {M4[6:0],1'b1};
				end
				else if(TABLE1[1][2][3] == 1'd1) begin
					HC4 <= {HC4[6:0],1'b1};
					M4  <= {M4[6:0],1'b1};
				end
				else begin
					HC4 <= HC4;
					M4  <= M4;
				end
			end
		endcase
	end
end

/////////symbol5 split////////
always@(posedge clk) begin
	if(reset) begin
		HC5 <= 8'd0;
		M5  <= 8'd0;
	end
	else begin
		case(cs)
			split_1 : begin
				if(TABLE5[2][2][4] == 1'd1) begin
					HC5 <= {HC5[6:0],1'b0};
					M5  <= {M5[6:0],1'b1};
				end
				else if(TABLE5[1][2][4] == 1'd1) begin
					HC5 <= {HC5[6:0],1'b1};
					M5  <= {M5[6:0],1'b1};
				end
			end

			split_2 : begin
				if(TABLE4[2][2][4] == 1'd1) begin
					HC5 <= {HC5[6:0],1'b0};
					M5  <= {M5[6:0],1'b1};
				end
				else if(TABLE4[1][2][4] == 1'd1) begin
					HC5 <= {HC5[6:0],1'b1};
					M5  <= {M5[6:0],1'b1};
				end
				else begin
					HC5 <= HC5;
					M5  <= M5;
				end
			end
			split_3 : begin
				if(TABLE3[2][2][4] == 1'd1) begin
					HC5 <= {HC5[6:0],1'b0};
					M5  <= {M5[6:0],1'b1};
				end
				else if(TABLE3[1][2][4] == 1'd1) begin
					HC5 <= {HC5[6:0],1'b1};
					M5  <= {M5[6:0],1'b1};
				end
				else begin
					HC5 <= HC5;
					M5  <= M5;
				end
			end
			split_4 : begin
				if(TABLE2[2][2][4] == 1'd1) begin
					HC5 <= {HC5[6:0],1'b0};
					M5  <= {M5[6:0],1'b1};
				end
				else if(TABLE2[1][2][4] == 1'd1) begin
					HC5 <= {HC5[6:0],1'b1};
					M5  <= {M5[6:0],1'b1};
				end
				else begin
					HC5 <= HC5;
					M5  <= M5;
				end
			end
			split_5 : begin
				if(TABLE1[2][2][4] == 1'd1) begin
					HC5 <= {HC5[6:0],1'b0};
					M5  <= {M5[6:0],1'b1};
				end
				else if(TABLE1[1][2][4] == 1'd1) begin
					HC5 <= {HC5[6:0],1'b1};
					M5  <= {M5[6:0],1'b1};
				end
				else begin
					HC5 <= HC5;
					M5  <= M5;
				end
			end
		endcase
	end
end



/////////symbol6 split////////
always@(posedge clk) begin
	if(reset) begin
		HC6 <= 8'd0;
		M6  <= 8'd0;
	end
	else begin
		case(cs)
			split_1 : begin
				if(TABLE5[2][2][5] == 1'd1) begin
					HC6 <= {HC6[6:0],1'b0};
					M6  <= {M6[6:0],1'b1};
				end
				else if(TABLE5[1][2][5] == 1'd1) begin
					HC6 <= {HC6[6:0],1'b1};
					M6  <= {M6[6:0],1'b1};
				end
			end

			split_2 : begin
				if(TABLE4[2][2][5] == 1'd1) begin
					HC6 <= {HC6[6:0],1'b0};
					M6  <= {M6[6:0],1'b1};
				end
				else if(TABLE4[1][2][5] == 1'd1) begin
					HC6 <= {HC6[6:0],1'b1};
					M6  <= {M6[6:0],1'b1};
				end
				else begin
					HC6 <= HC6;
					M6  <= M6;
				end
			end
			split_3 : begin
				if(TABLE3[2][2][5] == 1'd1) begin
					HC6 <= {HC6[6:0],1'b0};
					M6  <= {M6[6:0],1'b1};
				end
				else if(TABLE3[1][2][5] == 1'd1) begin
					HC6 <= {HC6[6:0],1'b1};
					M6  <= {M6[6:0],1'b1};
				end
				else begin
					HC6 <= HC6;
					M6  <= M6;
				end
			end
			split_4 : begin
				if(TABLE2[2][2][5] == 1'd1) begin
					HC6 <= {HC6[6:0],1'b0};
					M6  <= {M6[6:0],1'b1};
				end
				else if(TABLE2[1][2][5] == 1'd1) begin
					HC6 <= {HC6[6:0],1'b1};
					M6  <= {M6[6:0],1'b1};
				end
				else begin
					HC6 <= HC6;
					M6  <= M6;
				end
			end
			split_5 : begin
				if(TABLE1[2][2][5] == 1'd1) begin
					HC6 <= {HC6[6:0],1'b0};
					M6  <= {M6[6:0],1'b1};
				end
				else if(TABLE1[1][2][5] == 1'd1) begin
					HC6 <= {HC6[6:0],1'b1};
					M6  <= {M6[6:0],1'b1};
				end
				else begin
					HC6 <= HC6;
					M6  <= M6;
				end
			end
		endcase
	end
end

//wire [7:0] T5_2,T5_1,  T4_3,T4_2,T4_1, T3_4,T3_3,T3_2,T3_1, T2_5,T2_4,T2_3,T2_2,T2_1, T1_6,T1_5,T1_4,T1_3,T1_2,T1_1;
//wire [7:0] temp_1,temp_2,temp_3,temp_4,temp_5,temp_6;
//
//assign T5_2 = TABLE5[2][2];
//assign T5_1 = TABLE5[1][2];
//
//
//assign T4_3 = TABLE4[3][2];
//assign T4_2 = TABLE4[2][2];
//assign T4_1 = TABLE4[1][2];
//
//
//assign T3_4 = TABLE3[4][2];
//assign T3_3 = TABLE3[3][2];
//assign T3_2 = TABLE3[2][2];
//assign T3_1 = TABLE3[1][2];
//
//
//
//assign T2_5 = TABLE2[5][2];
//assign T2_4 = TABLE2[4][2];
//assign T2_3 = TABLE2[3][2];
//assign T2_2 = TABLE2[2][2];
//assign T2_1 = TABLE2[1][2];
//
//
//
//assign T1_6 = TABLE1[6][2];
//assign T1_5 = TABLE1[5][2];
//assign T1_4 = TABLE1[4][2];
//assign T1_3 = TABLE1[3][2];
//assign T1_2 = TABLE1[2][2];
//assign T1_1 = TABLE1[1][2];
//
//assign temp_6 = temp[6][2];
//assign temp_5 = temp[5][2];
//assign temp_4 = temp[4][2];
//assign temp_3 = temp[3][2];
//assign temp_2 = temp[2][2];
//assign temp_1 = temp[1][2];

endmodule

