module huffman(clk, reset,gray_data , gray_valid, CNT_valid, CNT1, CNT2, CNT3, CNT4, CNT5, CNT6,
    code_valid, HC1, HC2, HC3, HC4, HC5, HC6,M1, M2, M3, M4, M5, M6 );

input clk;
input reset;
input gray_valid;
input [7:0] gray_data;
output reg CNT_valid;	
output reg [7:0] CNT1, CNT2, CNT3, CNT4, CNT5, CNT6;
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
parameter insert_ini_5   = 5'd22;  //
parameter split_1        = 5'd23;  //
parameter split_5        = 5'd24;  //
parameter code_valid_OUT = 5'd25;  //結束狀態

//============================================
reg [4:0] cs,ns;
reg ini_sort_3_finish,insert_3_finish,insert_1_finish,insert_2_finish;

//sorting module//////
wire com_out_1;
wire equal_signal_1;
wire com1_is_zero_1;
wire com2_is_zero_1;
wire [6:0] merge_cnt;
wire [5:0] merge_index;
wire [6:0] which_one_have_be_put,  the_inverse_one_have_be_put;
wire [5:0] which_index_have_be_put, the_inverse_index_have_be_put;
wire which_reg_should_be_replaced;
wire split_finish; 

/////
reg [6:0] com_in1,com_in2;
reg [5:0] TABLE_idx [6:1];
reg [6:0] temp_cnt  [6:1];
reg [5:0] temp_idx  [6:1];



wire [6:0] merge_cnt_1,merge_cnt_2;
wire [5:0] merge_index_1,merge_index_2;



////判斷邏輯////共用部分////
reg [5:0] com_index_2,com_index_1;
//com_set_1////
assign com_out_1 = (com_in1 < com_in2);
assign equal_signal_1 = (com_in1 == com_in2);
assign com_index = (com_index_1 < com_index_2);//機率一樣時，大的放下面
assign com1_is_zero_1 = !(|com_index_1);//1代表全0,0代表有一
assign com2_is_zero_1 = !(|com_index_2);//1代表全0,0代表有一，用index比較是怕測資有任一symbol都沒有出現

////找出兩個比較項中，出現次數比較小的項目;若相等，則找出index較大的項目
assign which_one_have_be_put = (equal_signal_1)? ((com_index)?com_in2:com_in1) :((com_out_1)?com_in1:com_in2);
assign which_index_have_be_put = (equal_signal_1)? ((com_index)?com_index_2:com_index_1) :((com_out_1)?com_index_1:com_index_2);
////在ini_sort_2_1_1及2_2_1中，記憶哪一個reg該被大的覆蓋，若1代表覆蓋com_in1代表的TABLE1暫存。反之亦然
assign which_reg_should_be_replaced = (equal_signal_1)? (!(com_index)) :((com_out_1));


////找出兩個比較項中，出現次數比較大的項目;若相等，則找出index較小的項目
assign the_inverse_one_have_be_put = (equal_signal_1)? ((com_index)?com_in1:com_in2) :((com_out_1)?com_in2:com_in1);
assign the_inverse_index_have_be_put = (equal_signal_1)? ((com_index)?com_index_1:com_index_2) :((com_out_1)?com_index_2:com_index_1);

assign merge_cnt = temp_cnt[1] + temp_cnt[2];
assign merge_index = temp_idx[1] | temp_idx[2];



parameter symbol1 		= 6'b000001;
parameter symbol2 		= 6'b000010;
parameter symbol3 		= 6'b000100;
parameter symbol4 		= 6'b001000;
parameter symbol5 		= 6'b010000;
parameter symbol6 		= 6'b100000;

// =========================================== INDEX ==========================================
	//  - FSM done
	//  - CNT_valid
	//  - CNT1~6
	//  - code_valid
	//  - com_in1 & 2 com_index_1 & 2
	//  - merge cnt1&2 merge idx 1& 2
	//  - ini_sort_3_finish
	//  - insert_1_finish
	//  - insert_2_finish
	//  - insert_3_finish
	//  - temp_cnt & temp_idx 
	//  - symbol split
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
			ns = insert_ini_5;

		insert_ini_5 :
			ns = split_1;
		
		split_1: begin
			if(split_finish) begin
				ns = split_5;
			end
			else begin
				ns = split_1;
			end
		end

		split_5:
			ns = code_valid_OUT;
		code_valid_OUT:
			ns = code_valid_OUT;

		default : begin
			ns = idle;
		end				//寫滿狀態面積小
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
  //CNT1-6
//reg [7:0] cnt_sel;        // 送進唯一 adder 的 operand
//wire [7:0] cnt_inc;       // adder 輸出
//assign    cnt_inc = cnt_sel + 8'd1;   // <<< 只出現這一次加法 !!!
//
///* ========= combinational：決定要加哪顆 ========= */
//always @(*) begin
//    case (gray_data[2:0])          // gray_data 只在 1~6 時會用到
//        3'd1: cnt_sel = CNT1;
//        3'd2: cnt_sel = CNT2;
//        3'd3: cnt_sel = CNT3;
//        3'd4: cnt_sel = CNT4;
//        3'd5: cnt_sel = CNT5;
//        3'd6: cnt_sel = CNT6;
//        default: cnt_sel = 8'd0;     // 非法時隨便給 0，不影響功能
//    endcase
//end

