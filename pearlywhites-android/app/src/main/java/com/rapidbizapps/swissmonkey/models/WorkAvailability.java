
package com.rapidbizapps.swissmonkey.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class WorkAvailability {

    @SerializedName("work_id")
    @Expose
    private Integer workId;
    @SerializedName("work_availabilty_name")
    @Expose
    private String workAvailabiltyName;
    @SerializedName("work_availabilty_value")
    @Expose
    private String workAvailabiltyValue;
    @SerializedName("order")
    @Expose
    private Integer order;
    @SerializedName("status")
    @Expose
    private String status;
    @SerializedName("inserted")
    @Expose
    private String inserted;
    @SerializedName("updated")
    @Expose
    private String updated;
    @SerializedName("created_at")
    @Expose
    private String createdAt;
    @SerializedName("updated_at")
    @Expose
    private String updatedAt;

    /**
     * @return The workId
     */
    public Integer getWorkId() {
        return workId;
    }

    /**
     * @param workId The work_id
     */
    public void setWorkId(Integer workId) {
        this.workId = workId;
    }

    /**
     * @return The workAvailabiltyName
     */
    public String getWorkAvailabiltyName() {
        return workAvailabiltyName;
    }

    /**
     * @param workAvailabiltyName The work_availabilty_name
     */
    public void setWorkAvailabiltyName(String workAvailabiltyName) {
        this.workAvailabiltyName = workAvailabiltyName;
    }

    /**
     * @return The workAvailabiltyValue
     */
    public String getWorkAvailabiltyValue() {
        return workAvailabiltyValue;
    }

    /**
     * @param workAvailabiltyValue The work_availabilty_value
     */
    public void setWorkAvailabiltyValue(String workAvailabiltyValue) {
        this.workAvailabiltyValue = workAvailabiltyValue;
    }

    /**
     * @return The order
     */
    public Integer getOrder() {
        return order;
    }

    /**
     * @param order The order
     */
    public void setOrder(Integer order) {
        this.order = order;
    }

    /**
     * @return The status
     */
    public String getStatus() {
        return status;
    }

    /**
     * @param status The status
     */
    public void setStatus(String status) {
        this.status = status;
    }

    /**
     * @return The inserted
     */
    public String getInserted() {
        return inserted;
    }

    /**
     * @param inserted The inserted
     */
    public void setInserted(String inserted) {
        this.inserted = inserted;
    }

    /**
     * @return The updated
     */
    public String getUpdated() {
        return updated;
    }

    /**
     * @param updated The updated
     */
    public void setUpdated(String updated) {
        this.updated = updated;
    }

    /**
     * @return The createdAt
     */
    public String getCreatedAt() {
        return createdAt;
    }

    /**
     * @param createdAt The created_at
     */
    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    /**
     * @return The updatedAt
     */
    public String getUpdatedAt() {
        return updatedAt;
    }

    /**
     * @param updatedAt The updated_at
     */
    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return workAvailabiltyName;
    }


    @Override
    public boolean equals(Object o) {
        if (o instanceof WorkAvailability) {
            if (this.workId == ((WorkAvailability) o).workId) return true;
        }

        return false;
    }
}