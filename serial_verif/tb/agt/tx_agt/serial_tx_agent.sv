////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_tx_agent
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_TX_AGT_SV
`define SRL_TX_AGT_SV
class serial_tx_agent extends uvm_agent;
	`uvm_component_utils(serial_tx_agent)

	serial_driver srl_drv;
	serial_tx_monitor srl_tx_mon;
	serial_sequencer srl_sqr;

	function new(string name = "serial_tx_agent",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);

endclass

function void serial_tx_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	srl_drv = serial_driver::type_id::create("srl_drv",this);
	srl_tx_mon = serial_tx_monitor::type_id::create("srl_tx_mon",this);
	srl_sqr = serial_sequencer::type_id::create("srl_sqr",this);
endfunction

function void serial_tx_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	this.srl_drv.seq_item_port.connect(this.srl_sqr.seq_item_export);
endfunction
`endif
