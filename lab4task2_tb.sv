`default_nettype none

module lab4task2_tb();
  logic clock, reset;
  logic [1:0] CoinValue;
  logic CoinInserted;
  logic [2:0] LoadShape;
  logic [1:0] ShapeLocation;
  logic LoadShapeNow, StartGame, GradeIt;
  logic [11:0] masterPattern, Guess;
  logic [3:0] NumGames, RoundNumber;
  logic GameWon, loadNumGames, clearGame,
        loadZnarlyZood, loadGuess;
  logic [3:0] Zood, Znarly;
  logic [2:0] Money;
  logic BoughtGame;


  controller dut(.*);

  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end

  initial begin
    $monitor($stime,,
      "Money:%d NumGames:%d GameWon:%b Round:%d\n\
           MP:%b Guess:%b | Znarly:%d Zood:%d MPin:%b sLN:%b LSN: %b\
           Sen:%b over:%b enough:%d sSG:%b state:%s",
       Money, NumGames, GameWon, RoundNumber,
       masterPattern, Guess, Znarly, Zood,
       dut.masterPatternIn, dut.sLoadShapeNow, LoadShapeNow,
       dut.Sen, dut.GameOver, dut.enough, dut.sStartGame, dut.current_state.name);

   reset <= 1; CoinValue <= 0; CoinInserted <= 0; StartGame <= 0;
   Guess <= 0; GradeIt <= 0;
   @(posedge clock);
   reset <= 0;
   CoinValue <= 2'b01;
   @(posedge clock);
   @(posedge clock);
   @(posedge clock);
   CoinInserted <= 1; //1
   @(posedge clock);
   CoinInserted <= 0;
   $display("one coin");
   @(posedge clock);
   @(posedge clock);
   CoinInserted <= 1; //1
   @(posedge clock);
   @(posedge clock);
   @(posedge clock);
   @(posedge clock);
   CoinInserted <= 0;
   CoinValue <= 2'b10;
   @(posedge clock);
   @(posedge clock);
   @(posedge clock);
   @(posedge clock);
   CoinInserted <= 1; //4 1 game
   @(posedge clock);
   CoinInserted <= 0;
   @(posedge clock);
   CoinInserted <= 1; //7 1 game
   @(posedge clock);
   CoinInserted <= 0;
   @(posedge clock);
   @(posedge clock);
   CoinValue <= 2'b00;
   CoinInserted <= 1; //7 1 game
   @(posedge clock);
   CoinInserted <= 0;
   @(posedge clock);
   CoinValue <= 2'b01; //12 3 games
   CoinInserted <= 1;
   @(posedge clock);
   CoinInserted <= 0;
   @(posedge clock);
   CoinInserted <= 1; //17 4 games, 1 leftover
   @(posedge clock);
   CoinInserted <= 0;
   @(posedge clock);
   @(posedge clock);
   @(posedge clock);
   LoadShape <= 0;
   ShapeLocation <= 0;
   LoadShapeNow <= 0;

   $display("=====START GAME=====");
   //Start game 1
   //load shape pos 2
   @(posedge clock);
   LoadShape <= 3'b001;
   ShapeLocation <= 2'b10;
   @(posedge clock);
   @(posedge clock);
   LoadShapeNow <= 1;
   @(posedge clock);
   @(posedge clock);
   LoadShapeNow <= 0;
   @(posedge clock);

   //load shape pos 0;
   LoadShape <= 3'b101;
   ShapeLocation <= 2'b00;
   LoadShapeNow <= 0;
   @(posedge clock);
   LoadShapeNow <= 1;
   @(posedge clock);
   LoadShapeNow <= 0;
   @(posedge clock);

   //load shape pos 1;
   LoadShape <= 3'b110;
   ShapeLocation <= 2'b01;
   LoadShapeNow <= 0;
   @(posedge clock);
   LoadShapeNow <= 1;
   @(posedge clock);
   LoadShapeNow <= 0;
   @(posedge clock);

   //load shape pos 3;
   LoadShape <= 3'b011;
   ShapeLocation <= 2'b11;
   LoadShapeNow <= 0;
   @(posedge clock);
   LoadShapeNow <= 1;
   @(posedge clock);
   LoadShapeNow <= 0;
   @(posedge clock);

   //done loading pos3
   //testing


   StartGame <= 1;
   $display("=====DONE LOADING MP=====");
   //done loading mp: 011_001_110_101
   @(posedge clock);
   Guess <= 12'b011_101_001_010;
   GradeIt <= 1;
   StartGame <= 0;
   @(posedge clock);
   @(posedge clock);
   @(posedge clock);
   @(posedge clock);
   GradeIt <= 0;
   Guess <= 12'b101_001_010_011;
   @(posedge clock);
   GradeIt <= 1;
   @(posedge clock);
   @(posedge clock);
   @(posedge clock);
   @(posedge clock);
   GradeIt <= 0;
   Guess <= 12'b011_001_110_101;
   @(posedge clock);
   GradeIt <= 1;
   @(posedge clock);
   @(posedge clock);
   @(posedge clock);
   GradeIt <= 0;
   @(posedge clock);
   @(posedge clock);
   @(posedge clock);


   //start game 2 (repeating game 1)

   StartGame <= 1;
   $display("=====START GAME=====");
   //Start game 1
   //load shape pos 2
   @(posedge clock);
   StartGame <= 0;
   LoadShape <= 3'b001;
   ShapeLocation <= 2'b10;
   @(posedge clock);
   @(posedge clock);
   LoadShapeNow <= 1;
   @(posedge clock);
   @(posedge clock);
   LoadShapeNow <= 0;
   @(posedge clock);
   LoadShapeNow <= 1;
   LoadShape <= 3'b101;
   @(posedge clock);
   LoadShapeNow <= 0;
   @(posedge clock);

   //load shape pos 0;
   LoadShape <= 3'b101;
   ShapeLocation <= 2'b00;
   LoadShapeNow <= 0;
   @(posedge clock);
   LoadShapeNow <= 1;
   @(posedge clock);
   LoadShapeNow <= 0;
   @(posedge clock);

   //load shape pos 1;
   LoadShape <= 3'b110;
   ShapeLocation <= 2'b01;
   LoadShapeNow <= 0;
   @(posedge clock);
   LoadShapeNow <= 1;
   @(posedge clock);
   LoadShapeNow <= 0;
   @(posedge clock);

   //load shape pos 3;
   LoadShape <= 3'b011;
   ShapeLocation <= 2'b11;
   LoadShapeNow <= 0;
   @(posedge clock);
   LoadShapeNow <= 1;
   @(posedge clock);
   LoadShapeNow <= 0;
   @(posedge clock);

   //done loading pos3
   //testing
   @(posedge clock);
   LoadShape <= 3'b100;
   LoadShapeNow <= 1;
   @(posedge clock);
   LoadShapeNow <= 0;
   @(posedge clock);
   @(posedge clock);
   LoadShapeNow <= 1;
   @(posedge clock);
   LoadShapeNow <= 0;
   @(posedge clock);

   $display("=====DONE LOADING MP=====");
   //done loading mp: 011_001_110_101
   @(posedge clock);
   Guess <= 12'b011_101_001_010;
   GradeIt <= 1;
   @(posedge clock);
   @(posedge clock);
   @(posedge clock);
   @(posedge clock);
   GradeIt <= 0;
   Guess <= 12'b101_001_010_011;
   @(posedge clock);
   GradeIt <= 1;
   @(posedge clock);
   @(posedge clock);
   @(posedge clock);
   @(posedge clock);
   GradeIt <= 0;
   Guess <= 12'b011_001_110_101;
   @(posedge clock);
   GradeIt <= 1;
   @(posedge clock);
   @(posedge clock);
   @(posedge clock);
   GradeIt <= 0;
   @(posedge clock);
   @(posedge clock);
   @(posedge clock);
   @(posedge clock);
   #1 $finish;
  end


endmodule : lab4task2_tb
