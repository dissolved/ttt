
var TicTacToe = function() {
  this.turn = 0;
  this.board = new Array(9); //[[null,null,null],[null,null,null],[null,null,null]];
  
  this.humanMove = function(pos) {
    $('s' + pos).update("X");
    var compMove = this.computerResponse(pos);
    $('s' + compMove).update("O");
  }
  
  
  this.recordMove = function(pos,who) {
    this.board[pos] = who;
  }
  
  
  this.computerResponse = function(pos) {
    this.recordMove(pos,'X');
    
    if (++this.turn == 1) {
      if (pos == 4) { return 0; } else { return 4; }
    }
    else {
      
    }
  }
  
  
  this.findWinningMove = function(player) {
    for(var i; i < 3; i++){
      
    }
  }
}

var theGame = new TicTacToe;