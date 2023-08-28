////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_receive_01e
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_RCV_01E_SV
`define SRL_RCV_01E_SV
class serial_receive_01e extends serial_base_virtual_sequence;
	`uvm_object_utils(serial_receive_01e)

	function new(string name = "serial_receive_01e");
		super.new(name);
	endfunction

	virtual task body();
		int par_err_num = 0;
		int par_e_num = 0;
		int length = 0;
		int pkt_num = 0;

		super.body();
		srl_if.srl_wait_rst();

		par_err_num = 200;

		for(int i=0;i<par_err_num;i++)begin
			length = $urandom_range(3,15);
			`uvm_do_on_with(srl_tx_trans,p_sequencer.srl_sqr,{inter_len == length;
																preamble == 8'h55;
																signature == m_num;
																signature > 0;
																data > 0;
																parity[3:1] == '0;
																parity[0] == (^data)?1'b0:1'b1;
																})
			par_e_num++;
			pkt_num++;
		end

		#200;

		$display("\t######################################################");
		$display("\t\t\tPRE_VALID_SIG_VALID_PARITY_FALSE 's NUM is [ %0d ]",par_e_num);
		$display("\t\t\tALL_FRAME_NUM is [ %0d ]",pkt_num);
		$display("\t######################################################");

	endtask
endclass
`endif
