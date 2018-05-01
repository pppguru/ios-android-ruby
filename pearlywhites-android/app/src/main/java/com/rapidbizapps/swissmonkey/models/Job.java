package com.rapidbizapps.swissmonkey.models;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * Created by mlanka on 31-05-2016.
 */
public class Job implements Parcelable {

    public static final Creator<Job> CREATOR = new Creator<Job>() {
        @Override
        public Job createFromParcel(Parcel in) {
            return new Job(in);
        }

        @Override
        public Job[] newArray(int size) {
            return new Job[size];
        }
    };
    @SerializedName("job_id")
    int jobId;
    @SerializedName("job_location")
    String jobLocation;
    @SerializedName("position")
    String position;
    @SerializedName("job_type")
    String jobType;
    @SerializedName("job_description")
    String jobDescription;
    @SerializedName("job_duration")
    int jobDuration;
    String address1;
    String address2;
    String city;
    String state;
    @SerializedName("zipcode")
    String zipCode;
    @SerializedName("company_lat")
    double companyLat;
    @SerializedName("company_long")
    double companyLong;
    String compensations;
    @SerializedName("compensation_amount")
    String compensationAmount;
    @SerializedName("from_compensation_amount")
    String fromcompensationAmount;
    @SerializedName("to_compensation_amount")
    String tocompensationAmount;
    @SerializedName("created_at")
    String createdAt;
    @SerializedName("updated_at")
    String updatedAt;
    @SerializedName("year_of_experience")
    String yearsOfExperience;

    @SerializedName("practice_management_system")
    String practiceManagementSystem;

    @SerializedName("company_practice_management_system")
    String companyPracticeManagementSystem;

    String status;

    @SerializedName("closed_job_reason")
    int closedJobReason;
    @SerializedName("photo_required")
    String photoRequired;
    @SerializedName("video_required")
    String videoRequired;
    @SerializedName("skype_interview")
    String skypeInterview;
    String resume;
    @SerializedName("company_id")
    int companyId;
    String logo;
    @SerializedName("letter_of_recommendation")
    String letterOfRecommendation;
    @SerializedName("company_name")
    String companyName;
    @SerializedName("about_your_company")
    String aboutYourCompany;
    @SerializedName("practicephotos")
    String[] practicePhotos;
    @SerializedName("company_email")
    String companyEmail;
    @SerializedName("contact_name")
    String contactName;
    @SerializedName("company_phoneno")
    String companyPhoneNumber;
    String skills;
    String statusName;
    @SerializedName("video_link")
    String videoLink;
    @SerializedName("digital_x_ray")
    String digitalXRay;
    String website;
    @SerializedName("company_logo")
    String companyLogo;
    @SerializedName("company_established")
    String companyEstablished;
    @SerializedName("total_no_of_doctors")
    String totalNumberOfDoctors;
    @SerializedName("total_no_of_operatories")
    String totalNumberOfOperatories;
    @SerializedName("saved_status")
    boolean isSaved;
    @SerializedName("length_of_appointment")
    String lengthOfAppointment;
    @SerializedName("benefits")
    String benefits;
    @SerializedName("message")
    String alertMessage;
    @SerializedName("shifts")
    WeekdayInfo[] shifts;
    String languages;

    public Job() {


    }

    protected Job(Parcel in) {
        jobId = in.readInt();
        jobLocation = in.readString();
        position = in.readString();
        jobType = in.readString();
        jobDescription = in.readString();
        jobDuration = in.readInt();
        address1 = in.readString();
        address2 = in.readString();
        city = in.readString();
        state = in.readString();
        zipCode = in.readString();
        companyLat = in.readDouble();
        companyLong = in.readDouble();
        compensations = in.readString();
        compensationAmount = in.readString();
        fromcompensationAmount = in.readString();
        tocompensationAmount = in.readString();
        createdAt = in.readString();
        updatedAt = in.readString();
        yearsOfExperience = in.readString();
        practiceManagementSystem = in.readString();
        status = in.readString();
        closedJobReason = in.readInt();
        photoRequired = in.readString();
        videoRequired = in.readString();
        skypeInterview = in.readString();
        resume = in.readString();
        companyId = in.readInt();
        logo = in.readString();
        letterOfRecommendation = in.readString();
        companyName = in.readString();
        aboutYourCompany = in.readString();
        companyEmail = in.readString();
        contactName = in.readString();
        companyPhoneNumber = in.readString();
        skills = in.readString();
        statusName = in.readString();
        videoLink = in.readString();
        isSaved = in.readByte() != 0;
        website = in.readString();
        companyLogo = in.readString();
        practicePhotos = in.createStringArray();
        companyEstablished = in.readString();
        digitalXRay = in.readString();
        totalNumberOfDoctors = in.readString();
        lengthOfAppointment = in.readString();
        benefits = in.readString();
        shifts = in.createTypedArray(WeekdayInfo.CREATOR);
    }

    public String getCompanyPracticeManagementSystem() {
        return companyPracticeManagementSystem;
    }

