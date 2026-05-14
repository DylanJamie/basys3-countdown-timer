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
    reg [3:0] d0;
    reg [3:0] d1;
    reg [3:0] d2;
    reg [3:0] d3;
    reg running;
    reg [16:0] refresh_counter;
    reg [1:0] digit_select;

    always @(posedge clk) begin
        if (btnU) begin
            d0 <= 0;
            d1 <= 0;
            d2 <= 0;
            d3 <= 0;
            counter <= 0;
        end    
        
        if (btnC) begin
            running <= ~running;
        end
    
        if(running) begin
            if (counter == 100000000) begin
                counter <= 0;
                // Loop back counter
                if (d0 == 9) begin
                    d0 <= 0;
                    if (d1 == 9) begin
                        d1 <= 0;
                        if (d2 == 9) begin
                            d2 <= 0;
                            if (d3 == 9) begin
                                d3 <= 0;
                            end else   
                                d3 <= d3 + 1; 
                        end else
                            d2 <= d2 + 1;
                    end else
                        d1 <= d1 + 1;
                end else
                    d0 <= d0 + 1;
                end else
            counter <= counter + 1;
        end
    end
    
    // Refresh counter for Multiplexing
    always @(posedge clk) begin
        if(refresh_counter == 100000) begin
            refresh_counter <= 0;
            digit_select <= digit_select + 1;
        end else
            refresh_counter <= refresh_counter + 1;
    end
    
    // Function to transfer seven seg to Numbers 
    function [6:0] seven_seg;
        input [3:0] digit;
        case (digit)
            4'd0 : seven_seg = 7'b1000000; // 0
            4'd1 : seven_seg = 7'b1111001; // 1
            4'd2 : seven_seg = 7'b0100100; // 2
            4'd3 : seven_seg = 7'b0110000; // 3
            4'd4 : seven_seg = 7'b0011001; // 4
            4'd5 : seven_seg = 7'b0010010; // 5
            4'd6 : seven_seg = 7'b0000010; // 6
            4'd7 : seven_seg = 7'b1111000; // 7
            4'd8 : seven_seg = 7'b0000000; // 8
            4'd9 : seven_seg = 7'b0010000; // 9
            default: seven_seg = 7'b1111111;
        endcase  
    endfunction  

    // Display    
    always @(*) begin
        led = 16'b0000000000000000;
        
        case (digit_select)
            2'b00: begin
                an = 4'b1110;
                seg = seven_seg(d0);
            end
            2'b01: begin
                an = 4'b1101;
                seg = seven_seg(d1);
            end
            2'b10: begin
                an = 4'b1011;
                seg = seven_seg(d2);
            end
            2'b11: begin
                an = 4'b0111;
                seg = seven_seg(d3);
            end
        endcase
    end

endmodule
