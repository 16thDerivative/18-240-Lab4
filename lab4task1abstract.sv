`default_nettype none

module grader
      (input logic CLOCK_100, reset,
       input logic [11:0] masterPattern, guess,
       input logic GradeIt,
       output logic done,
       output logic [3:0] Znarly, Zood);

  logic znarly3, znarly2, znarly1, znarly0;

  Comparator #(3) shape3(masterPattern[11:9], guess[11:9], znarly3),
                  shape2(masterPattern[8:6], guess[8:6], znarly2),
                  shape1(masterPattern[5:3], guess[5:3], znarly1),
                  shape0(masterPattern[2:0], guess[2:0], znarly0);

  logic [3:0] mpT, mpC, mpO, mpD, mpI, mpZ, gT, gC, gO, gD, gI, gZ;

  assign mpT = (masterPattern[11:9] == 3'b001) + (masterPattern[8:6] == 3'b001)
             + (masterPattern[5:3] == 3'b001) + (masterPattern[2:0] == 3'b001);

  assign mpC = (masterPattern[11:9] == 3'b010) + (masterPattern[8:6] == 3'b010)
             + (masterPattern[5:3] == 3'b010) + (masterPattern[2:0] == 3'b010);

  assign mpO = (masterPattern[11:9] == 3'b011) + (masterPattern[8:6] == 3'b011)
             + (masterPattern[5:3] == 3'b011) + (masterPattern[2:0] == 3'b011);

  assign mpD = (masterPattern[11:9] == 3'b100) + (masterPattern[8:6] == 3'b100)
             + (masterPattern[5:3] == 3'b100) + (masterPattern[2:0] == 3'b100);

  assign mpI = (masterPattern[11:9] == 3'b101) + (masterPattern[8:6] == 3'b101)
             + (masterPattern[5:3] == 3'b101) + (masterPattern[2:0] == 3'b101);

  assign mpZ = (masterPattern[11:9] == 3'b110) + (masterPattern[8:6] == 3'b110)
             + (masterPattern[5:3] == 3'b110) + (masterPattern[2:0] == 3'b110);

  assign gT = (guess[11:9] == 3'b001) + (guess[8:6] == 3'b001)
            + (guess[5:3] == 3'b001) + (guess[2:0] == 3'b001);

  assign gC = (guess[11:9] == 3'b010) + (guess[8:6] == 3'b010)
            + (guess[5:3] == 3'b010) + (guess[2:0] == 3'b010);

  assign gO = (guess[11:9] == 3'b011) + (guess[8:6] == 3'b011)
            + (guess[5:3] == 3'b011) + (guess[2:0] == 3'b011);

  assign gD = (guess[11:9] == 3'b100) + (guess[8:6] == 3'b100)
            + (guess[5:3] == 3'b100) + (guess[2:0] == 3'b100);

  assign gI = (guess[11:9] == 3'b101) + (guess[8:6] == 3'b101)
            + (guess[5:3] == 3'b101) + (guess[2:0] == 3'b101);

  assign gZ = (guess[11:9] == 3'b110) + (guess[8:6] == 3'b110)
            + (guess[5:3] == 3'b110) + (guess[2:0] == 3'b110);

  logic [3:0] matchT, matchC, matchO, matchD, matchI, matchZ, numMatch;

  assign matchT = (mpT < gT) ? mpT : gT;
  assign matchC = (mpC < gC) ? mpC : gC;
  assign matchO = (mpO < gO) ? mpO : gO;
  assign matchD = (mpD < gD) ? mpD : gD;
  assign matchI = (mpI < gI) ? mpI : gI;
  assign matchZ = (mpZ < gZ) ? mpZ : gZ;
  assign numMatch = matchT + matchC + matchO + matchD + matchI + matchZ;

  logic en;

  always_comb begin
    if (en) begin
      Znarly = znarly3 + znarly2 + znarly1 + znarly0;
      Zood = numMatch - Znarly;
    end
    else begin
      Znarly = 4'd0;
      Zood = 4'd0;
    end
  end

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
      DONE: next_state = GradeIt ? DONE : WAIT;
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
