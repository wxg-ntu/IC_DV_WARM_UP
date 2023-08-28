////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_kind_rand_virtual_sequence
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_KIND_RAND_V_SEQ_SV
`define SRL_KIND_RAND_V_SEQ_SV
class serial_kind_rand_virtual_sequence extends serial_base_virtual_sequence;
	`uvm_object_utils(serial_kind_rand_virtual_sequence)

	function new(string name = "serial_kind_rand_virtual_sequence");
		super.new(name);
	endfunction

	virtual task body();
		int pre_err_num = 0;
		int pre_ri_sig_err_num = 0;
		int pre_ri_sig_ri_num = 0;

		int kind_n = 0;
		int length = 3;
		int pkt_num = 0;

		super.body();
		srl_if.srl_wait_rst();

		for(pkt_num=0;pkt_num<$urandom_range(3000,4000);pkt_num++)begin
			kind_n = $urandom_range(1,3);
			case(kind_n)
				1:begin
					length = $urandom_range(3,10);
					`uvm_do_on_with(srl_smk_seq,p_sequencer.srl_sqr,{
																inter_length == length;
																pre == 8'h55;
																sig == m_number;
																sig > 0;
																dat > 0;})
					pre_ri_sig_ri_num++;
				end
				2:begin
					length = $urandom_range(3,10);
					`uvm_do_on_with(srl_smk_seq,p_sequencer.srl_sqr,{
																inter_length == length;
																pre != 8'h55;
																{pre[6:0],sig[5]} != 8'h55;
																{pre[5:0],sig[5:4]} != 8'h55;
																{pre[4:0],sig[5:3]} != 8'h55;
																{pre[3:0],sig[5:2]} != 8'h55;
																{pre[2:0],sig[5:1]} != 8'h55;
																{pre[1:0],sig[5:0]} != 8'h55;
																{pre[0],sig,dat[7]} != 8'h55;
																{sig,dat[7:6]} != 8'h55;
																{sig[4:0],dat[7:5]} != 8'h55;
																{sig[3:0],dat[7:4]} != 8'h55;
																{sig[2:0],dat[7:3]} != 8'h55;
																{sig[1:0],dat[7:2]} != 8'h55;
																{sig[0],dat[7:1]} != 8'h55;//to avoid break_frame
																pre > 0;
																sig > 0;
																dat > 0;
																dat != 8'h55;
																m_number >= 0;})
					pre_err_num++;
				end
				3:begin
					length = $urandom_range(3,10);
					`uvm_do_on_with(srl_smk_seq,p_sequencer.srl_sqr,{
																inter_length == length;
																pre == 8'h55;
																sig != m_number;
																sig > 0;
																m_number > 0;
																dat > 0;
																dat != 8'h55;})
					pre_ri_sig_err_num++;
				end
			endcase
		end

		#200;

		$display("\t######################################################");
		$display("\t\t\tPRE_VALID_SIG_VALID 's NUM is [ %0d ]",pre_ri_sig_ri_num);
		$display("\t\t\tPRE_INVALID 's NUM is [ %0d ]",pre_err_num);
		$display("\t\t\tPRE_VALID_SIG_INVALID 's NUM is [ %0d ]",pre_ri_sig_err_num);
		$display("\t\t\tALL_FRAME_NUM is [ %0d ]",pkt_num);
		$display("\t######################################################");


	endtask

endclass
`endif
