module priorityEn8_3 (
    input      [7:0] in,     // 8 request lines
    output reg [2:0] out    // index of highest set bit
);

    // take the highest set bit 
    always @(*) begin
        casez (in)
            8'b1???????: out = 3'd7;
            8'b01??????: out = 3'd6;
            8'b001?????: out = 3'd5;
            8'b0001????: out = 3'd4;
            8'b00001???: out = 3'd3;
            8'b000001??: out = 3'd2;
            8'b0000001?: out = 3'd1;
            default:     out = 3'd0;
        endcase
    end

endmodule