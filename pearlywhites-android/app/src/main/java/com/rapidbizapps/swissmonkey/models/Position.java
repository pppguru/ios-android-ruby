package com.rapidbizapps.swissmonkey.models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by mlanka on 31-05-2016.
 */
public class Position {
    @SerializedName("position_id")
    int positionId;
    @SerializedName("position_name")
    String positionName;
    @SerializedName("order_id")
    int orderId;
    @SerializedName("position_value")
    String positionvalue;

    public int getPositionId() {
        return positionId;
    }

    public void setPositionId(int positionId) {
        this.positionId = positionId;
    }

    public String getPositionName() {
        return positionName;
    }

    public void setPositionName(String positionName) {
        this.positionName = positionName;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getPositionvalue() {
        return positionvalue;
    }

    public void setPositionvalue(String positionvalue) {
        this.positionvalue = positionvalue;
    }

    //To represent in dropdown list
    @Override
    public String toString() {
        return positionName;
    }


    @Override
    public boolean equals(Object o) {
        if (o instanceof Position) {
            if (this.positionId == ((Position) o).positionId)
                return true;
        }

        return false;
    }
}
