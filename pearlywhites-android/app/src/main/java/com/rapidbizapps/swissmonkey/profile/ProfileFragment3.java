package com.rapidbizapps.swissmonkey.profile;


import android.app.DatePickerDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.AlertDialog;
import android.text.InputFilter;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import com.rapidbizapps.swissmonkey.HomeActivity;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.Services.DataHelper;
import com.rapidbizapps.swissmonkey.Services.ProfileHelper;
import com.rapidbizapps.swissmonkey.models.JobType;
import com.rapidbizapps.swissmonkey.models.LocationRange;
import com.rapidbizapps.swissmonkey.models.PracticeManagementSoftware;
import com.rapidbizapps.swissmonkey.models.Profile;
import com.rapidbizapps.swissmonkey.models.SoftwareProficiency;
import com.rapidbizapps.swissmonkey.models.WorkAvailability;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.DatePickerFragment;
import com.rapidbizapps.swissmonkey.utility.DropdownAdapter;
import com.rapidbizapps.swissmonkey.utility.FirstLetterCapFilter;
import com.rapidbizapps.swissmonkey.utility.Utility;
import com.rba.MaterialEditText;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import butterknife.BindView;
import butterknife.BindViews;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnTextChanged;


public class ProfileFragment3 extends Fragment {
    private final String TAG = ProfileFragment3.class.getSimpleName();

    @BindView(R.id.job_type_profile)
    MaterialEditText jobType_et;

    @BindView(R.id.et_workAvailablity)
    EditText et_workAvailablity;

    @BindView(R.id.et_work_availability_date)
    View viewAvailabilityDate;

    @BindView(R.id.et_work_availability_month)
    MaterialEditText workAvailabilityMonth_et;

    @BindView(R.id.et_work_availability_day)
    MaterialEditText workAvailabilityDay_et;

    @BindView(R.id.et_work_availability_year)
    MaterialEditText workAvailabilityYear_et;

    @BindView(R.id.et_opportunityWithinMiles)
    EditText et_opportunityWithinMiles;

    @BindView(R.id.et_softwareExperience)
    EditText et_softwareExperience;

    @BindView(R.id.ll_subSoftwareExperience)
    LinearLayout ll_subSoftwareExperience;

    @BindView(R.id.et_additionalSkills)
    EditText et_additionalSkills;

    @BindView(R.id.ll_subAdditionalSkills)
    LinearLayout ll_subAdditionalSkills;

    @BindView(R.id.et_language)
    EditText et_language;

    @BindView(R.id.et_other_software_experience)
    EditText et_otherSoftwareExpereince;

    @BindViews({R.id.monday_morning, R.id.tuesday_morning, R.id.wednesday_morning, R.id.thursday_morning, R.id.friday_morning, R.id.saturday_morning, R.id.sunday_morning})
    List<ImageView> morningViews;

    @BindViews({R.id.monday_afternoon, R.id.tuesday_afternoon, R.id.wednesday_afternoon, R.id.thursday_afternoon, R.id.friday_afternoon, R.id.saturday_afternoon, R.id.sunday_afternoon})
    List<ImageView> afternoonViews;

    @BindViews({R.id.monday_evening, R.id.tuesday_evening, R.id.wednesday_evening, R.id.thursday_evening, R.id.friday_evening, R.id.saturday_evening, R.id.sunday_evening})
    List<ImageView> eveningViews;

    JsonArray mShiftObjects;
    JsonObject morningShift, afternoonShift, eveningShift;
    JsonArray morningArray, afternoonArray, eveningArray;
    JsonPrimitive mondayPrimitive, tuesdayPrimitive, wednesdayPrimitive, thursdayPrimitive, fridayPrimitive, saturdayPrimitive, sundayPrimitive;
    JsonArray mAdditionalSkillsArray = new JsonArray();
    ArrayList<Integer> mAdditionalSkillsJSONArraytracker = new ArrayList<>();

    private int workAvailabilityId = -1;
    private int milesId = -1;
    private int compensationId = -1;

    ArrayList<Integer> mSelectedJobTypes;
    private boolean[] mSelectedJobTypeArray;

    AlertDialog mAlertDialog;
    boolean[] morningClicked, afternoonClicked, eveningClicked;

    ArrayList<Integer> mSelectedSkills = new ArrayList<>();
    ArrayList<Integer> mSelectedSubSkills = new ArrayList<>();
    ArrayList<Integer> mSelectedSoftwareExperiences;
    private HomeActivity mActivity;

    private static final String LOG_TAG = "ProfileFragment3";
    private Calendar workAvailabilityCalendar;

    private boolean[] mSelectedAdditionSkillsArray, mSelectedPracticeArray;
    private CharSequence[] additionalSkills;
    private InputFilter[] mFilters;

    // HashMap for storing the selected items in the
    // dynamically created sub-categories for Additional Skills.
    private HashMap<String, boolean[]> subAddiSkillsSelectedItems = new HashMap<>();

