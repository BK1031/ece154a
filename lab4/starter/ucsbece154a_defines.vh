// ucsbece154a_defines.vh
// All Rights Reserved
// Copyright (c) 2023 UCSB ECE
// Distribution Prohibited


// ALU Control Codes
localparam    [2:0] ALUcontrol_add = 3'b000;
localparam    [2:0] ALUcontrol_sub = 3'b001;
localparam    [2:0] ALUcontrol_and = 3'b010;
localparam    [2:0] ALUcontrol_or  = 3'b011;
localparam    [2:0] ALUcontrol_slt = 3'b101;

// ALU op codes
localparam    [1:0] ALUop_mem   = 2'b00;
localparam    [1:0] ALUop_beq   = 2'b01;
localparam    [1:0] ALUop_other = 2'b10;


// Result Src mux
localparam    [1:0] ResultSrc_load = 2'b01;
localparam    [1:0] ResultSrc_ALU  = 2'b00;
localparam    [1:0] ResultSrc_jal  = 2'b10;
localparam    [1:0] ResultSrc_lui  = 2'b11;


// ALU Src
localparam          ALUSrc_reg = 1'b0;
localparam          ALUSrc_imm = 1'b1;


// Extend Unit (Imm Src code)
localparam    [2:0] imm_Itype = 3'b000;
localparam    [2:0] imm_Stype = 3'b001;
localparam    [2:0] imm_Btype = 3'b010;
localparam    [2:0] imm_Jtype = 3'b011;
localparam    [2:0] imm_Utype = 3'b100;


// Instruction Funct3 Codes
localparam    [2:0] instr_addsub_funct3 = 3'b000; 
localparam    [2:0] instr_slt_funct3    = 3'b010;  
localparam    [2:0] instr_or_funct3     = 3'b110;  
localparam    [2:0] instr_and_funct3    = 3'b111;  


// Instruction Op Codes
localparam    [6:0] instr_Rtype_op    = 7'b0110011;
localparam    [6:0] instr_lw_op       = 7'b0000011;
localparam    [6:0] instr_sw_op       = 7'b0100011;
localparam    [6:0] instr_jal_op      = 7'b1101111;
localparam    [6:0] instr_beq_op      = 7'b1100011;
localparam    [6:0] instr_ItypeALU_op = 7'b0010011;
localparam    [6:0] instr_lui_op      = 7'b0110111;



