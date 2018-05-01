package com.rapidbizapps.swissmonkey.models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by mlanka on 07-06-2016.
 */
public class CompensationRange {

    @SerializedName("compensation_id")
    int compensationId;

    @SerializedName("compensation_name")
    String compensationName;

    @SerializedName("compensation_value")
    String compensationValue;

    int order;

    String status;

    public int getCompensationId() {
        return compensationId;
    }

    public void setCompensationId(int compensationId) {
        this.compensationId = compensationId;
    }

    public String getCompensationName() {
        return compensationName;
    }

    public void setCompensationName(String compensationName) {
        this.compensationName = compensationName;
    }

    public String getCompensationValue() {
        return compensationValue;
    }

    public void setCompensationValue(String compensationValue) {
        this.compensationValue = compensationValue;
    }

    public int getOrder() {
        return order;
    }

    public void setOrder(int order) {
        this.order = order;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return compensationName;
    }

    @Override
    public boolean equals(Object o) {
        if (o instanceof CompensationRange) {
            if (this.compensationId == ((CompensationRange) o).compensationId) return true;
        }

        return false;
    }
}
