////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_base_sequence
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_BASE_SEQ_SV
`define SRL_BASE_SEQ_SV
class serial_base_sequence extends uvm_sequence#(serial_tx_transaction);
	`uvm_object_utils(serial_base_sequence)

	serial_tx_transaction srl_tx_trans;

	rand int inter_length = -1;
	rand int pre = -1;
	rand int sig = -1;
	rand int dat = -1;
	rand int m_number = -1;
	rand int par = -1;

	function new(string name = "serial_base_sequence");
		super.new(name);
	endfunction

	
	virtual task body();
	endtask


endclass
`endif
