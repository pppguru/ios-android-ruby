package com.rapidbizapps.swissmonkey.models;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.annotations.SerializedName;
import com.rapidbizapps.swissmonkey.Services.ProfileHelper;

/**
 * Created by mjain on 6/2/2016.
 */
public class Profile implements Parcelable {

    public static final Creator<Profile> CREATOR = new Creator<Profile>() {
        @Override
        public Profile createFromParcel(Parcel source) {
            return null;
        }

        @Override
        public Profile[] newArray(int size) {
            return new Profile[0];
        }
    };

    private static Profile instance = null;
    @SerializedName("profile")
    String profilePic;

    String newPracticeSoftware;

    public String getNewPracticeSoftware() {
        return newPracticeSoftware;
    }

    public void setNewPracticeSoftware(String newPracticeSoftware) {
        this.newPracticeSoftware = newPracticeSoftware;
    }

    @SerializedName("profile_url")
    String profile_url;

    @SerializedName("licenseVerified")
    String licenseVerified;
    @SerializedName("name")
    String name;
    @SerializedName("addressLine1")
    String addressLine1;
    @SerializedName("addressLine2")
    String addressLine2;
    @SerializedName("city")
    String cityname;
    @SerializedName("state")
    String statename;
    @SerializedName("zipcode")
    String zipcode;
    @SerializedName("email")
    String email;
    @SerializedName("phoneNumber")
    String phoneNumber;
    @SerializedName("aboutMe")
    String aboutMe;
    @SerializedName("positionIDs")
    int[] positionIDs;
    @SerializedName("experienceID")
    int experienceID=-1;
    @SerializedName("boardCretifiedID") // TODO: 21-06-2016 typo!
    int boardCertifiedID = -1;
    @SerializedName("licenseNumber")
    String licenseNumber;
    @SerializedName("licenseExpiry")
    String licenseExpiry;
    @SerializedName("job_types")
    String[] jobTypes;
    @SerializedName("workAvailabilityID")
    int workAvailablityID=-1;
    @SerializedName("workAvailabilityDate")
    String workAvailabilityDate;
    @SerializedName("practiceManagementID")
    String[] practiceManagementID;
    @SerializedName("shifts")
    JsonObject[] shifts;
    @SerializedName("resume")
    String[] resume;

    @SerializedName("resume_url")
    String[] resume_url;

    @SerializedName("recomendationLettrs")
    String[] recommendationLetters;

    @SerializedName("recomendationLettrs_url")
    String[] recomendationLettrs_url;

    @SerializedName("image")
    String[] image;

    @SerializedName("image_url")
    String[] image_url;

    @SerializedName("video")
    String[] video;

    @SerializedName("video_url")
    String[] video_url;  // TODO: 09-08-2016 change the convention


    @SerializedName("videoThumbnail")
    String[] videoThumbnail;


    @SerializedName("locationRangeID")
    int locationRangeID=-1;
    @SerializedName("miles")
    int miles;
    @SerializedName("skills")
    String[] skills;
    @SerializedName("compensationID")
    int compensationID;
    @SerializedName("salary")
    String salary;
    @SerializedName("comments")
    String comments;
    @SerializedName("bilingual_languages")
    String bilingualLanguages;

    @SerializedName("from_salary_range")
    String salaryMin;

    @SerializedName("to_salary_range")
    String salaryMax;

    public String[] getLicenseVerifiedStates() {
        return licenseVerifiedStates;
    }

    public void setLicenseVerifiedStates(String[] licenseVerifiedStates) {
        this.licenseVerifiedStates = licenseVerifiedStates;
    }

    @SerializedName("licenseVerifiedStates")
    String[] licenseVerifiedStates;

    private Profile() {
    }

    protected Profile(Parcel in) {
        profile_url=in.readString();
        name = in.readString();
        addressLine1 = in.readString();
        addressLine2 = in.readString();
        cityname = in.readString();
        statename = in.readString();
        zipcode = in.readString();
        email = in.readString();
        phoneNumber = in.readString();
        aboutMe = in.readString();
        licenseNumber = in.readString();
        licenseExpiry = in.readString();

        resume_url=in.createStringArray();
        recomendationLettrs_url=in.createStringArray();
        image_url=in.createStringArray();
        video_url=in.createStringArray();
        videoThumbnail=in.createStringArray();
        salary = in.readString();
        comments = in.readString();
        bilingualLanguages = in.readString();
        salaryMin = in.readString();
        salaryMax = in.readString();
    }

