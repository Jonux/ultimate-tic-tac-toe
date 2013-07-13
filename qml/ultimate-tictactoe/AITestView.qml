import QtQuick 2.0
import "rules.js" as Rules
import "ai.js" as AI

Item {
  property int gr_r: 0
  property int gr_g: 0
  property int gr_tie: 0
  property int rmc_r: 0
  property int rmc_mc: 0
  property int rmc_tie: 0
  property int gmc_g: 0
  property int gmc_mc: 0
  property int gmc_tie: 0
  property int mcmc_mc1: 0
  property int mcmc_mc2: 0
  property int mcmc_tie: 0

  function runRandomVsGreedy() {
    gr_g = 0;
    gr_r = 0;
    gr_tie = 0;
    gameRunner.sendMessage({ai1: "random", ai2: "greedy", n: 1000});
  }
  function runRandomVsMonteCarlo() {
    rmc_r = 0;
    rmc_mc = 0;
    rmc_tie = 0;
    gameRunner.sendMessage({ai1: "random", ai2: "montecarlo", n: 100});
  }
  function runGreedyVsMonteCarlo() {
    gmc_g = 0;
    gmc_mc = 0;
    gmc_tie = 0;
    gameRunner.sendMessage({ai1: "greedy", ai2: "montecarlo", n: 100});
  }

  function runMonteCarloVsMonteCarlo() {
    mcmc_mc1 = 0;
    mcmc_mc2 = 0;
    mcmc_tie = 0;
    gameRunner.sendMessage({ai1: "montecarlo1", ai2: "montecarlo2", n: 100});
  }

  WorkerScript {
    id: gameRunner
    source: "aiTest.js"
    onMessage: {
      var ai1 = messageObject.request.ai1;
      var ai2 = messageObject.request.ai2;
      if(ai1 === "random" && ai2 === "greedy") {
        gr_r = messageObject.ai1;
        gr_g = messageObject.ai2;
        gr_tie = messageObject.ties;
      } else if(ai1 === "random" && ai2 === "montecarlo") {
        rmc_r = messageObject.ai1;
        rmc_mc = messageObject.ai2;
        rmc_tie = messageObject.ties;
      } else if(ai1 === "greedy" && ai2 === "montecarlo") {
        gmc_g = messageObject.ai1;
        gmc_mc = messageObject.ai2;
        gmc_tie = messageObject.ties;
      } else if(ai1 === "montecarlo1" && ai2 === "montecarlo2") {
        mcmc_mc1 = messageObject.ai1;
        mcmc_mc2 = messageObject.ai2;
        mcmc_tie = messageObject.ties;
      }
    }
  }

  Column {
    Row {
      Button {
        label: "Random vs. Greedy"
        onClicked: runRandomVsGreedy()
        color: "#444"
        width: 300
      }
      Column {
        Text {
          text: "Random: " + gr_r
        }
        Text {
          text: "Greedy: " + gr_g
        }
        Text {
          text: "Ties: " + gr_tie
        }
      }
    }
    Row {
      Button {
        label: "Random vs. MonteCarlo"
        onClicked: runRandomVsMonteCarlo()
        color: "#444"
        width: 300
      }
      Column {
        Text {
          text: "Random: " + rmc_r
        }
        Text {
          text: "MonteCarlo: " + rmc_mc
        }
        Text {
          text: "Ties: " + rmc_tie
        }
      }
    }
    Row {
      Button {
        label: "Greedy vs. MonteCarlo"
        onClicked: runGreedyVsMonteCarlo()
        color: "#444"
        width: 300
      }
      Column {
        Text {
          text: "Greedy: " + gmc_g
        }
        Text {
          text: "MonteCarlo: " + gmc_mc
        }
        Text {
          text: "Ties: " + gmc_tie
        }
      }
    }
    Row {
      Button {
        label: "MonteCarlo1 vs. MonteCarlo2"
        onClicked: runMonteCarloVsMonteCarlo()
        color: "#444"
        width: 300
      }
      Column {
        Text {
          text: "MonteCarlo1: " + mcmc_mc1
        }
        Text {
          text: "MonteCarlo2: " + mcmc_mc2
        }
        Text {
          text: "Ties: " + mcmc_tie
        }
      }
    }
  }
}