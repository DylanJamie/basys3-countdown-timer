`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2026 11:57:38 AM
// Design Name: 
// Module Name: countdown_timer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module countdown_timer(
    input clk,
    input btnC,
    input btnU,
    input [15:0] sw,
    output reg [15:0] led,
    output reg [6:0] seg,
    output reg [3:0] an
    );
    
    reg [26:0] counter;
    reg [4:0] digit;
    
    always @(posedge clk) begin
        if(sw[0]) begin
            digit <= 9;
            counter <= 0;
        end else if (counter == 100000000) begin
            counter <= 0;
            // Loop back counter
            if (digit == 0)
                digit <= 9;
            else   
                digit <= digit - 1; 
        end else begin
            counter <= counter + 1;
        end 
    end
    
    always @(*) begin
        an[3:0] = 4'b1110; // activate the right digit
        led = 16'b0000000000000000;
        
        case (digit)
            4'd0 : seg = 7'b1000000; // 0
            4'd1 : seg = 7'b1111001; // 1
            4'd2 : seg = 7'b0100100; // 2
            4'd3 : seg = 7'b0011000; // 3
            4'd4 : seg = 7'b0011001; // 4
            4'd5 : seg = 7'b0010010; // 5
            4'd6 : seg = 7'b0000010; // 6
            4'd7 : seg = 7'b1110000; // 7
            4'd8 : seg = 7'b0000000; // 8
            4'd9 : seg = 7'b0010000; // 9
            default: seg = 7'b1111111;
        endcase
    end

endmodule