    public static Profile getInstance() {
        if (instance == null) instance = new Profile();

        return instance;
    }

    public static void setInstance(Profile instance) {
        Profile.instance = instance;

        makeNull(ProfileHelper.getInstance().getImagesArray());
        makeNull(ProfileHelper.getInstance().getModifiedUrls());
        makeNull(ProfileHelper.getInstance().getVidoesArray());
        makeNull(ProfileHelper.getInstance().getVideoUrls());
        makeNull(ProfileHelper.getInstance().getmResumesArray());
        makeNull(ProfileHelper.getInstance().getmModifiedResumeUrls());
        makeNull(ProfileHelper.getInstance().getmRecommendArray());
        makeNull(ProfileHelper.getInstance().getmRecommendUrls());
        makeNull(ProfileHelper.getInstance().getVideosThumbnailsArray());
        ProfileHelper.getInstance().setSelectedPracticeSoftware(new JsonArray());
        ProfileHelper.getInstance().setSelectedSkillsArray(new JsonArray());
        ProfileHelper.getInstance().setSelectedStatesArray(new JsonArray());

    }

    private static void makeNull(String string[]) {
        for (int i = 0; i < string.length; i++) {
            string[i] = null;
        }

    }

    public static Creator<Profile> getCREATOR() {
        return CREATOR;
    }


    public String[] getVideoThumbnail() {
        return videoThumbnail;
    }

    public void setVideoThumbnail(String[] videoThumbnail) {
        this.videoThumbnail = videoThumbnail;
    }


    public String getProfile_url() {
        return profile_url;
    }

    public void setProfile_url(String profile_url) {
        this.profile_url = profile_url;
    }


    public String[] getResume_url() {
        return resume_url;
    }

    public void setResume_url(String[] resume_url) {
        this.resume_url = resume_url;
    }

    public String[] getRecomendationLettrs_url() {
        return recomendationLettrs_url;
    }

    public void setRecomendationLettrs_url(String[] recomendationLettrs_url) {
        this.recomendationLettrs_url = recomendationLettrs_url;
    }

    public String[] getImage_url() {
        return image_url;
    }

    public void setImage_url(String[] image_url) {
        this.image_url = image_url;
    }

    public String[] getVideo_url() {
        return video_url;
    }

    public void setVideo_url(String[] video_url) {
        this.video_url = video_url;
    }

    public String getLicenseVerified() {
        return licenseVerified;
    }

    public void setLicenseVerified(String licenseVerified) {
        this.licenseVerified = licenseVerified;
    }

    public String getProfilePic() {
        return profilePic;
    }

    public void setProfilePic(String profilePic) {
        this.profilePic = profilePic;
    }

    public JsonObject[] getShifts() {
        return shifts;
    }

