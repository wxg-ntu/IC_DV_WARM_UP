////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_receive_01a
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_RCV_01A_SV
`define SRL_RCV_01A_SV
class serial_receive_01a extends serial_base_virtual_sequence;
	`uvm_object_utils(serial_receive_01a)

	function new(string name = "serial_receive_01a");
		super.new(name);
	endfunction

	virtual task body();
		int f_num = 0;
		int length = 3;
		int i = 0;

		super.body();
		`uvm_info(get_type_name(),"\n---------------------------SEQ START--------------------",UVM_LOW)
		srl_if.srl_wait_rst();

		f_num = 50;//set frame_num

		for(i=0;i<f_num;i++)begin
			length = $urandom_range(3,15);
			`uvm_do_on_with(srl_smk_seq,p_sequencer.srl_sqr,{
												inter_length == length;
												pre == 8'h55;
												sig == m_number;
												sig > 0;
												dat > 0;})
		end

		#200;
		$display("\t######################################################");
		$display("\t\t\tPRE_VALID_SIG_VALID 's NUM is [ %0d ]",i);
		$display("\t######################################################");

		`uvm_info(get_type_name(),"\n---------------------------SEQ END  --------------------",UVM_LOW)
	endtask

endclass
`endif
