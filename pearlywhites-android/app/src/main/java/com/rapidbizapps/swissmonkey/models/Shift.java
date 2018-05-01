package com.rapidbizapps.swissmonkey.models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by mlanka on 07-06-2016.
 */
public class Shift {

    @SerializedName("shift_id")
    int shiftId;

    @SerializedName("shift_timings")
    String shiftTimings;

    @SerializedName("Shift_name")
    String shiftName;

    public int getShiftId() {
        return shiftId;
    }

    public void setShiftId(int shiftId) {
        this.shiftId = shiftId;
    }

    public String getShiftTimings() {
        return shiftTimings;
    }

    public void setShiftTimings(String shiftTimings) {
        this.shiftTimings = shiftTimings;
    }

    public String getShiftName() {
        return shiftName;
    }

    public void setShiftName(String shiftName) {
        this.shiftName = shiftName;
    }
}
