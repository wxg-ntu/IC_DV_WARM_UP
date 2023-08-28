////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_rx_monitor
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_RX_MON_SV
`define SRL_RX_MON_SV
class serial_rx_monitor extends uvm_monitor;
	`uvm_component_utils(serial_rx_monitor)

	virtual serial_if srl_if;

	uvm_analysis_port#(serial_rx_transaction) srl_rx_collect_port;

	function new(string name = "serial_rx_monitor",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);

endclass

function void serial_rx_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	srl_rx_collect_port = new("srl_rx_collect_port",this);
endfunction

function void serial_rx_monitor::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(!uvm_config_db#(virtual serial_if)::get(this,"","srl_if",srl_if))
		`uvm_error(get_type_name(),"NO VIF is set to this rx_monitor!")
endfunction

task serial_rx_monitor::run_phase(uvm_phase phase);
	serial_rx_transaction srl_rx_trans_s,srl_rx_trans_r;
	super.run_phase(phase);
	forever begin
		@(srl_if.clk_b);
				if(srl_if.s_err === 1'b1)begin
					@(srl_if.clk_b);
					if(srl_if.s_err === 1'b1)begin
						srl_rx_trans_s = serial_rx_transaction::type_id::create("srl_rx_trans_s");
						srl_rx_trans_s.s_err = 1'b1;
						srl_rx_collect_port.write(srl_rx_trans_s);
					end
				end
				if(srl_if.r_done === 1'b1)begin
					srl_rx_trans_r = serial_rx_transaction::type_id::create("srl_rx_trans_r");
					srl_rx_trans_r.data_out = srl_if.data_out;
					srl_rx_trans_r.p_err = srl_if.p_err? 1'b1 : 1'b0;
					srl_rx_trans_r.r_done = 1'b1;
					srl_rx_trans_r.s_err = 1'b0;
					srl_rx_collect_port.write(srl_rx_trans_r);
				end
	end
endtask
`endif
