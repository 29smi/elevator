`timescale 1ns/1ps

//////////////////////////////////////
//////////////////////////////////////
// 
// Elevator Controller Main Module
// 
//////////////////////////////////////

module elevator_controller(
    input wire clk,
    input wire rst_n,
    // Button presses from users
    input wire floor1_up,
    input wire floor2_down,
    input wire floor2_up,
    input wire floor3_down,
    input wire floor1_button,
    input wire floor2_button,
    input wire floor3_button,
    // Outputs
    output wire floor_1_indi,
    output wire floor_2_indi,
    output wire floor_3_indi,
    output wire door_open
);

wire f1;
wire f2;
wire f3;
wire f4;
wire f5;
wire f6;
wire f7;

wire clear1;
wire clear2;
wire clear3;
wire clear4;
wire clear5;
wire clear6;
wire clear7;


elevator_button button1(.clk(clk), .rst_n(rst_n), 
                        .button_pressed(floor1_up), 
                        .clear(clear1), 
                        .button_out(f1));
elevator_button button2(.clk(clk), .rst_n(rst_n), 
                        .button_pressed(floor2_down), 
                        .clear(clear2), 
                        .button_out(f2));
elevator_button button3(.clk(clk), .rst_n(rst_n), 
                        .button_pressed(floor2_up), 
                        .clear(clear3), 
                        .button_out(f3));
elevator_button button4(.clk(clk), .rst_n(rst_n), 
                        .button_pressed(floor3_down), 
                        .clear(clear4), 
                        .button_out(f4));
elevator_button button5(.clk(clk), .rst_n(rst_n), 
                        .button_pressed(floor1_button), 
                        .clear(clear5), 
                        .button_out(f5));
elevator_button button6(.clk(clk), .rst_n(rst_n), 
                        .button_pressed(floor2_button), 
                        .clear(clear6), 
                        .button_out(f6));
elevator_button button7(.clk(clk), .rst_n(rst_n), 
                        .button_pressed(floor3_button), 
                        .clear(clear7), 
                        .button_out(f7));

elevator k1(.clk(clk), .rst_n(rst_n), 
            .floor1up(f1), 
            .floor2down(f2), 
            .floor2up(f3), 
            .floor3down(f4), 
            .floor1button(f5), 
            .floor2button(f6),
            .floor3button(f7), 
            .floor_1_indi(floor_1_indi), 
            .floor_2_indi(floor_2_indi), 
            .floor_3_indi(floor_3_indi), 
            .door_open(door_open), 
            .floor1up_buttonclear(clear1), 
            .floor2down_buttonclear(clear2), 
            .floor2up_buttonclear(clear3), 
            .floor3down_buttonclear(clear4), 
            .floor1_elevator_buttonclear(clear5), 
            .floor2_elevator_buttonclear(clear6), 
            .floor3_elevator_buttonclear(clear7)
            );

endmodule
