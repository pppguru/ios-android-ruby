package com.rapidbizapps.swissmonkey.models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by mlanka on 07-06-2016.
 */
public class JobType {
    @SerializedName("job_type_id")
    int jobTypeId;
    @SerializedName("job_type")
    String jobType;

    public int getJobTypeId() {
        return jobTypeId;
    }

    public void setJobTypeId(int jobTypeId) {
        this.jobTypeId = jobTypeId;
    }

    public String getJobType() {
        return jobType;
    }

    public void setJobType(String jobType) {
        this.jobType = jobType;
    }

    @Override
    public String toString() {
        return jobType;
    }

    @Override
    public boolean equals(Object o) {
        if (o instanceof JobType) {
            if (this.jobTypeId == ((JobType) o).jobTypeId)
                return true;
        }

        return false;
    }

    public static String toBackendName(int jobTypeId) {
        switch (jobTypeId) {
            case 1:
                return "FULL_TIME";
            case 2:
                return "PART_TIME";
            case 5:
                return "TEMP";
            case 7:
                return "EXTERNSHIP";
            default:
                return "OTHER";
        }
    }

    public static int toJobTypeId(String backendName) {
        if (backendName.equalsIgnoreCase("FULL_TIME")) {
            return 1;
        } else if (backendName.equalsIgnoreCase("PART_TIME")) {
            return 2;
        } else if (backendName.equalsIgnoreCase("TEMP")) {
            return 5;
        } else if (backendName.equalsIgnoreCase("EXTERNSHIP")) {
            return 7;
        } else {
            return 8;
        }
    }
}
