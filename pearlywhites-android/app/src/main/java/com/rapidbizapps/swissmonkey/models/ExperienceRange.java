package com.rapidbizapps.swissmonkey.models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by mlanka on 07-06-2016.
 */
public class ExperienceRange {

    @SerializedName("experience_range_id")
    int experienceRangeId;

    @SerializedName("experience_range")
    String experienceRange;

    @SerializedName("created-at")
    String createdAt;

    @SerializedName("updated_at")
    String updatedAt;

    public int getExperienceRangeId() {
        return experienceRangeId;
    }

    public void setExperienceRangeId(int experienceRangeId) {
        this.experienceRangeId = experienceRangeId;
    }

    public String getExperienceRange() {
        return experienceRange;
    }

    public void setExperienceRange(String experienceRange) {
        this.experienceRange = experienceRange;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return experienceRange;
    }

    @Override
    public boolean equals(Object o) {
        if (o instanceof ExperienceRange) {
            if (this.experienceRangeId == ((ExperienceRange) o).experienceRangeId) return true;
        }

        return false;
    }
}
