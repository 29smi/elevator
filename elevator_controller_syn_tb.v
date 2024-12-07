`timescale 1ns / 1ps

//////////////////////////////////////
//////////////////////////////////////
// ECE6213
// Siem Mihreteab and Felipe Garcia
// Elevator buttons Test Bench
// 
// 
//////////////////////////////////////

module elevator_controller_syn_tb;

    // Inputs to DUT
    reg clk;
    reg rst_n;
    // Input Press button
    reg floor1up;
    reg floor2down;
    reg floor2up;
    reg floor3down;
    reg floor1button;
    reg floor2button;
    reg floor3button;

    // Outputs Indicator
    wire floor_1_indi;
    wire floor_2_indi;
    wire floor_3_indi;
    // Door open
    wire door_open;

    // Instantiate the DUT (Design Under Test)
    elevator_controller DUT (
        .clk(clk),
        .rst_n(rst_n),

        .floor1_up(floor1up),
        .floor2_down(floor2down),
        .floor2_up(floor2up),
        .floor3_down(floor3down),
        .floor1_button(floor1button),
        .floor2_button(floor2button),
        .floor3_button(floor3button),

        .floor_1_indi(floor_1_indi),
        .floor_2_indi(floor_2_indi),
        .floor_3_indi(floor_3_indi),

        .door_open(door_open)
    );

    // Clock generation - 10ns clock period (100 MHz)
    always #5 clk = ~clk;

    // initial block for SDF back annotation
   initial begin
      $sdf_annotate("../../synthesis/netlists/elevator_controller_syn.sdf",elevator_controller_syn_tb.DUT, ,"back_annotate.log");
   end

    // Testbench stimulus
    initial 
    begin

        $display("Three Story Elevator Machines Functionality.");
        // f1up, f2down, f2up, f3down, f1btn, f2btb, f3btn, f1led, f2led, f3led, d_open
        $display("clk\t rst_n f1up f2down f2up f3down f1btn f2btb f3btn f1led f2led f3led d_open");

        $monitor("%t\t %1b\t %1b\t %1b\t %1b\t %1b\t %1b\t %1b\t %1b\t %1b\t %1b\t %1b\t %1b\t", $time,
        rst_n, floor1up, floor2down, floor2up, floor3down, floor1button, floor2button, floor3button, 
        floor_1_indi, floor_2_indi, floor_3_indi, door_open);

        // Initialize inputs
        clk = 0;
        rst_n = 0;
        floor1up = 0;
        floor2down = 0;
        floor2up = 0;
        floor3down = 0;
        floor1button = 0;
        floor2button = 0;
        floor3button = 0;

        repeat(5) @(negedge clk);
        rst_n = 1;

        repeat(5) @(negedge clk);

        // Test Case 1: 1 --> 2

        floor1up = 1;
        repeat(2) @(negedge clk);
        floor1up = 0;
        repeat(5) @(negedge clk);
        

        floor2button = 1;
        repeat(2) @(negedge clk);
        floor2button = 0;
        repeat(8) @(negedge clk);
        
        // Test Case 2: 1 --> 3
        
        floor1up = 1;
        repeat(2) @(negedge clk);
        floor1up = 0;
        repeat(5) @(negedge clk);

        floor3button = 1;
        repeat(2) @(negedge clk);
        floor3button = 0;
        repeat(8) @(negedge clk);
        
        // Test Case 3: 2 --> 3
        
        floor2up = 1;
        repeat(2) @(negedge clk);
        floor2up = 0;
        repeat(5) @(negedge clk);

        floor3button = 1;
        repeat(2) @(negedge clk);
        floor3button = 0;
        repeat(8) @(negedge clk);
        
        // Test Case 4: 2 --> 1
        
        floor2down = 1;
        repeat(2) @(negedge clk);
        floor2down = 0;
        repeat(5) @(negedge clk);

        floor1button = 1;
        repeat(2) @(negedge clk);
        floor1button = 0;
        repeat(8) @(negedge clk);
        
        // Test Case 5: 3 --> 2
    
        floor3down = 1;
        repeat(2) @(negedge clk);
        floor3down = 0;
        repeat(5) @(negedge clk);

        floor2button = 1;
        repeat(2) @(negedge clk);
        floor2button = 0;
        repeat(8) @(negedge clk);
        
        // Test Case 6: 3 --> 1

        floor3down = 1;
        repeat(2) @(negedge clk);
        floor3down = 0;
        repeat(5) @(negedge clk);

        floor1button = 1;
        repeat(2) @(negedge clk);
        floor1button = 0;
        repeat(8) @(negedge clk);
        
        // Test Case 7: 1 --> 3 w/ pickup on Floor 2
        
        floor1up = 1;
        repeat(2) @(negedge clk);
        floor1up = 0;

        repeat(5) @(negedge clk);

        floor3button = 1;
        floor2up = 1;

        repeat(2) @(negedge clk);

        floor2up = 0;
        floor3button = 0;
        repeat(10) @(negedge clk);
        
        // Test Case 8: 3 --> 1 w/ pickup on Floor 2

        floor3down = 1;
        repeat(2) @(negedge clk);
        floor3down = 0;
        
        repeat(5) @(negedge clk);

        floor1button = 1;
        floor2down = 1;

        repeat(2) @(negedge clk);

        floor2down = 0;
        floor1button = 0;
        repeat(10) @(negedge clk);
        
        
        // Test Case 9: Initially the elevator was going from floor 1 to floor 3
        // And if an individual get in floor 2 and wants to go to floor 1 by pressing floor 1 button
        // the elevator should travel to back to floor one after it finished traveling tp floor 3 
        // imidiately - four times will door open
        floor1up = 1;
        repeat(2) @(negedge clk);
        floor1up = 0;
        repeat(5) @(negedge clk);

        floor2up = 1;
        floor3button = 1;
        repeat(2) @(negedge clk);
        floor1button = 1;
        repeat(2) @(negedge clk);

        floor2up = 0;
        floor3button = 0;
        floor1button = 0;

        repeat(15) @(negedge clk);

    $finish;
    end
endmodule
