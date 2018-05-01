package com.rapidbizapps.swissmonkey.models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by mlanka on 07-06-2016.
 */
public class State {

    @SerializedName("state_id")
    String stateId;

    @SerializedName("state_name")
    String stateName;

    public String getStateId() {
        return stateId;
    }

    public void setStateId(String stateId) {
        this.stateId = stateId;
    }

    public String getStateName() {
        return stateName;
    }

    public void setStateName(String stateName) {
        this.stateName = stateName;
    }

    //To represent in dropdown list
    @Override
    public String toString() {
        return stateName;
    }

    @Override
    public boolean equals(Object o) {
        if (o instanceof State) {
            if (this.stateId.equals(((State) o).stateId)) {
                return true;
            }
        }

        return false;
    }
}