    public void setShifts(JsonObject[] shifts) {
        this.shifts = shifts;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddressLine1() {
        return addressLine1;
    }

    public void setAddressLine1(String addressLine1) {
        this.addressLine1 = addressLine1;
    }

    public String getAddressLine2() {
        return addressLine2;
    }

    public void setAddressLine2(String addressLine2) {
        this.addressLine2 = addressLine2;
    }

    public String getCityname() {
        return cityname;
    }

    public void setCityname(String cityname) {
        this.cityname = cityname;
    }

    public String getStatename() {
        return statename;
    }

    public void setStatename(String statename) {
        this.statename = statename;
    }

    public String getZipcode() {
        return zipcode;
    }

    public void setZipcode(String zipcode) {
        this.zipcode = zipcode;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getAboutMe() {
        return aboutMe;
    }

    public void setAboutMe(String aboutMe) {
        this.aboutMe = aboutMe;
    }

    public int getExperienceID() {
        return experienceID;
    }

    public void setExperienceID(int experienceID) {
        this.experienceID = experienceID;
    }

    public int getBoardCertifiedID() {
        return boardCertifiedID;
    }

    public void setBoardCertifiedID(int boardCertifiedID) {
        this.boardCertifiedID = boardCertifiedID;
    }

    public String getLicenseNumber() {
        return licenseNumber;
    }

    public void setLicenseNumber(String licenseNumber) {
        this.licenseNumber = licenseNumber;
    }

    public String getLicenseExpiry() {
        return licenseExpiry;
    }

    public void setLicenseExpiry(String licenseExpiry) {
        this.licenseExpiry = licenseExpiry;
    }

    public String[] getJobTypes() {
        return jobTypes;
    }

    public void setJobTypes(String[] jobTypes) {
        this.jobTypes = jobTypes;
    }

    public int getWorkAvailablityID() {
        return workAvailablityID;
    }

    public void setWorkAvailablityID(int workAvailablityID) {
        this.workAvailablityID = workAvailablityID;
    }

    public String getWorkAvailabilityDate() {
        return workAvailabilityDate;
    }

    public void setWorkAvailabilityDate(String workAvailabilityDate) {
        this.workAvailabilityDate = workAvailabilityDate;
    }

    public String[] getPracticeManagementID() {
        return practiceManagementID;
    }

    public void setPracticeManagementID(String[] practiceManagementID) {
        this.practiceManagementID = practiceManagementID;
    }

    public void setPositionIDs(int[] positionIDs) {
        this.positionIDs = positionIDs;
    }

    public int[] getPositionIDs() {
        return positionIDs;
    }

    public String[] getResume() {
        return resume;
    }

    public void setResume(String[] resume) {
        this.resume = resume;
    }

    public String[] getRecommendationLetters() {
        return recommendationLetters;
    }

    public void setRecommendationLetters(String[] recommendationLetters) {
        this.recommendationLetters = recommendationLetters;
    }

    public String[] getImage() {
        return image;
    }

    public void setImage(String[] image) {
        this.image = image;
    }

    public String[] getVideo() {
        return video;
    }

    public void setVideo(String[] video) {
        this.video = video;
    }

    public int getLocationRangeID() {
        return locationRangeID;
    }

    public void setLocationRangeID(int locationRangeID) {
        this.locationRangeID = locationRangeID;
    }

    public int getMiles() {
        return miles;
    }

    public void setMiles(int miles) {
        this.miles = miles;
    }

    public String[] getSkills() {
        return skills;
    }

    public void setSkills(String[] skills) {
        this.skills = skills;
    }

    public int getCompensationID() {
        return compensationID;
    }

    public void setCompensationID(int compensationID) {
        this.compensationID = compensationID;
    }

    public String getSalary() {
        return salary;
    }

    public void setSalary(String salary) {
        this.salary = salary;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public String getBilingualLanguages() {
        return bilingualLanguages;
    }

    public void setBilingualLanguages(String bilingualLanguages) {
        this.bilingualLanguages = bilingualLanguages;
    }

    public String getSalaryMax() {
        if (salaryMax == null) {
            return null;
        }
        return String.format("%.0f", Float.parseFloat(salaryMax));
    }

    public void setSalaryMax(String salaryMax) {
        this.salaryMax = salaryMax;
    }

    public String getSalaryMin() {
        if (salaryMin == null) {
            return null;
        }
        return String.format("%.0f", Float.parseFloat(salaryMin));
    }

    public void setSalaryMin(String salaryMin) {
        this.salaryMin = salaryMin;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(profile_url);
        dest.writeString(name);
        dest.writeString(addressLine1);
        dest.writeString(addressLine2);
        dest.writeString(cityname);
        dest.writeString(statename);
        dest.writeString(zipcode);
        dest.writeString(email);
        dest.writeString(phoneNumber);
        dest.writeString(aboutMe);
        dest.writeString(licenseNumber);
        dest.writeString(licenseExpiry);
        dest.writeStringArray(resume_url);
        dest.writeStringArray(recomendationLettrs_url);
        dest.writeStringArray(image_url);
        dest.writeStringArray(video_url);
        dest.writeStringArray(videoThumbnail);
        dest.writeString(salary);
        dest.writeString(comments);
        dest.writeString(bilingualLanguages);
        dest.writeString(salaryMin);
        dest.writeString(salaryMax);
    }

}
