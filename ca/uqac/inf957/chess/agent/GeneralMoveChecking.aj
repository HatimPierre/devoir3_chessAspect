package ca.uqac.inf957.chess.agent;

import ca.uqac.inf957.chess.Board;
import ca.uqac.inf957.chess.Spot;
import ca.uqac.inf957.chess.piece.Piece;

public aspect GeneralMoveChecking {
    private static Spot[][] ss = null;
    private static boolean init = false;

    pointcut move_legality(Piece piece, Move mv) : (execution(* ca.uqac.inf957.chess.piece.Piece+.isMoveLegal(..)) && target(piece) && args(mv));
    pointcut move_exec(Move mv, Player player) : (execution(* ca.uqac.inf957.chess.agent.StupidAI.move(..))
             || execution(* ca.uqac.inf957.chess.agent.HumanPlayer.move(..)))
             && args(mv) && target(player);

    before(Move mv, Player player) : move_exec(mv, player){
        if (!init){
            ss = player.getPlayGround().getGrid();
            init = true;
        }
    }

    boolean around (Move mv, Player player) : move_exec(mv, player){
        // check if move is on board
        // check if square has a piece
        // check if color of the piece to be moved matches the player's
        // check if capture is not king or one of player's pieces
        // use the piece's legalMove checker to verify if it's ok
        // if ok return proceed
        // if not return false

        String color = player.Colour == Player.BLACK ? "Black" : "White";
        System.out.println("Player " + color + " is trying a move");
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

        return pi.isMoveLegal(mv) && proceed(mv, player);

    }

    private int chebychev(Move mv){
        return Math.max(Math.abs(mv.xF - mv.xI), Math.abs(mv.yI - mv.yF));
    }

    private boolean slide(Move mv){
        int dir[] = {0,0}; // x y
        System.out.println("Looking at slinding move : " + mv.toString() +
        "\nWith infos xI : " + mv.xI + " yI : " + mv.yI +
        " xF : " + mv.xF + " yF : " + mv.yF +
        "\nWith chebychev : " + chebychev(mv));
        if (mv.xF - mv.xI > 0)
            dir[0] = 1;
        else if (mv.xF - mv.xI < 0)
            dir[0] = -1;

        if (mv.yF - mv.yI > 0)
            dir[1] = 1;
        else if (mv.yF - mv.yI < 0)
            dir[1] = -1;

        System.out.println("Found moving in the direction x : " + dir[0] + " y : " + dir[1]);

        int x = mv.xI;
        int y = mv.yI;

        for (int i = 0; i < chebychev(mv); i++){
            x += dir[0];
            y += dir[1];
            System.out.println("Currently examined square is x : " + x + " y : " + y +
            "\npiece here is : " + ss[x][y].getPiece());
            if (ss[x][y].getPiece() != null)
                return false;
        }
        return true;
    }

    boolean around (Piece piece, Move mv) : move_legality(piece, mv){
        System.out.println("Is this legal? " + mv.toString());
        String s = piece.toString();

        if (chebychev(mv) == 0)
            return false;

        switch (s) {
            case "p":
            case "P":
                System.out.println("It's a pawn, or a bishop. Treating it as pawn..");
                if (((chebychev(mv) == 2 && (mv.yI != 1 && mv.yI != 6))) || chebychev(mv) > 2)
                    return false;

                if ((piece.getPlayer() == Player.BLACK && mv.yI < mv.yF) ||
                    (piece.getPlayer() == Player.WHITE && mv.yI > mv.yF))
                    return false;
                break;
            case "r":
            case "R":
                System.out.println("It'a King");
                if (chebychev(mv) > 1)
                    return false;
                break;
            case "c":
            case "C":
                System.out.println("It'a Knight");
                if ((Math.abs(mv.yF - mv.yI) == 2 && Math.abs(mv.xF - mv.xI) == 1)
                        ||(Math.abs(mv.xF - mv.xI) == 2 && Math.abs(mv.yF - mv.yI) == 1))
                    return true;
                else
                    return false;
            case "d":
            case "D":
                System.out.println("It'a Queen");
                if ((mv.xI != mv.xF && mv.yI != mv.yF) &&
                    (Math.abs(mv.xI - mv.xF) != Math.abs(mv.yI - mv.yF)))
                    return false;
                if (!slide(mv))
                    return false;
                break;
            case "t":
            case "T":
                System.out.println("It'a Rook");
                if (mv.xI != mv.xF && mv.yI != mv.yF)
                    return false;
                if (!slide(mv))
                    return false;
                break;
            default:
                System.out.println("Unrecognized piece " + s +" can't apply any specific behavior");
                break;
        }
        return true;
    }
}
