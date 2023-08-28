////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_receive_01b
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_RCV_01B_SV
`define SRL_RCV_01B_SV
class serial_receive_01b extends serial_base_virtual_sequence;
	`uvm_object_utils(serial_receive_01b)

	function new(string name = "serial_receive_01b");
		super.new(name);
	endfunction

	virtual task body();
		int length = 0;
		int pre_ri_num_1 = 0;
		int pre_ri_num_2 = 0;
		int pre_err_num = 0;
		int pre_ri_num = 0;
		int pre_e_num = 0;
		int pkt_num = 0;

		super.body();
		srl_if.srl_wait_rst();

		pre_ri_num_1 = 80;
		pre_ri_num_2 = 50;
		pre_err_num = 60;

		for(int i=0;i<pre_ri_num_1;i++)begin
			length = $urandom_range(3,15);
			`uvm_do_on_with(srl_smk_seq,p_sequencer.srl_sqr,{inter_length == length;
																pre == 8'h55;
																sig > 0;
																dat >= 0;
																dat != 8'h55;
																m_number > 0;
																})
			pre_ri_num++;
			pkt_num++;
		end

		for(int i=0;i<pre_err_num;i++)begin
			length = $urandom_range(3,15);
			`uvm_do_on_with(srl_smk_seq,p_sequencer.srl_sqr,{inter_length == length;
																pre != 8'h55;
																sig > 0;
																dat >= 0;
																dat != 8'h55;
																m_number > 0;
																})
			pre_e_num++;
			pkt_num++;
		end

		for(int i=0;i<pre_ri_num_2;i++)begin
			length = $urandom_range(3,15);
			`uvm_do_on_with(srl_smk_seq,p_sequencer.srl_sqr,{inter_length == length;
																pre == 8'h55;
																sig > 0;
																dat >= 0;
																dat != 8'h55;
																m_number > 0;
																})
			pre_ri_num++;
			pkt_num++;
		end

		#200;

		$display("\t######################################################");
		$display("\t\t\tPRE_VALID_SIG_VALID 's NUM is [ %0d ]",pre_ri_num);
		$display("\t\t\tPRE_INVALID 's NUM is [ %0d ]",pre_e_num);
		$display("\t\t\tALL_FRAME_NUM is [ %0d ]",pkt_num);
		$display("\t######################################################");


	endtask

endclass
`endif
