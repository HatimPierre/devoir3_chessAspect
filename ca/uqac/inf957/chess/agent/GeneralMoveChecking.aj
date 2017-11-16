package ca.uqac.inf957.chess.agent;

public aspect GeneralMoveChecking {
    pointcut move_exec(Move mv, Player player) : execution(* ca.uqac.inf957.chess.agent.*.move(..))
             && args(mv) && target(player);

    boolean around (Move mv, Player player) : move_exec(mv, player){
        // check if color of the piece to be moved matches the player's
        // check if move is on board
        // check if capture is not king or one of player's pieces
        // if ok return proceed
        // if not return false
    }
}
