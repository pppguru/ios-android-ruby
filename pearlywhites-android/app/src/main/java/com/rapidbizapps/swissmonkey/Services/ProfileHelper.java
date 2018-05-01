package com.rapidbizapps.swissmonkey.Services;

import android.net.Uri;

import com.google.gson.JsonArray;
import com.rapidbizapps.swissmonkey.models.Profile;

/**
 * Created by mlanka on 21-06-2016.
 */
public class ProfileHelper {

    private static final String LOG_TAG = "ProfileHelper";
    private static ProfileHelper instance = null;
    int mExperienceId;
    int mBoardCertifiedId = -1;
    int mWorkAvailabilityId;
    int mMilesId;
    int mCompensationId;
    JsonArray mSelectedSkillsArray, mSelectedStatesArray, mSelectedPracticeSoftware, mShifts, mSelectedPositions, mSelectedJobTypes;
    String licenseVerified;
    boolean agreeToTerms;

    public String getLicenseVerified() {
        return licenseVerified;
    }

    public void setLicenseVerified(String licenseVerified) {
        this.licenseVerified = licenseVerified;
    }

    String[] imageUrls, resumeUrls, lorUrls;
    String profilePicPath;
    Uri[] videoUris = new Uri[3];


    String[] modifiedUrls = new String[3];//for urls
    String[] imagesArray = new String[3];//for names

    String[] videoUrls = new String[3];//s3 urls of the videos
    String[] vidoesArray = new String[3];//for names

    String[] videosThumbnailsArray=new String[3];

    public String[] getVideosThumbnailsArray() {
        return videosThumbnailsArray;
    }

    public void setVideosThumbnailsArray(String[] videosThumbnailsArray) {
        this.videosThumbnailsArray = videosThumbnailsArray;
    }

    public String[] getModifiedUrls() {
        return modifiedUrls;
    }

    public void setModifiedUrls(String[] modifiedUrls) {
        this.modifiedUrls = modifiedUrls;
    }

    public String[] getImagesArray() {
        return imagesArray;
    }

    public void setImagesArray(String[] imagesArray) {
        this.imagesArray = imagesArray;
    }

    public String[] getVidoesArray() {
        return vidoesArray;
    }

    public void setVidoesArray(String[] vidoesArray) {
        this.vidoesArray = vidoesArray;
    }

    String[] mRecommendUrls = new String[2];
    String[] mRecommendArray = new String[2];


    String[] mModifiedResumeUrls = new String[5];
    String[] mResumesArray = new String[5];


    public String[] getmRecommendUrls() {
        return mRecommendUrls;
    }

    public void setmRecommendUrls(String[] mRecommendUrls) {
        this.mRecommendUrls = mRecommendUrls;
    }

    public String[] getmRecommendArray() {
        return mRecommendArray;
    }

    public void setmRecommendArray(String[] mRecommendArray) {
        this.mRecommendArray = mRecommendArray;
    }

    public String[] getmModifiedResumeUrls() {
        return mModifiedResumeUrls;
    }

    public void setmModifiedResumeUrls(String[] mModifiedResumeUrls) {
        this.mModifiedResumeUrls = mModifiedResumeUrls;
    }

    public String[] getmResumesArray() {
        return mResumesArray;
    }

    public void setmResumesArray(String[] mResumesArray) {
        this.mResumesArray = mResumesArray;
    }


    public Uri[] getVideoUris() {
        return videoUris;
    }

    public void setVideoUris(Uri[] videoUris) {
        this.videoUris = videoUris;
    }

    public String getProfilePicPath() {
        return profilePicPath;
    }

    public void setProfilePicPath(String profilePicPath) {
        this.profilePicPath = profilePicPath;
    }

    public String[] getVideoUrls() {
        return videoUrls;
    }

    public void setVideoUrls(String[] videoUrls) {
        this.videoUrls = videoUrls;
    }

    public String[] getImageUrls() {
        return imageUrls;
    }

    public void setImageUrls(String[] imageUrls) {
        this.imageUrls = imageUrls;
    }

    public String[] getResumeUrls() {
        return resumeUrls;
    }

    public void setResumeUrls(String[] resumeUrls) {
        this.resumeUrls = resumeUrls;
    }

    public String[] getLorUrls() {
        return lorUrls;
    }

    public void setLorUrls(String[] lorUrls) {
        this.lorUrls = lorUrls;
    }

    public boolean isProfilePicSet() {
        return isProfilePicSet;
    }

    public void setProfilePicSet(boolean profilePicSet) {
        isProfilePicSet = profilePicSet;
    }

    boolean isProfilePicSet;

    private ProfileHelper() {
        // Exists only to defeat instantiation.
    }

    public static ProfileHelper getInstance() {
        if (instance == null) {
            instance = new ProfileHelper();
        }
        return instance;
    }
    public static void setInstance()
    {
        instance=null;
    }


    public int getMilesId() {
        return mMilesId;
    }

    public void setMilesId(int milesId) {
        mMilesId = milesId;
    }

    public int getCompensationId() {
        return mCompensationId;
    }

    public void setCompensationId(int compensationId) {
        mCompensationId = compensationId;
    }

    public int getWorkAvailabilityId() {
        return mWorkAvailabilityId;
    }

    public void setWorkAvailabilityId(int workAvailabilityId) {
        mWorkAvailabilityId = workAvailabilityId;
    }

    public JsonArray getShifts() {
        return mShifts;
    }

    public void setShifts(JsonArray shifts) {
        mShifts = shifts;
    }

    public int getBoardCertifiedId() {
        return mBoardCertifiedId;
    }

    public void setBoardCertifiedId(int boardCertifiedId) {
        mBoardCertifiedId = boardCertifiedId;
    }

    public int getExperienceId() {
        return mExperienceId;
    }

    public void setExperienceId(int experienceId) {
        mExperienceId = experienceId;
    }

    public JsonArray getSelectedSkillsArray() {
        return mSelectedSkillsArray;
    }

    public void setSelectedSkillsArray(JsonArray selectedSkillsArray) {
        mSelectedSkillsArray = selectedSkillsArray;
    }

    public JsonArray getSelectedPracticeSoftware() {
        return mSelectedPracticeSoftware;
    }

    public void setSelectedPracticeSoftware(JsonArray selectedPracticeSoftware) {
        mSelectedPracticeSoftware = selectedPracticeSoftware;
    }

    public JsonArray getSelectedPositions() {
        return mSelectedPositions;
    }

    public void setSelectedPositions(JsonArray selectedPositions) {
        mSelectedPositions = selectedPositions;
    }

    public JsonArray getSelectedJobTypes() {
        return mSelectedJobTypes;
    }

    public void setSelectedJobTypes(JsonArray selectedJobTypes) {
        this.mSelectedJobTypes = selectedJobTypes;
    }

    public void setSelectedStatesArray(JsonArray selectedStatesArray) {
        mSelectedStatesArray = selectedStatesArray;
    }

    public JsonArray getSelectedStatesArray() {
        return mSelectedStatesArray;
    }

    public boolean isAgreeToTerms() {
        return agreeToTerms;
    }

    public void setAgreeToTerms(boolean agreeToTerms) {
        this.agreeToTerms = agreeToTerms;
    }
}
