package ca.uqac.inf957.chess.agent;

public aspect AspectLogger {
    pointcut AI_move_exec() : execution(* ca.uqac.inf957.chess.agent.StupidAI.move(..));

    before() : AI_move_exec(){
        System.out.println("Im alive in AI");
    }
}
