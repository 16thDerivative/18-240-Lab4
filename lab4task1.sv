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
  Comparator #(3) shape3(masterPattern[11:9], guess[11:9], znarly3),
                  shape2(masterPattern[8:6], guess[8:6], znarly2),
                  shape1(masterPattern[5:3], guess[5:3], znarly1),
                  shape0(masterPattern[2:0], guess[2:0], znarly0);

  logic[3:0] znarly01, znarly23, znarlySum;


  Adder #(4) addZn01(1'b0, {3'b000, znarly0}, {3'b000, znarly1}, , znarly01),
             addZn23(1'b0, {3'b000, znarly2}, {3'b000, znarly3}, , znarly23),
             addZn(1'b0, znarly01, znarly23, , znarlySum);
  Mux2to1 #(4) ZnarlySel(4'd0, znarlySum, en, Znarly);


  //ZOOD CALC
  logic [3:0] mpT, mpC, mpO, mpD, mpI, mpZ, gT, gC, gO, gD, gI, gZ;
  //mp count
  logic mpT3, mpT2, mpT1, mpT0;
  logic [3:0] mpT01, mpT23;
  Comparator #(3) mpTcomp3(masterPattern[11:9], 3'b001, mpT3),
                  mpTcomp2(masterPattern[8:6], 3'b001, mpT2),
                  mpTcomp1(masterPattern[5:3], 3'b001, mpT1),
                  mpTcomp0(masterPattern[2:0], 3'b001, mpT0);
  Adder #(4) mpTadd01(1'b0, {3'b000, mpT0}, {3'b000, mpT1}, , mpT01),
             mpTadd23(1'b0, {3'b000, mpT2}, {3'b000, mpT3}, , mpT23),
             mpTadd(1'b0, mpT01, mpT23, , mpT);

  logic mpC3, mpC2, mpC1, mpC0;
  logic [3:0] mpC01, mpC23;
  Comparator #(3) mpCcomp3(masterPattern[11:9], 3'b010, mpC3),
                  mpCcomp2(masterPattern[8:6], 3'b010, mpC2),
                  mpCcomp1(masterPattern[5:3], 3'b010, mpC1),
                  mpCcomp0(masterPattern[2:0], 3'b010, mpC0);
  Adder #(4) mpCadd01(1'b0, {3'b000, mpC0}, {3'b000, mpC1}, , mpC01),
             mpCadd23(1'b0, {3'b000, mpC2}, {3'b000, mpC3}, , mpC23),
             mpCadd(1'b0, mpC01, mpC23, , mpC);

  logic mpO3, mpO2, mpO1, mpO0;
  logic [3:0] mpO01, mpO23;
  Comparator #(3) mpOcomp3(masterPattern[11:9], 3'b011, mpO3),
                  mpOcomp2(masterPattern[8:6], 3'b011, mpO2),
                  mpOcomp1(masterPattern[5:3], 3'b011, mpO1),
                  mpOcomp0(masterPattern[2:0], 3'b011, mpO0);
  Adder #(4) mpOadd01(1'b0, {3'b000, mpO0}, {3'b000, mpO1}, , mpO01),
             mpOadd23(1'b0, {3'b000, mpO2}, {3'b000, mpO3}, , mpO23),
             mpOadd(1'b0, mpO01, mpO23, , mpO);


  logic mpD3, mpD2, mpD1, mpD0;
  logic [3:0] mpD01, mpD23;
  Comparator #(3) mpDcomp3(masterPattern[11:9], 3'b100, mpD3),
                  mpDcomp2(masterPattern[8:6], 3'b100, mpD2),
                  mpDcomp1(masterPattern[5:3], 3'b100, mpD1),
                  mpDcomp0(masterPattern[2:0], 3'b100, mpD0);
  Adder #(4) mpDadd01(1'b0, {3'b000, mpD0}, {3'b000, mpD1}, , mpD01),
             mpDadd23(1'b0, {3'b000, mpD2}, {3'b000, mpD3}, , mpD23),
             mpDadd(1'b0, mpD01, mpD23, , mpD);


  logic mpI3, mpI2, mpI1, mpI0;
  logic [3:0] mpI01, mpI23;
  Comparator #(3) mpIcomp3(masterPattern[11:9], 3'b101, mpI3),
                  mpIcomp2(masterPattern[8:6], 3'b101, mpI2),
                  mpIcomp1(masterPattern[5:3], 3'b101, mpI1),
                  mpIcomp0(masterPattern[2:0], 3'b101, mpI0);
  Adder #(4) mpIadd01(1'b0, {3'b000, mpI0}, {3'b000, mpI1}, , mpI01),
             mpIadd23(1'b0, {3'b000, mpI2}, {3'b000, mpI3}, , mpI23),
             mpIadd(1'b0, mpI01, mpI23, , mpI);


  logic mpZ3, mpZ2, mpZ1, mpZ0;
  logic [3:0] mpZ01, mpZ23;
  Comparator #(3) mpZcomp3(masterPattern[11:9], 3'b110, mpZ3),
                  mpZcomp2(masterPattern[8:6], 3'b110, mpZ2),
                  mpZcomp1(masterPattern[5:3], 3'b110, mpZ1),
                  mpZcomp0(masterPattern[2:0], 3'b110, mpZ0);
  Adder #(4) mpZadd01(1'b0, {3'b000, mpZ0}, {3'b000, mpZ1}, , mpZ01),
             mpZadd23(1'b0, {3'b000, mpZ2}, {3'b000, mpZ3}, , mpZ23),
             mpZadd(1'b0, mpZ01, mpZ23, , mpZ);


  //ZOOD CALC
  //g count
  logic gT3, gT2, gT1, gT0;
  logic [3:0] gT01, gT23;
  Comparator #(3) gTcog3(guess[11:9], 3'b001, gT3),
                  gTcog2(guess[8:6], 3'b001, gT2),
                  gTcog1(guess[5:3], 3'b001, gT1),
                  gTcog0(guess[2:0], 3'b001, gT0);
  Adder #(4) gTadd01(1'b0, {3'b000, gT0}, {3'b000, gT1}, , gT01),
             gTadd23(1'b0, {3'b000, gT2}, {3'b000, gT3}, , gT23),
             gTadd(1'b0, gT01, gT23, , gT);

  logic gC3, gC2, gC1, gC0;
  logic [3:0] gC01, gC23;
  Comparator #(3) gCcog3(guess[11:9], 3'b010, gC3),
                  gCcog2(guess[8:6], 3'b010, gC2),
                  gCcog1(guess[5:3], 3'b010, gC1),
                  gCcog0(guess[2:0], 3'b010, gC0);
  Adder #(4) gCadd01(1'b0, {3'b000, gC0}, {3'b000, gC1}, , gC01),
             gCadd23(1'b0, {3'b000, gC2}, {3'b000, gC3}, , gC23),
             gCadd(1'b0, gC01, gC23, , gC);

  logic gO3, gO2, gO1, gO0;
  logic [3:0] gO01, gO23;
  Comparator #(3) gOcog3(guess[11:9], 3'b011, gO3),
                  gOcog2(guess[8:6], 3'b011, gO2),
                  gOcog1(guess[5:3], 3'b011, gO1),
                  gOcog0(guess[2:0], 3'b011, gO0);
  Adder #(4) gOadd01(1'b0, {3'b000, gO0}, {3'b000, gO1}, , gO01),
             gOadd23(1'b0, {3'b000, gO2}, {3'b000, gO3}, , gO23),
             gOadd(1'b0, gO01, gO23, , gO);

  logic gD3, gD2, gD1, gD0;
  logic [3:0] gD01, gD23;
  Comparator #(3) gDcog3(guess[11:9], 3'b100, gD3),
                  gDcog2(guess[8:6], 3'b100, gD2),
                  gDcog1(guess[5:3], 3'b100, gD1),
                  gDcog0(guess[2:0], 3'b100, gD0);
  Adder #(4) gDadd01(1'b0, {3'b000, gD0}, {3'b000, gD1}, , gD01),
             gDadd23(1'b0, {3'b000, gD2}, {3'b000, gD3}, , gD23),
             gDadd(1'b0, gD01, gD23, , gD);

  logic gI3, gI2, gI1, gI0;
  logic [3:0] gI01, gI23;
  Comparator #(3) gIcog3(guess[11:9], 3'b101, gI3),
                  gIcog2(guess[8:6], 3'b101, gI2),
                  gIcog1(guess[5:3], 3'b101, gI1),
                  gIcog0(guess[2:0], 3'b101, gI0);
  Adder #(4) gIadd01(1'b0, {3'b000, gI0}, {3'b000, gI1}, , gI01),
             gIadd23(1'b0, {3'b000, gI2}, {3'b000, gI3}, , gI23),
             gIadd(1'b0, gI01, gI23, , gI);

  logic gZ3, gZ2, gZ1, gZ0;
  logic [3:0] gZ01, gZ23;
  Comparator #(3) gZcog3(guess[11:9], 3'b110, gZ3),
                  gZcog2(guess[8:6], 3'b110, gZ2),
                  gZcog1(guess[5:3], 3'b110, gZ1),
                  gZcog0(guess[2:0], 3'b110, gZ0);
  Adder #(4) gZadd01(1'b0, {3'b000, gZ0}, {3'b000, gZ1}, , gZ01),
             gZadd23(1'b0, {3'b000, gZ2}, {3'b000, gZ3}, , gZ23),
             gZadd(1'b0, gZ01, gZ23, , gZ);


  logic [3:0] matchT, matchC, matchO, matchD, matchI, matchZ, numMatch;
  logic selT, selC, selO, selD, selI, selZ;

  MagComp #(4) MCompT(mpT, gT, selT, , );
  Mux2to1 #(4) muxSelT(gT, mpT, selT, matchT);

  MagComp #(4) MCompC(mpC, gC, selC, , );
  Mux2to1 #(4) muxSelC(gC, mpC, selC, matchC);

  MagComp #(4) MCompO(mpO, gO, selO, , );
  Mux2to1 #(4) muxSelO(gO, mpO, selO, matchO);

  MagComp #(4) MCompD(mpD, gD, selD, , );
  Mux2to1 #(4) muxSelD(gD, mpD, selD, matchD);

  MagComp #(4) MCompI(mpI, gI, selI, , );
  Mux2to1 #(4) muxSelI(gI, mpI, selI, matchI);

  MagComp #(4) MCompZ(mpZ, gZ, selZ, , );
  Mux2to1 #(4) muxSelZ(gZ, mpZ, selZ, matchZ);

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

  enum logic [1:0] {WAIT, GRADE, DONE} state, next_state;

  always_ff @(posedge CLOCK_100, posedge reset)
    if (reset)
      state <= WAIT;
    else
      state <= next_state;

  always_comb
    case (state)
      WAIT: next_state = GradeIt ? GRADE : WAIT;
      GRADE: next_state = DONE;
      DONE: next_state = WAIT;

    endcase

  always_comb begin
    case (state)
      WAIT: begin
            en = 0;
            done = 0;
      end
      GRADE: begin
             en = 1;
             done = 0;
      end
      DONE: begin
            en = 1;
            done = 1;
      end
    endcase
  end

endmodule : grader_fsm
