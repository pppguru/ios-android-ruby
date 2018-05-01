package com.rapidbizapps.swissmonkey.Services;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.rapidbizapps.swissmonkey.models.Job;
import com.rapidbizapps.swissmonkey.models.Profile;

import org.json.JSONObject;

import retrofit.Callback;
import retrofit.http.Body;
import retrofit.http.GET;
import retrofit.http.Header;
import retrofit.http.POST;
import retrofit.http.Path;
import retrofit.mime.MultipartTypedOutput;


/**
 * Created by mjain on 5-20-2016.
 */
public interface ServiceHelper {

   /* @Headers("Accept:application/json")
    @POST("/")
    public void deviceRegisterPostCall(@Body JsonObject obj, Callback<JsonObject> callback);*/


    @retrofit.http.Headers("Accept:application/json")
    @retrofit.http.POST("/user/signup")
    public void registerUser(@retrofit.http.Body JsonObject obj, retrofit.Callback<JsonObject> callback);

    @retrofit.http.Headers("Accept:application/json")
    @retrofit.http.GET("/dropdown/data")
    public void getDropDownListData(retrofit.Callback<JsonObject> callback);

    @retrofit.http.Headers("Accept:application/json")
    @retrofit.http.POST("/user/logout")
    public void logoutUser(@retrofit.http.Body JsonObject obj, retrofit.Callback<JsonObject> callback);

    @retrofit.http.Headers("Accept:application/json")
    @retrofit.http.POST("/user/login")
    public void loginUser(@retrofit.http.Body JsonObject obj, retrofit.Callback<JsonObject> callback);

    @retrofit.http.Headers("Accept:application/json")
    @retrofit.http.POST("/user/forgot")
    public void forgotPassword(@retrofit.http.Body JsonObject obj, retrofit.Callback<JsonObject> callback);

    @POST("/user/reset")
    public void resetPassword(@Body JsonObject requestBody, Callback<JsonObject> callback);

    @POST("/user/deactivate")
    public void deactivateAccount(@Body JsonObject requestBody, Callback<JsonObject> callback);

    @POST("/profile/info")
    void getProfileData(@Body JsonObject requestBody, Callback<Profile> callback);

    @POST("/profile/info")
    void getProfileDataInJsonObject(@Body JsonObject requestBody, Callback<JsonObject> callback);


    @POST("/profile/save")
    void saveProfile(@Body JsonObject requestBody, Callback<JsonObject> callback);

    //Upload Image
    @POST("/profile/upload")
    void uploadFile(@Body MultipartTypedOutput task, Callback<JsonObject> callback);

    @POST("/job/search")
    void findJob(@Body JsonObject requestBody, Callback<JsonObject> callback);

    @POST("/job/save")
    void saveJob(@Body JsonObject requestBody, Callback<JsonObject> callback);

    @POST("/job/details/{jobId}")
    void getJob(@Path("jobId") int jobId, @Body JsonObject requestBody, Callback<JsonArray> callback);

    @POST("/job/apply")
    void applyNow(@Body JsonObject requestBody, Callback<JsonObject> callback);

    @POST("/job/jobs")
    void jobsForYou(@Body JsonObject requestBody, Callback<JsonObject> callback);

    @POST("/job/applications")
    void applicationStatus(@Body JsonObject requestBody, Callback<JsonObject> callback);

    @POST("/job/savedjobs")
    void savedJobs(@Body JsonObject requestBody, Callback<JsonObject> callback);

    @POST("/job/history")
    void jobsHistory(@Body JsonObject requestBody, Callback<JsonObject> callback);

    @retrofit.http.Headers("Accept:application/json")
    @POST("/profile/download")
    void downloadFiles(@Body JsonObject requestBody, Callback<JsonObject> callback);


    @POST("/profile/delete")
    void deleteFiles(@Body JsonObject requestBody, Callback<JsonObject> callback);

    @POST("/settings/apinotifications")
    void getNotifications(@Body JsonObject requestBody, Callback<JsonObject> callback);

    @POST("/settings/viewed")
    void viewNotifications(@Body JsonObject requestBody, Callback<JsonObject> callback);

    @POST("/user/deviceregistration")
    void sendRegistrationToken(@Body JsonObject requestBody, Callback<JsonObject> callback);

    @POST("/user/activate")
    void activateUser(@Body JsonObject requestBody, Callback<JsonObject> callback);

    @POST("/user/accept_privacy_policy")
    void acceptToA(@Body JsonObject requestBody, Callback<JsonObject> callback);

    @POST("/user/privacy_policy_status")
    void getToAStatus(@Body JsonObject requestBody, Callback<JsonObject> callback);

}
