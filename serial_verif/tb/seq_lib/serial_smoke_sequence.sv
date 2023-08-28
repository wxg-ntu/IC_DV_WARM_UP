////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_smoke_sequence
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_SMK_SEQ_SV
`define SRL_SMK_SEQ_SV
class serial_smoke_sequence extends serial_base_sequence;
	`uvm_object_utils(serial_smoke_sequence)

	constraint cons_smk_seq{
		soft pre == -1;
		soft sig == -1;
		soft dat == -1;
		soft m_number == -1;
	}

	function new(string name = "serial_smoke_sequence");
		super.new(name);
	endfunction

	virtual task body();
		super.body();

		srl_tx_trans = new();

		if(inter_length > 0) srl_tx_trans.inter_len = inter_length;
		if(pre >= 0) srl_tx_trans.preamble = pre;
		if(sig >= 0) srl_tx_trans.signature = sig;
		if(dat >= 0) srl_tx_trans.data = dat;
		if(m_number >= 0) srl_tx_trans.m_num = m_number;

		`uvm_send(srl_tx_trans)

	endtask
endclass
`endif
