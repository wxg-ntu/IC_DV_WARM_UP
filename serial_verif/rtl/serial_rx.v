////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_rx
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
module serial_rx(input clk,rst_n,si,
                 input [5:0]m_num,
                 output s_err,p_err,r_done,
                 output [7:0]data_out);

        parameter PRE_DETECT=0;
		parameter SIG_DETECT=1;
		parameter SIG_COMP=2;
		parameter DATA_DETECT=3;
		parameter PARITY_DETECT=4;

		reg [2:0]state,next_state;
		reg [7:0]rx_data;
		reg [3:0]rx_parity;
		reg s_err_tmp;

		wire stm_pre = (state == PRE_DETECT);
		wire stm_parity = (state == PARITY_DETECT);
		wire stm_sigde = (state == SIG_DETECT);
		wire stm_data = (state == DATA_DETECT);

		wire pre_done;
		wire count_4_done;
		wire count_6_done;
		wire count_8_done;

		reg [5:0]rx_sig;
		wire sig_comp_suc = (state == SIG_COMP) && (rx_sig == m_num);

		seq_detect #(.DSIZE(8),.DTECT(85)) U_SEQ_DETECT(clk,rst_n,stm_pre,si,pre_done);
		counter #(.NUM_RST(0),.END(3)) U_COUNTER_4(clk,rst_n,stm_parity,count_4_done);
		counter #(.NUM_RST(0),.END(5)) U_COUNTER_6(clk,rst_n,stm_sigde,count_6_done);
		counter #(.NUM_RST(0),.END(6)) U_COUNTER_8(clk,rst_n,stm_data,count_8_done);

		always @(*)begin
			case(state)
				PRE_DETECT:next_state = pre_done? SIG_DETECT:PRE_DETECT;
				SIG_DETECT:next_state = count_6_done? SIG_COMP:SIG_DETECT;
				SIG_COMP  :next_state = sig_comp_suc? DATA_DETECT:PRE_DETECT;
				DATA_DETECT:next_state = count_8_done? PARITY_DETECT:DATA_DETECT;
				PARITY_DETECT:next_state = count_4_done? PRE_DETECT:PARITY_DETECT;
				default:next_state = PRE_DETECT;
			endcase
		end

		always @(posedge clk or negedge rst_n)begin
			if(!rst_n)begin
				state <= PRE_DETECT;
			end
			else begin
				state <= next_state;
			end
		end

		//deal with rx_signature
		always @(posedge clk or negedge rst_n)begin
			if(!rst_n)begin
				rx_sig <= 0;
			end
			else begin
				if((state == SIG_DETECT && !count_6_done) || (state == PRE_DETECT && pre_done))begin
					rx_sig <= {rx_sig[4:0],si};
				end
			end
		end

		//deal with s_err for 2 cycles
		always @(posedge clk or negedge rst_n)begin
			if(!rst_n)begin
				s_err_tmp <= 0;
			end
			else begin
				s_err_tmp <= ((state == SIG_COMP) && (~sig_comp_suc));
			end
		end

		assign s_err = s_err_tmp | ((state == SIG_COMP) && (~sig_comp_suc));

		//deal with rx_data
		always @(posedge clk or negedge rst_n)begin
			if(!rst_n)begin
				rx_data <= 0;
			end
			else begin
				if((state == DATA_DETECT && (!count_8_done)) || state == SIG_COMP || count_6_done)begin
					rx_data <= {rx_data[6:0],si};
				end
			end
		end

		//deal with rx_parity
		always @(posedge clk or negedge rst_n)begin
			if(!rst_n)begin
				rx_parity <= 0;
			end
			else begin
				if(state == PARITY_DETECT)begin
					rx_parity <= {rx_parity[2:0],si};
				end
			end
		end

		assign r_done = count_4_done;
		assign p_err = r_done && (^{rx_data,rx_parity[0]});//even check

		assign data_out = (!rst_n)? 1'b0 : r_done? rx_data:data_out;


endmodule
