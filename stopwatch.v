`timescale 1ns / 1ps

module clock( input clk,input reset,output reg clk_1hz);
  parameter freq = 50; // for simulation: divide by just 50 clock cycles

  reg [25:0] counter ;
  always@(posedge clk or posedge reset) begin
    if (reset) begin
      clk_1hz <=0;
      counter <=0;
    end
    else begin 
      counter <= counter +26'b1;
      if (counter == freq/2) begin 
        clk_1hz <= ~ clk_1hz;
        counter <= 0;
      end  
      else begin
        clk_1hz <= clk_1hz;
      end
    end
  end
endmodule

module stopwatchcounter( input clk_1hz,input reset,input enable,output reg [5:0] MM, output reg [5:0]SS );
  always@(posedge clk_1hz or posedge reset ) begin
    if (reset) begin 
      MM <=0;
      SS <=0;
    end
    else begin
      if (enable) begin
        if (SS == 59)begin
          if (MM == 59) begin
           MM <= 0;
          end
          else begin
            MM <= MM+1;
          end
          SS <=0;
        end
        else begin
          SS <= SS+1;
        end
      end
    end
  end
endmodule
    
module control(input clk,input reset,input start,input stop,output reg enable);
   always @(posedge clk or posedge reset) begin
        if (reset)
            enable <= 0;
        else if (start)
            enable <= 1;
        else if (stop)
            enable <= 0;
  
    end
endmodule

module stopwatch_top (
  input clk,             
  input reset,
  input start,
  input stop,
  
  output [5:0] MM,
  output [5:0] SS
);

  
  wire clk_1hz;
  wire enable;

  
  clock clk_inst (
    .clk(clk),
    .reset(reset),
    .clk_1hz(clk_1hz)
  );

  
  control ctrl_inst (
    .clk(clk),             
    .reset(reset),
    .start(start),
    .stop(stop),
    
    .enable(enable)
  );

 
  stopwatchcounter sw_inst (
    .clk_1hz(clk_1hz),
    .reset(reset),
    .enable(enable),
    .MM(MM),
    .SS(SS)
  );

endmodule