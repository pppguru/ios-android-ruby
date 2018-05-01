package com.rapidbizapps.swissmonkey.models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by mjain on 6/10/2016.
 */
public class BoardCertified {
    @SerializedName("board_certified_id")
    String boardCertifiedId;

    @SerializedName("board_certified_name")
    String boardCertifiedName;

    public BoardCertified(String stateId, String stateName) {
        this.boardCertifiedId = stateId;
        this.boardCertifiedName = stateName;
    }

    public String getBoardCertifiedId() {
        return boardCertifiedId;
    }

    public String getBoardCertifiedName() {
        return boardCertifiedName;
    }

    public void setBoardCertifiedId(String boardCertifiedId) {
        this.boardCertifiedId = boardCertifiedId;
    }

    public void setBoardCertifiedName(String boardCertifiedName) {
        this.boardCertifiedName = boardCertifiedName;
    }

    //To represent in dropdown list
    @Override
    public String toString() {
        return boardCertifiedName;
    }

    @Override
    public boolean equals(Object o) {
        if (o instanceof BoardCertified) {
            if (this.boardCertifiedId.equals(((BoardCertified) o).boardCertifiedId)) {
                return true;
            }
        }

        return false;
    }
}
