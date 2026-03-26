`default_nettype none
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
    output logic [11:0] masterPattern, output logic BoughtGame);

    logic [11:0] masterPatternIn;
    logic [2:0] adderA, shape, adderOut, subOut;
    logic [2:0] moneyIn;
    logic [1:0] sLoc;
    logic GameOver;

    logic sStartGame, sLoadShape, sGradeIt, sCoinIn;
    //logic Won;
    //logic BoughtGame;
    logic sLoadShapeNow;



    logic Gen, Gclr, Gup;
    logic Ren, Rclr;
    logic Cen, Cclr;
    logic Sen, Sclr;

    logic grst;
    logic enough, MaxGames;

    assign shape = LoadShape;
    assign sLoc = ShapeLocation;

    enum logic [1:0] {START, LOAD, PLAY} current_state, next_state;

    logic pos3en, pos2en, pos1en, pos0en, loaded3, loaded2, loaded1, loaded0,
          pos3clr, pos2clr, pos1clr, pos0clr;
    always_comb begin
        case (current_state)
            START: next_state = (enough)? LOAD : START;
            LOAD: next_state = (sStartGame) ? PLAY : LOAD;
            PLAY:  next_state = (GameOver | GameWon)? START : PLAY;
        endcase
    end

    always_ff @(posedge clock, posedge reset) begin
        Gen  <= 1'b0;
        Gclr <= 1'b0;
        Ren  <= 1'b0;
        Rclr <= 1'b0;
        Cen  <= 1'b0;
        Cclr <= 1'b0;
        Sen  <= 1'b0;
        Sclr <= 1'b0;
        grst <= 1'b0;
        pos3clr <= 1'b0;
        pos2clr <= 1'b0;
        pos1clr <= 1'b0;
        pos0clr <= 1'b0;
        if (reset) begin
            current_state <= START;
            Cclr          <= 1'b1;
            Gclr          <= 1'b1;
            Rclr          <= 1'b1;
            Sclr          <= 1'b1;
            grst          <= 1'b1;
            pos3clr <= 1'b1;
            pos2clr <= 1'b1;
            pos1clr <= 1'b1;
            pos0clr <= 1'b1;
        end else begin
            current_state <= next_state;

            case (current_state)
                START: begin
                    if (BoughtGame & ~MaxGames) begin
                        Gup <= 1'b1;
                        Gen <= 1'b1;
                    end
                    if (sCoinIn)
                        Cen <= 1'b1;
                end
                LOAD: begin
                    if (BoughtGame & ~MaxGames) begin
                        Gen <= 1'b1;
                        Gup <= 1'b1;
                    end
                    if (sLoadShapeNow & sLoc[0] & sLoc[1] & ~loaded3) begin
                        pos3en <= 1;
                        Sen <= 1'b1;
                    end
                    if (sLoadShapeNow & ~sLoc[0] & sLoc[1] & ~loaded2) begin
                        pos2en <= 1;
                        Sen <= 1'b1;
                    end
                    if (sLoadShapeNow & sLoc[0] & ~sLoc[1] & ~loaded1) begin
                        pos1en <= 1;
                        Sen <= 1'b1;
                    end
                    if (sLoadShapeNow & ~sLoc[0] & ~sLoc[1] & ~loaded0) begin
                        pos0en <= 1;
                        Sen <= 1'b1;
                    end

                    if (sCoinIn)
                        Cen <= 1'b1;
                    if (sStartGame) begin
                        Gen <= 1'b1;
                        Gup <= 1'b0;
                    end
                end
                PLAY: begin
                    if (GameOver | GameWon) begin
                        Rclr <= 1'b1;
                        Gclr <= 1'b1;
                    end
                end
            endcase
        end
    end

    Synchronizer syncCoin (
        .async(CoinInserted),
        .clock(clock),
        .sync(sCoinIn)
    );

    Synchronizer syncLS (
        .async(LoadShapeNow),
        .clock(clock),
        .sync(sLoadShapeNow)
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

    Counter #(1) p3count(pos3en, pos3clr, 1'b0, 1'b1, clock, 1'b0, loaded3),
                 p2count(pos2en, pos2clr, 1'b0, 1'b1, clock, 1'b0, loaded2),
                 p1count(pos1en, pos1clr, 1'b0, 1'b1, clock, 1'b0, loaded1),
                 p0count(pos0en, pos0clr, 1'b0, 1'b1, clock, 1'b0, loaded0);

    MagComp #(4) compEnough (
        .A(NumGames),
        .B(4'd0),
        .AltB(),
        .AeqB(),
        .AgtB(enough)
    );

    MagComp #(4) compMax (
        .A(NumGames),
        .B(4'd7),
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
        .S((sLoc[1]&sLoc[0])),
        .Y(masterPatternIn[11:9])
    );

    Mux2to1 #(3) muxPat2 (
        .I1(shape),
        .I0(masterPattern[8:6]),
        .S((sLoc[1]&~sLoc[0])),
        .Y(masterPatternIn[8:6])
    );

    Mux2to1 #(3) muxPat1 (
        .I1(shape),
        .I0(masterPattern[5:3]),
        .S((~sLoc[1]&sLoc[0])),
        .Y(masterPatternIn[5:3])
    );

    Mux2to1 #(3) muxPat0 (
        .I1(shape),
        .I0(masterPattern[2:0]),
        .S((~sLoc[1]&~sLoc[0])),
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
        .masterPattern(masterPattern),
        .guess(Guess),
        .GradeIt(sGradeIt),
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
