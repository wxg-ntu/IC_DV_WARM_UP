////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_base_virtual_sequence
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_BASE_V_SEQ_SV
`define SRL_BASE_V_SEQ_SV
class serial_base_virtual_sequence extends uvm_sequence;
	`uvm_object_utils(serial_base_virtual_sequence)
	`uvm_declare_p_sequencer(serial_virtual_sequencer)

	virtual serial_if srl_if;

	serial_smoke_sequence srl_smk_seq;
	serial_tx_transaction srl_tx_trans;
	
	rand int frame_num;

	constraint cons_frame_num{
		soft frame_num > 0;
	}

	function new(string name = "serial_base_virtual_sequence");
		super.new(name);
	endfunction


	virtual task body();
		this.srl_if = p_sequencer.srl_if;
	endtask
endclass
`endif
