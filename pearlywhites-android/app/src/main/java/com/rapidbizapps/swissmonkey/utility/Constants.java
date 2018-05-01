package com.rapidbizapps.swissmonkey.utility;

import android.content.Intent;
import android.os.Environment;

import java.io.File;

/**
 * Created by mjain on 5/18/2016.
 */
public interface Constants {
    //Integer constants
    int label_hint_textsize = 8;
    int edittext_textsize = 12;


    //String constants

    String APP_NAME = "Swiss Monkey";

    //Key for google cloude messaging
    public static final String GOOGLE_SERVER_API_KEY = "AIzaSyBdvWFNp_peq9L8-BnWyTzLS1WeSUVceLk";
    public static final String SENDER_IDENTITY = "602997592059"; // Meghna's Laptop key

    //Flurry key
    public static final String FLURRY_APIKEY = "SRZN22FTPYFB7JFW54C7";


    public static final String AUTHORIZATION_KEY = "Authorization";
    public static final String PROPERTY_REG_ID = "registration_id";
    public static final String PROPERTY_APP_VERSION = "appVersion";


    //Server constants

    // Dialog messages
    public static final String ENTER_EMAIL = "Email should not be empty";
    public static final String INVALID_EMAIL = "Please enter valid email";
    public static final String INVALID_PHONE = "Please enter valid phone number";
    public static final String INVALID_PASSWORD = "Please enter valid password.";
    public static final String PASSWORD_VERIFY = "Password doesn't match";
    public static final String INVALID_PASSWORD_LENGTH = "Password must be atleast 8 characters";
    public static final String REQUIRED_FIELDS = "Please fill the required fields";
    public static final String INVALID_CREDENTIALS = "Please enter valid credentials";
    public static final String INVALID_EXPERIENCE = "Please enter experience";

    public static final String NO_NETWORK_HEADER = "No Internet";
    public static final String NO_NETWORK = "Please check your internet connection";


    //Register Activity
    public static final String SUCCESS_MESSAGE = "successsMessage";

    String SUCCESS_RESPONSE_KEY = "success";

    //Aboutus Fragment
    public static final String EMAILTO = "info@swissmonkey.io";
    public static final String CALLTO = "916-500-4125";

    public static final String POSITION_ID_INTENT_EXTRA = "position_id";

    // Home Activity

    public static final String WELCOME = "Welcome";
    public static final String PROFILE = "Profile";
    public static final String SETTINGS = "Settings";
    public static final String SUPPORT = "Support";

    //JSON keys
    public static final String AUTH_TOKEN_KEY = "authtoken";
    public static final String VIEWED_IDS = "viewed_ids";
    public static final String POSITION_KEY = "position";
    public static final String JOB_ID_KEY = "jobID";
    public static final String MILES_KEY = "miles";
    String SEARCH_KEY = "search";
    String FROM_COMPENSATION_KEY = "fromCompensation";
    String TO_COMPENSATION_KEY = "toCompensation";
    String TYPE_KEY = "type";
    String KEYS_KEY = "keys";

    String NAME_KEY = "name";


    //Intent extra keys
    public static final String FIND_RANGE_INTENT_EXTRA = "range_in_miles";
    String JOB_ID_INTENT_EXTRA = "job_id";
    String JOB_INTENT_EXTRA = "job";
    String JOBS_INTENT_EXTRA = "jobs";
    String HEADER_TEXT_INTENT_EXTRA = "header_text";


    //Profile constants

    public static final String USERNAME = "userName";
    public static final String PROFILE_NAME = "profileName";
    public static final String CITY_KEY = "city";
    public static final String STATE_KEY = "state";
    public static final String ZIPCODE_KEY = "zipcode";
    public static final String ADDRESS_LINE1_KEY = "addressLine1";
    public static final String ADDRESS_LINE2_KEY = "addressLine2";


    String POSITIONS_KEY = "positions";
    String LOCATION_RANGE_KEY = "location_range";
    String EXPERIENCE_KEY = "experience";
    String JOBS_TYPE_KEY = "jobtype";
    String COMPENSATION_RANGE_KEY = "comprange";
    String SOFTWARE_PROFICIENCY_KEY = "software_proficiency";
    String PRACTICE_MANAGEMENT_SOFTWARE_KEY = "praticeManagementSoftware";
    String SHIFTS_KEY = "shifts";
    String STATE_LIST_KEY = "state_list";

