
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
// ECE6213
// Siem Mihreteab
// Elevator FSM
// 
// 
//////////////////////////////////////////////////////////////////////////////////

module elevator(
    input wire clk,
    input wire rst_n,
    input wire floor1up,
    input wire floor2down,
    input wire floor2up,
    input wire floor3down,
    input wire floor1button,
    input wire floor2button,
    input wire floor3button,
    // Outputs
    output reg floor_1_indi,
    output reg floor_2_indi,
    output reg floor_3_indi,
    output reg door_open,
    // Clear signals to button modules
    output reg floor1up_buttonclear,
    output reg floor2down_buttonclear,
    output reg floor2up_buttonclear,  
    output reg floor3down_buttonclear,
    output reg floor1_elevator_buttonclear,
    output reg floor2_elevator_buttonclear,
    output reg floor3_elevator_buttonclear
    );

    // declare state names
    parameter [2:0] floor1 = 3'b000;
    parameter [2:0] floor1_up_idle = 3'b001;
    parameter [2:0] floor2_up = 3'b010;
    parameter [2:0] floor2_up_idle = 3'b011;
    parameter [2:0] floor2_down = 3'b100;
    parameter [2:0] floor2_down_idle = 3'b101;
    parameter [2:0] floor3 = 3'b110;
    parameter [2:0] floor3_down_idle = 3'b111;
    
    // sequential variables
    reg [2:0] state_current;
    
    // combinational variables
    reg [2:0] state_next;
    // reg [6:0] out1;
    
    reg [10:0] out2;
   
    // clock in registers, asynch active-low reset
    always @(posedge clk or negedge rst_n)
    begin
        if(rst_n == 1'b0) begin
          state_current <= floor1;
        end else begin
           state_current <= state_next;
        end
     end
 
    // Combinational logic for next_state_logic
    
    always @ (*)
    begin
    
        state_next = state_current;
        
        case(state_current)
            floor1: begin
                if(floor1up || floor1button) begin
                    state_next = floor1_up_idle;
                end else if(floor3button || floor2button || floor2up || floor3down || floor2down) begin
                    state_next = floor2_up;
                end
            end
            floor1_up_idle: begin
                if(!floor1up && !floor1button) begin
                    state_next = floor1;
                end
            end
            floor2_up: begin
                if(floor2up || floor2button) begin
                    state_next = floor2_up_idle;
                end else if(floor3down || floor3button) begin
                    state_next = floor3;
                end else if(floor2down || floor1up || floor1button) begin
                    state_next = floor2_down;
                end
            end
            floor2_up_idle: begin
                if(!floor2up && !floor2button) begin
                    state_next = floor2_up;
                end
            end
            floor3: begin
                if(floor3button || floor3down) begin
                    state_next = floor3_down_idle;
                end else if(floor2button || floor1button || floor2down || floor2up || floor1up) begin
                    state_next = floor2_down;
                end 
            end 
            floor3_down_idle: begin
                if(!floor3down && !floor3button) begin
                    state_next = floor3;
                end
            end
            floor2_down: begin
                if(floor2down || floor2button) begin
                    state_next = floor2_down_idle;
                end else if(floor1up || floor1button) begin
                    state_next = floor1;
                end else if(floor3down || floor3button || floor2up) begin
                    state_next = floor2_up;
                end
            end
            floor2_down_idle: begin
                if(!floor2down && !floor2button) begin
                    state_next = floor2_down;
                end
            end
            default: begin
                state_next = floor1;
            end
         endcase
    end
    
    // Combinational always block for output logic
    
    always @(*)
        begin
            
            out2 = 11'b0;
            
            if(state_current == floor1) begin
                out2 = 11'b100_0_0000_000;
            end else if(state_current == floor1_up_idle) begin
                out2 = 11'b100_1_1000_100;
            end else if(state_current == floor2_up) begin
                out2 = 11'b010_0_0000_000;
            end else if(state_current == floor2_up_idle) begin
                out2 = 11'b010_1_0010_010;
            end else if(state_current == floor3) begin 
                out2 = 11'b001_0_0000_000;
            end else if(state_current == floor3_down_idle) begin
                out2 = 11'b001_1_0001_001;
            end else if(state_current == floor2_down) begin
                out2 = 11'b010_0_0000_000;
            end else if(state_current == floor2_down_idle) begin
                out2 = 11'b010_1_0100_010;
            end else begin
                out2 = 11'b0;
            end
            {floor_1_indi, floor_2_indi, floor_3_indi, door_open, floor1up_buttonclear, floor2down_buttonclear, floor2up_buttonclear, floor3down_buttonclear, floor1_elevator_buttonclear, floor2_elevator_buttonclear, floor3_elevator_buttonclear } = out2;
        end
        
endmodule