always@(posedge clk) begin
	if (reset) begin
		CNT1 <= 8'd0;
		CNT2 <= 8'd0;
		CNT3 <= 8'd0;
		CNT4 <= 8'd0;
		CNT5 <= 8'd0;
		CNT6 <= 8'd0;
		TABLE_idx[1] <= 6'd0;
		TABLE_idx[2] <= 6'd0;
		TABLE_idx[3] <= 6'd0;
		TABLE_idx[4] <= 6'd0;
		TABLE_idx[5] <= 6'd0;
		TABLE_idx[6] <= 6'd0;
	end
	else if (gray_valid)
		case(gray_data[2:0]) 
		3'd1 : CNT1 <= CNT1 + 1;
		3'd2 : CNT2 <= CNT2 + 1;
		3'd3 : CNT3 <= CNT3 + 1;
		3'd4 : CNT4 <= CNT4 + 1;
		3'd5 : CNT5 <= CNT5 + 1;
		3'd6 : CNT6 <= CNT6 + 1;
		endcase


	if(cs == insert_1 || cs == insert_2 || cs == insert_3 || cs == insert_4) begin
		if(com1_is_zero_1 && !com2_is_zero_1) begin //代表合併項已經被放入temp_idx、_cnt，CNT6:2直接右移，CNT2要放進temp_cnt2
			CNT6[6:0]    <= 7'd0;
			TABLE_idx[6] <= 6'd0;
			CNT5[6:0]    <= CNT6[6:0];
			TABLE_idx[5] <= TABLE_idx[6];
			CNT4[6:0]    <= CNT5[6:0];
			TABLE_idx[4] <= TABLE_idx[5];
			CNT3[6:0]    <= CNT4[6:0];
			TABLE_idx[3] <= TABLE_idx[4];
			CNT2[6:0]    <= CNT3[6:0];
			TABLE_idx[2] <= TABLE_idx[3];
		end
		else if ((!com1_is_zero_1 && com2_is_zero_1) || equal_signal_1 || com_out_1) begin
			 //第一個判斷代表temp6:2已全被放到temp_idx、_cnt裡面，直接把CNT1丟去temp_idx、_cnt並更新為0就好,下一周期就會觸發判斷全0
			 //第二個判斷代表CNT1和CNT2皆不是0並相等，直接把合併後的項CNT1丟進去temp_idx、_cnt並且把CNT1更新為0(此處描述temp暫存器故僅更新為0)
			 //第三個判斷代表若CNT1<CNT2且都不是0，把CNT1的項丟進去temp_idx、_cnt並更新為0
			CNT1[6:0] <= 7'd0;
			TABLE_idx[1] <= 6'd0;
		end
		else if (!com_out_1) begin //代表若CNT1>CNT2且都不是0，把temp[2]放進tempcnt並右移CNT6:2
			CNT6[6:0] <= 7'd0;
			TABLE_idx[6] <= 6'd0;
			CNT5[6:0]    <= CNT6[6:0]   ;
			TABLE_idx[5] <= TABLE_idx[6];
			CNT4[6:0]    <= CNT5[6:0]   ;
			TABLE_idx[4] <= TABLE_idx[5];
			CNT3[6:0]    <= CNT4[6:0]   ;
			TABLE_idx[3] <= TABLE_idx[4];
			CNT2[6:0]    <= CNT3[6:0]   ;
			TABLE_idx[2] <= TABLE_idx[3];
		end
	end

	case(cs)
		ini_sort_2_1_1: begin
			CNT1[6:0] <= which_one_have_be_put; 
			TABLE_idx[1] <= which_index_have_be_put;
		end
		ini_sort_2_1_2: begin
			CNT2[6:0] <= which_one_have_be_put;
			TABLE_idx[2] <= which_index_have_be_put;
			CNT3[6:0] <= the_inverse_one_have_be_put;
			TABLE_idx[3] <= the_inverse_index_have_be_put;
		end
		ini_sort_2_2_1 : begin
			CNT4[6:0] <= which_one_have_be_put;
			TABLE_idx[4] <= which_index_have_be_put;
		end
		ini_sort_2_2_2: begin
			CNT5[6:0]    <= which_one_have_be_put;
			TABLE_idx[5] <= which_index_have_be_put;
			CNT6[6:0]    <= the_inverse_one_have_be_put;
			TABLE_idx[6] <= the_inverse_index_have_be_put;
		end
		ini_sort_3_1 : 
			case(which_reg_should_be_replaced)	
				1'b1 : begin//成立代表temp[1]被放入table1內，故位移temp[3-1]
					CNT3[6:0] <= 7'd0;
					TABLE_idx[3] <= 6'd0;
					CNT2[6:0] <= CNT3[6:0];
					TABLE_idx[2] <= TABLE_idx[3];
					CNT1[6:0] <= CNT2[6:0];
					TABLE_idx[1] <= TABLE_idx[2];
				end
				1'b0 : begin//代表temp [4]被放入table1內，故位移temp[6-4]
					CNT6[6:0] <= 7'd0;
					TABLE_idx[6] <= 6'd0;
					CNT5[6:0] <= CNT6[6:0];
					TABLE_idx[5] <= TABLE_idx[6];
					CNT4[6:0] <= CNT5[6:0];
					TABLE_idx[4] <= TABLE_idx[5];
				end
			endcase
		ini_sort_3_2 : begin
			case(which_reg_should_be_replaced)	
				1'b1 : begin//成立代表temp[1]被放入table1內，故位移temp[3-1]
					CNT3[6:0] <= 7'd0;
					TABLE_idx[3] <= 6'd0;
					CNT2[6:0] <= CNT3[6:0];
					TABLE_idx[2] <= TABLE_idx[3];
					CNT1[6:0] <= CNT2[6:0];
					TABLE_idx[1] <= TABLE_idx[2];
				end
				1'b0 : begin//代表temp [4]被放入table1內，故位移CNT[6-4]
					CNT6[6:0] <= 7'd0;
					TABLE_idx[6] <= 6'd0;
					CNT5[6:0] <= CNT6[6:0];
					TABLE_idx[5] <= TABLE_idx[6];
					CNT4[6:0] <= CNT5[6:0];
					TABLE_idx[4] <= TABLE_idx[5];
				end
			endcase
		end
		ini_sort_3_3 : begin
			case(which_reg_should_be_replaced)	
				1'b1 : begin//成立代表temp[1]被放入table1內，故位移CNT3-1
					CNT3[6:0] <= 7'd0;
					TABLE_idx[3] <= 6'd0;
					CNT2[6:0] <= CNT3[6:0];
					TABLE_idx[2] <= TABLE_idx[3];
					CNT1[6:0] <= CNT2[6:0];
					TABLE_idx[1] <= TABLE_idx[2];
				end
				1'b0 : begin//代表temp [4]被放入table1內，故位移temp[6-4]
					CNT6[6:0] <= 7'd0;
					TABLE_idx[6] <= 6'd0;
					CNT5[6:0] <= CNT6[6:0];
					TABLE_idx[5] <= TABLE_idx[6];
					CNT4[6:0] <= CNT5[6:0];
					TABLE_idx[4] <= TABLE_idx[5];
				end
			endcase
		end
		ini_sort_3_4 : begin
				case(which_reg_should_be_replaced)	
					1'b1 : begin//成立代表temp[1]被放入table1內，故位移temp[3-1]
						CNT3[6:0] <= 7'd0;
						TABLE_idx[3] <= 6'd0;
						CNT2[6:0] <= CNT3[6:0];
						TABLE_idx[2] <= TABLE_idx[3];
						CNT1[6:0] <= CNT2[6:0];
						TABLE_idx[1] <= TABLE_idx[2];
					end
					1'b0 : begin//代表temp [4]被放入table1內，故位移temp[6-4]
						CNT6[6:0] <= 7'd0;
						TABLE_idx[6] <= 6'd0;
						CNT5[6:0] <= CNT6[6:0];
						TABLE_idx[5] <= TABLE_idx[6];
						CNT4[6:0] <= CNT5[6:0];
						TABLE_idx[4] <= TABLE_idx[5];
					end
				endcase
			end
		insert_ini_1 : begin
			CNT1[6:0]    <= merge_cnt;
			TABLE_idx[1] <= merge_index;
			CNT2[6:0]    <= temp_cnt[3];
			TABLE_idx[2] <= temp_idx[3];
			CNT3[6:0]    <= temp_cnt[4];
			TABLE_idx[3] <= temp_idx[4];
			CNT4[6:0]    <= temp_cnt[5];
			TABLE_idx[4] <= temp_idx[5];
			CNT5[6:0]    <= temp_cnt[6];
			TABLE_idx[5] <= temp_idx[6];
			CNT6[6:0]    <= 7'd0;
			TABLE_idx[6] <= 6'd0;
		end
		insert_ini_2 : begin
			CNT1[6:0]    <= merge_cnt;
			TABLE_idx[1] <= merge_index;
			CNT2[6:0]    <= temp_cnt[3];
			TABLE_idx[2] <= temp_idx[3];
			CNT3[6:0]    <= temp_cnt[4];
			TABLE_idx[3] <= temp_idx[4];
			CNT4[6:0]    <= temp_cnt[5];
			TABLE_idx[4] <= temp_idx[5];
			CNT5[6:0]    <= 7'd0;
			TABLE_idx[5] <= 6'd0;
			CNT6[6:0]    <= 7'd0;
			TABLE_idx[6] <= 6'd0;
		end
		insert_ini_3 : begin
			CNT1[6:0]    <= merge_cnt;
			TABLE_idx[1] <= merge_index;
			CNT2[6:0]    <= temp_cnt[3];
			TABLE_idx[2] <= temp_idx[3];
			CNT3[6:0]    <= temp_cnt[4];
			TABLE_idx[3] <= temp_idx[4];
			CNT4[6:0]    <= 7'd0;
			TABLE_idx[4] <= 6'd0;
			CNT5[6:0]    <= 7'd0;
			TABLE_idx[5] <= 6'd0;
			CNT6[6:0]    <= 7'd0;
			TABLE_idx[6] <= 6'd0;
		end
		insert_ini_4 : begin
			CNT1[6:0]    <= merge_cnt;
			TABLE_idx[1] <= merge_index;
			CNT2[6:0]    <= temp_cnt[3];
			TABLE_idx[2] <= temp_idx[3];
			CNT3[6:0]    <= 7'd0;
			TABLE_idx[3] <= 6'd0;
			CNT4[6:0]    <= 7'd0;
			TABLE_idx[4] <= 6'd0;
			CNT5[6:0]    <= 7'd0;
			TABLE_idx[5] <= 6'd0;
			CNT6[6:0]    <= 7'd0;
			TABLE_idx[6] <= 6'd0;
		end
	endcase
