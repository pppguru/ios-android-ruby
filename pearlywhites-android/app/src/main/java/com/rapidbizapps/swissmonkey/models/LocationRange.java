package com.rapidbizapps.swissmonkey.models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by mlanka on 07-06-2016.
 */
public class LocationRange {

    @SerializedName("range_id")
    int rangeId;

    @SerializedName("miles_range")
    String milesRange;

    @SerializedName("from_range")
    int fromRange;

    public int getToRange() {
        return toRange;
    }

    public void setToRange(int toRange) {
        this.toRange = toRange;
    }

    public int getRangeId() {
        return rangeId;
    }

    public void setRangeId(int rangeId) {
        this.rangeId = rangeId;
    }

    public String getMilesRange() {
        return milesRange;
    }

    public void setMilesRange(String milesRange) {
        this.milesRange = milesRange;
    }

    public int getFromRange() {
        return fromRange;
    }

    public void setFromRange(int fromRange) {
        this.fromRange = fromRange;
    }

    @SerializedName("to_range")

    int toRange;

    @Override
    public String toString() {
        return milesRange;
    }

    @Override
    public boolean equals(Object o) {
        if (o instanceof LocationRange) {
            if (this.rangeId == ((LocationRange) o).rangeId) return true;
        }

        return false;
    }
}
