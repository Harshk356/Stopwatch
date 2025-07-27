`timescale 1ns / 1ps

module stopwatch_tb;

  // Inputs
  reg clk;
  reg reset;
  reg start;
  reg stop;

  // Outputs
  wire [5:0] MM;
  wire [5:0] SS;

  // Instantiate the DUT
  stopwatch_top uut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .stop(stop),
    .MM(MM),
    .SS(SS)
  );

  // Clock generation: 10ns period => 100MHz
  initial clk = 0;
  always #10 clk = ~clk;

  // Dump waveform for GTKWave/EPWave
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, stopwatch_tb);
  end

  // Monitor the MM:SS output at every clk_1hz rising edge
  always @(posedge uut.clk_inst.clk_1hz) begin
    $display("Time: %0t ns | MM = %0d | SS = %0d", $time, MM, SS);
  end

  // Stimulus logic
  initial begin
    $display("Starting stopwatch simulation...");

    // Initial reset
    reset = 1; start = 0; stop = 0;
    #100;

    reset = 0;
    #50;

    // Start the stopwatch
    $display("START");
    start = 1; #20; start = 0;

    // Let it run for a while
    #3000;

    // Stop the stopwatch
    $display("STOP");
    stop = 1; #20; stop = 0;

    // Wait, then restart
    #1000;
    $display("RESTART");
    start = 1; #20; start = 0;

    // Let it run again
    #3000;

    // Final reset
    $display("RESET");
    reset = 1; #50; reset = 0;

    #1000;

    $display("Simulation finished.");
    $finish;
  end

endmodule