module alu(input [31:0] a, b,
    input [2:0] f,
    output [31:0] result,
    output zero,
    output overflow,
    output carry,
    output negative);

    reg [31:0] y;
    reg [31:0] z;
    wire [32:0] sum;

    assign sum = a + z;
    assign result = y;
    assign zero = ~|y;

    assign overflow = (a[31] ^ sum[31]) & (f[0] ^ a[31] ^ b[31]) & f[1];
    assign carry = sum[32] & !f[1] & !f[2];
    assign negative = y[31];

    always @(*) begin
        case (f[0])
            1'b0: z = b;
            1'b1: z = ~b + 32'b1;
        endcase
    end

    always @(*) begin
        case (f)
            3'b000: y = sum[31:0];
            3'b001: y = sum[31:0];
            3'b010: y = a & b;
            3'b011: y = a | b;
            3'b101: y = (sum[31] ^ overflow) ? 32'b1 : 32'b0;
            default: y = 32'b0;
        endcase
    end

endmodule