end
 
//code valid///////////////
always@(posedge clk) begin
	if (reset) begin
		code_valid <= 1'b0;
	end
	else if(cs == split_5) begin
		code_valid <= 1'b1;
	end
end

///com_in1 and 2 ///com_index
always@(*) begin
case (cs) 
	ini_sort_1_1 : begin
		com_in1 	<= CNT2[6:0];
		com_in2 	<= CNT3[6:0];
		com_index_1 <= symbol2;
		com_index_2 <= symbol3;

		end
	ini_sort_1_2 : begin
		com_in1 	<= CNT5[6:0];
		com_in2 	<= CNT6[6:0];
		com_index_1 <= symbol5;
		com_index_2 <= symbol6;
	end
	ini_sort_2_1_1 : begin
		com_in1 	<= temp_cnt [1];
		com_index_1 <= temp_idx [1];
		com_in2 	<= temp_cnt [2];
		com_index_2 <= temp_idx [2];
	end
	ini_sort_2_1_2 : begin
		com_in1 	<= temp_cnt [1];
		com_index_1 <= temp_idx [1];
		com_in2 	<= temp_cnt [2];
		com_index_2 <= temp_idx [2];
	end
	ini_sort_2_2_1 : begin
		com_in1 	<= temp_cnt [4];
		com_index_1 <= temp_idx [4];
		com_in2 	<= temp_cnt [5];
		com_index_2 <= temp_idx [5];
	end
	ini_sort_2_2_2 : begin
		com_in1 	<= temp_cnt [4];
		com_index_1 <= temp_idx [4];
		com_in2 	<= temp_cnt [5];
		com_index_2 <= temp_idx [5];
	end
	ini_sort_3_1 : begin
		com_in1 	<= CNT1[6:0];
		com_index_1 <= TABLE_idx[1];
		com_in2 	<= CNT4[6:0];
		com_index_2 <= TABLE_idx[4];
	end
	ini_sort_3_2 : begin
		com_in1 	<= CNT1[6:0];
		com_index_1 <= TABLE_idx[1];
		com_in2 	<= CNT4[6:0];
		com_index_2 <= TABLE_idx[4];

	end
	ini_sort_3_3 : begin
		com_in1 	<= CNT1[6:0];
		com_index_1 <= TABLE_idx[1];
		com_in2 	<= CNT4[6:0];
		com_index_2 <= TABLE_idx[4];

	end
	ini_sort_3_4 : begin
		com_in1 	<= CNT1[6:0];
		com_index_1 <= TABLE_idx[1];
		com_in2 	<= CNT4[6:0];
		com_index_2 <= TABLE_idx[4];
	end
	ini_sort_3_5 : begin
		com_in1 	<= CNT1[6:0];
		com_index_1 <= TABLE_idx[1];
		com_in2 	<= CNT4[6:0];
		com_index_2 <= TABLE_idx[4];
	end

	default : begin ///////   insert   階段全都是比較temp[1] & [2]
		com_in1 	<= CNT1[6:0];
		com_index_1 <= TABLE_idx[1];
		com_in2 	<= CNT2[6:0];
		com_index_2 <= TABLE_idx[2];
	end
