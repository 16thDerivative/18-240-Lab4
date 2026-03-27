`default_nettype none

module grader
      (input logic CLOCK_100, reset,
       input logic [11:0] masterPattern, guess,
       input logic GradeIt,
       output logic done,
       output logic [3:0] Znarly, Zood);

  logic znarly3, znarly2, znarly1, znarly0;
  logic en;

  //ZNARLY CALC
  Comparator #(3) Shape3(masterPattern[11:9], guess[11:9], znarly3),
                  Shape2(masterPattern[8:6], guess[8:6], znarly2),
                  Shape1(masterPattern[5:3], guess[5:3], znarly1),
                  Shape0(masterPattern[2:0], guess[2:0], znarly0);

  logic[3:0] znarly01, znarly23, znarlySum;


  Adder #(4) AddZn01(1'b0, {3'b000, znarly0}, {3'b000, znarly1}, , znarly01),
             AddZn23(1'b0, {3'b000, znarly2}, {3'b000, znarly3}, , znarly23),
             AddZn(1'b0, znarly01, znarly23, , znarlySum);
  Mux2to1 #(4) ZnarlySel(4'd0, znarlySum, en, Znarly);


  //ZOOD CALC
  logic [3:0] mpT, mpC, mpO, mpD, mpI, mpZ, gT, gC, gO, gD, gI, gZ;
  //mp count
  logic mpT3, mpT2, mpT1, mpT0;
  logic [3:0] mpT01, mpT23;
  Comparator #(3) MpTcomp3(masterPattern[11:9], 3'b001, mpT3),
                  MpTcomp2(masterPattern[8:6], 3'b001, mpT2),
                  MpTcomp1(masterPattern[5:3], 3'b001, mpT1),
                  MpTcomp0(masterPattern[2:0], 3'b001, mpT0);
  Adder #(4) MpTadd01(1'b0, {3'b000, mpT0}, {3'b000, mpT1}, , mpT01),
             MpTadd23(1'b0, {3'b000, mpT2}, {3'b000, mpT3}, , mpT23),
             MpTadd(1'b0, mpT01, mpT23, , mpT);

  logic mpC3, mpC2, mpC1, mpC0;
  logic [3:0] mpC01, mpC23;
  Comparator #(3) MpCcomp3(masterPattern[11:9], 3'b010, mpC3),
                  MpCcomp2(masterPattern[8:6], 3'b010, mpC2),
                  MpCcomp1(masterPattern[5:3], 3'b010, mpC1),
                  MpCcomp0(masterPattern[2:0], 3'b010, mpC0);
  Adder #(4) MpCadd01(1'b0, {3'b000, mpC0}, {3'b000, mpC1}, , mpC01),
             MpCadd23(1'b0, {3'b000, mpC2}, {3'b000, mpC3}, , mpC23),
             MpCadd(1'b0, mpC01, mpC23, , mpC);

  logic mpO3, mpO2, mpO1, mpO0;
  logic [3:0] mpO01, mpO23;
  Comparator #(3) MpOcomp3(masterPattern[11:9], 3'b011, mpO3),
                  MpOcomp2(masterPattern[8:6], 3'b011, mpO2),
                  MpOcomp1(masterPattern[5:3], 3'b011, mpO1),
                  MpOcomp0(masterPattern[2:0], 3'b011, mpO0);
  Adder #(4) MpOadd01(1'b0, {3'b000, mpO0}, {3'b000, mpO1}, , mpO01),
             MpOadd23(1'b0, {3'b000, mpO2}, {3'b000, mpO3}, , mpO23),
             MpOadd(1'b0, mpO01, mpO23, , mpO);


  logic mpD3, mpD2, mpD1, mpD0;
  logic [3:0] mpD01, mpD23;
  Comparator #(3) MpDcomp3(masterPattern[11:9], 3'b100, mpD3),
                  MpDcomp2(masterPattern[8:6], 3'b100, mpD2),
                  MpDcomp1(masterPattern[5:3], 3'b100, mpD1),
                  MpDcomp0(masterPattern[2:0], 3'b100, mpD0);
  Adder #(4) MpDadd01(1'b0, {3'b000, mpD0}, {3'b000, mpD1}, , mpD01),
             MpDadd23(1'b0, {3'b000, mpD2}, {3'b000, mpD3}, , mpD23),
             MpDadd(1'b0, mpD01, mpD23, , mpD);


  logic mpI3, mpI2, mpI1, mpI0;
  logic [3:0] mpI01, mpI23;
  Comparator #(3) MpIcomp3(masterPattern[11:9], 3'b101, mpI3),
                  MpIcomp2(masterPattern[8:6], 3'b101, mpI2),
                  MpIcomp1(masterPattern[5:3], 3'b101, mpI1),
                  MpIcomp0(masterPattern[2:0], 3'b101, mpI0);
  Adder #(4) MpIadd01(1'b0, {3'b000, mpI0}, {3'b000, mpI1}, , mpI01),
             MpIadd23(1'b0, {3'b000, mpI2}, {3'b000, mpI3}, , mpI23),
             MpIadd(1'b0, mpI01, mpI23, , mpI);


  logic mpZ3, mpZ2, mpZ1, mpZ0;
  logic [3:0] mpZ01, mpZ23;
  Comparator #(3) MpZcomp3(masterPattern[11:9], 3'b110, mpZ3),
                  MpZcomp2(masterPattern[8:6], 3'b110, mpZ2),
                  MpZcomp1(masterPattern[5:3], 3'b110, mpZ1),
                  MpZcomp0(masterPattern[2:0], 3'b110, mpZ0);
  Adder #(4) MpZadd01(1'b0, {3'b000, mpZ0}, {3'b000, mpZ1}, , mpZ01),
             MpZadd23(1'b0, {3'b000, mpZ2}, {3'b000, mpZ3}, , mpZ23),
             MpZadd(1'b0, mpZ01, mpZ23, , mpZ);


  //ZOOD CALC
  //g count
  logic gT3, gT2, gT1, gT0;
  logic [3:0] gT01, gT23;
  Comparator #(3) GTcog3(guess[11:9], 3'b001, gT3),
                  GTcog2(guess[8:6], 3'b001, gT2),
                  GTcog1(guess[5:3], 3'b001, gT1),
                  GTcog0(guess[2:0], 3'b001, gT0);
  Adder #(4) GTadd01(1'b0, {3'b000, gT0}, {3'b000, gT1}, , gT01),
             GTadd23(1'b0, {3'b000, gT2}, {3'b000, gT3}, , gT23),
             GTadd(1'b0, gT01, gT23, , gT);

  logic gC3, gC2, gC1, gC0;
  logic [3:0] gC01, gC23;
  Comparator #(3) GCcog3(guess[11:9], 3'b010, gC3),
                  GCcog2(guess[8:6], 3'b010, gC2),
                  GCcog1(guess[5:3], 3'b010, gC1),
                  GCcog0(guess[2:0], 3'b010, gC0);
  Adder #(4) GCadd01(1'b0, {3'b000, gC0}, {3'b000, gC1}, , gC01),
             GCadd23(1'b0, {3'b000, gC2}, {3'b000, gC3}, , gC23),
             GCadd(1'b0, gC01, gC23, , gC);

  logic gO3, gO2, gO1, gO0;
  logic [3:0] gO01, gO23;
  Comparator #(3) GOcog3(guess[11:9], 3'b011, gO3),
                  GOcog2(guess[8:6], 3'b011, gO2),
                  GOcog1(guess[5:3], 3'b011, gO1),
                  GOcog0(guess[2:0], 3'b011, gO0);
  Adder #(4) GOadd01(1'b0, {3'b000, gO0}, {3'b000, gO1}, , gO01),
             GOadd23(1'b0, {3'b000, gO2}, {3'b000, gO3}, , gO23),
             GOadd(1'b0, gO01, gO23, , gO);

  logic gD3, gD2, gD1, gD0;
  logic [3:0] gD01, gD23;
  Comparator #(3) GDcog3(guess[11:9], 3'b100, gD3),
                  GDcog2(guess[8:6], 3'b100, gD2),
                  GDcog1(guess[5:3], 3'b100, gD1),
                  GDcog0(guess[2:0], 3'b100, gD0);
  Adder #(4) GDadd01(1'b0, {3'b000, gD0}, {3'b000, gD1}, , gD01),
             GDadd23(1'b0, {3'b000, gD2}, {3'b000, gD3}, , gD23),
             GDadd(1'b0, gD01, gD23, , gD);

  logic gI3, gI2, gI1, gI0;
  logic [3:0] gI01, gI23;
  Comparator #(3) GIcog3(guess[11:9], 3'b101, gI3),
                  GIcog2(guess[8:6], 3'b101, gI2),
                  GIcog1(guess[5:3], 3'b101, gI1),
                  GIcog0(guess[2:0], 3'b101, gI0);
  Adder #(4) GIadd01(1'b0, {3'b000, gI0}, {3'b000, gI1}, , gI01),
             GIadd23(1'b0, {3'b000, gI2}, {3'b000, gI3}, , gI23),
             GIadd(1'b0, gI01, gI23, , gI);

  logic gZ3, gZ2, gZ1, gZ0;
  logic [3:0] gZ01, gZ23;
  Comparator #(3) GZcog3(guess[11:9], 3'b110, gZ3),
                  GZcog2(guess[8:6], 3'b110, gZ2),
                  GZcog1(guess[5:3], 3'b110, gZ1),
                  GZcog0(guess[2:0], 3'b110, gZ0);
  Adder #(4) GZadd01(1'b0, {3'b000, gZ0}, {3'b000, gZ1}, , gZ01),
             GZadd23(1'b0, {3'b000, gZ2}, {3'b000, gZ3}, , gZ23),
             GZadd(1'b0, gZ01, gZ23, , gZ);


  logic [3:0] matchT, matchC, matchO, matchD, matchI, matchZ, numMatch;
  logic selT, selC, selO, selD, selI, selZ;

  MagComp #(4) MCompT(mpT, gT, selT, , );
  Mux2to1 #(4) MuxSelT(gT, mpT, selT, matchT);

  MagComp #(4) MCompC(mpC, gC, selC, , );
  Mux2to1 #(4) MuxSelC(gC, mpC, selC, matchC);

  MagComp #(4) MCompO(mpO, gO, selO, , );
  Mux2to1 #(4) MuxSelO(gO, mpO, selO, matchO);

  MagComp #(4) MCompD(mpD, gD, selD, , );
  Mux2to1 #(4) MuxSelD(gD, mpD, selD, matchD);

  MagComp #(4) MCompI(mpI, gI, selI, , );
  Mux2to1 #(4) MuxSelI(gI, mpI, selI, matchI);

  MagComp #(4) MCompZ(mpZ, gZ, selZ, , );
  Mux2to1 #(4) MuxSelZ(gZ, mpZ, selZ, matchZ);

  logic [3:0] sumTC, sumOD, sumTCOD, sumIZ;

  Adder #(4) AddTC(1'b0, matchT, matchC, , sumTC),
             AddOD(1'b0, matchO, matchD, , sumOD),
             AddTCOD(1'b0, sumTC, sumOD, , sumTCOD),
             AddIZ(1'b0, matchI, matchZ, , sumIZ),
             AddMatch(1'b0, sumTCOD, sumIZ, , numMatch);

  logic [3:0] ZoodDiff;

  Subtracter #(4) ZoodSub(1'b0, numMatch, Znarly, , ZoodDiff);
  Mux2to1 #(4) ZoodSel(4'd0, ZoodDiff, en, Zood);

  grader_fsm fsm(.*);

endmodule : grader


module grader_fsm
      (input logic CLOCK_100, reset,
       input logic GradeIt,
       output logic en, done);

  enum logic [1:0] {WAIT, GRADE, IDLE} state, next_state;

  always_ff @(posedge CLOCK_100, posedge reset)
    if (reset)
      state <= WAIT;
    else
      state <= next_state;

  always_comb
    case (state)
      IDLE: next_state = GradeIt ? GRADE : IDLE;
      GRADE: next_state = WAIT;
      WAIT: next_state = GradeIt ? WAIT : IDLE;
    endcase

  always_comb begin
    case (state)
      IDLE: begin
            en = 0;
            done = 0;
      end
      GRADE: begin
             en = 1;
             done = 1;
      end
      WAIT: begin
            en = 0;
            done = 0;
      end
    endcase
  end

endmodule : grader_fsm