    String JOB_TYPE_KEY = "job_types";

    String MONDAY = "Monday";
    String TUESDAY = "Tuesday";
    String WEDNESDAY = "Wednesday";
    String THURSDAY = "Thursday";
    String FRIDAY = "Friday";
    String SATURDAY = "Saturday";
    String SUNDAY = "Sunday";

    String PROFILE_FILE_TYPE_KEY = "profile";
    String IMAGE_FILE_TYPE_KEY = "imgFiles";
    String VIDEO_FILE_TYPE_KEY = "videoFiles";
    String RECO_LETTER_FILE_TYPE_KEY = "recommendationletters";
    String RESUME_FILE_TYPE_KEY = "resume";


    String EMAIL_KEY = "email";
    String PHONE_NUMBER_KEY = "phoneNumber";
    String ABOUT_ME_KEY = "aboutMe";
    String EXPERIENCE_ID_KEY = "experienceID";
    String BOARD_CERTIFIED_ID_KEY = "boardCretifiedID";  // TODO: 21-06-2016 typo! :@ correct it!
    String POSITION_ID_KEY = "positionID";

    String LICENSE_NUMBER_KEY = "licenseNumber"; // TODO: 21-06-2016 is this right?
    String LICENSE_VERIFIED_STATES_KEY = "licenseVerifiedStates";

    String LICENSE_EXPIRY_KEY = "licenseExpiry";
    String LICENSE_VERIFIED_KEY = "licenseVerified";
    String WORK_AVAILABILITY_ID_KEY = "workAvailabilityID";
    String PRACTICE_MANAGEMENT_ID_KEY = "practiceManagementID";
    String SKILLS_KEY = "skills";
    String BILINGUAL_LANGUAGES_KEY = "bilingual_languages";
    String COMPENSATION_ID_KEY = "compensationID";
    String LOCATION_RANGE_ID_KEY = "locationRangeID";


    String SALARY_KEY = "salary";
    String SALARY_MIN_KEY = "from_salary_range";
    String SALARY_MAX_KEY = "to_salary_range";

    String COMMENTS_KEY = "comments";

    String WORK_AVAILBILITY_KEY = "work_availability";
    String FILE_KEY = "file";

    String ADVANCED_SEARCH = "Advanced Search";


    String USER_LOGGED_IN = "user_logged_in"; //to check if user is already logged in
    String DOWNLOAD_VIDEOS = "downlaod_videos";
    String PROMPT_COMPLETE_PROFILE = "prompt_user_to_complete_profile";

    //gcm stuff
    String TOKEN = "token";
    String DEVICE_TOKEN = "deviceToken"; //while logging out
    String DEVICE_TYPE = "device_type";
    String ANDROID = "android";
    String REGISTRATION_TOKEN = "registration_token";
    String NOTIFICATION = "notification";
    String MESSAGE_RECEIVED = "message_received";
    String SENDER_ID = "679093189198";
    String USER_STATUS = "user_status";

    //check if user can add files more than accepted
    String CAN_ADD_PHOTOS = "can_add_photos";
    String CAN_ADD_VIDEOS = "can_add_videos";
    String CAN_ADD_RESUMES = "can_add_videos";
    String CAN_ADD_LOR = "can_add_lors";
    String PROFILE_PROGRESS_COUNT = "progress_count";
    int CIRCULAR_IMAGE_RADIUS = 150;


    String SHOW_PROFILE = "show_profile";
    String NOTIFICATION_NUMBER = "notification_number";

    String WORK_AVAILABILITY_DATE_KEY = "workAvailabilityDate";

    String NEW_EMAIL_KEY = "newEmail";
    String OTHER_REQS_KEY = "comments";

    String baseUrl = Environment.getExternalStorageDirectory() + File.separator + ".rapidBizApps/";

    String NOTIFICATION_MESSAGE = "notification_message";
    String NEW_PRACTICE_SOFTWARE = "newPracticeSoftware";

    String NOTIFICATIONS = "notifications";

    String PRIVACY_POLICY_STATUS_KEY = "privacy_policy_status";

    String TERMS_AND_CONDITIONS_ACCEPTED = "terms_and_conditions_accepted";

    String ANONYMOUS = "ANONYMOUS";

    String FULL_TIME = "Full-time";
}
