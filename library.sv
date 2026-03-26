`default_nettype none

module Memory
     #(parameter DW = 16,
                 W = 256,
                 AW = $clog2(DW))
      (input logic re, we, clock,
       input logic [AW - 1:0] addr,
       inout tri [DW - 1:0] data);

  logic [DW-1:0] M[W], rData;

  assign data = (re) ? rData : 'bz;

  always_ff @(posedge clock)
    if (we)
      M[addr] <= data;

  always_comb
    rData = M[addr];

endmodule : Memory


module BusDriver
     #(parameter WIDTH = 8)
      (input logic en,
       input logic [WIDTH - 1:0] data,
       inout tri [WIDTH - 1:0] bus,
       output logic [WIDTH - 1:0] buff);

  assign bus = (en) ? data : 'bz;
  assign buff = bus;
endmodule : BusDriver


module Synchronizer
      (input logic async, clock,
       output logic sync);

  logic d1, d2;

  always_ff @(posedge clock) begin
    d1 <= async;
    d2 <= d1;
  end

  assign sync = d2;
endmodule : Synchronizer


module BarrelShiftRegister
     #(parameter WIDTH = 8)
      (input logic en, load, clock,
       input logic [1:0] by,
       input logic [WIDTH - 1:0] D,
       output logic [WIDTH - 1:0] Q);

  always_ff @(posedge clock)
    if (load)
      Q <= D;
    else if (en)
      Q <= Q << by;
endmodule : BarrelShiftRegister


module ShiftRegisterPIPO
     #(parameter WIDTH = 8)
      (input logic en, left, load, clock,
       input logic [WIDTH - 1:0] D,
       output logic [WIDTH - 1:0] Q);

  always_ff @(posedge clock)
    if (load)
      Q <= D;
    else if (en & left)
      Q <= {Q[WIDTH - 2:0], 1'b0};
    else if (en & ~left)
      Q <= {1'b0, Q[WIDTH - 1:1]};
endmodule : ShiftRegisterPIPO


module ShiftRegisterSIPO
     #(parameter WIDTH = 8)
      (input logic en, left, serial, clock,
       output logic [WIDTH - 1:0] Q);

  always_ff @(posedge clock)
    if (en & left)
      Q <= {Q[WIDTH - 2:0], serial};
    else if (en & ~left)
      Q <= {serial, Q[WIDTH - 1:1]};
endmodule : ShiftRegisterSIPO


module Counter
     #(parameter WIDTH = 4)
      (input logic en, clear, load, up, clock,
       input logic [WIDTH - 1:0] D,
       output logic [WIDTH - 1:0] Q);

  always_ff @(posedge clock, posedge clear)
    if (clear)
      Q <= 0;
    else if (load)
      Q <= D;
    else if (en & up)
      Q <= Q + 1;
    else if (en & ~up)
      Q <= Q - 1;
endmodule : Counter


module Register
     #(parameter WIDTH = 6)
      (input logic [WIDTH-1:0] D,
       input logic en, clear, clock,
       output logic [WIDTH-1:0] Q);

  always_ff @(posedge clock, posedge clear)
    if (en)
      Q <= D;
    else if (clear)
      Q <= 0;
endmodule : Register


module DFlipFlop
      (input logic D, clock, reset_L, preset_L,
       output logic Q);

  always_ff @(posedge clock, negedge reset_L, negedge preset_L)
    if (~reset_L)
      Q <= 0;
    else if (~preset_L)
      Q <= 1;
    else
      Q <= D;
endmodule : DFlipFlop


module Adder
     #(parameter WIDTH = 8)
      (input logic cin,
       input logic [WIDTH - 1:0] A, B,
       output logic cout,
       output logic [WIDTH - 1:0] sum);

  assign {cout, sum} = A + B + cin;
endmodule: Adder


module Subtracter
     #(parameter WIDTH = 8)
      (input logic bin,
       input logic [WIDTH - 1:0] A, B,
       output logic bout,
       output logic [WIDTH - 1:0] diff);

  assign {bout, diff} = A - B - bin;
endmodule: Subtracter


module Decoder
     #(parameter WIDTH = 8)
      (input logic [$clog2(WIDTH) - 1:0] I,
       input logic en,
       output logic [WIDTH - 1:0] D);

   always_comb begin
       D = 0;
       if (en === 1'b1)
           D[I] = 1'b1;
   end
endmodule: Decoder


module BarrelShifter
     #(parameter WIDTH = 16)
      (input logic [WIDTH - 1:0] V,
       input logic [$clog2(WIDTH) - 1:0] by,
       output logic [WIDTH - 1:0] S);

    always_comb begin
        S = V << by;
    end

endmodule: BarrelShifter


module Multiplexer
     #(parameter WIDTH = 8)
      (input logic [WIDTH - 1:0] I,
       input logic [$clog2(WIDTH) - 1:0] S,
       output logic Y);

    always_comb begin
        Y = I[S];
    end

endmodule: Multiplexer


module Mux2to1
     #(parameter WIDTH = 8)
      (input logic [WIDTH - 1:0] I0,
       input logic [WIDTH - 1:0] I1,
       input logic S,
       output logic [WIDTH - 1:0] Y);

    always_comb begin
        if (S)
            Y = I1;
        else
            Y = I0;
    end

endmodule: Mux2to1


module Mux4to1
     #(parameter WIDTH = 8)
      (input logic [WIDTH - 1:0] I0, I1, I2, I3,
       input logic [1:0] S,
       output logic [WIDTH - 1:0] Y);

  always_comb begin
    case (S)
      2'b00: Y = I0;
      2'b01: Y = I1;
      2'b10: Y = I2;
      2'b11: Y = I3;
    endcase
  end

endmodule : Mux4to1


module MagComp
     #(parameter WIDTH = 8)
      (input logic [WIDTH - 1:0] A, B,
       output logic AltB, AeqB, AgtB);

    always_comb begin
        AltB = A < B;
        AeqB = (A == B);
        AgtB = A > B;
    end

endmodule: MagComp


module Comparator
     #(parameter WIDTH = 4)
      (input logic [WIDTH - 1:0] A, B,
       output logic AeqB);

    always_comb begin
        AeqB = (A === B);
    end

endmodule: Comparator
