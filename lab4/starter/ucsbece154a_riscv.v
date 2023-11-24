// ucsbece154a_mips.v
// All Rights Reserved
// Copyright (c) 2023 UCSB ECE
// Distribution Prohibited


module ucsbece154a_riscv (
    input               clk, reset,
    output wire  [31:0] pc_o,
    input        [31:0] instr_i,
    output wire         MemWrite_o,
    output wire  [31:0] aluresult_o, writedata_o,
    input        [31:0] readdata_i
);

wire [1:0] ResultSrc;
wire [2:0] ImmSrc;
wire PCSrc, ALUSrc, RegWrite, zero;
wire [2:0] ALUControl;

ucsbece154a_controller c (
    .op_i(instr_i[6:0]), .funct3_i(instr_i[14:12]), .funct7b5_i(instr_i[30]), .zero_i(zero),
    .RegWrite_o(RegWrite), 
    .ALUSrc_o(ALUSrc),
    .MemWrite_o(MemWrite_o),
    .ResultSrc_o(ResultSrc),
    .ALUControl_o(ALUControl),
    .PCSrc_o(PCSrc),
    .ImmSrc_o(ImmSrc)
);
ucsbece154a_datapath dp (
    .clk(clk), .reset(reset),
    .RegWrite_i(RegWrite),
    .ImmSrc_i(ImmSrc),
    .ALUSrc_i(ALUSrc),
    .PCSrc_i(PCSrc),
    .ResultSrc_i(ResultSrc),
    .ALUControl_i(ALUControl),
    .zero_o(zero),
    .pc_o(pc_o),
    .instr_i(instr_i),
    .aluresult_o(aluresult_o),
    .writedata_o(writedata_o),
    .readdata_i(readdata_i)
);
endmodule
