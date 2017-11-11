package ca.uqac.inf957.chess.agent;

public aspect Logger {
    pointcut AI_move_exec() : execution(* StupidAI.move(..));

    before() : AI_move_exec(){
        System.out.println("Im alive in AI");
    }
}
