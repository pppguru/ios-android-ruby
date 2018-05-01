package com.rapidbizapps.swissmonkey.models;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by mlanka on 07-06-2016.
 */
public class SoftwareProficiency {

    @SerializedName("software_type_id")
    int softwareTypeId;

    @SerializedName("software_type_name")
    String softwareTypeName;

    @SerializedName("software_type_value")
    String softwareTypeValue;

    @SerializedName("parent_id")
    Integer parentId;

    String status;

    List<SoftwareProficiency> subCategories = new ArrayList<>();

    public List<SoftwareProficiency> getSubCategories() {
        return subCategories;
    }

    public void setSubCategories(List<SoftwareProficiency> subCategories) {
        this.subCategories = subCategories;
    }

    public int getSoftwareTypeId() {
        return softwareTypeId;
    }

    public void setSoftwareTypeId(int softwareTypeId) {
        this.softwareTypeId = softwareTypeId;
    }

    public String getSoftwareTypeName() {
        return softwareTypeName;
    }

    public void setSoftwareTypeName(String softwareTypeName) {
        this.softwareTypeName = softwareTypeName;
    }

    public String getSoftwareTypeValue() {
        return softwareTypeValue;
    }

    public void setSoftwareTypeValue(String softwareTypeValue) {
        this.softwareTypeValue = softwareTypeValue;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getParentId() {
        return parentId;
    }

    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }

    @Override
    public boolean equals(Object o) {
        if (o instanceof SoftwareProficiency) {
            if (this.softwareTypeId == ((SoftwareProficiency) o).softwareTypeId) return true;
        }

        return false;
    }



}
