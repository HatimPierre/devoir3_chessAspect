package ca.uqac.inf957.chess.agent;

import ca.uqac.inf957.chess.Board;
import ca.uqac.inf957.chess.Spot;
import ca.uqac.inf957.chess.piece.Piece;

public aspect GeneralMoveChecking {
    pointcut move_exec(Move mv, Player player) : (execution(* ca.uqac.inf957.chess.agent.StupidAI.move(..))
             || execution(* ca.uqac.inf957.chess.agent.HumanPlayer.move(..)))
             && args(mv) && target(player);

    boolean around (Move mv, Player player) : move_exec(mv, player){
        // check if color of the piece to be moved matches the player's
        // check if move is on board
        // check if capture is not king or one of player's pieces
        // use the piece's legalMove checker to verify if it's ok
        // if ok return proceed
        // if not return false
        Board b = player.getPlayGround();
        Spot[][] ss = b.getGrid();
        Spot s = ss[mv.xI][mv.yI];
        Piece p = s.getPiece();
        p.isMoveLegal(mv);
        return proceed(mv, player);
    }
}
