// ucsbece154a_top.v
// All Rights Reserved
// Copyright (c) 2023 UCSB ECE
// Distribution Prohibited


module ucsbece154a_top (
    input clk, reset
);

wire [31:0] pc, instr, readdata;
wire [31:0] writedata, dataadr;
wire        MemWrite;

// processor and memories are instantiated here
ucsbece154a_riscv riscv (
    .clk(clk), .reset(reset),
    .pc_o(pc),
    .instr_i(instr),
    .MemWrite_o(MemWrite),
    .aluresult_o(dataadr), .writedata_o(writedata),
    .readdata_i(readdata)
);
ucsbece154a_imem imem (
    .a_i(pc), .rd_o(instr)
);
ucsbece154a_dmem dmem (
    .clk(clk), .we_i(MemWrite),
    .a_i(dataadr), .wd_i(writedata),
    .rd_o(readdata)
);

endmodule
