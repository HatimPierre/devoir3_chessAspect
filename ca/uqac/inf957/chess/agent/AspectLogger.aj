package ca.uqac.inf957.chess.agent;

import java.io.PrintWriter;

public aspect AspectLogger {
    private PrintWriter logWriter = null;

    public AspectLogger(){
        try {
            logWriter = new PrintWriter("log_chess.txt", "UTF-8");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    pointcut AI_move_exec(Move mv) : execution(* ca.uqac.inf957.chess.agent.StupidAI.move(..)) && args(mv);
    pointcut HU_move_exec(Move mv) : execution(* ca.uqac.inf957.chess.agent.HumanPlayer.move(..)) && args(mv);

    after(Move mv) returning(boolean isok) : AI_move_exec(mv){
        if (isok){
            logWriter.println("AI played    : " + mv.toString());
            logWriter.flush();
        }
    }

    after(Move mv) returning(boolean isok) : HU_move_exec(mv){
        if (isok){
            logWriter.println("Human played :  " + mv.toString());
            logWriter.flush();
        }
    }
}
