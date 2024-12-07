`timescale 1ns / 1ps

//////////////////////////////////////
//////////////////////////////////////
// ECE6213
// Siem Mihreteab
// Elevator buttons Test Bench
// 
// 
//////////////////////////////////////

module elevator_controller_compare_syn_tb;


    // testbench control signals
    // string to display section labels on waveforms, change its radix 
    //      to ASCII in the waveform to view correctly
   reg [(20*8)-1:0] testcase; 
   reg [31:0] 	    error_count = 32'h00000000;
   reg 		        check_outputs = 1'b0;	

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

    // outputs - separate for DUT and post-synthesis DUT

    // Outputs Indicator for DUT
    wire floor_1_indi;
    wire floor_2_indi;
    wire floor_3_indi;
    wire door_open;
    // Outputs Indicator for DUT_syn
    wire floor_1_indi_syn;
    wire floor_2_indi_syn;
    wire floor_3_indi_syn;
    wire door_open_syn;

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

    elevator_controller_syn DUT_SYN(
        .clk(clk),
        .rst_n(rst_n),

        .floor1_up(floor1up),
        .floor2_down(floor2down),
        .floor2_up(floor2up),
        .floor3_down(floor3down),
        .floor1_button(floor1button),
        .floor2_button(floor2button),
        .floor3_button(floor3button),

        .floor_1_indi(floor_1_indi_syn),
        .floor_2_indi(floor_2_indi_syn),
        .floor_3_indi(floor_3_indi_syn),

        .door_open(door_open_syn)
    );


    // Clock generation - 10ns clock period (100 MHz)
    always #5 clk = ~clk;

    // initial block for SDF back annotation
   initial begin
      $sdf_annotate("../../synthesis/netlists/elevator_controller_syn.sdf",elevator_controller_compare_syn_tb.DUT_SYN, ,"back_annotate.log");
   end

    // Testbench stimulus
    initial 
    begin
   
        $monitor("Tescase %s: Time = %t", testcase, $time);

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
        testcase     = "Reset_Checks";


        repeat(5) @(negedge clk);
        // turn on output checking after reset is applied
        check_outputs = 1'b1;

        // release reset and check
        rst_n = 1;

        repeat(5) @(negedge clk);


        // Test Case 1: 1 --> 2

        testcase = "Test Case 1: 1 --> 2";
        floor1up = 1;
        repeat(2) @(negedge clk);
        floor1up = 0;
        repeat(5) @(negedge clk);
        

        floor2button = 1;
        repeat(2) @(negedge clk);
        floor2button = 0;
        repeat(8) @(negedge clk);
        
        // Test Case 2: 1 --> 3
        
        testcase = "Test Case 2: 1 --> 3";
        floor1up = 1;
        repeat(2) @(negedge clk);
        floor1up = 0;
        repeat(5) @(negedge clk);

        floor3button = 1;
        repeat(2) @(negedge clk);
        floor3button = 0;
        repeat(8) @(negedge clk);
        
        // Test Case 3: 2 --> 3
        
        testcase = "Test Case 3: 2 --> 3";
        floor2up = 1;
        repeat(2) @(negedge clk);
        floor2up = 0;
        repeat(5) @(negedge clk);

        floor3button = 1;
        repeat(2) @(negedge clk);
        floor3button = 0;
        repeat(8) @(negedge clk);
        
        // Test Case 4: 2 --> 1
        
        testcase = "Test Case 4: 2 --> 1";
        floor2down = 1;
        repeat(2) @(negedge clk);
        floor2down = 0;
        repeat(5) @(negedge clk);

        floor1button = 1;
        repeat(2) @(negedge clk);
        floor1button = 0;
        repeat(8) @(negedge clk);
        
        // Test Case 5: 3 --> 2

        testcase = "Test Case 5: 3 --> 2";
        floor3down = 1;
        repeat(2) @(negedge clk);
        floor3down = 0;
        repeat(5) @(negedge clk);

        floor2button = 1;
        repeat(2) @(negedge clk);
        floor2button = 0;
        repeat(8) @(negedge clk);
        
        // Test Case 6: 3 --> 1

        testcase = "Test Case 6: 3 --> 1";
        floor3down = 1;
        repeat(2) @(negedge clk);
        floor3down = 0;
        repeat(5) @(negedge clk);

        floor1button = 1;
        repeat(2) @(negedge clk);
        floor1button = 0;
        repeat(8) @(negedge clk);
        
        // Test Case 7: 1 --> 3 w/ pickup on Floor 2
        
        testcase = "Test Case 7: 1 --> 3 w/ pickup on Floor 2";
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

        testcase = "Test Case 8: 3 --> 1 w/ pickup on Floor 2";
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

        testcase = "Test Case 9: ";
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

        if (error_count == 0) begin
	        $display("\n\n----------SIMULATION PASSED   ----------\n\n");
       end else begin
	        $display("\n\n----------SIMULATION FAILED   ----------");
	        $display("---------- %d ERRORS TOTAL----------\n\n",error_count);
       end
    $finish;
    end  // End of initial Block

    // always block for response checking
   always @(negedge clk) begin
      if (check_outputs == 1'b1 ) begin
	      if (door_open != door_open_syn) begin
            $display("**FAIL**: Expected_door = %h, Actual_door = %h, Time = %t", door_open, door_open_syn, $time);
            error_count = error_count + 1;
	      end
         if(floor_3_indi != floor_3_indi_syn) begin
            $display("**FAIL**: Expected_LED1 = %h, Actual_LED1 = %h, Time = %t", floor_3_indi, floor_3_indi_syn, $time);
            error_count = error_count + 1;
         end
         if(floor_2_indi != floor_2_indi_syn) begin
            $display("**FAIL**: Expected_LED2 = %h, Actual_LED2 = %h, Time = %t", floor_2_indi, floor_2_indi_syn, $time);
            error_count = error_count + 1;
         end
         if(floor_1_indi != floor_1_indi_syn) begin
            $display("**FAIL**: Expected_LED1 = %h, Actual_LED1 = %h, Time = %t", floor_1_indi, floor_1_indi_syn, $time);
            error_count = error_count + 1;
         end
      end
   end

endmodule
