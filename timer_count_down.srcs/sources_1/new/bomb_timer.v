`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2026 09:51:46 AM
// Design Name: 
// Module Name: bomb_timer
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


module bomb_timer(
    input clk,
    input reset,
    input [15:0] sw,
    output reg [15:0] led,
    output reg [6:0] seg,
    output reg [3:0] an
    );
    
    // Converts to binary 
    reg [26:0] counter;

    reg [16:0] refresh_counter;
    reg [1:0] digit_select;
    
    reg [7:0] timer = 10;
    reg exploded = 0;
    
    wire active_switches;
    
    assign active_switches = sw[0] && sw[1] && sw[2] && sw[3];
    
    wire [3:0] d0;
    wire [3:0] d1;
    
    // Actually makes the timer show 10
    assign d0 = timer % 10;
    assign d1 = timer / 10;
    
    always @(posedge clk) begin
        // check if mode was swithed
        if (reset) begin
            timer = 10;
            exploded <= 0;
            counter <= 0;
            led <= 0;
        end
        
        // Start the countdown
        else if (!active_switches) begin
            counter <= 0;
        end
        
        else if (!exploded) begin
            if (counter == 100000000) begin
                counter <= 0;
                
                if (timer > 0)
                    timer <= timer - 1;
                else
                    exploded <= 1;
            end
            else
                counter <= counter + 1;   
        end
        
        // Flash LEDs after Explosion
        if (exploded) begin
            if (counter == 5000000) begin
                counter <= 0;
                led <= ~led;
            end 
            else
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
    
    always @(*) begin
        case(digit_select)
    
            2'b00: begin
                an = 4'b1110;
                seg = seven_seg(d0);
            end
    
            2'b01: begin
                an = 4'b1101;
                seg = seven_seg(d1);
            end
    
            // turn off unused digits
            2'b10: begin
                an = 4'b1011;
                seg = 7'b1111111;
            end
    
            2'b11: begin
                an = 4'b0111;
                seg = 7'b1111111;
            end
        endcase
    end
    
endmodule