endcase
end

//ini_sort_3_finish
always@(*) begin
	case(cs)
		ini_sort_3_4: begin
			if(!(|TABLE_idx[1]) || !(|TABLE_idx[4])) begin //先判斷是否兩組比較暫存是否有一組全0,若有拉起結束訊號
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

//insert_1_finish
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

//insert_2_finish
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
		insert_3 :  begin
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

///temp_cnt & temp_idx //
integer i;

always@(posedge clk) begin
	if (reset) begin
		temp_cnt[1] <= 7'd0;
		temp_idx[1]	<= 6'd0;
		temp_cnt[2]	<= 7'd0;
		temp_idx[2]	<= 6'd0;
		temp_cnt[3]	<= 7'd0;
		temp_idx[3]	<= 6'd0;
		temp_cnt[4]	<= 7'd0;
		temp_idx[4]	<= 6'd0;
		temp_cnt[5]	<= 7'd0;
		temp_idx[5]	<= 6'd0;
		temp_cnt[6]	<= 7'd0;
		temp_idx[6]	<= 6'd0;
	end

	else begin
		case (cs)
			ini_sort_1_1 : begin
				temp_cnt[1] <= CNT1[6:0];
				temp_idx[1] <= symbol1;
				temp_cnt[2] <= which_one_have_be_put;
				temp_idx[2] <= which_index_have_be_put;
				temp_cnt[3] <= the_inverse_one_have_be_put;
				temp_idx[3] <= the_inverse_index_have_be_put;
			end
			ini_sort_1_2 : begin
				temp_cnt[4] <= CNT4[6:0];
				temp_idx[4] <= symbol4;
				temp_cnt[5] <= which_one_have_be_put;
				temp_idx[5] <= which_index_have_be_put;
				temp_cnt[6] <= the_inverse_one_have_be_put;
				temp_idx[6] <= the_inverse_index_have_be_put;
			end
			ini_sort_2_1_1 : begin
				if(which_reg_should_be_replaced) begin //若成立代表[1]的被放進temp reg，故用[3]取代
					temp_cnt[1] <= temp_cnt[3];
					temp_idx[1] <= temp_idx[3];
				end
				else begin
					temp_cnt[2] <= temp_cnt[3];
					temp_idx[2] <= temp_idx[3];
				end
			end

			ini_sort_2_2_1 : begin//!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				if(which_reg_should_be_replaced) begin //若成立代表[4]的被放進temp reg，故用[6]取代
					temp_cnt[4] <= temp_cnt[6];
					temp_idx[4] <= temp_idx[6];
				end
				else begin
					temp_cnt[5] <= temp_cnt[6];
					temp_idx[5] <= temp_idx[6];
				end

			end
			ini_sort_3_1 : begin
				temp_cnt[1] <= which_one_have_be_put;
				temp_idx[1] <= which_index_have_be_put;
			end

			ini_sort_3_2 : begin
				temp_cnt[2] <= which_one_have_be_put;
				temp_idx[2] <= which_index_have_be_put;
			end

			ini_sort_3_3 : begin
				temp_cnt[3] <= which_one_have_be_put;
				temp_idx[3] <= which_index_have_be_put;
			end

			ini_sort_3_4 : begin
				if(com1_is_zero_1) begin //先判斷是否兩組比較暫存是否有一組全0,若有把另一邊全輸入到table
					temp_cnt[4] <= CNT4; 
					temp_idx[4] <= TABLE_idx[4];
					temp_cnt[5] <= CNT5; 
					temp_idx[5] <= TABLE_idx[5];
					temp_cnt[6] <= CNT6; 
					temp_idx[6] <= TABLE_idx[6];
				end

				else if (com2_is_zero_1) begin
					temp_cnt[4] <= CNT1; 
					temp_idx[4] <= TABLE_idx[1];
					temp_cnt[5] <= CNT2; 
					temp_idx[5] <= TABLE_idx[2];
					temp_cnt[6] <= CNT3; 
					temp_idx[6] <= TABLE_idx[3];

				end

				else begin //若無則正常排序
					temp_cnt[4] <= which_one_have_be_put;
					temp_idx[4] <= which_index_have_be_put;
				end
			end


			ini_sort_3_5 : begin
				temp_cnt[5] <= which_one_have_be_put;
				temp_idx[5] <= which_index_have_be_put;
				temp_cnt[6] <= the_inverse_one_have_be_put;
				temp_idx[6] <= the_inverse_index_have_be_put;
			end
			insert_1 : begin
				temp_cnt[6] <= 7'd0;
				temp_idx[6] <= 6'd0;

				if(com1_is_zero_1 && com2_is_zero_1)begin //若兩邊都是0，則該回合不做事等待下一狀態
					temp_cnt[5] <= temp_cnt[5];
					temp_idx[5] <= temp_idx[5];
					temp_cnt[4] <= temp_cnt[4];
					temp_idx[4] <= temp_idx[4];
					temp_cnt[3] <= temp_cnt[3];
					temp_idx[3] <= temp_idx[3];
					temp_cnt[2] <= temp_cnt[2];
					temp_idx[2] <= temp_idx[2];
					temp_cnt[1] <= temp_cnt[1];
					temp_idx[1] <= temp_idx[1];
				end

				else begin
					if(com1_is_zero_1 && !com2_is_zero_1)begin
						temp_cnt[5] <= CNT2[6:0];
						temp_idx[5] <= TABLE_idx[2];
					end
					else if(!com1_is_zero_1 && com2_is_zero_1) begin
						temp_cnt[5] <= CNT1[6:0];
						temp_idx[5] <= TABLE_idx[1];
					end
					else begin
						if (equal_signal_1)begin		////////////////////////
							temp_cnt[5] <= merge_cnt;	//MODIFY HERE !!!!!!!!//
							temp_idx[5] <= merge_index;	////////////////////////
						end	

						else begin
							temp_cnt[5] <= which_one_have_be_put;
							temp_idx[5] <= which_index_have_be_put;
						end
					end
					temp_cnt[4] <= temp_cnt[5];
					temp_idx[4] <= temp_idx[5];
					temp_cnt[3] <= temp_cnt[4];
					temp_idx[3] <= temp_idx[4];//右移，這邊之後改for寫法
					temp_cnt[2] <= temp_cnt[3];
					temp_idx[2] <= temp_idx[3];
					temp_cnt[1] <= temp_cnt[2];
					temp_idx[1] <= temp_idx[2];
					end
			end

			insert_2 : begin
				temp_cnt[6] <= 7'd0;
				temp_idx[6] <= 6'd0;
				temp_cnt[5] <= 7'd0;
				temp_idx[5] <= 6'd0;

				if(com1_is_zero_1 && com2_is_zero_1)begin
					temp_cnt[4] <= temp_cnt[4];
					temp_idx[4] <= temp_idx[4];
					temp_cnt[3] <= temp_cnt[3];
					temp_idx[3] <= temp_idx[3];
					temp_cnt[2] <= temp_cnt[2];
					temp_idx[2] <= temp_idx[2];
					temp_cnt[1] <= temp_cnt[1];
					temp_idx[1] <= temp_idx[1];
				end

				else begin
					if(com1_is_zero_1 && !com2_is_zero_1)begin
						temp_cnt[4] <= CNT2[6:0];
						temp_idx[4] <= TABLE_idx[2];
					end
					else if(!com1_is_zero_1 && com2_is_zero_1) begin
						temp_cnt[4] <= CNT1[6:0];
						temp_idx[4] <= TABLE_idx[1];
					end
					else begin
						if(equal_signal_1)begin			  ////////////////////////
							temp_cnt[4] <= merge_cnt;	  //MODIFY HERE !!!!!!!!//
							temp_idx[4] <= merge_index;   ////////////////////////
						end

						else begin
							temp_cnt[4] <= which_one_have_be_put;
							temp_idx[4] <= which_index_have_be_put;
						end
					end
					temp_cnt[3] <= temp_cnt[4];
					temp_idx[3] <= temp_idx[4];
					temp_cnt[2] <= temp_cnt[3];
					temp_idx[2] <= temp_idx[3];
					temp_cnt[1] <= temp_cnt[2];
					temp_idx[1] <= temp_idx[2];
				end
			end

			insert_3 : begin
				temp_cnt[6] <= 7'd0;
				temp_idx[6] <= 6'd0;
				temp_cnt[5] <= 7'd0;
				temp_idx[5] <= 6'd0;
				temp_cnt[4] <= 7'd0;
				temp_idx[4] <= 6'd0;
				if(com1_is_zero_1 && com2_is_zero_1)begin
					temp_cnt[3] <= temp_cnt[3];
					temp_idx[3] <= temp_idx[3];
					temp_cnt[2] <= temp_cnt[2];
					temp_idx[2] <= temp_idx[2];
					temp_cnt[1] <= temp_cnt[1];
					temp_idx[1] <= temp_idx[1];
				end


				else begin
					if(com1_is_zero_1 && !com2_is_zero_1)begin
						temp_cnt[3] <= CNT2[6:0];
						temp_idx[3] <= TABLE_idx[2];
					end
					else if(!com1_is_zero_1 && com2_is_zero_1) begin
						temp_cnt[3] <= CNT1[6:0];
						temp_idx[3] <= TABLE_idx[1];
					end
					else begin
						if(equal_signal_1)begin			////////////////////////
							temp_cnt[3] <= merge_cnt;	//MODIFY HERE !!!!!!!!//
							temp_idx[3] <= merge_index;	////////////////////////
						end
						else begin
						temp_cnt[3] <= which_one_have_be_put;
						temp_idx[3] <= which_index_have_be_put;
						end
					end
					temp_cnt[2] <= temp_cnt[3];
					temp_idx[2] <= temp_idx[3];
					temp_cnt[1] <= temp_cnt[2];
					temp_idx[1] <= temp_idx[2];
				end
			end
			insert_4 : begin
				temp_cnt[6] <= 7'd0;
				temp_idx[6] <= 6'd0;
				temp_cnt[5] <= 7'd0;
				temp_idx[5] <= 6'd0;
				temp_cnt[4] <= 7'd0;
				temp_idx[4] <= 6'd0;
				temp_cnt[3] <= 7'd0;
				temp_idx[3] <= 6'd0;
				temp_cnt[1] <= which_one_have_be_put;
				temp_idx[1] <= which_index_have_be_put;
				temp_cnt[2] <= the_inverse_one_have_be_put;
				temp_idx[2] <= the_inverse_index_have_be_put;
			end

		endcase
	end
