import QtQuick 2.0
import "rules.js" as Rules
import "ai.js" as AI

Item {
  id: view

  property bool singlePlayer: false

  signal done

  states: [
    State {
      name: "game"
      PropertyChanges { target: gameover; visible: false }
    },
    State {
      name: "gameover"
      PropertyChanges { target: gameover; visible: true }
    }
  ]

  state: "game"

  TicTacToeCell {
    anchors.fill: parent
    owner: game.turn
    opacity: 0.3
    disabled: true
    animateOwnerChange: false
  }

  MouseArea {
    id: gameover
    anchors.fill: parent
    onClicked: view.done()
  }

  UltimateTicTacToeGrid {
    id: game

    property int turn: 1
    property var previous
    property int previousMove

    anchors.fill: parent
    anchors.margins: parent.width/20
    onClicked: if(!singlePlayer || turn === 1) playTurn(bigCellIndex, cellIndex)

    function playTurn(bigCellIndex, cellIndex) {
      if(previous) {
        previous.highlighted = false;
      }

      var bigCell = getCell(bigCellIndex);
      var grid = bigCell.grid;
      var cell = grid.getCell(cellIndex);

      if(cell.disabled)
        return;

      cell.owner = turn;
      cell.highlighted = true;
      cell.disabled = true;
      previous = cell;
      previousMove = bigCellIndex * 9 + cellIndex;

      if(bigCell.cell.owner === 0) {
        var gridWinner = Rules.gridWinner(grid.getOwnerArray());
        bigCell.cell.owner = gridWinner === null ? 0 : gridWinner;
      }

      var nextBigCellIndex = cellIndex;
      var nextBigCell = getCell(nextBigCellIndex);
      var nextGrid = nextBigCell.grid;

      var nextBigCellHasRoom = false;
      for(var i = 0; i < 9; ++i) {
        if(nextGrid.getCell(i).owner === 0) {
          nextBigCellHasRoom = true;
          break;
        }
      }

      var winner = Rules.gridWinner(getOwnerArray());

      turn = winner !== null && winner !== 0 ? winner : turn == 1 ? 2 : 1;
      for(i = 0; i < 9; ++i) {
        getCell(i).disabled = (winner !== null && winner !== 0) || (i !== nextBigCellIndex && nextBigCellHasRoom);
      }

      if(winner !== null) {
        view.state = "gameover";
      } else if(view.singlePlayer && turn === 2) {
        aiTimer.restart();
      }
    }

    Timer {
      id: aiTimer
      interval: 1000
      running: false
      onTriggered: {
        var board = [];

        for(var i = 0; i < 9; ++i) {
          board = board.concat(game.getCell(i).grid.getOwnerArray());
        }

        var solution = AI.think(board, game.previousMove, 2);
        var bigCellIndex = Math.floor(solution / (3*3));
        var cellIndex = solution % (3*3);
        console.log(bigCellIndex, cellIndex);
        game.playTurn(bigCellIndex, cellIndex);
      }
    }

    function reset() {
      view.state = "game"

      for(var i = 0; i < 9; ++i) {
        getCell(i).disabled = false;
        getCell(i).owner = 0;
        for(var j = 0; j < 9; ++j) {
          getCell(i).grid.getCell(j).owner = 0;
        }
      }
      turn = 1;
    }
  }

  function reset() {
    game.reset();
  }
}