    View rootView;

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        mActivity = (HomeActivity) context;
    }

    public ProfileFragment3() {
        // Required empty public constructor
    }

    // TODO: Rename and change types and number of parameters
    public static ProfileFragment3 newInstance() {
        ProfileFragment3 fragment = new ProfileFragment3();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mFilters = new InputFilter[]{new FirstLetterCapFilter()};
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_profile_3, container, false);
        rootView = view;
        ButterKnife.bind(this, view);

        jobType_et.setKeyListener(null);
        et_workAvailablity.setKeyListener(null);
        et_softwareExperience.setKeyListener(null);
        et_additionalSkills.setKeyListener(null);
        et_opportunityWithinMiles.setKeyListener(null);


        jobType_et.setFocusable(false);
        et_workAvailablity.setFocusable(false);
        workAvailabilityMonth_et.setFocusable(false);
        workAvailabilityDay_et.setFocusable(false);
        workAvailabilityYear_et.setFocusable(false);
        et_additionalSkills.setFocusable(false);
        et_opportunityWithinMiles.setFocusable(false);
        et_softwareExperience.setFocusable(false);

        et_language.setFilters(mFilters);
        et_otherSoftwareExpereince.setFilters(mFilters);

        setupDays();
        setupData();


        return view;
    }

    private void setupData() {

        if (DataHelper.getInstance().getJobTypes() != null) {
            String jobTypes = "";

            mSelectedJobTypeArray = new boolean[DataHelper.getInstance().getJobTypes().size()];

            if (Profile.getInstance().getJobTypes() != null) {
                for (String jobType : Profile.getInstance().getJobTypes()) {
                    List<JobType> tempList = DataHelper.getInstance().getJobTypes();
                    JobType tempJobType = new JobType();
                    tempJobType.setJobTypeId(JobType.toJobTypeId(jobType));
                    int location = tempList.indexOf(tempJobType);
                    if (location >= 0) {
                        jobTypes += tempList.get(location).getJobType() + ", ";
                        Log.d(LOG_TAG, "setupData: " + tempJobType.getJobType());
                        mSelectedJobTypeArray[location] = true;
                    }
                }
            }

            if (jobTypes.length() > 0)
                jobTypes = jobTypes.substring(0, jobTypes.length() - 2);
            jobType_et.setText(jobTypes);
        }

        Log.d(LOG_TAG, "setupData: workAvailabilityID" + Profile.getInstance().getWorkAvailablityID());
        if (Profile.getInstance().getWorkAvailablityID() > -1) {

            WorkAvailability tempAvailablity = new WorkAvailability();
            tempAvailablity.setWorkId(Profile.getInstance().getWorkAvailablityID());

            int index = DataHelper.getInstance().getWorkAvailabilities().indexOf(tempAvailablity);
            if (index > -1)
                et_workAvailablity.setText(DataHelper.getInstance().getWorkAvailabilities().get(index).getWorkAvailabiltyName());

            //if user is not immediately available
            if (index == 1) {
                viewAvailabilityDate.setVisibility(View.VISIBLE);
                String availabilityDate = Profile.getInstance().getWorkAvailabilityDate();
                String [] arrAvailabilityDateParts = availabilityDate.split("-");
                workAvailabilityMonth_et.setText(arrAvailabilityDateParts[0]);
                workAvailabilityDay_et.setText(arrAvailabilityDateParts[1]);
                workAvailabilityYear_et.setText(arrAvailabilityDateParts[2]);
            }

        }


        String practiceSoftware = "";

        if (DataHelper.getInstance().getPracticeManagementSoftwares() != null) {
            mSelectedPracticeArray = new boolean[DataHelper.getInstance().getPracticeManagementSoftwares().size()];

            if (Profile.getInstance().getPracticeManagementID() != null) {
                for (int i = 0; i < Profile.getInstance().getPracticeManagementID().length; i++) {
                    if (Integer.parseInt(Profile.getInstance().getPracticeManagementID()[i]) >= 0) {
                        List<PracticeManagementSoftware> tempList = DataHelper.getInstance().getPracticeManagementSoftwares();
                        PracticeManagementSoftware tempPracticeSoftware = new PracticeManagementSoftware();
                        tempPracticeSoftware.setSoftwareId(Integer.parseInt(Profile.getInstance().getPracticeManagementID()[i]));
                        int location = tempList.indexOf(tempPracticeSoftware);
                        if (location >= 0) {
                            practiceSoftware += tempList.get(location).getSoftware() + ", ";
                            Log.d(LOG_TAG, "setupData: " + tempPracticeSoftware.getSoftware());
                            mSelectedPracticeArray[location] = true;
                        }
                    }
                }
            }
        }

        if (practiceSoftware.length() > 0)
            practiceSoftware = practiceSoftware.substring(0, practiceSoftware.length() - 2);
        Log.d(LOG_TAG, "setupData: practiceSoftware" + practiceSoftware);
        et_softwareExperience.setText(practiceSoftware);

        String skills = "";
        // Sub-list for maintaining all the items with sub-categories.
        List<SoftwareProficiency> subList;
        // Current Skill Id to be checked.
        Integer skillId;
        // HashMap to main Software Types with sub-categories.
        HashMap<Integer, ArrayList<Integer>> wantedList = new HashMap<>();
        // Selected list of all the sub-categories.
        ArrayList<Integer> selectedList = new ArrayList<>();
        // Separate list for maintaining list of parent and sub-category ids.
        ArrayList<Integer> separateIds = new ArrayList<>();
        // Boolean to check if the last item of Skills list has been checked.
        boolean checkOnce = true;
        // Boolean to check if the list contains Bilingual
        boolean checkBilingual = false;

        if (DataHelper.getInstance().getSoftwareProficiencies() != null) {
            mSelectedAdditionSkillsArray = new boolean[DataHelper.getInstance().getSoftwareProficiencies().size()];
            Arrays.fill(mSelectedAdditionSkillsArray, Boolean.FALSE);

            // FIXME: Very confusing logic. Need to simplify it if possible.
            if (Profile.getInstance().getSkills() != null) {

                for (int i = 0; i < Profile.getInstance().getSkills().length; i++) {
                    skillId = Integer.parseInt(Profile.getInstance().getSkills()[i]);
                    if (skillId >= 0) {
                        Log.v("SKILLIDS", "" + skillId);
                        for (int j = 0; j < DataHelper.getInstance().getSoftwareProficiencies().size(); j++) {

                            // Condition for last item in the Skills list.
                            if (skillId == DataHelper.getInstance().getSoftwareProficiencies().size()) {
                                if (checkOnce) {
                                    Integer parentId = DataHelper.getInstance().getSoftwareProficiencies().get(skillId - 1).getParentId();

                                    if (parentId != null) {
                                        selectedList.add(skillId);
                                        wantedList.put(parentId, selectedList);

                                        if (!separateIds.contains(skillId)) {
                                            separateIds.add(skillId);
                                        }
                                    }
                                    checkOnce = false;
                                }
                            }
                            // Condition for non-last items.
                            else if (skillId.equals(j)) {
                                String softwareTypeName = "";
                                List<SoftwareProficiency> tempList = DataHelper.getInstance().getSoftwareProficiencies();
                                SoftwareProficiency tempSoftwareProficiency = new SoftwareProficiency();
                                tempSoftwareProficiency.setSoftwareTypeId(skillId);
                                int location = tempList.indexOf(tempSoftwareProficiency);
                                if (location >= 0) {
                                    softwareTypeName = tempList.get(location).getSoftwareTypeName().trim();
                                }
                                if (skillId != 16)
                                    if (!softwareTypeName.equals("Bilingual")) {
                                        Integer parentId = DataHelper.getInstance().getSoftwareProficiencies().get(skillId).getParentId();

                                        if (parentId != null) {
                                            selectedList.add(skillId);
                                            wantedList.put(parentId, selectedList);

                                            if (!separateIds.contains(skillId)) {
                                                separateIds.add(skillId);
                                            }
                                        }
                                    } else {
                                        checkBilingual = true;
                                    }
                            }
                        }

                        // To print all the main items.
                        if (!separateIds.contains(skillId)) {
                            List<SoftwareProficiency> tempList = DataHelper.getInstance().getSoftwareProficiencies();
                            SoftwareProficiency tempSoftwareProficiency = new SoftwareProficiency();
                            tempSoftwareProficiency.setSoftwareTypeId(skillId);
                            int location = tempList.indexOf(tempSoftwareProficiency);
                            Log.d(LOG_TAG, "setupData: index :" + location + " " + Profile.getInstance().getSkills()[i]);
                            if (location >= 0) {
                                skills += tempList.get(location).getSoftwareTypeName() + ", ";
                                mSelectedAdditionSkillsArray[location] = true;
                            }
                        }
                    }
                }
            }
        }

        // To print all the sub items, and keep them checked in the check-list pop-up.
        if (wantedList.keySet().size() > 0) {
            for (Integer skillID : wantedList.keySet()) {

                List<SoftwareProficiency> tempList = DataHelper.getInstance().getSoftwareProficiencies();
                SoftwareProficiency tempSoftwareProficiency = new SoftwareProficiency();
                tempSoftwareProficiency.setSoftwareTypeId(skillID);
                int location = tempList.indexOf(tempSoftwareProficiency);
                if (location >= 0) {
                    subList = DataHelper.getInstance().getSoftwareProficiencies()
                            .get(location).getSubCategories();
                    subSelectedAdditionalSkillsView(tempList.get(location).getSoftwareTypeName(),
                            subList, selectedList);
                }
            }
        }

        if (skills.length() > 0)
            skills = skills.substring(0, skills.length() - 2);
        Log.d(LOG_TAG, "setupData: skills" + skills);
        et_additionalSkills.setText(skills);

        if (checkBilingual) {
            String langauges = Profile.getInstance().getBilingualLanguages();
            if (langauges != null && !langauges.isEmpty()) {
                et_language.setVisibility(View.VISIBLE);
                et_language.setText(Utility.capitalizeFirstLetter(langauges));
            } else {
                et_language.setVisibility(View.GONE);
            }
        } else {
            et_language.setVisibility(View.GONE);
            Profile.getInstance().setBilingualLanguages(null);
        }

        String otherSoftwareExperience = Profile.getInstance().getNewPracticeSoftware();
        if (otherSoftwareExperience != null && !otherSoftwareExperience.isEmpty()) {
            et_otherSoftwareExpereince.setVisibility(View.VISIBLE);
            et_otherSoftwareExpereince.setText(Utility.capitalizeFirstLetter(otherSoftwareExperience));
        } else {
            et_otherSoftwareExpereince.setVisibility(View.GONE);
        }


        if (Profile.getInstance().getLocationRangeID() > -1) { //for empty profile
            Log.d(LOG_TAG, "setupData: locationRangeID " + Profile.getInstance().getLocationRangeID());

            LocationRange tempLocationRange = new LocationRange();
            tempLocationRange.setRangeId(Profile.getInstance().getLocationRangeID());
            int index = DataHelper.getInstance().getLocationRanges().indexOf(tempLocationRange);
            if (index > -1) {
                et_opportunityWithinMiles.setText(DataHelper.getInstance().getLocationRanges().get(index).getMilesRange());
            }
        }

        //set weekdays
        JsonObject morningObject = null, afternoonObject = null, eveningObject = null;

        if (Profile.getInstance().getShifts() != null) {
            int shiftId;
            for (int i = 0; i < Profile.getInstance().getShifts().length; i++) {
                shiftId = Profile.getInstance().getShifts()[i].get("shiftID").getAsInt();
                if (shiftId == 1) morningObject = Profile.getInstance().getShifts()[i];
                else if (shiftId == 2) afternoonObject = Profile.getInstance().getShifts()[i];
                else eveningObject = Profile.getInstance().getShifts()[i];
            }

            // Setting mornings' color codes.
            setMornings(morningObject);
            // Setting afternoons' color codes.
            setAfternoons(afternoonObject);
            // Setting evenings' color codes.
            setEvenings(eveningObject);
        }
    }

    /**
     * Setting color for mornings in weekdays.
     *
     * @param morningObject Contains morning data.
     */
    private void setMornings(JsonObject morningObject) {
        if (morningObject != null) {
            for (int i = 0; i < morningObject.getAsJsonArray("days").size(); i++) {
                if (morningObject.getAsJsonArray("days").get(i).getAsString().equals(Constants.MONDAY)) {
                    morningViews.get(0).setImageResource(R.drawable.day3);
                    morningClicked[0] = true;
                    morningArray.add(mondayPrimitive);
                } else if (morningObject.getAsJsonArray("days").get(i).getAsString().equals(Constants.TUESDAY)) {
                    morningViews.get(1).setImageResource(R.drawable.day3);
                    morningClicked[1] = true;
                    morningArray.add(tuesdayPrimitive);
                } else if (morningObject.getAsJsonArray("days").get(i).getAsString().equals(Constants.WEDNESDAY)) {
                    morningViews.get(2).setImageResource(R.drawable.day3);
                    morningClicked[2] = true;
                    morningArray.add(wednesdayPrimitive);
                } else if (morningObject.getAsJsonArray("days").get(i).getAsString().equals(Constants.THURSDAY)) {
                    morningViews.get(3).setImageResource(R.drawable.day3);
                    morningClicked[3] = true;
                    morningArray.add(thursdayPrimitive);
                } else if (morningObject.getAsJsonArray("days").get(i).getAsString().equals(Constants.FRIDAY)) {
                    morningViews.get(4).setImageResource(R.drawable.day3);
                    morningClicked[4] = true;
                    morningArray.add(fridayPrimitive);
                } else if (morningObject.getAsJsonArray("days").get(i).getAsString().equals(Constants.SATURDAY)) {
                    morningViews.get(5).setImageResource(R.drawable.day3);
                    morningClicked[5] = true;
                    morningArray.add(saturdayPrimitive);
                } else if (morningObject.getAsJsonArray("days").get(i).getAsString().equals(Constants.SUNDAY)) {
                    morningViews.get(6).setImageResource(R.drawable.day3);
                    morningClicked[6] = true;
                    morningArray.add(sundayPrimitive);
                }
            }
        }
    }

    /**
     * Setting color for afternoons in weekdays.
     *
     * @param afternoonObject Contains afternoon data.
     */
    private void setAfternoons(JsonObject afternoonObject) {
        if (afternoonObject != null) {
            for (int i = 0; i < afternoonObject.getAsJsonArray("days").size(); i++) {
                if (afternoonObject.getAsJsonArray("days").get(i).getAsString().equals(Constants.MONDAY)) {
                    afternoonViews.get(0).setImageResource(R.drawable.day1);
                    afternoonClicked[0] = true;
                    afternoonArray.add(mondayPrimitive);
                } else if (afternoonObject.getAsJsonArray("days").get(i).getAsString().equals(Constants.TUESDAY)) {
                    afternoonViews.get(1).setImageResource(R.drawable.day1);
                    afternoonClicked[1] = true;
                    afternoonArray.add(tuesdayPrimitive);
                } else if (afternoonObject.getAsJsonArray("days").get(i).getAsString().equals(Constants.WEDNESDAY)) {
                    afternoonViews.get(2).setImageResource(R.drawable.day1);
                    afternoonClicked[2] = true;
                    afternoonArray.add(wednesdayPrimitive);
                } else if (afternoonObject.getAsJsonArray("days").get(i).getAsString().equals(Constants.THURSDAY)) {
                    afternoonViews.get(3).setImageResource(R.drawable.day1);
                    afternoonClicked[3] = true;
                    afternoonArray.add(thursdayPrimitive);
                } else if (afternoonObject.getAsJsonArray("days").get(i).getAsString().equals(Constants.FRIDAY)) {
                    afternoonViews.get(4).setImageResource(R.drawable.day1);
                    afternoonClicked[4] = true;
                    afternoonArray.add(fridayPrimitive);
                } else if (afternoonObject.getAsJsonArray("days").get(i).getAsString().equals(Constants.SATURDAY)) {
                    afternoonViews.get(5).setImageResource(R.drawable.day1);
                    afternoonClicked[5] = true;
                    afternoonArray.add(saturdayPrimitive);
                } else if (afternoonObject.getAsJsonArray("days").get(i).getAsString().equals(Constants.SUNDAY)) {
                    afternoonViews.get(6).setImageResource(R.drawable.day1);
                    afternoonClicked[6] = true;
                    afternoonArray.add(sundayPrimitive);
                }
            }
        }
    }

    /**
     * Setting color for evenings in weekdays.
     *
     * @param eveningObject Contains evening data.
     */
    private void setEvenings(JsonObject eveningObject) {
        if (eveningObject != null) {
            for (int i = 0; i < eveningObject.getAsJsonArray("days").size(); i++) {
                if (eveningObject.getAsJsonArray("days").get(i).getAsString().equals(Constants.MONDAY)) {
                    eveningViews.get(0).setImageResource(R.drawable.day4);
                    eveningClicked[0] = true;
                    eveningArray.add(mondayPrimitive);
                } else if (eveningObject.getAsJsonArray("days").get(i).getAsString().equals(Constants.TUESDAY)) {
                    eveningViews.get(1).setImageResource(R.drawable.day4);
                    eveningClicked[1] = true;
                    eveningArray.add(tuesdayPrimitive);
                } else if (eveningObject.getAsJsonArray("days").get(i).getAsString().equals(Constants.WEDNESDAY)) {
                    eveningViews.get(2).setImageResource(R.drawable.day4);
                    eveningClicked[2] = true;
                    eveningArray.add(wednesdayPrimitive);
                } else if (eveningObject.getAsJsonArray("days").get(i).getAsString().equals(Constants.THURSDAY)) {
                    eveningViews.get(3).setImageResource(R.drawable.day4);
                    eveningClicked[3] = true;
                    eveningArray.add(thursdayPrimitive);
                } else if (eveningObject.getAsJsonArray("days").get(i).getAsString().equals(Constants.FRIDAY)) {
                    eveningViews.get(4).setImageResource(R.drawable.day4);
                    eveningClicked[4] = true;
                    eveningArray.add(fridayPrimitive);
                } else if (eveningObject.getAsJsonArray("days").get(i).getAsString().equals(Constants.SATURDAY)) {
                    eveningViews.get(5).setImageResource(R.drawable.day4);
                    eveningClicked[5] = true;
                    eveningArray.add(saturdayPrimitive);
                } else if (eveningObject.getAsJsonArray("days").get(i).getAsString().equals(Constants.SUNDAY)) {
                    eveningViews.get(6).setImageResource(R.drawable.day4);
                    eveningClicked[6] = true;
                    eveningArray.add(sundayPrimitive);
                }
            }
        }
    }

    /**
     * setup the weekday preferences data
     */
    private void setupDays() {
        morningClicked = new boolean[7];
        afternoonClicked = new boolean[7];
        eveningClicked = new boolean[7];

        mShiftObjects = new JsonArray();

        morningArray = new JsonArray();
        afternoonArray = new JsonArray();
        eveningArray = new JsonArray();

        morningShift = new JsonObject();
        afternoonShift = new JsonObject();

        eveningShift = new JsonObject();

        mondayPrimitive = new JsonPrimitive(Constants.MONDAY);
        tuesdayPrimitive = new JsonPrimitive(Constants.TUESDAY);
        wednesdayPrimitive = new JsonPrimitive(Constants.WEDNESDAY);
        thursdayPrimitive = new JsonPrimitive(Constants.THURSDAY);
        fridayPrimitive = new JsonPrimitive(Constants.FRIDAY);
        saturdayPrimitive = new JsonPrimitive(Constants.SATURDAY);
        sundayPrimitive = new JsonPrimitive(Constants.SUNDAY);
    }

    @OnClick(R.id.et_work_availability_month)
    void onWorkAvailabilityMonthClick() {
        showDatePicker2();
    }
    @OnClick(R.id.et_work_availability_day)
    void onWorkAvailabilityDayClick() {
        showDatePicker2();
    }
    @OnClick(R.id.et_work_availability_year)
    void onWorkAvailabilityYearClick() {
        showDatePicker2();
    }


    private void showDatePicker2() {
        DatePickerFragment date = new DatePickerFragment();
        /**
         * Set Up Current Date Into dialog
         */
        Calendar calender = Calendar.getInstance();
        Bundle args = new Bundle();
        args.putInt("year", calender.get(Calendar.YEAR));
        args.putInt("month", calender.get(Calendar.MONTH));
        args.putInt("day", calender.get(Calendar.DAY_OF_MONTH));
        date.setArguments(args);
        /**
         * Set Call back to capture selected date
         */
        date.setCallBack(ondate);
        date.show(getFragmentManager(), "Datepickerdialog");
    }

    DatePickerDialog.OnDateSetListener ondate = new DatePickerDialog.OnDateSetListener() {

        @Override
        public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
            workAvailabilityMonth_et.setText(String.valueOf(monthOfYear + 1));
            workAvailabilityDay_et.setText(String.valueOf(dayOfMonth));
            workAvailabilityYear_et.setText(String.valueOf(year));
        }
    };


    @OnClick(R.id.et_language)
    void onLanguagesClick() {
        et_language.setCursorVisible(true);
    }

    @OnClick(R.id.et_other_software_experience)
    void onOtherExperienceClick() {
        et_otherSoftwareExpereince.setCursorVisible(true);
    }

    @OnClick(R.id.job_type_profile)
    void onJobTypeClick() {

        mSelectedJobTypes = new ArrayList<>();

        AlertDialog.Builder builder = new AlertDialog.Builder(mActivity);
        CharSequence[] dialogList = new CharSequence[DataHelper.getInstance().getJobTypes().size()];
        // set the dialog title
        for (int i = 0; i < DataHelper.getInstance().getJobTypes().size(); i++) {
            dialogList[i] = DataHelper.getInstance().getJobTypes().get(i).getJobType();
        }

        builder.setMultiChoiceItems(dialogList, mSelectedJobTypeArray, new DialogInterface.OnMultiChoiceClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which, boolean isChecked) {

            }
        });

        //set action items
        builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                ListView list = ((AlertDialog) dialog).getListView();
                // make selected item in the comma separated string
                StringBuilder stringBuilder = new StringBuilder();
                for (int i = 0; i < list.getCount(); i++) {
                    boolean checked = list.isItemChecked(i);
                    if (checked) {
                        // if the user checked the item, add it to the selected items
                        mSelectedJobTypeArray[i] = true;
                        int jobTypeId = DataHelper.getInstance().getJobTypes().get(i).getJobTypeId();
                        mSelectedJobTypes.add(jobTypeId);
                    } else {
                        // else if the item is already in the array, remove it
                        mSelectedJobTypeArray[i] = false;
                        if (mSelectedJobTypes.size() > 0) {
                            int jobTypeId = DataHelper.getInstance().getJobTypes().get(i).getJobTypeId();
                            int index = mSelectedJobTypes.indexOf(jobTypeId);

                            Log.d(LOG_TAG, "onClick: " + jobTypeId);

                            if (index >= 0)
                                mSelectedJobTypes.remove(index);
                        }
                    }
                    if (checked) {
                        if (stringBuilder.length() > 0)
                            stringBuilder.append(", ");
                        stringBuilder.append(list.getItemAtPosition(i));
                    }
                }
                    /*Check string builder is empty or not. If string builder is not empty.
                      It will display on the screen.
                     */
                if (!stringBuilder.toString().trim().equals("")) {
                    jobType_et.setText(stringBuilder);
                } else {
                    jobType_et.setText("");
                }

                JsonArray mJobTypesArray = new JsonArray();
                for (int item : mSelectedJobTypes) {
                    mJobTypesArray.add(new JsonPrimitive(JobType.toBackendName(item)));
                }

                // TODO: 21-06-2016
                ProfileHelper.getInstance().setSelectedJobTypes(mJobTypesArray);

            }
        }).setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //
            }
        }).show();
    }

    @OnClick(R.id.et_workAvailablity)
    void onWorkAvailabilityClick() {
        ArrayAdapter<WorkAvailability> spinnerAdapter = new DropdownAdapter<>(mActivity, android.R.layout.simple_list_item_1, DataHelper.getInstance().getWorkAvailabilities());
        spinnerAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);


        mAlertDialog = new AlertDialog.Builder(mActivity)
                .setAdapter(spinnerAdapter, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        et_workAvailablity.setText(DataHelper.getInstance().getWorkAvailabilities().get(which).toString());
                        workAvailabilityId = DataHelper.getInstance().getWorkAvailabilities().get(which).getWorkId();
                        ProfileHelper.getInstance().setWorkAvailabilityId(workAvailabilityId);
                        dialog.dismiss();

                        //make the field visible accordingly
                        if (workAvailabilityId == 2)
                            viewAvailabilityDate.setVisibility(View.VISIBLE);
                        else
                            viewAvailabilityDate.setVisibility(View.GONE); //do not show for immediate

                    }
                }).create();

        if (mAlertDialog != null && !mAlertDialog.isShowing()) {
            Utility.setupSpinnerView(mActivity, mAlertDialog);
            mAlertDialog.show();
        }
    }

    @OnClick({R.id.monday_morning, R.id.tuesday_morning, R.id.wednesday_morning, R.id.thursday_morning, R.id.friday_morning, R.id.saturday_morning, R.id.sunday_morning})
    void onMorningClick(ImageView imageView) {
        // TODO: 07-06-2016 add to request body
        switch (imageView.getId()) {
            case R.id.monday_morning:
                if (morningClicked[0]) {
                    imageView.setImageResource(R.drawable.day2);
                    morningClicked[0] = false;
                    morningArray.remove(mondayPrimitive);

                } else {
                    imageView.setImageResource(R.drawable.day3);
                    morningClicked[0] = true;
                    morningArray.add(mondayPrimitive);
                }

                break;

            case R.id.tuesday_morning:
                if (morningClicked[1]) {
                    imageView.setImageResource(R.drawable.day2);
                    morningClicked[1] = false;
                    morningArray.remove(tuesdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day3);
                    morningClicked[1] = true;
                    morningArray.add(tuesdayPrimitive);
                }

                break;

            case R.id.wednesday_morning:
                if (morningClicked[2]) {
                    imageView.setImageResource(R.drawable.day2);
                    morningClicked[2] = false;
                    morningArray.remove(wednesdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day3);
                    morningClicked[2] = true;
                    morningArray.add(wednesdayPrimitive);
                }

                break;
            case R.id.thursday_morning:
                if (morningClicked[3]) {
                    imageView.setImageResource(R.drawable.day2);
                    morningClicked[3] = false;
                    morningArray.remove(thursdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day3);
                    morningClicked[3] = true;
                    morningArray.add(thursdayPrimitive);
                }

                break;
            case R.id.friday_morning:
                if (morningClicked[4]) {
                    imageView.setImageResource(R.drawable.day2);
                    morningClicked[4] = false;
                    morningArray.remove(fridayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day3);
                    morningClicked[4] = true;
                    morningArray.add(fridayPrimitive);
                }
                break;
            case R.id.saturday_morning:
                if (morningClicked[5]) {
                    imageView.setImageResource(R.drawable.day2);
                    morningClicked[5] = false;
                    morningArray.remove(saturdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day3);
                    morningClicked[5] = true;
                    morningArray.add(saturdayPrimitive);
                }

                break;
            case R.id.sunday_morning:
                if (morningClicked[6]) {
                    imageView.setImageResource(R.drawable.day2);
                    morningClicked[6] = false;
                    morningArray.remove(sundayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day3);
                    morningClicked[6] = true;
                    morningArray.add(sundayPrimitive);
                }
                break;

        }

        if (morningArray.size() != 0) {
            morningShift.addProperty("shiftID", 1);
            morningShift.add("days", morningArray);
            mShiftObjects.add(morningShift);
            mActivity.mShifts.add(morningShift);
        }

    }

    @OnClick({R.id.monday_afternoon, R.id.tuesday_afternoon, R.id.wednesday_afternoon, R.id.thursday_afternoon, R.id.friday_afternoon, R.id.saturday_afternoon, R.id.sunday_afternoon})
    void onAfternoonClick(ImageView imageView) {

        switch (imageView.getId()) {
            case R.id.monday_afternoon:
                if (afternoonClicked[0]) {
                    imageView.setImageResource(R.drawable.day2);
                    afternoonClicked[0] = false;
                    afternoonArray.remove(mondayPrimitive);

                } else {
                    imageView.setImageResource(R.drawable.day4);
                    afternoonClicked[0] = true;
                    afternoonArray.add(mondayPrimitive);
                }
                break;

            case R.id.tuesday_afternoon:
                if (afternoonClicked[1]) {
                    imageView.setImageResource(R.drawable.day2);
                    afternoonClicked[1] = false;
                    afternoonArray.remove(tuesdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day4);
                    afternoonClicked[1] = true;
                    afternoonArray.add(tuesdayPrimitive);
                }
                break;

            case R.id.wednesday_afternoon:
                if (afternoonClicked[2]) {
                    imageView.setImageResource(R.drawable.day2);
                    afternoonClicked[2] = false;
                    afternoonArray.remove(wednesdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day4);
                    afternoonClicked[2] = true;
                    afternoonArray.add(wednesdayPrimitive);
                }
                break;
            case R.id.thursday_afternoon:
                if (afternoonClicked[3]) {
                    imageView.setImageResource(R.drawable.day2);
                    afternoonClicked[3] = false;
                    afternoonArray.remove(thursdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day4);
                    afternoonClicked[3] = true;
                    afternoonArray.add(thursdayPrimitive);
                }
                break;
            case R.id.friday_afternoon:
                if (afternoonClicked[4]) {
                    imageView.setImageResource(R.drawable.day2);
                    afternoonClicked[4] = false;
                    afternoonArray.remove(fridayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day4);
                    afternoonClicked[4] = true;
                    afternoonArray.add(fridayPrimitive);
                }
                break;
            case R.id.saturday_afternoon:
                if (afternoonClicked[5]) {
                    imageView.setImageResource(R.drawable.day2);
                    afternoonClicked[5] = false;
                    afternoonArray.remove(saturdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day4);
                    afternoonClicked[5] = true;
                    afternoonArray.add(saturdayPrimitive);
                }
                break;
            case R.id.sunday_afternoon:
                if (afternoonClicked[6]) {
                    imageView.setImageResource(R.drawable.day2);
                    afternoonClicked[6] = false;
                    afternoonArray.remove(sundayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day4);
                    afternoonClicked[6] = true;
                    afternoonArray.add(sundayPrimitive);
                }
                break;

        }

        if (afternoonArray.size() != 0) {
            afternoonShift.addProperty("shiftID", 2);
            afternoonShift.add("days", afternoonArray);
            mShiftObjects.add(afternoonShift);
            mActivity.mShifts.add(afternoonShift);
        }

    }

    @OnClick({R.id.monday_evening, R.id.tuesday_evening, R.id.wednesday_evening, R.id.thursday_evening, R.id.friday_evening, R.id.saturday_evening, R.id.sunday_evening})
    void onEveningClick(ImageView imageView) {
        switch (imageView.getId()) {
            case R.id.monday_evening:
                if (eveningClicked[0]) {
                    imageView.setImageResource(R.drawable.day2);
                    eveningClicked[0] = false;
                    eveningArray.remove(mondayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day1);
                    eveningClicked[0] = true;
                    eveningArray.add(mondayPrimitive);
                }
                break;

            case R.id.tuesday_evening:
                if (eveningClicked[1]) {
                    imageView.setImageResource(R.drawable.day2);
                    eveningClicked[1] = false;
                    eveningArray.remove(tuesdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day1);
                    eveningClicked[1] = true;
                    eveningArray.add(tuesdayPrimitive);
                }
                break;

            case R.id.wednesday_evening:
                if (eveningClicked[2]) {
                    imageView.setImageResource(R.drawable.day2);
                    eveningClicked[2] = false;
                    eveningArray.remove(wednesdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day1);
                    eveningClicked[2] = true;
                    eveningArray.add(wednesdayPrimitive);
                }
                break;
            case R.id.thursday_evening:
                if (eveningClicked[3]) {
                    imageView.setImageResource(R.drawable.day2);
                    eveningClicked[3] = false;
                    eveningArray.remove(thursdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day1);
                    eveningClicked[3] = true;
                    eveningArray.add(thursdayPrimitive);
                }
                break;
            case R.id.friday_evening:
                if (eveningClicked[4]) {
                    imageView.setImageResource(R.drawable.day2);
                    eveningClicked[4] = false;
                    eveningArray.remove(fridayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day1);
                    eveningClicked[4] = true;
                    eveningArray.add(fridayPrimitive);
                }
                break;
            case R.id.saturday_evening:
                if (eveningClicked[5]) {
                    imageView.setImageResource(R.drawable.day2);
                    eveningClicked[5] = false;
                    eveningArray.remove(saturdayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day1);
                    eveningClicked[5] = true;
                    eveningArray.add(saturdayPrimitive);
                }
                break;
            case R.id.sunday_evening:
                if (eveningClicked[6]) {
                    imageView.setImageResource(R.drawable.day2);
                    eveningClicked[6] = false;
                    eveningArray.remove(sundayPrimitive);
                } else {
                    imageView.setImageResource(R.drawable.day1);
                    eveningClicked[6] = true;
                    eveningArray.add(sundayPrimitive);
                }
                break;
        }

        if (eveningArray.size() != 0) {
            eveningShift.addProperty("shiftID", 3);
            eveningShift.add("days", eveningArray);
            mShiftObjects.add(eveningShift);
            mActivity.mShifts.add(eveningShift);
        }

    }

    @OnClick(R.id.et_softwareExperience)
    void onPracticeSoftwareExperienceClick() {
        // Removing all the sub Views before showing the Software Experience's sub-list.
        ll_subSoftwareExperience.removeAllViews();
        // where we will store or remove selected items
        mSelectedSoftwareExperiences = new ArrayList<>();

        AlertDialog.Builder builder = new AlertDialog.Builder(mActivity, R.style.customAlertDialog);
        CharSequence[] dialogList = new CharSequence[DataHelper.getInstance().getPracticeManagementSoftwares().size()];
        //      toArray(new CharSequence[DataHelper.getInstance().getPracticeManagementSoftwares().size()]);
        // set the dialog title
        for (int i = 0; i < DataHelper.getInstance().getPracticeManagementSoftwares().size(); i++) {
            dialogList[i] = DataHelper.getInstance().getPracticeManagementSoftwares().get(i).getSoftware();
        }

        // specify the list array, the items to be selected by default (null for none),
        // and the listener through which to receive call backs when items are selected
        // R.array.choices were set in the resources res/values/strings.xml


        builder.setMultiChoiceItems(dialogList, mSelectedPracticeArray, new DialogInterface.OnMultiChoiceClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which, boolean isChecked) {

            }
        });

        //set action items
        builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                ListView list = ((AlertDialog) dialog).getListView();
                // make selected item in the comma separated string
                StringBuilder stringBuilder = new StringBuilder();
                for (int i = 0; i < list.getCount(); i++) {
                    boolean checked = list.isItemChecked(i);
                    if (checked) {
                        // if the user checked the item, add it to the selected items
                        mSelectedPracticeArray[i] = true;
                        int practiceExperienceID = DataHelper.getInstance().getPracticeManagementSoftwares().get(i).getSoftwareId();
                        mSelectedSoftwareExperiences.add(practiceExperienceID);

                        if (practiceExperienceID == 33) {
                            et_otherSoftwareExpereince.setVisibility(View.VISIBLE); //show when *other* is selected
                        }


                    } else {
                        // else if the item is already in the array, remove it
                        mSelectedPracticeArray[i] = false;
                        if (mSelectedSoftwareExperiences.size() > 0) {
                            int practiceExperienceID = DataHelper.getInstance().getPracticeManagementSoftwares().get(i).getSoftwareId();
                            int index = mSelectedSoftwareExperiences.indexOf(practiceExperienceID);

                            Log.d(LOG_TAG, "onClick: " + practiceExperienceID);

                            if (practiceExperienceID == 33) {
                                et_otherSoftwareExpereince.setVisibility(View.GONE); // hide if *other* is not selected
                                mActivity.otherSoftwareExperience = "";
                            }

                            if (index >= 0)
                                mSelectedSoftwareExperiences.remove(index);
                        }
                    }
                    if (checked) {
                        if (stringBuilder.length() > 0)
                            stringBuilder.append(", ");
                        stringBuilder.append(list.getItemAtPosition(i));
                        Log.d(TAG, "onClick: " + " Software Expertise: " + list.getItemAtPosition(i));
                     /*
                        if (list.getItemAtPosition(i).equals("Dovetail") || list.getItemAtPosition(i).equals("Open Dental")) {
                            subSoftwareExperienceView(list.getItemAtPosition(i));
                        }*/
                        //  mSoftwareExperienceArray.add( new JsonPrimitive(i));

                    }
                }
                    /*Check string builder is empty or not. If string builder is not empty.
                      It will display on the screen.
                     */
                if (!stringBuilder.toString().trim().equals("")) {
                    et_softwareExperience.setText(stringBuilder);
                } else {
                    et_softwareExperience.setText("");
                }

                JsonArray mSoftwareExperienceArray = new JsonArray();
                for (int item : mSelectedSoftwareExperiences) {
                    mSoftwareExperienceArray.add(new JsonPrimitive(item + ""));
                    Log.d(LOG_TAG, "onClick: software experiences" + item);
                }

                // TODO: 21-06-2016
                ProfileHelper.getInstance().setSelectedPracticeSoftware(mSoftwareExperienceArray);

            }
        }).setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //
            }
        }).show();


    }

    /**
     * Method to add sub categories dynamically for
     * Software Experience.
     */
    private void subSoftwareExperienceView(Object listItem) {
        EditText etSubSoftwareExperience = (EditText) View.inflate(mActivity, R.layout.profile3_sub_item, null);
        etSubSoftwareExperience.setHint(listItem.toString());
        etSubSoftwareExperience.setFocusable(false);
        etSubSoftwareExperience.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                subSoftwareExperienceDialog();
            }
        });
        ll_subSoftwareExperience.addView(etSubSoftwareExperience);
    }

    /**
     * Alert dialog containing the check-list of
     * sub-items within the selected Software Experience.
     */
    private void subSoftwareExperienceDialog() {
        AlertDialog.Builder builder = new AlertDialog.Builder(mActivity, R.style.customAlertDialog);
        CharSequence[] dialogList = new CharSequence[DataHelper.getInstance().getPracticeManagementSoftwares().size()];
        //      toArray(new CharSequence[DataHelper.getInstance().getPracticeManagementSoftwares().size()]);
        // set the dialog title
        for (int i = 0; i < DataHelper.getInstance().getPracticeManagementSoftwares().size(); i++) {
            dialogList[i] = DataHelper.getInstance().getPracticeManagementSoftwares().get(i).getSoftware();
        }

        // specify the list array, the items to be selected by default (null for none),
        // and the listener through which to receive call backs when items are selected
        // R.array.choices were set in the resources res/values/strings.xml


        builder.setMultiChoiceItems(dialogList, mSelectedPracticeArray, new DialogInterface.OnMultiChoiceClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which, boolean isChecked) {

            }
        });

        //set action items
        builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                ListView list = ((AlertDialog) dialog).getListView();
                // make selected item in the comma separated string
                StringBuilder stringBuilder = new StringBuilder();
                for (int i = 0; i < list.getCount(); i++) {
                    boolean checked = list.isItemChecked(i);
                    if (checked) {
                        // if the user checked the item, add it to the selected items
                        mSelectedPracticeArray[i] = true;
                        int practiceExperienceID = DataHelper.getInstance().getPracticeManagementSoftwares().get(i).getSoftwareId();
                        mSelectedSoftwareExperiences.add(practiceExperienceID);

                        if (practiceExperienceID == 33) {
                            et_otherSoftwareExpereince.setVisibility(View.VISIBLE); //show when *other* is selected
                        }


                    } else {
                        // else if the item is already in the array, remove it
                        mSelectedPracticeArray[i] = false;
                        if (mSelectedSoftwareExperiences.size() > 0) {
                            int practiceExperienceID = DataHelper.getInstance().getPracticeManagementSoftwares().get(i).getSoftwareId();
                            int index = mSelectedSoftwareExperiences.indexOf(practiceExperienceID);

                            Log.d(LOG_TAG, "onClick: " + practiceExperienceID);

                            if (practiceExperienceID == 33) {
                                et_otherSoftwareExpereince.setVisibility(View.GONE); // hide if *other* is not selected
                                mActivity.otherSoftwareExperience = "";
                            }

                            if (index >= 0)
                                mSelectedSoftwareExperiences.remove(index);
                        }
                    }
                    if (checked) {
                        if (stringBuilder.length() > 0)
                            stringBuilder.append(", ");
                        stringBuilder.append(list.getItemAtPosition(i));
                        Log.d(TAG, "onClick: " + " Software Expertise: " + list.getItemAtPosition(i));
                        //  mSoftwareExperienceArray.add( new JsonPrimitive(i));

                    }
                }
                    /*Check string builder is empty or not. If string builder is not empty.
                      It will display on the screen.
                     */
                if (!stringBuilder.toString().trim().equals("")) {
                    et_softwareExperience.setText(stringBuilder);
                } else {
                    et_softwareExperience.setText("");
                }

                JsonArray mSoftwareExperienceArray = new JsonArray();
                for (int item : mSelectedSoftwareExperiences) {
                    mSoftwareExperienceArray.add(new JsonPrimitive(item + ""));
                    Log.d(LOG_TAG, "onClick: software experiences" + item);
                }

                // TODO: 21-06-2016
                ProfileHelper.getInstance().setSelectedPracticeSoftware(mSoftwareExperienceArray);

            }
        }).setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //
            }
        }).show();

    }

    @OnClick(R.id.et_opportunityWithinMiles)
    void onFindOpportunityWithin() {

        ArrayAdapter<LocationRange> spinnerAdapter = new DropdownAdapter<>(mActivity,
                android.R.layout.simple_list_item_1, DataHelper.getInstance().getLocationRanges());

        spinnerAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        mAlertDialog = new AlertDialog.Builder(mActivity)
                .setAdapter(spinnerAdapter, new DialogInterface.OnClickListener() {

                    public void onClick(DialogInterface dialog, int which) {
                        et_opportunityWithinMiles.setText(DataHelper.getInstance().getLocationRanges().get(which).getMilesRange());
                        milesId = DataHelper.getInstance().getLocationRanges().get(which).getRangeId();
                        ProfileHelper.getInstance().setMilesId(milesId);
                        dialog.dismiss();
                    }
                }).create();

        if (mAlertDialog != null && !mAlertDialog.isShowing()) {
            Utility.setupSpinnerView(mActivity, mAlertDialog);
            mAlertDialog.show();
        }
    }

    @OnClick(R.id.et_additionalSkills)
    void additionalSkillsClick() {
        // Removing all the sub Views before showing the Additional Skills' sub-list.
//        ll_subAdditionalSkills.removeAllViews();

        AlertDialog.Builder builder = new AlertDialog.Builder(mActivity, R.style.customAlertDialog);
//        CharSequence[] dialogList = new CharSequence[DataHelper.getInstance().getSoftwareProficiencies().size()];
        additionalSkills = new CharSequence[DataHelper.getInstance().getSoftwareProficiencies().size()];
        //      toArray(new CharSequence[DataHelper.getInstance().getPracticeManagementSoftwares().size()]);
        // set the dialog title
        int parentIdCount = 0;
        if (DataHelper.getInstance().getSoftwareProficiencies() != null) {
            for (int i = 0; i < DataHelper.getInstance().getSoftwareProficiencies().size(); i++) {
                // Only if the parent id is null, i.e, if the item is not a sub of
                // some other item, add it to the list.
                if (DataHelper.getInstance().getSoftwareProficiencies().get(i).getParentId() == null) {
//                    dialogList[i] = DataHelper.getInstance().getSoftwareProficiencies().get(i).getSoftwareTypeName();
                    additionalSkills[i] = DataHelper.getInstance().getSoftwareProficiencies().get(i).getSoftwareTypeName();

                    parentIdCount++;
                } else {
//                    dialogList[i] = "";
                    additionalSkills[i] = "";
                }
            }
        }

        // A new list without the sub-items.
        CharSequence[] dialogItemList = new CharSequence[parentIdCount];
        int parentId = 0;
        for (int i = 0; i < DataHelper.getInstance().getSoftwareProficiencies().size(); i++) {
            if (additionalSkills[i].equals("")) {
            } else {
                dialogItemList[parentId++] = additionalSkills[i];
            }
        }
        // specify the list array, the items to be selected by default (null for none),
        // and the listener through which to receive call backs when items are selected
        // R.array.choices were set in the resources res/values/strings.xml
        builder.setMultiChoiceItems(dialogItemList, mSelectedAdditionSkillsArray,
                new DialogInterface.OnMultiChoiceClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which, boolean isChecked) {

                    }
                });

        // Set the action buttons
        builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                ListView list = ((AlertDialog) dialog).getListView();
                // make selected item in the comma separated string
                StringBuilder stringBuilder = new StringBuilder();
                for (int i = 0; i < list.getCount(); i++) {
                    boolean checked = list.isItemChecked(i);
                    if (checked) {
                        // if the user checked the item, add it to the selected items
                        mSelectedAdditionSkillsArray[i] = true;
                        int softwareTypeId = DataHelper.getInstance().getSoftwareProficiencies().get(i).getSoftwareTypeId();
                        mSelectedSkills.add(softwareTypeId);

                        String softwareTypeName = "";
                        List<SoftwareProficiency> tempList = DataHelper.getInstance().getSoftwareProficiencies();
                        SoftwareProficiency tempSoftwareProficiency = new SoftwareProficiency();
                        tempSoftwareProficiency.setSoftwareTypeId(softwareTypeId);
                        int location = tempList.indexOf(tempSoftwareProficiency);
                        if (location >= 0) {
                            softwareTypeName = tempList.get(location).getSoftwareTypeName().trim();
                        }
                        if (softwareTypeName.equalsIgnoreCase("Bilingual")) {
                            et_language.setVisibility(View.VISIBLE); //show for bilingual item
                        }

                    } else {
                        // else if the item is already in the array, remove it
                        mSelectedAdditionSkillsArray[i] = false;
                        if (mSelectedSkills.size() > 0) {
                            int softwareTypeId = DataHelper.getInstance().getSoftwareProficiencies().get(i).getSoftwareTypeId();
                            int index = mSelectedSkills.indexOf(softwareTypeId);

                            String softwareTypeName = "";
                            List<SoftwareProficiency> tempList = DataHelper.getInstance().getSoftwareProficiencies();
                            SoftwareProficiency tempSoftwareProficiency = new SoftwareProficiency();
                            tempSoftwareProficiency.setSoftwareTypeId(softwareTypeId);
                            int location = tempList.indexOf(tempSoftwareProficiency);
                            if (location >= 0) {
                                softwareTypeName = tempList.get(location).getSoftwareTypeName().trim();
                            }
                            if (softwareTypeName.equalsIgnoreCase("Bilingual")) {
                                et_language.setVisibility(View.GONE); //hide for bilingual item.
                                Profile.getInstance().setBilingualLanguages(null); // set the language-data to null.
                            }

                            if (index >= 0)
                                mSelectedSkills.remove(index);
                        }
                    }

                    if (checked) {
                        if (stringBuilder.length() > 0) stringBuilder.append(", ");
                        stringBuilder.append(list.getItemAtPosition(i));
                        // Checking if there are any sub categories within the checked
                        // item.
                        if (rootView.findViewWithTag(list.getItemAtPosition(i)) == null) {
                            List<SoftwareProficiency> subList = DataHelper.getInstance()
                                    .getSoftwareProficiencies().get(i).getSubCategories();
                            if (subList != null && subList.size() > 0) {
                                subAdditionalSkillsView(list.getItemAtPosition(i), subList);
                            }
                        }

                    } else {
                        View v = rootView.findViewWithTag(list.getItemAtPosition(i));
                        if (v != null) ll_subAdditionalSkills.removeView(v);
                    }
                }
                    /*Check string builder is empty or not. If string builder is not empty.
                      It will display on the screen.
                     */
                if (!stringBuilder.toString().trim().equals("")) {
                    et_additionalSkills.setText(stringBuilder);
                } else {
                    et_additionalSkills.setText("");
                    et_language.setVisibility(View.GONE);
                }

                if (mSelectedSkills.size() > 0) {
                    for (int item : mSelectedSkills) {
                        Log.d(LOG_TAG, "onClick: skills" + item);
                        if (!mAdditionalSkillsJSONArraytracker.contains(item)) {
                            mAdditionalSkillsArray.add(new JsonPrimitive(item + ""));
                            mAdditionalSkillsJSONArraytracker.add(item);
                        }
                    }

                    ProfileHelper.getInstance().setSelectedSkillsArray(mAdditionalSkillsArray);
                }

            }
        }).setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //
            }
        }).show();

    }

    /**
     * Method to add sub categories dynamically for
     * Additional Skills.
     */
    private void subAdditionalSkillsView(final Object listItem, final List<SoftwareProficiency> subItems) {
        MaterialEditText etSubAdditionalSkills = (MaterialEditText) View.inflate(mActivity, R.layout.profile3_sub_item, null);
        etSubAdditionalSkills.setKeyListener(null);
        etSubAdditionalSkills.setTag(listItem);
        // FIXME: Add hint programmatically later.
//        etSubAdditionalSkills.setHint(listItem.toString());
        etSubAdditionalSkills.setMaxLines(1);
        etSubAdditionalSkills.setFocusable(false);
        etSubAdditionalSkills.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                subAdditionalSkillsDialog(listItem, subItems, v);
            }
        });
        ll_subAdditionalSkills.addView(etSubAdditionalSkills);

    }

    /**
     * Method to add sub categories dynamically for
     * Additional Skills, based on the response from server.
     */
    private void subSelectedAdditionalSkillsView(final Object listItem, final List<SoftwareProficiency> subItems, ArrayList<Integer> selectedIds) {
        StringBuffer buffer = new StringBuffer();
        boolean[] selecIds = new boolean[subItems.size()];
        List<SoftwareProficiency> tempList = DataHelper.getInstance().getSoftwareProficiencies();
        for (Integer selectedId : selectedIds) {
            SoftwareProficiency tempSoftwareProficiency = new SoftwareProficiency();
            tempSoftwareProficiency.setSoftwareTypeId(selectedId);
            int location = tempList.indexOf(tempSoftwareProficiency);
            if (location >= 0) {
                buffer.append(tempList.get(location).getSoftwareTypeName() + ", ");
            }
        }
        for (int i = 0; i < subItems.size(); i++) {
            selecIds[i] = false;
            for (int j = 0; j < selectedIds.size(); j++) {
                if (subItems.get(i).getSoftwareTypeId() == selectedIds.get(j)) {
                    selecIds[i] = true;
                }
            }
        }
        subAddiSkillsSelectedItems.put(listItem.toString(), selecIds);
        MaterialEditText etSubAdditionalSkills = (MaterialEditText) View.inflate(mActivity, R.layout.profile3_sub_item, null);
        etSubAdditionalSkills.setTag(listItem);
        if (buffer.length() > 0) {
            etSubAdditionalSkills.setText(buffer);
        }
        // FIXME: Add hint programmatically later.
//        etSubAdditionalSkills.setHint(listItem.toString());
        etSubAdditionalSkills.setMaxLines(1);
        etSubAdditionalSkills.setFocusable(false);
        etSubAdditionalSkills.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                subAdditionalSkillsDialog(listItem, subItems, v);
            }
        });
        ll_subAdditionalSkills.addView(etSubAdditionalSkills);

    }


    /**
     * Dialog for showing the sub-list of an Additional Skills item.
     */
    private void subAdditionalSkillsDialog(final Object listItem, final List<SoftwareProficiency> subItems, final View view) {
        final boolean[] selectedItems = new boolean[subItems.size()];
        AlertDialog.Builder builder = new AlertDialog.Builder(mActivity, R.style.customAlertDialog);
        CharSequence[] dialogList = new CharSequence[subItems.size()];
        // set the dialog title
        if (DataHelper.getInstance().getSoftwareProficiencies() != null) {
            for (int i = 0; i < subItems.size(); i++) {
                dialogList[i] = subItems.get(i).getSoftwareTypeName();
            }
        }

        builder.setMultiChoiceItems(dialogList,
                subAddiSkillsSelectedItems.get(listItem.toString()),
                new DialogInterface.OnMultiChoiceClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which, boolean isChecked) {

                    }
                });

        // Set the action buttons
        builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                ListView list = ((AlertDialog) dialog).getListView();
                // make selected item in the comma separated string
                StringBuilder stringBuilder = new StringBuilder();
                for (int i = 0; i < list.getCount(); i++) {
                    boolean checked = list.isItemChecked(i);
                    int softwareTypeId = subItems.get(i).getSoftwareTypeId();
                    if (checked) {
                        // if the user checked the item, add it to the selected items
                        selectedItems[i] = true;
                        // Adding the checked sub item's software_type_id to the Skills list.
                        mSelectedSubSkills.add(softwareTypeId);
                        Log.v("SUBITEMS", "" + softwareTypeId);
                    } else {
                        // else if the item is already in the array, remove it
                        selectedItems[i] = false;
                        // Also remove it from the Skills list.
                        if (mSelectedSubSkills.contains(softwareTypeId)) {
                            int index = mSelectedSubSkills.indexOf(softwareTypeId);
                            mSelectedSubSkills.remove(index);
                        }
                    }

                    if (checked) {
                        if (stringBuilder.length() > 0) stringBuilder.append(", ");
                        stringBuilder.append(list.getItemAtPosition(i));
                    }
                }

                // Adding selected sub category list to the skills list.
                if (mSelectedSubSkills.size() > 0) {
                    for (int item : mSelectedSubSkills) {
                        Log.d(TAG, "onClick: sub skills: " + item);
                        if (!mAdditionalSkillsJSONArraytracker.contains(item)) {
                            mAdditionalSkillsArray.add(new JsonPrimitive(item + ""));
                            mAdditionalSkillsJSONArraytracker.add(item);
                        }
                    }
                    ProfileHelper.getInstance().setSelectedSkillsArray(mAdditionalSkillsArray);

                    // Log of skills being sent to the server.
                    for (Integer integer : mAdditionalSkillsJSONArraytracker) {
                        Log.v("JSONSKILLS", "" + integer);
                    }
                }


                // Setting the data in the dynamically generated EditText.
                subAddiSkillsSelectedItems.put(listItem.toString(), selectedItems);
                MaterialEditText etSubItem = (MaterialEditText) view;
                etSubItem.setKeyListener(null);
                etSubItem.setHint(listItem.toString());
                etSubItem.setText(stringBuilder);
            }
        });
        builder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //
            }
        });
        builder.show();
    }

    @OnTextChanged(R.id.et_language)
    void onLanguageChange(CharSequence charSequence) {
        mActivity.languages = charSequence.toString().trim();
    }

    @OnTextChanged(R.id.et_other_software_experience)
    void onOtherSoftwareExperienceChange(CharSequence charSequence) {
        mActivity.otherSoftwareExperience = charSequence.toString();
        Log.d(LOG_TAG, "onOtherSoftwareExperienceChange: " + charSequence.toString());
    }

    @OnTextChanged(R.id.et_work_availability_month)
    void onWorkAvailabilityMonthChange(CharSequence charSequence) {
        mActivity.workAvailabilitydate = workAvailabilityMonth_et.getText()
                + "-" + workAvailabilityDay_et.getText()
                + "-" + workAvailabilityYear_et.getText();
    }
    @OnTextChanged(R.id.et_work_availability_day)
    void onWorkAvailabilityDayChange(CharSequence charSequence) {
        mActivity.workAvailabilitydate = workAvailabilityMonth_et.getText()
                + "-" + workAvailabilityDay_et.getText()
                + "-" + workAvailabilityYear_et.getText();
    }
    @OnTextChanged(R.id.et_work_availability_year)
    void onWorkAvailabilityYearChange(CharSequence charSequence) {
        mActivity.workAvailabilitydate = workAvailabilityMonth_et.getText()
                + "-" + workAvailabilityDay_et.getText()
                + "-" + workAvailabilityYear_et.getText();
    }
}
