package com.rapidbizapps.swissmonkey.models;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by mlanka on 10-07-2016.
 */
public class WeekdayInfo implements Parcelable{
    int shiftID;

    String[] days;

    protected WeekdayInfo(Parcel in) {
        shiftID = in.readInt();
        days = in.createStringArray();
    }

    public static final Creator<WeekdayInfo> CREATOR = new Creator<WeekdayInfo>() {
        @Override
        public WeekdayInfo createFromParcel(Parcel in) {
            return new WeekdayInfo(in);
        }

        @Override
        public WeekdayInfo[] newArray(int size) {
            return new WeekdayInfo[size];
        }
    };

    public int getShiftID() {
        return shiftID;
    }

    public void setShiftID(int shiftID) {
        this.shiftID = shiftID;
    }

    public String[] getDays() {
        return days;
    }

    public void setDays(String[] days) {
        this.days = days;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(shiftID);
        dest.writeStringArray(days);
    }
}
