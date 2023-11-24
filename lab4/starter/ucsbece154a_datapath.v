// ucsbece154a_datapath.v
// All Rights Reserved
// Copyright (c) 2023 UCSB ECE
// Distribution Prohibited


module ucsbece154a_datapath (
    input               clk, reset,
    input               RegWrite_i,
    input         [2:0] ImmSrc_i,
    input               ALUSrc_i,
    input               PCSrc_i,
    input         [1:0] ResultSrc_i,
    input         [2:0] ALUControl_i,
    output              zero_o,
    output reg   [31:0] pc_o,
    input        [31:0] instr_i,
    output wire  [31:0] aluresult_o, writedata_o,
    input        [31:0] readdata_i
);

`include "ucsbece154a_defines.vh"



/// Your code here

wire [31:0] PCNext, PCPlus4, PCTarget;
reg  [31:0] ImmExt;
wire [31:0] SrcA, SrcB;
reg [31:0] Result;
wire dummy1;
wire dummy2;
assign PCNext = PCSrc_i ? PCTarget : PCPlus4;
assign SrcB = ALUSrc_i ? ImmExt : writedata_o;

always @ * begin
     case (ResultSrc_i)
        2'b00: Result = aluresult_o;
        2'b01: Result = readdata_i;2'b10: Result = PCPlus4;
        2'b11: Result = ImmExt;
        default: Result = 32'b0;
    endcase
end

always @ * begin
     case (ImmSrc_i)
        3'b000: ImmExt = {{20{instr_i[31]}}, instr_i[31:20]};
        3'b001: ImmExt = {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]};
        3'b010: ImmExt = {{20{instr_i[31]}}, instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0};
        3'b011: ImmExt = {{12{instr_i[31]}},instr_i[19:12],instr_i[20],instr_i[30:21],1'b0};
        3'b100: ImmExt = {instr_i[31:12],12'b0};
        default: ImmExt = 32'b0;
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pc_o <= 32'b0;
    end
    else begin
         pc_o <= PCNext;
     end
end

assign PCPlus4 = pc_o + 32'b100;
assign PCTarget = pc_o + ImmExt;

ucsbece154a_alu ALU (
    .a_i(SrcA),
    .b_i(SrcB),
    .alucontrol_i(ALUControl_i),
    .result_o(aluresult_o),
    .zero_o(zero_o)
);

ucsbece154a_rf rf(
    .clk(clk),
    .a1_i(instr_i[19:15]),
    .a2_i(instr_i[24:20]),
    .a3_i(instr_i[11:7]),
    .rd1_o(SrcA),
    .rd2_o(writedata_o),
    .we3_i(RegWrite_i),
    .wd3_i(Result)
);

// Use name "rf" for a register file module so testbench file work properly (or modify testbench file) 


endmodule
