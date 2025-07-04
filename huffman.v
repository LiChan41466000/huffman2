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
parameter idle    = 4'd0;   // idle
parameter rec     = 4'd1;   //reset 
parameter CNT_OUT = 4'd2;   //send cnt to output
parameter encoding= 4'd3;   // idle
parameter done    = 4'd4;   //reset 


//============================================
reg [3:0] cs,ns;
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
		encoding :
			if (encoding_done) begin
				ns = done;
			end
			else begin 
				ns = encoding;
			end
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


module sorting (cs,clk,reset,CNT1, CNT2, CNT3, CNT4, CNT5, CNT6,sort_finish   );
//process sort and merge algo in ini sort state
//process insertion algo in the following state
//using cs to control
input clk;
input reset;
input cs;
input [7:0] CNT1, CNT2, CNT3, CNT4, CNT5, CNT6;
output sort_finish;

reg [5:0] TABLE1;//table for sort
reg [5:0] TABLE2;//table for sort
reg [5:0] TABLE3;//table for sort
reg [5:0] TABLE4;//table for sort
reg [5:0] TABLE5;//table for sort
reg [5:0] TABLE6;//table for sort



endmodule

