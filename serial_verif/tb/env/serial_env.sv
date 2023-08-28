////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_env
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_ENV_SV
`define SRL_ENV_SV
class serial_env extends uvm_env;
	`uvm_component_utils(serial_env)

	serial_tx_agent srl_tx_agt;
	serial_rx_agent srl_rx_agt;
	serial_scoreboard srl_scb;
	serial_virtual_sequencer srl_vsqr;

	function new(string name = "serial_env",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);

endclass

function void serial_env::build_phase(uvm_phase phase);
	super.build_phase(phase);
	srl_tx_agt = serial_tx_agent::type_id::create("srl_tx_agt",this);
	srl_rx_agt = serial_rx_agent::type_id::create("srl_rx_agt",this);
	srl_scb = serial_scoreboard::type_id::create("srl_scb",this);
	srl_vsqr = serial_virtual_sequencer::type_id::create("srl_vsqr",this);
endfunction

function void serial_env::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	this.srl_tx_agt.srl_tx_mon.srl_tx_collect_port.connect(this.srl_scb.srl_tx_fifo.analysis_export);
	this.srl_rx_agt.srl_rx_mon.srl_rx_collect_port.connect(this.srl_scb.srl_rx_fifo.analysis_export);
	this.srl_vsqr.srl_sqr = this.srl_tx_agt.srl_sqr;
endfunction
`endif
