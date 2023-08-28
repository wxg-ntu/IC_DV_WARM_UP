////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: counter
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
module counter#(parameter NUM_RST = 0,END = 6)(input clk,rst_n,ena,output done_flag);

		reg [2:0]count;

		assign done_flag = (count == END);

        always @(posedge clk or negedge rst_n)begin
                if(!rst_n)begin
                        count <=  NUM_RST;
                end
                else begin
					if(ena)begin
                        if(count == END)begin
                                count <=  NUM_RST;
                        end
                        else begin
                                count <=  count + 1;
                        end
					end
					else begin
						count <= NUM_RST;
					end
                end
        end
endmodule
