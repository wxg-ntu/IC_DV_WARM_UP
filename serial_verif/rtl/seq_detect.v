////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: seq_detect
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
module seq_detect#(parameter DSIZE=8,DTECT=85)(input clk,rst_n,ena,si,output done_flag);
	reg [DSIZE-1:0] tmp_data;

	assign done_flag = (tmp_data == DTECT);

	always @(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			tmp_data <=  0;
		end
		else begin
			if(ena)begin
				tmp_data <=  {tmp_data[DSIZE-2:0],si};
			end
			else begin
				tmp_data <= 0;
			end
		end
	end

endmodule
