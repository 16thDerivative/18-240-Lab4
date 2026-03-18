`default_nettype none

module lab4task1_tb();
  logic CLOCK_100, reset, GradeIt, done;
  logic [11:0] masterPattern, guess;
  logic [3:0] Znarly, Zood;

  grader dut(.*);

  initial begin
    CLOCK_100 = 0;
    forever #5 CLOCK_100 = ~CLOCK_100;
  end

  initial begin
    $monitor($stime,, "GradeIt=%b, masterPattern=%b,  guess=%b | Znarly=%d,\
 Zood=%d", GradeIt, masterPattern, guess, Znarly, Zood);
    reset <= 1; GradeIt <= 0; masterPattern <= 0; guess <= 0;
    @(posedge CLOCK_100);
    @(posedge CLOCK_100);
    @(posedge CLOCK_100);
    reset <= 0;
    masterPattern <= 12'b001_010_110_101;
    guess <= 12'b100_100_010_011;
    @(posedge CLOCK_100);
    guess <= 12'b001_001_010_011;
    @(posedge CLOCK_100);
    GradeIt <= 1;
    @(posedge CLOCK_100);
    @(posedge CLOCK_100);
    @(posedge CLOCK_100);
    $display("numMatch=%0d Znarly=%0d Zood=%0d",
        dut.numMatch, dut.Znarly, dut.Zood);
    @(posedge CLOCK_100);
    @(posedge CLOCK_100);
    @(posedge CLOCK_100);
    GradeIt <= 0;
    @(posedge CLOCK_100);
    @(posedge CLOCK_100);
    guess <= 12'b110_101_001_010;
    @(posedge CLOCK_100);
    GradeIt <= 1;
    @(posedge CLOCK_100);
    @(posedge CLOCK_100);
    @(posedge CLOCK_100);
    GradeIt <= 0;
    @(posedge CLOCK_100);
    GradeIt <= 1;
    @(posedge CLOCK_100);
    @(posedge CLOCK_100);
    guess <= 12'b001_010_101_110;
    @(posedge CLOCK_100);
    @(posedge CLOCK_100);
    GradeIt <= 0;
    @(posedge CLOCK_100);
    guess <= 12'b001_010_110_101;
    @(posedge CLOCK_100);
    GradeIt <= 1;
    @(posedge CLOCK_100);

    #1 $finish;
  end
endmodule : lab4task1_tb
