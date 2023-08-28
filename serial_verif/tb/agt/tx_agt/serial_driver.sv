////////////////////////////////////////////////////////////////////
//(c) Copyright 2023/8/9 WXG. All rights reserved
//
// File			: serial_driver
// Project		: Simple Serial Protocol Verification
// Purpose		: Just warm up
// Author		: WU XIGUANG
// Created on	: 2023/8/9
//
//
// Detailed description of the the module included in the file.
//
////////////////////////////////////////////////////////////////////
`ifndef SRL_DRV_SV
`define SRL_DRV_SV
class serial_driver extends uvm_driver#(serial_tx_transaction);
	`uvm_component_utils(serial_driver)

	virtual serial_if srl_if;

	uvm_event start_drv;

	function new(string name = "serial_driver",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	extern virtual task run_phase(uvm_phase phase);

endclass

function void serial_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	start_drv = uvm_event_pool::get_global("start_drv");
endfunction

function void serial_driver::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(!uvm_config_db#(virtual serial_if)::get(this,"","srl_if",srl_if))
		`uvm_error(get_type_name(),"NO VIF is set to this driver!")
endfunction

task serial_driver::run_phase(uvm_phase phase);
	serial_tx_transaction srl_tx_trans;
	serial_tx_transaction srl_debug_tx_trans;

	super.run_phase(phase);
	forever begin
		seq_item_port.get_next_item(srl_tx_trans);
		srl_debug_tx_trans = serial_tx_transaction::type_id::create("srl_debug_tx_trans");
		srl_debug_tx_trans = srl_tx_trans;
		fork
			begin
				@(srl_if.clk_b);
				start_drv.trigger(srl_debug_tx_trans);
			end
			begin//drive m_num
				@(srl_if.clk_b);
				srl_if.m_num <= srl_tx_trans.m_num;
			end
			begin//drive si
				for(int i=7;i>=0;i--)begin//preamble
					@(srl_if.clk_b);
					srl_if.si <= srl_tx_trans.preamble[i];
				end
				for(int j=5;j>=0;j--)begin//signature
					@(srl_if.clk_b);
					srl_if.si <= srl_tx_trans.signature[j];
				end
				for(int m=7;m>=0;m--)begin//data
					@(srl_if.clk_b);
					srl_if.si <= srl_tx_trans.data[m];
				end
				for(int k=3;k>=0;k--)begin//parity
					@(srl_if.clk_b);
					srl_if.si <= srl_tx_trans.parity[k];
				end
				for(int l=0;l<srl_tx_trans.inter_len;l++)begin//inter-frame
					@(srl_if.clk_b);
					srl_if.si <= 1'b0;
				end
			end
		join
		seq_item_port.item_done();
	end
endtask
`endif
