package com.rapidbizapps.swissmonkey.Services;

import com.google.gson.JsonObject;
import com.rapidbizapps.swissmonkey.models.CompensationRange;
import com.rapidbizapps.swissmonkey.models.ExperienceRange;
import com.rapidbizapps.swissmonkey.models.JobType;
import com.rapidbizapps.swissmonkey.models.LocationRange;
import com.rapidbizapps.swissmonkey.models.Position;
import com.rapidbizapps.swissmonkey.models.PracticeManagementSoftware;
import com.rapidbizapps.swissmonkey.models.Shift;
import com.rapidbizapps.swissmonkey.models.SoftwareProficiency;
import com.rapidbizapps.swissmonkey.models.State;
import com.rapidbizapps.swissmonkey.models.WorkAvailability;

import java.util.List;

/**
 * Created by mlanka on 07-06-2016.
 */
public class DataHelper {

    private static DataHelper instance = null;

    List<LocationRange> mLocationRanges;

    List<ExperienceRange> mExperiences;

    List<JobType> mJobTypes;

    List<CompensationRange> mCompensationRanges;

    List<SoftwareProficiency> mSoftwareProficiencies;

    List<Shift> mShifts;

    public JsonObject[] getWorkDays() {
        return mWorkDays;
    }

    public void setWorkDays(JsonObject[] workDays) {
        mWorkDays = workDays;
    }

    JsonObject[] mWorkDays;

    List<PracticeManagementSoftware> mPracticeManagementSoftwares;

    List<State> mStates;

    List<Position> mPositions;

    List<WorkAvailability> mWorkAvailabilities;

    public List<WorkAvailability> getWorkAvailabilities() {
        return mWorkAvailabilities;
    }

    public void setWorkAvailabilities(List<WorkAvailability> workAvailabilities) {
        mWorkAvailabilities = workAvailabilities;
    }

    public List<Position> getPositions() {
        return mPositions;
    }

    public void setPositions(List<Position> positions) {
        mPositions = positions;
    }

    public List<State> getStates() {
        return mStates;
    }

    public void setStates(List<State> states) {
        mStates = states;
    }

    public List<PracticeManagementSoftware> getPracticeManagementSoftwares() {
        return mPracticeManagementSoftwares;
    }

    public void setPracticeManagementSoftwares(List<PracticeManagementSoftware> practiceManagementSoftwares) {
        mPracticeManagementSoftwares = practiceManagementSoftwares;
    }

    public List<ExperienceRange> getExperiences() {
        return mExperiences;
    }

    public void setExperiences(List<ExperienceRange> experiences) {
        mExperiences = experiences;
    }

    public List<JobType> getJobTypes() {
        return mJobTypes;
    }

    public void setJobTypes(List<JobType> jobTypes) {
        mJobTypes = jobTypes;
    }

    public List<CompensationRange> getCompensationRanges() {
        return mCompensationRanges;
    }

    public void setCompensationRanges(List<CompensationRange> compensationRanges) {
        mCompensationRanges = compensationRanges;
    }

    public List<SoftwareProficiency> getSoftwareProficiencies() {
        return mSoftwareProficiencies;
    }

    public void setSoftwareProficiencies(List<SoftwareProficiency> softwareProficiencies) {
        mSoftwareProficiencies = softwareProficiencies;
    }

    public List<Shift> getShifts() {
        return mShifts;
    }

    public void setShifts(List<Shift> shifts) {
        mShifts = shifts;
    }

    public List<LocationRange> getLocationRanges() {
        return mLocationRanges;
    }

    public void setLocationRanges(List<LocationRange> locationRanges) {
        mLocationRanges = locationRanges;
    }

    private DataHelper() {
        // Exists only to defeat instantiation.
    }
    public static DataHelper getInstance() {
        if(instance == null) {
            instance = new DataHelper();
        }
        return instance;
    }


}
