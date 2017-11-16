package ca.uqac.inf957.chess.agent;

import ca.uqac.inf957.chess.Board;
import ca.uqac.inf957.chess.Spot;
import ca.uqac.inf957.chess.piece.Piece;

public aspect GeneralMoveChecking {
    pointcut move_exec(Move mv, Player player) : (execution(* ca.uqac.inf957.chess.agent.StupidAI.move(..))
             || execution(* ca.uqac.inf957.chess.agent.HumanPlayer.move(..)))
             && args(mv) && target(player);

    boolean around (Move mv, Player player) : move_exec(mv, player){
        // check if move is on board
        // check if square has a piece
        // check if color of the piece to be moved matches the player's
        // check if capture is not king or one of player's pieces
        // use the piece's legalMove checker to verify if it's ok
        // if ok return proceed
        // if not return false

        if (mv.xI < 0 || mv.xI > 7 || mv.yI < 0 || mv.yI > 7 ||
                mv.xF < 0 || mv.xF > 7 || mv.yF < 0 || mv.yF > 7)
            return false;

        Board b = player.getPlayGround();
        Spot[][] ss = b.getGrid();
        Spot init = ss[mv.xI][mv.yI];
        Spot fina = ss[mv.xF][mv.yF];
        Piece pi = init.getPiece();
        Piece pf = fina.getPiece();

        if (pi == null || pi.getPlayer() != player.Colour)
            return false;
        if (pf != null && (pf.getPlayer() == player.Colour ||
                pf.toString().equals("rb") || pf.toString().equals("R")))
            return false;

        pi.isMoveLegal(mv);
        return proceed(mv, player);
    }
}
