package ca.uqac.inf957.chess.piece;

import ca.uqac.inf957.chess.agent.Move;

public aspect SpecializedMoveChecker {
    pointcut move_legality(Piece piece, Move mv) : (execution(* Piece+.isMoveLegal(..)) && target(piece) && args(mv));

    boolean around (Piece piece, Move mv) : move_legality(piece, mv){
        System.out.println("Is this legal? " + mv.toString());
        return proceed(piece, mv);
    }
}