    public void setCompanyPracticeManagementSystem(String companyPracticeManagementSystem) {
        this.companyPracticeManagementSystem = companyPracticeManagementSystem;
    }

    public String getTotalNumberOfOperatories() {
        return totalNumberOfOperatories;
    }

    public void setTotalNumberOfOperatories(String totalNumberOfOperatories) {
        this.totalNumberOfOperatories = totalNumberOfOperatories;
    }

    public String getLanguages() {
        return languages;
    }

    public void setLanguages(String languages) {
        this.languages = languages;
    }

    public WeekdayInfo[] getShifts() {
        return shifts;
    }

    public void setShifts(WeekdayInfo[] shifts) {
        this.shifts = shifts;
    }

    public String getAlertMessage() {
        return alertMessage;
    }

    public void setAlertMessage(String alertMessage) {
        this.alertMessage = alertMessage;
    }

    public String getLengthOfAppointment() {
        return lengthOfAppointment;
    }

    public void setLengthOfAppointment(String lengthOfAppointment) {
        this.lengthOfAppointment = lengthOfAppointment;
    }

    public String getBenefits() {
        return benefits;
    }

    public void setBenefits(String benefits) {
        this.benefits = benefits;
    }

    public String getFromcompensationAmount() {
        if (fromcompensationAmount == null) {
            return null;
        }
        return String.format("%.0f", Float.parseFloat(fromcompensationAmount));
    }

    public void setFromcompensationAmount(String fromcompensationAmount) {
        this.fromcompensationAmount = fromcompensationAmount;
    }

    public String getTocompensationAmount() {
        if (tocompensationAmount == null) {
            return null;
        }
        return String.format("%.0f", Float.parseFloat(tocompensationAmount));
    }

    public void setTocompensationAmount(String tocompensationAmount) {
        this.tocompensationAmount = tocompensationAmount;
    }

    public String getDigitalXRay() {
        return digitalXRay;
    }

    public void setDigitalXRay(String digitalXRay) {
        this.digitalXRay = digitalXRay;
    }

