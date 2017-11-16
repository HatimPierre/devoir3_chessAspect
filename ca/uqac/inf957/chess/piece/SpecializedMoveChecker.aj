package ca.uqac.inf957.chess.piece;

import ca.uqac.inf957.chess.agent.Move;

public aspect SpecializedMoveChecker {
    pointcut move_legality(Piece piece, Move mv) : (execution(* Piece+.isMoveLegal(..)) && target(piece) && args(mv));

    boolean around (Piece piece, Move mv) : move_legality(piece, mv){
        System.out.println("Is this legal? " + mv.toString());
        String s = piece.toString();

        switch (s) {
            case "p":
            case "P":
                System.out.println("It's a pawn, or a bishop. Not sure that's intended behavior..");
                //TODO handle pawns mvt
                break;
            case "r":
            case "R":
                System.out.println("It'a King");
                //TODO handle King mvt
                break;
            case "c":
            case "C":
                System.out.println("It'a Knight");
                //TODO handle Knight mvt
                break;
            case "d":
            case "D":
                System.out.println("It'a Queen");
                //TODO handle Queen mvt
                break;
            case "t":
            case "T":
                System.out.println("It'a Rook");
                //TODO handle Rook mvt
                break;
            default:
                System.out.println("Unrecognized piece " + s +" can't apply any specific behavior");
                break;
        }
        return proceed(piece, mv);
    }
}
