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
    output logic [11:0] masterPattern
    );

    logic [11:0] masterPatternIn;
    logic [2:0] adderA, shape, adderOut, subOut;
    logic [2:0] moneyIn;
    logic [1:0] sLoc;
    logic GameOver;

    logic sStartGame, sLoadShape, sGradeIt, sCoinIn;
    logic Won;
    logic BoughtGame;
    logic sLoadShapeNow;



    logic Gen, Gclr, Gup;
    logic Ren, Rclr;
    logic Cen, Cclr;
    logic Sen, Sclr;

    logic grst;
    logic enough, MaxGames;

    assign shape = LoadShape;
    assign sLoc = ShapeLocation;


    enum logic {START, PLAY} current_state, next_state;

    always_comb begin
        case (current_state)
            START: next_state = (enough & sStartGame)? PLAY : START;
            PLAY:  next_state = (GameOver | Won)? START : PLAY;
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
        if (reset) begin
            current_state <= START;
            Cclr          <= 1'b1;
            Gclr          <= 1'b1;
            Rclr          <= 1'b1;
            Sclr          <= 1'b1;
            grst          <= 1'b1;
        end else begin
            case (current_state)
                START: begin
                    if (enough & sStartGame) begin
                        Gup <= 1'b0;
                        Gen <= 1'b1;
                    end else if (BoughtGame & ~MaxGames) begin
                        Gen <= 1'b1;
                        Gup <= 1'b1;
                    end
                end
                PLAY: begin
                    if (GameOver | Won) begin
                        Rclr <= 1'b1;
                        Gclr <= 1'b1;
                    end else if (sLoadShapeNow) begin
                        Sen  <= 1'b1;
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
        .async(LoadShape),
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
        .cout(1'b0),
        .sum(adderOut)
    );

    Subtracter #(3) sub (
        .A(Money),
        .B(3'd4),
        .bin(1'b0),
        .bout(1'b0),
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

    MagComp #(4) compEnough (
        .A(NumGames),
        .B(4'd0),
        .AltB(1'b0),
        .AeqB(1'b0),
        .AgtB(enough)
    );

    MagComp #(4) compMax (
        .A(NumGames),
        .B(4'd7),
        .AltB(1'b0),
        .AeqB(1'b0),
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
        .A(4'd0),
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

    Grader grad (
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
        .B(4'b1111),
        .AeqB(Won)
    );


endmodule: controller