    public String getWebsite() {
        return website;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public String getTotalNumberOfDoctors() {
        return totalNumberOfDoctors;
    }

    public void setTotalNumberOfDoctors(String totalNumberOfDoctors) {
        this.totalNumberOfDoctors = totalNumberOfDoctors;
    }

    public String getCompanyEstablished() {
        return companyEstablished;
    }

    public void setCompanyEstablished(String companyEstablished) {
        this.companyEstablished = companyEstablished;
    }

    public String getYearsOfExperience() {
        return yearsOfExperience;
    }

    public void setYearsOfExperience(String yearsOfExperience) {
        this.yearsOfExperience = yearsOfExperience;
    }

    public String getPracticeManagementSystem() {
        return practiceManagementSystem;
    }

    public void setPracticeManagementSystem(String practiceManagementSystem) {
        this.practiceManagementSystem = practiceManagementSystem;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getClosedJobReason() {
        return closedJobReason;
    }

    public void setClosedJobReason(int closedJobReason) {
        this.closedJobReason = closedJobReason;
    }

    public String getPhotoRequired() {
        return photoRequired;
    }

    public void setPhotoRequired(String photoRequired) {
        this.photoRequired = photoRequired;
    }

    public String getVideoRequired() {
        return videoRequired;
    }

    public void setVideoRequired(String videoRequired) {
        this.videoRequired = videoRequired;
    }

    public String getSkypeInterview() {
        return skypeInterview;
    }

    public void setSkypeInterview(String skypeInterview) {
        this.skypeInterview = skypeInterview;
    }

    public String getResume() {
        return resume;
    }

    public void setResume(String resume) {
        this.resume = resume;
    }

    public int getCompanyId() {
        return companyId;
    }

    public void setCompanyId(int companyId) {
        this.companyId = companyId;
    }

    public String getLogo() {
        return logo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }

    public String getLetterOfRecommendation() {
        return letterOfRecommendation;
    }

    public void setLetterOfRecommendation(String letterOfRecommendation) {
        this.letterOfRecommendation = letterOfRecommendation;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getAboutYourCompany() {
        return aboutYourCompany;
    }

    public void setAboutYourCompany(String aboutYourCompany) {
        this.aboutYourCompany = aboutYourCompany;
    }

    public String[] getPracticePhotos() {
        return practicePhotos;
    }

    public void setPracticePhotos(String[] practicePhotos) {
        this.practicePhotos = practicePhotos;
    }

    public String getCompanyEmail() {
        return companyEmail;
    }

    public void setCompanyEmail(String companyEmail) {
        this.companyEmail = companyEmail;
    }

    public String getContactName() {
        return contactName;
    }

    public void setContactName(String contactName) {
        this.contactName = contactName;
    }

    public String getCompanyPhoneNumber() {
        return companyPhoneNumber;
    }

    public void setCompanyPhoneNumber(String companyPhoneNumber) {
        this.companyPhoneNumber = companyPhoneNumber;
    }

    public String getSkills() {
        return skills;
    }

    public void setSkills(String skills) {
        this.skills = skills;
    }

    public String getStatusName() {
        return statusName;
    }

    public void setStatusName(String statusName) {
        this.statusName = statusName;
    }

    public String getVideoLink() {
        return videoLink;
    }

    public void setVideoLink(String videoLink) {
        this.videoLink = videoLink;
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

    public boolean isSaved() {
        return isSaved;
    }

    public void setSaved(boolean saved) {
        isSaved = saved;
    }

    public int getJobId() {
        return jobId;
    }

    public void setJobId(int jobId) {
        this.jobId = jobId;
    }

    public String getJobLocation() {
        return jobLocation;
    }

    public void setJobLocation(String jobLocation) {
        this.jobLocation = jobLocation;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getJobType() {
        return jobType;
    }

    public void setJobType(String jobType) {
        this.jobType = jobType;
    }

    public String getJobDescription() {
        return jobDescription;
    }

    public void setJobDescription(String jobDescription) {
        this.jobDescription = jobDescription;
    }

    public int getJobDuration() {
        return jobDuration;
    }

    public void setJobDuration(int jobDuration) {
        this.jobDuration = jobDuration;
    }

    public String getAddress1() {
        return address1;
    }

    public void setAddress1(String address1) {
        this.address1 = address1;
    }

    public String getAddress2() {
        return address2;
    }

    public void setAddress2(String address2) {
        this.address2 = address2;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getZipCode() {
        return zipCode;
    }

    public void setZipCode(String zipCode) {
        this.zipCode = zipCode;
    }

    public double getCompanyLat() {
        return companyLat;
    }

    public void setCompanyLat(double companyLat) {
        this.companyLat = companyLat;
    }

    public double getCompanyLong() {
        return companyLong;
    }

    public void setCompanyLong(double companyLong) {
        this.companyLong = companyLong;
    }

    public String getCompensations() {
        return compensations;
    }

    public void setCompensations(String compensations) {
        this.compensations = compensations;
    }

    public String getCompensationAmount() {
        return compensationAmount;
    }

    public void setCompensationAmount(String compensationAmount) {
        this.compensationAmount = compensationAmount;
    }

    public int getNumOfDaysOld() {

        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US);
        Date created, now;
        try {
            created = format.parse(getCreatedAt());
            now = format.parse(format.format(new Date()));
        } catch (ParseException e) {
            e.printStackTrace();
            created = new Date();
            now = new Date();
        }

        long timeOne = created.getTime();
        long timeTwo = now.getTime();

        long oneDay = 1000 * 60 * 60 * 24;
        long delta = (timeTwo - timeOne) / oneDay;

        return (int) delta;

    }

    @Override
    public int describeContents() {
        return 0;
    }

    public String getCompanyLogo() {
        return companyLogo;
    }

    public void setCompanyLogo(String companyLogo) {
        this.companyLogo = companyLogo;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(jobId);
        dest.writeString(jobLocation);
        dest.writeString(position);
        dest.writeString(jobType);
        dest.writeString(jobDescription);
        dest.writeInt(jobDuration);
        dest.writeString(address1);
        dest.writeString(address2);
        dest.writeString(city);
        dest.writeString(state);
        dest.writeString(zipCode);
        dest.writeDouble(companyLat);
        dest.writeDouble(companyLong);
        dest.writeString(compensations);
        dest.writeString(compensationAmount);
        dest.writeString(fromcompensationAmount);
        dest.writeString(tocompensationAmount);
        dest.writeString(createdAt);
        dest.writeString(updatedAt);
        dest.writeString(yearsOfExperience);
        dest.writeString(practiceManagementSystem);
        dest.writeString(status);
        dest.writeInt(closedJobReason);
        dest.writeString(photoRequired);
        dest.writeString(videoRequired);
        dest.writeString(skypeInterview);
        dest.writeString(resume);
        dest.writeInt(companyId);
        dest.writeString(logo);
        dest.writeString(letterOfRecommendation);
        dest.writeString(companyName);
        dest.writeString(aboutYourCompany);
        dest.writeString(companyEmail);
        dest.writeString(contactName);
        dest.writeString(companyPhoneNumber);
        dest.writeString(skills);
        dest.writeString(statusName);
        dest.writeString(videoLink);
        dest.writeByte((byte) (isSaved ? 1 : 0));
        dest.writeString(website);
        dest.writeString(companyLogo);
        dest.writeStringArray(practicePhotos);
        dest.writeString(companyEstablished);
        dest.writeString(digitalXRay);
        dest.writeString(totalNumberOfDoctors);
        dest.writeString(lengthOfAppointment);
        dest.writeString(benefits);
        dest.writeTypedArray(shifts, 0);
    }

    @Override
    public boolean equals(Object o) {

        return ((Job) o).getCompanyLat() == getCompanyLat() && ((Job) o).getCompanyLong() == getCompanyLong();
    }


}
