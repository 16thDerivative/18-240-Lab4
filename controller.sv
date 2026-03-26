//`default_nettype none

/* This is the main controller for this system. It contains
   an fsm, and complete datapath for the game. */

module controller (
    input logic clock, reset,
    input logic [1:0] CoinValue,
    input logic CoinInserted,
    input logic [2:0] LoadShape,
    input logic [1:0] ShapeLocation,
    input logic LoadShapeNow, StartGame,
                GradeIt,
    input logic [11:0] Guess,
    output logic [3:0] NumGames,
    output logic [3:0] RoundNumber,
    output logic GameWon, loadNumGames, clearGame,
    output logic [3:0] Zood,
    output logic [3:0] Znarly,
    output logic loadZnarlyZood, loadGuess,
    output logic [2:0] Money,
    output logic [11:0] masterPattern,
    output logic BoughtGame,
    output logic [1:0] State,
    output logic Loaded1,
    output logic Loaded2,
    output logic Loaded3,
    output logic Loaded0,
    output logic sLoadShapeOut
    );

    logic [11:0] masterPatternIn;
    logic [2:0] adderA, shape, adderOut, subOut;
    logic [2:0] moneyIn;
    logic GameOver;

    logic sStartGame, sLoadShape, sGradeIt, sCoinIn;
    //logic Won;
    //logic BoughtGame;




    logic Gen, Gclr, Gup;
    logic Ren, Rclr;
    logic Cen, Cclr;
    logic Sen, Sclr;

    logic grst;
    logic enough, MaxGames;
    logic clear;

    assign shape = LoadShape;
    assign clearGame = sStartGame;
    
    
    
   
   assign sLoadShapeOut = (load_shape_state == 2'b01);
   assign loadGuess = loadZnarlyZood;

    enum logic [1:0] {INIT, START, LOAD, PLAY} current_state, next_state;
    assign State = current_state;

    logic [1:0] coin_state, coin_next, load_shape_state, load_shape_next,
                grade_state, grade_next;

    logic pos3en, pos2en, pos1en, pos0en, loaded3, loaded2, loaded1, loaded0,
          pos3clr, pos2clr, pos1clr, pos0clr;

    logic gradeEn;

    assign Loaded0 = loaded0;
    assign Loaded1 = loaded1;
    assign Loaded2 = loaded2;
    assign Loaded3 = loaded3;

    
//   assign loadGuess = (grade_state == 2'b01) && (current_state == PLAY);


    always_comb begin
        case (current_state)
            INIT:  next_state = START;
            START: next_state = (enough) ? LOAD : START;
            LOAD:  next_state = (sStartGame & loaded0 & loaded1 & loaded2 & loaded3) 
                                ? PLAY : LOAD;
            PLAY:  next_state = (GameOver | GameWon) ? START : PLAY;
        endcase

        case (coin_state)
            2'b00: coin_next = (sCoinIn) ? 2'b01 : 2'b00;
            2'b01: coin_next =  2'b11;
            2'b11: coin_next = (~sCoinIn) ? 2'b10 : 2'b11;
            2'b10: coin_next = 2'b00;
        endcase
        case (load_shape_state)
            2'b00: load_shape_next = (sLoadShape) ? 2'b01 : 2'b00;
            2'b01: load_shape_next =  2'b11;
            2'b11: load_shape_next = (~sLoadShape) ? 2'b10 : 2'b11;
            2'b10: load_shape_next = 2'b00;
        endcase
        case (grade_state)
            2'b00: grade_next = (sGradeIt) ? 2'b01 : 2'b00;
            2'b01: grade_next =  2'b11;
            2'b11: grade_next = (~sGradeIt) ? 2'b10 : 2'b11;
            2'b10: grade_next = 2'b00;
        endcase

    end

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            current_state <= INIT;
        else
            current_state <= next_state;
    end

    always_ff @(posedge clock) begin
        if (reset)
            coin_state <= 2'b00;
        else
            coin_state <= coin_next;
    end
    
    always_ff @(posedge clock) begin
        if (reset)
            load_shape_state <= 2'b00;
        else
           load_shape_state <= load_shape_next;
    end
    
    always_ff @(posedge clock) begin
        if (reset)
            grade_state <= 2'b00;
        else
           grade_state <= grade_next;
    end


    always_comb begin
        Gen  = 1'b0;
        Gclr = 1'b0;
        Ren  = 1'b0;
        Rclr = 1'b0;
        Cen  = 1'b0;
        Cclr = 1'b0;
        Sen  = 1'b0;
        Sclr = 1'b0;
        grst = 1'b0;
        pos3clr = 1'b0;
        pos2clr = 1'b0;
        pos1clr = 1'b0;
        pos0clr = 1'b0;
        pos3en = 1'b0;
        pos2en = 1'b0;
        pos1en = 1'b0;
        pos0en = 1'b0;
        gradeEn = 1'b0;
        Gup = 1'b1;
        
        case (current_state)
            INIT: begin
                Cclr = 1'b1;
                Gclr = 1'b1;
                Rclr = 1'b1;
                Sclr = 1'b1;
                grst = 1'b1;
                pos3clr = 1'b1;
                pos2clr = 1'b1;
                pos1clr = 1'b1;
                pos0clr = 1'b1;
            end
            START: begin
                if (BoughtGame & ~MaxGames) begin
                    Gen = 1'b1;
                end
                if ((CoinValue != 2'b00 && coin_state == 2'b01) ||
                    BoughtGame)
                    Cen = 1'b1;
            end
            LOAD: begin
                if (BoughtGame & ~MaxGames) begin
                    Gen = 1'b1;
                end 
                if (sLoadShape & ShapeLocation[0] & ShapeLocation[1] & ~loaded3) begin
                    pos3en = 1;
                    Sen = 1'b1;
                end if (sLoadShape & ~ShapeLocation[0] & ShapeLocation[1] & ~loaded2) begin
                    pos2en = 1;
                    Sen = 1'b1;
                end if (sLoadShape & ShapeLocation[0] & ~ShapeLocation[1] & ~loaded1) begin
                    pos1en = 1;
                    Sen = 1'b1;
                end
                if (sLoadShape & ~ShapeLocation[0] & ~ShapeLocation[1] & ~loaded0) begin
                    pos0en = 1;
                    Sen = 1'b1;
                end
  

                if ((CoinValue != 2'b00 && coin_state == 2'b01) ||
                    BoughtGame)
                    Cen = 1'b1;
                if (sStartGame && loaded0 && loaded1 && loaded2 && loaded3) begin
                    Gen = 1'b1;
                    Gup = 1'b0;
                end
            end
            PLAY: begin
                if (GameOver | GameWon) begin
                    Rclr = 1'b1;
                    Gclr = 1'b1;
                end
                if (grade_state == 2'b01) begin
                    gradeEn = 1'b1;
                    Ren = 1'b1;
                end
            end
        endcase
    end

    Synchronizer syncCoin (
        .async(CoinInserted),
        .clock(clock),
        .sync(sCoinIn)
    );

    Synchronizer syncLS (
        .async(LoadShapeNow),
        .clock(clock),
        .sync(sLoadShape)
    );

    Synchronizer syncGI (
        .async(GradeIt),
        .clock(clock),
        .sync(sGradeIt)
    );

    Synchronizer syncSG (
        .async(StartGame),
        .clock(clock),
        .sync(sStartGame)
    );

    Mux4to1 #(3) muxVal (
        .I0(3'd0),
        .I1(3'd1),
        .I2(3'd3),
        .I3(3'd5),
        .S(CoinValue),
        .Y(adderA)
    );

    Adder #(3) add (
        .A(adderA),
        .B(Money),
        .cin(1'b0),
        .cout(),
        .sum(adderOut)
    );

    Subtracter #(3) sub (
        .A(Money),
        .B(3'd4),
        .bin(1'b0),
        .bout(),
        .diff(subOut)
    );

    Mux2to1 #(3) muxBought (
        .I0(adderOut),
        .I1(subOut),
        .S(BoughtGame),
        .Y(moneyIn)
    );

    Register #(3) regMoney (
        .en(Cen),
        .clear(Cclr),
        .clock(clock),
        .D(moneyIn),
        .Q(Money)
    );

    MagComp #(3) compBought (
        .A(Money),
        .AltB(),
        .AeqB(),
        .B(3'd3),
        .AgtB(BoughtGame)
    );

    Counter #(4) countGames (
        .en(Gen),
        .clear(Gclr),
        .up(Gup),
        .load(1'b0),
        .clock(clock),
        .D(4'd0),
        .Q(NumGames)
    );

    Counter #(1) p3count(
          .en(pos3en), 
          .clear(pos3clr), 
          .load(1'b0),
          .up(1'b1), 
          .clock(clock), 
          .D(1'b0), 
          .Q(loaded3)
     );
     
     Counter #(1) p2count(
          .en(pos2en), 
          .clear(pos2clr), 
          .load(1'b0),
          .up(1'b1), 
          .clock(clock), 
          .D(1'b0), 
          .Q(loaded2)
     );
     
     Counter #(1) p1count(
          .en(pos1en), 
          .clear(pos1clr), 
          .load(1'b0),
          .up(1'b1), 
          .clock(clock), 
          .D(1'b0), 
          .Q(loaded1)
     );
     
     Counter #(1) p0count(
          .en(pos0en), 
          .clear(pos0clr), 
          .load(1'b0),
          .up(1'b1), 
          .clock(clock), 
          .D(1'b0), 
          .Q(loaded0)
     );

    MagComp #(4) compEnough (
        .A(NumGames),
        .B(4'd0),
        .AltB(),
        .AeqB(),
        .AgtB(enough)
    );

    MagComp #(4) compMax (
        .A(NumGames),
        .B(4'd6),
        .AltB(),
        .AeqB(),
        .AgtB(MaxGames)
    );

    Counter #(4) countRound (
        .en(Ren),
        .clear(Rclr),
        .up(1'b1),
        .clock(clock),
        .load(1'b0),
        .D(4'd0),
        .Q(RoundNumber)
    );

    Comparator #(4) compOver (
        .A(4'd7),
        .B(RoundNumber),
        .AeqB(GameOver)
    );

    Mux2to1 #(3) muxPat3 (
        .I1(shape),
        .I0(masterPattern[11:9]),
        .S((ShapeLocation[1]&ShapeLocation[0])),
        .Y(masterPatternIn[11:9])
    );

    Mux2to1 #(3) muxPat2 (
        .I1(shape),
        .I0(masterPattern[8:6]),
        .S((ShapeLocation[1]&~ShapeLocation[0])),
        .Y(masterPatternIn[8:6])
    );

    Mux2to1 #(3) muxPat1 (
        .I1(shape),
        .I0(masterPattern[5:3]),
        .S((~ShapeLocation[1]&ShapeLocation[0])),
        .Y(masterPatternIn[5:3])
    );

    Mux2to1 #(3) muxPat0 (
        .I1(shape),
        .I0(masterPattern[2:0]),
        .S((~ShapeLocation[1]&~ShapeLocation[0])),
        .Y(masterPatternIn[2:0])
    );

    Register #(12) regPat (
        .en(Sen),
        .clear(Sclr),
        .clock(clock),
        .D(masterPatternIn),
        .Q(masterPattern)
    );

    grader grad (
        .CLOCK_100(clock),
        .reset(grst),
        .masterPattern(masterPattgradeEnern),
        .guess(Guess),
        .GradeIt(gradeEn),
        .done(loadZnarlyZood),
        .Zood(Zood),
        .Znarly(Znarly)
    );

    Comparator #(4) compWon (
        .A(Znarly),
        .B(4'd4),
        .AeqB(GameWon)
    );


endmodule: controller