end




/////////symbol split////////
reg split_1_finish, split_2_finish, split_3_finish, split_4_finish, split_5_finish, split_6_finish;
assign split_finish = split_1_finish && split_2_finish && split_3_finish && split_4_finish && split_5_finish && split_6_finish;

always@(posedge clk) begin
	if(reset) begin
		HC1 <= 8'd0;
		M1  <= 8'd0;
		HC2 <= 8'd0;
		M2  <= 8'd0;
		HC3 <= 8'd0;
		M3  <= 8'd0;
		HC4 <= 8'd0;
		M4  <= 8'd0;
		HC5 <= 8'd0;
		M5  <= 8'd0;
		HC6 <= 8'd0;
		M6  <= 8'd0;
		split_1_finish <= 1'd0;
		split_2_finish <= 1'd0;
		split_3_finish <= 1'd0;
		split_4_finish <= 1'd0;
		split_5_finish <= 1'd0;
		split_6_finish <= 1'd0;

	end
	else begin
		case(cs)
			insert_ini_1: begin
				if(temp_idx[1][0]) begin//若TABLE1最下方第0個BIT是1，HC1編1
					HC1 <= {1'b1,HC1[7:1]};//右移
					M1  <= {1'b1,M1[7:1]};
				end
				else if (temp_idx[2][0]) begin//若TABLE1倒數第二個元素第1個BIT是1，HC2編0
					HC1 <= {1'b0,HC1[7:1]};//右移
					M1  <= {1'b1,M1[7:1]};
				end

				if(temp_idx[1][1]) begin//若TABLE1最下方第0個BIT是1，HC1編1
					HC2 <= {1'b1,HC2[7:1]};//右移
					M2  <= {1'b1,M2[7:1]};
				end
				else if (temp_idx[2][1]) begin//若TABLE1倒數第二個元素第1個BIT是1，HC2編0
					HC2 <= {1'b0,HC2[7:1]};//右移
					M2  <= {1'b1,M2[7:1]};
				end

				if(temp_idx[1][2]) begin//若TABLE1最下方第2個BIT是1，HC3編1
					HC3 <= {1'b1,HC3[7:1]};//右移
					M3  <= {1'b1,M3[7:1]};
				end
				else if (temp_idx[2][2]) begin//若TABLE1倒數第二個元素第2個BIT是1，HC3編0
					HC3 <= {1'b0,HC3[7:1]};//右移
					M3  <= {1'b1,M3[7:1]};
				end

				if(temp_idx[1][3]) begin//若TABLE1最下方第3個BIT是1，HC4編1
					HC4 <= {1'b1,HC4[7:1]};//右移
					M4  <= {1'b1,M4[7:1]};
				end
				else if (temp_idx[2][3]) begin//若TABLE1倒數第二個元素第3個BIT是1，HC4編0
					HC4 <= {1'b0,HC4[7:1]};//右移
					M4  <= {1'b1,M4[7:1]};
				end

				if(temp_idx[1][4]) begin//若TABLE1最下方第4個BIT是1，HC5編1
					HC5 <= {1'b1,HC5[7:1]};//右移
					M5  <= {1'b1,M5[7:1]};
				end
				else if (temp_idx[2][4]) begin//若TABLE1倒數第二個元素第4個BIT是1，HC5編0
					HC5 <= {1'b0,HC5[7:1]};//右移
					M5  <= {1'b1,M5[7:1]};
				end

				if(temp_idx[1][5]) begin//若TABLE1最下方第5個BIT是1，HC6編1
					HC6 <= {1'b1,HC6[7:1]};//右移
					M6  <= {1'b1,M6[7:1]};
				end
				else if (temp_idx[2][5]) begin//若TABLE1倒數第二個元素第5個BIT是1，HC6編0
					HC6 <= {1'b0,HC6[7:1]};//右移
					M6  <= {1'b1,M6[7:1]};
				end

			end

			insert_ini_2: begin
				if(temp_idx[1][0]) begin//若TABLE1最下方第0個BIT是1，HC1編1
					HC1 <= {1'b1,HC1[7:1]};//右移
					M1  <= {1'b1,M1[7:1]};
				end
				else if (temp_idx[2][0]) begin//若TABLE1倒數第二個元素第1個BIT是1，HC2編0
					HC1 <= {1'b0,HC1[7:1]};//右移
					M1  <= {1'b1,M1[7:1]};
				end

				if(temp_idx[1][1]) begin//若TABLE1最下方第0個BIT是1，HC1編1
					HC2 <= {1'b1,HC2[7:1]};//右移
					M2  <= {1'b1,M2[7:1]};
				end
				else if (temp_idx[2][1]) begin//若TABLE1倒數第二個元素第1個BIT是1，HC2編0
					HC2 <= {1'b0,HC2[7:1]};//右移
					M2  <= {1'b1,M2[7:1]};
				end

				if(temp_idx[1][2]) begin//若TABLE1最下方第2個BIT是1，HC3編1
					HC3 <= {1'b1,HC3[7:1]};//右移
					M3  <= {1'b1,M3[7:1]};
				end
				else if (temp_idx[2][2]) begin//若TABLE1倒數第二個元素第2個BIT是1，HC3編0
					HC3 <= {1'b0,HC3[7:1]};//右移
					M3  <= {1'b1,M3[7:1]};
				end

				if(temp_idx[1][3]) begin//若TABLE1最下方第3個BIT是1，HC4編1
					HC4 <= {1'b1,HC4[7:1]};//右移
					M4  <= {1'b1,M4[7:1]};
				end
				else if (temp_idx[2][3]) begin//若TABLE1倒數第二個元素第3個BIT是1，HC4編0
					HC4 <= {1'b0,HC4[7:1]};//右移
					M4  <= {1'b1,M4[7:1]};
				end

				if(temp_idx[1][4]) begin//若TABLE1最下方第4個BIT是1，HC5編1
					HC5 <= {1'b1,HC5[7:1]};//右移
					M5  <= {1'b1,M5[7:1]};
				end
				else if (temp_idx[2][4]) begin//若TABLE1倒數第二個元素第4個BIT是1，HC5編0
					HC5 <= {1'b0,HC5[7:1]};//右移
					M5  <= {1'b1,M5[7:1]};
				end

				if(temp_idx[1][5]) begin//若TABLE1最下方第5個BIT是1，HC6編1
					HC6 <= {1'b1,HC6[7:1]};//右移
					M6  <= {1'b1,M6[7:1]};
				end
				else if (temp_idx[2][5]) begin//若TABLE1倒數第二個元素第5個BIT是1，HC6編0
					HC6 <= {1'b0,HC6[7:1]};//右移
					M6  <= {1'b1,M6[7:1]};
				end

			end

			insert_ini_3: begin
				if(temp_idx[1][0]) begin//若TABLE1最下方第0個BIT是1，HC1編1
					HC1 <= {1'b1,HC1[7:1]};//右移
					M1  <= {1'b1,M1[7:1]};
				end
				else if (temp_idx[2][0]) begin//若TABLE1倒數第二個元素第1個BIT是1，HC2編0
					HC1 <= {1'b0,HC1[7:1]};//右移
					M1  <= {1'b1,M1[7:1]};
				end

				if(temp_idx[1][1]) begin//若TABLE1最下方第0個BIT是1，HC1編1
					HC2 <= {1'b1,HC2[7:1]};//右移
					M2  <= {1'b1,M2[7:1]};
				end
				else if (temp_idx[2][1]) begin//若TABLE1倒數第二個元素第1個BIT是1，HC2編0
					HC2 <= {1'b0,HC2[7:1]};//右移
					M2  <= {1'b1,M2[7:1]};
				end

				if(temp_idx[1][2]) begin//若TABLE1最下方第2個BIT是1，HC3編1
					HC3 <= {1'b1,HC3[7:1]};//右移
					M3  <= {1'b1,M3[7:1]};
				end
				else if (temp_idx[2][2]) begin//若TABLE1倒數第二個元素第2個BIT是1，HC3編0
					HC3 <= {1'b0,HC3[7:1]};//右移
					M3  <= {1'b1,M3[7:1]};
				end

				if(temp_idx[1][3]) begin//若TABLE1最下方第3個BIT是1，HC4編1
					HC4 <= {1'b1,HC4[7:1]};//右移
					M4  <= {1'b1,M4[7:1]};
				end
				else if (temp_idx[2][3]) begin//若TABLE1倒數第二個元素第3個BIT是1，HC4編0
					HC4 <= {1'b0,HC4[7:1]};//右移
					M4  <= {1'b1,M4[7:1]};
				end

				if(temp_idx[1][4]) begin//若TABLE1最下方第4個BIT是1，HC5編1
					HC5 <= {1'b1,HC5[7:1]};//右移
					M5  <= {1'b1,M5[7:1]};
				end
				else if (temp_idx[2][4]) begin//若TABLE1倒數第二個元素第4個BIT是1，HC5編0
					HC5 <= {1'b0,HC5[7:1]};//右移
					M5  <= {1'b1,M5[7:1]};
				end

				if(temp_idx[1][5]) begin//若TABLE1最下方第5個BIT是1，HC6編1
					HC6 <= {1'b1,HC6[7:1]};//右移
					M6  <= {1'b1,M6[7:1]};
				end
				else if (temp_idx[2][5]) begin//若TABLE1倒數第二個元素第5個BIT是1，HC6編0
					HC6 <= {1'b0,HC6[7:1]};//右移
					M6  <= {1'b1,M6[7:1]};
				end

			end

			insert_ini_4: begin
				if(temp_idx[1][0]) begin//若TABLE1最下方第0個BIT是1，HC1編1
					HC1 <= {1'b1,HC1[7:1]};//右移
					M1  <= {1'b1,M1[7:1]};
				end
				else if (temp_idx[2][0]) begin//若TABLE1倒數第二個元素第1個BIT是1，HC2編0
					HC1 <= {1'b0,HC1[7:1]};//右移
					M1  <= {1'b1,M1[7:1]};
				end

				if(temp_idx[1][1]) begin//若TABLE1最下方第0個BIT是1，HC1編1
					HC2 <= {1'b1,HC2[7:1]};//右移
					M2  <= {1'b1,M2[7:1]};
				end
				else if (temp_idx[2][1]) begin//若TABLE1倒數第二個元素第1個BIT是1，HC2編0
					HC2 <= {1'b0,HC2[7:1]};//右移
					M2  <= {1'b1,M2[7:1]};
				end

				if(temp_idx[1][2]) begin//若TABLE1最下方第2個BIT是1，HC3編1
					HC3 <= {1'b1,HC3[7:1]};//右移
					M3  <= {1'b1,M3[7:1]};
				end
				else if (temp_idx[2][2]) begin//若TABLE1倒數第二個元素第2個BIT是1，HC3編0
					HC3 <= {1'b0,HC3[7:1]};//右移
					M3  <= {1'b1,M3[7:1]};
				end

				if(temp_idx[1][3]) begin//若TABLE1最下方第3個BIT是1，HC4編1
					HC4 <= {1'b1,HC4[7:1]};//右移
					M4  <= {1'b1,M4[7:1]};
				end
				else if (temp_idx[2][3]) begin//若TABLE1倒數第二個元素第3個BIT是1，HC4編0
					HC4 <= {1'b0,HC4[7:1]};//右移
					M4  <= {1'b1,M4[7:1]};
				end

				if(temp_idx[1][4]) begin//若TABLE1最下方第4個BIT是1，HC5編1
					HC5 <= {1'b1,HC5[7:1]};//右移
					M5  <= {1'b1,M5[7:1]};
				end
				else if (temp_idx[2][4]) begin//若TABLE1倒數第二個元素第4個BIT是1，HC5編0
					HC5 <= {1'b0,HC5[7:1]};//右移
					M5  <= {1'b1,M5[7:1]};
				end

				if(temp_idx[1][5]) begin//若TABLE1最下方第5個BIT是1，HC6編1
					HC6 <= {1'b1,HC6[7:1]};//右移
					M6  <= {1'b1,M6[7:1]};
				end
				else if (temp_idx[2][5]) begin//若TABLE1倒數第二個元素第5個BIT是1，HC6編0
					HC6 <= {1'b0,HC6[7:1]};//右移
					M6  <= {1'b1,M6[7:1]};
				end

			end

			insert_ini_5 : begin
				if(temp_idx[1][0]) begin//若TABLE1最下方第0個BIT是1，HC1編1
					HC1 <= {1'b1,HC1[7:1]};//右移
					M1  <= {1'b1,M1[7:1]};
				end
				else if (temp_idx[2][0]) begin//若TABLE1倒數第二個元素第1個BIT是1，HC2編0
					HC1 <= {1'b0,HC1[7:1]};//右移
					M1  <= {1'b1,M1[7:1]};
				end

				if(temp_idx[1][1]) begin//若TABLE1最下方第0個BIT是1，HC1編1
					HC2 <= {1'b1,HC2[7:1]};//右移
					M2  <= {1'b1,M2[7:1]};
				end
				else if (temp_idx[2][1]) begin//若TABLE1倒數第二個元素第1個BIT是1，HC2編0
					HC2 <= {1'b0,HC2[7:1]};//右移
					M2  <= {1'b1,M2[7:1]};
				end

				if(temp_idx[1][2]) begin//若TABLE1最下方第2個BIT是1，HC3編1
					HC3 <= {1'b1,HC3[7:1]};//右移
					M3  <= {1'b1,M3[7:1]};
				end
				else if (temp_idx[2][2]) begin//若TABLE1倒數第二個元素第2個BIT是1，HC3編0
					HC3 <= {1'b0,HC3[7:1]};//右移
					M3  <= {1'b1,M3[7:1]};
				end

				if(temp_idx[1][3]) begin//若TABLE1最下方第3個BIT是1，HC4編1
					HC4 <= {1'b1,HC4[7:1]};//右移
					M4  <= {1'b1,M4[7:1]};
				end
				else if (temp_idx[2][3]) begin//若TABLE1倒數第二個元素第3個BIT是1，HC4編0
					HC4 <= {1'b0,HC4[7:1]};//右移
					M4  <= {1'b1,M4[7:1]};
				end

				if(temp_idx[1][4]) begin//若TABLE1最下方第4個BIT是1，HC5編1
					HC5 <= {1'b1,HC5[7:1]};//右移
					M5  <= {1'b1,M5[7:1]};
				end
				else if (temp_idx[2][4]) begin//若TABLE1倒數第二個元素第4個BIT是1，HC5編0
					HC5 <= {1'b0,HC5[7:1]};//右移
					M5  <= {1'b1,M5[7:1]};
				end

				if(temp_idx[1][5]) begin//若TABLE1最下方第5個BIT是1，HC6編1
					HC6 <= {1'b1,HC6[7:1]};//右移
					M6  <= {1'b1,M6[7:1]};
				end
				else if (temp_idx[2][5]) begin//若TABLE1倒數第二個元素第5個BIT是1，HC6編0
					HC6 <= {1'b0,HC6[7:1]};//右移
					M6  <= {1'b1,M6[7:1]};
				end
			end


			split_1 : begin
				if(!M1[0]) begin
					HC1 <= {1'b0,HC1[7:1]};//右移塞0
					M1  <= {1'b0,M1[7:1]};//右移塞0
				end
				else if (M1[0])begin
					split_1_finish <= 1'd1;
				end

				if(!M2[0]) begin
					HC2 <= {1'b0,HC2[7:1]};//右移塞0
					M2  <= {1'b0,M2[7:1]};//右移塞0
				end
				else if (M2[0])begin
					split_2_finish <= 1'd1;
				end

				if(!M3[0]) begin
					HC3 <= {1'b0,HC3[7:1]};//右移塞0
					M3  <= {1'b0,M3[7:1]};//右移塞0
				end
				else if (M3[0])begin
					split_3_finish <= 1'd1;
				end

				if(!M4[0]) begin
					HC4 <= {1'b0,HC4[7:1]};//右移塞0
					M4  <= {1'b0,M4[7:1]};//右移塞0
				end
				else if (M4[0])begin
					split_4_finish <= 1'd1;
				end

				if(!M5[0]) begin
					HC5 <= {1'b0,HC5[7:1]};//右移塞0
					M5  <= {1'b0,M5[7:1]};//右移塞0
				end
				else if (M5[0])begin
					split_5_finish <= 1'd1;
				end

				if(!M6[0]) begin
					HC6 <= {1'b0,HC6[7:1]};//右移塞0
					M6  <= {1'b0,M6[7:1]};//右移塞0
				end
				else if (M6[0])begin
					split_6_finish <= 1'd1;
				end
			end
		endcase
	end

end

wire [5:0] TEMP6,TEMP5,TEMP4,TEMP3,TEMP2,TEMP1;
assign TEMP6 = temp_idx[6];
assign TEMP5 = temp_idx[5];
assign TEMP4 = temp_idx[4];
assign TEMP3 = temp_idx[3];
assign TEMP2 = temp_idx[2];
assign TEMP1 = temp_idx[1];

wire [5:0] T6,T5,T4,T3,T2,T1;
assign T6 = TABLE_idx[6];
assign T5 = TABLE_idx[5];
assign T4 = TABLE_idx[4];
assign T3 = TABLE_idx[3];
assign T2 = TABLE_idx[2];
assign T1 = TABLE_idx[1];



endmodule




