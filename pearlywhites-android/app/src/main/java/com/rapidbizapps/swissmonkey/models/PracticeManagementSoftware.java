package com.rapidbizapps.swissmonkey.models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by mlanka on 07-06-2016.
 */
public class PracticeManagementSoftware {

    @SerializedName("software_id")
    int softwareId;

    String software;

    String status;

    @SerializedName("visible_to")
    String visibleTo;

    @SerializedName("software_value")
    String softwareValue;

    public int getSoftwareId() {
        return softwareId;
    }

    public void setSoftwareId(int softwareId) {
        this.softwareId = softwareId;
    }

    public String getSoftware() {
        return software;
    }

    public void setSoftware(String software) {
        this.software = software;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getVisibleTo() {
        return visibleTo;
    }

    public void setVisibleTo(String visibleTo) {
        this.visibleTo = visibleTo;
    }

    public String getSoftwareValue() {
        return softwareValue;
    }

    public void setSoftwareValue(String softwareValue) {
        this.softwareValue = softwareValue;
    }

    @Override
    public String toString() {
        return software;
    }

    @Override
    public boolean equals(Object o) {
        if (o instanceof PracticeManagementSoftware) {
            if (this.softwareId == ((PracticeManagementSoftware) o).softwareId) return true;
        }
        return false;
    }
}
