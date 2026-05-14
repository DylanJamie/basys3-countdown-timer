`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2026 10:34:13 AM
// Design Name: 
// Module Name: full_mod
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


module full_mod(
    input clk,
    input btnC,
    input btnU,
    input [15:0] sw,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an
);

    // mode control
    reg prev_mode;
    wire mode_change;
    
    assign mode_change = (prev_mode != sw[15]);
    
    // set switch 15
    always @(posedge clk) begin
        prev_mode <= sw[15];
    end 

    // Internal wires for the count down timer
    wire [15:0] led_count;
    wire [6:0] seg_count;
    wire [3:0] an_count;
    
    // Internal wires for bomb timere
    wire [15:0] led_timer;
    wire [6:0] seg_timer;
    wire [3:0] an_timer;
    
    // Instantiations
    // Countdown timer
    countdown_timer count (
        .clk(clk),
        .btnC(btnC),
        .btnU(btnU),
        .sw(sw),
        .led(led_count),
        .seg(seg_count),
        .an(an_count)
    );
    
    // bomb timer
    bomb_timer bom (
        .clk(clk),
        .reset(mode_change),
        .sw(sw),
        .led(led_timer),
        .seg(seg_timer),
        .an(an_timer)
    );
    
    // Mode Selector
    assign led = (sw[15]) ? led_timer : led_count;
    assign seg = (sw[15]) ? seg_timer : seg_count;
    assign an  = (sw[15]) ? an_timer  : an_count;
    

endmodule
