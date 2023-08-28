////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_tx_monitor
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_TX_MON_SV
`define SRL_TX_MON_SV
class serial_tx_monitor extends uvm_monitor;
	`uvm_component_utils(serial_tx_monitor)

	virtual serial_if srl_if;

	uvm_analysis_port#(serial_tx_transaction) srl_tx_collect_port;

	uvm_event start_drv;

	function new(string name = "serial_tx_monitor",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);

endclass

function void serial_tx_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	srl_tx_collect_port = new("srl_tx_collect_port",this);
	start_drv = uvm_event_pool::get_global("start_drv");
endfunction

function void serial_tx_monitor::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(!uvm_config_db#(virtual serial_if)::get(this,"","srl_if",srl_if))
		`uvm_error(get_type_name(),"NO VIF is set to tx_monitor!")
endfunction

task serial_tx_monitor::run_phase(uvm_phase phase);
	serial_tx_transaction srl_collect_trans;
	serial_tx_transaction srl_clone_trans;
	uvm_object obj;

	super.run_phase(phase);
	forever begin
		start_drv.wait_trigger_data(obj);
		if(!$cast(srl_clone_trans,obj))
			`uvm_error(get_type_name(),"Cast failed!")
		srl_collect_trans = serial_tx_transaction::type_id::create("srl_collect_trans");
		fork
			begin//derive m_num
				@(srl_if.clk_b);
				srl_collect_trans.m_num <= srl_if.m_num;
			end
			begin//derive si
				for(int i=7;i>=0;i--)begin
					@(srl_if.clk_b);
					srl_collect_trans.preamble[i] <= srl_if.si;
				end
				for(int j=5;j>=0;j--)begin
					@(srl_if.clk_b);
					srl_collect_trans.signature[j] <= srl_if.si;
				end
				for(int m=7;m>=0;m--)begin
					@(srl_if.clk_b);
					srl_collect_trans.data[m] <= srl_if.si;
				end
				for(int k=3;k>=0;k--)begin
					@(srl_if.clk_b);
					srl_collect_trans.parity[k] <= srl_if.si;
				end
				srl_collect_trans.inter_len = 0;
				for(int l=0;l<srl_clone_trans.inter_len;l++)begin
					@(srl_if.clk_b);
					if(srl_if.si == 1'b0) srl_collect_trans.inter_len++;
				end
			end
		join
		srl_tx_collect_port.write(srl_collect_trans);
	end
endtask
`endif
