package com.rapidbizapps.swissmonkey.fragments;


import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.Services.DataHelper;
import com.rapidbizapps.swissmonkey.models.CompensationRange;
import com.rapidbizapps.swissmonkey.models.ExperienceRange;
import com.rapidbizapps.swissmonkey.models.LocationRange;
import com.rapidbizapps.swissmonkey.models.PracticeManagementSoftware;
import com.rapidbizapps.swissmonkey.models.Profile;
import com.rapidbizapps.swissmonkey.models.SoftwareProficiency;
import com.rapidbizapps.swissmonkey.models.State;
import com.rapidbizapps.swissmonkey.utility.Constants;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * A simple {@link Fragment} subclass.
 */
public class WorkFragment extends Fragment {

    private static final String LOG_TAG = "WorkFragment";
    Profile profile;

    @BindView(R.id.tv_experience)
    TextView experience;

    @BindView(R.id.tv_boardCertified)
    TextView boardCertified;

    @BindView(R.id.tv_LicenceNumber)
    TextView licenceNumber;

    @BindView(R.id.tv_expirationDate)
    TextView expirationDate;

    @BindView(R.id.tv_states)
    TextView licenseVerifiedStates_tv;

    @BindView(R.id.tv_PracticeSoftwareExp)
    TextView practiceSoftwareExp;

    @BindView(R.id.tv_other_software_experience)
    TextView otherSoftwareExperience_tv;

    @BindView(R.id.tv_workAvailablity)
    TextView workAvailablity;

    @BindView(R.id.tv_opportunityWithin)
    TextView opportunityWithin;

    @BindView(R.id.tv_additionalSkills)
    TextView additionalSkills;

    @BindView(R.id.tv_language)
    TextView language;

    @BindView(R.id.tv_compensation)
    TextView compensation;

    @BindView(R.id.tv_expSalary)
    TextView expSalary;

    @BindView(R.id.tv_others)
    TextView others_tv;

    SimpleDateFormat originalFormat = new SimpleDateFormat("yyyy-mm-dd");
    SimpleDateFormat targetFormat = new SimpleDateFormat("mm-dd-yyyy");

    public WorkFragment() {
        // Required empty public constructor
    }

    public static WorkFragment newInstance(Profile profile) {
        WorkFragment fragment = new WorkFragment();
        Bundle args = new Bundle();
        args.putParcelable(Constants.JOB_INTENT_EXTRA, profile);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            profile = getArguments().getParcelable(Constants.JOB_INTENT_EXTRA);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_work, container, false);
        ButterKnife.bind(this, rootView);

        String practiceSoftware = "", skills = "", states = "";

        if (Profile.getInstance().getExperienceID() > -1) {
            List<ExperienceRange> experiences = DataHelper.getInstance().getExperiences();
            ExperienceRange experienceRange = new ExperienceRange();
            experienceRange.setExperienceRangeId(Profile.getInstance().getExperienceID());
            experience.setText(experiences.get(experiences.indexOf(experienceRange)).getExperienceRange());
        } else {
            experience.setText("-");
        }

        if (Profile.getInstance().getBoardCertifiedID() == 1) {
            boardCertified.setText("Yes");
        } else if (Profile.getInstance().getBoardCertifiedID() == 0) {
            boardCertified.setText("No");
        } else if (Profile.getInstance().getBoardCertifiedID() == 2) {
            boardCertified.setText("N/A");
        } else {
            boardCertified.setText("-");
        }


        if (Profile.getInstance().getLicenseNumber() != null)
            licenceNumber.setText(Profile.getInstance().getLicenseNumber());
        else
            licenceNumber.setText("-");

        if (Profile.getInstance().getLicenseExpiry() != null) {

            Date date = null;
            try {
                date = originalFormat.parse(Profile.getInstance().getLicenseExpiry());
                String formattedDate = targetFormat.format(date);
                expirationDate.setText(formattedDate);
            } catch (ParseException e) {
                e.printStackTrace();
            }

        } else
            expirationDate.setText("-");

        if (Profile.getInstance().getLicenseVerifiedStates() != null && Profile.getInstance().getLicenseVerifiedStates().length != 0) {
            for (int i = 0; i < Profile.getInstance().getLicenseVerifiedStates().length; i++) {
                List<State> licenseVerifiedStates = DataHelper.getInstance().getStates();
                State state = new State();
                state.setStateId(Profile.getInstance().getLicenseVerifiedStates()[i]);
                int location = licenseVerifiedStates.indexOf(state);

                if (location >= 0)
                    states = licenseVerifiedStates.get(location).getStateName() + ", " + states;
            }
            if (states.length() > 0)
                states = states.substring(0, states.length() - 2);
        } else {
            states = "-";
        }

        licenseVerifiedStates_tv.setText(states.toUpperCase());


        if (Profile.getInstance().getPracticeManagementID() != null && Profile.getInstance().getPracticeManagementID().length != 0) {
            for (int i = 0; i < Profile.getInstance().getPracticeManagementID().length; i++) {
                List<PracticeManagementSoftware> practiceManagementSoftwares = DataHelper.getInstance().getPracticeManagementSoftwares();
                PracticeManagementSoftware tempPracticeSoftware = new PracticeManagementSoftware();
                tempPracticeSoftware.setSoftwareId(Integer.parseInt(Profile.getInstance().getPracticeManagementID()[i]));
                int location = practiceManagementSoftwares.indexOf(tempPracticeSoftware);

                if (location >= 0)
                    practiceSoftware = practiceManagementSoftwares.get(location).getSoftware() + ", " + practiceSoftware;
            }
            if (practiceSoftware.length() > 0)
                practiceSoftware = practiceSoftware.substring(0, practiceSoftware.length() - 2);
        } else {
            practiceSoftware = "-";
        }

        if (Profile.getInstance().getNewPracticeSoftware() != null && !Profile.getInstance().getNewPracticeSoftware().isEmpty()) {

            String otherExperience = Profile.getInstance().getNewPracticeSoftware().replace(",", ", ");

            otherSoftwareExperience_tv.setText(otherExperience);
        } else
            otherSoftwareExperience_tv.setText("-");


        practiceSoftwareExp.setText(practiceSoftware);

        if (Profile.getInstance().getWorkAvailablityID() == 1) {
            workAvailablity.setText("Immediately available");
        } else if (Profile.getInstance().getWorkAvailabilityDate() != null) {
            workAvailablity.setText("Available after " + Profile.getInstance().getWorkAvailabilityDate());
        } else {
            workAvailablity.setText("-");
        }

        //set this as default. gets overrided accordingly
        opportunityWithin.setText("-");
        if (Profile.getInstance().getLocationRangeID() != 0) {
            LocationRange locationRange = new LocationRange();
            locationRange.setRangeId(Profile.getInstance().getLocationRangeID());
            List<LocationRange> locationRanges = DataHelper.getInstance().getLocationRanges();
            int location = locationRanges.indexOf(locationRange);
            if (location > -1) {
                opportunityWithin.setText(locationRanges.get(location).getMilesRange());
            }
        }


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
        // Boolean to check if the list contain Bilingual.
        boolean containsBilingual = false;

        // FIXME: Very confusing logic. Need to simplify it if possible.
        if (Profile.getInstance().getSkills() != null && Profile.getInstance().getSkills().length != 0) {

            for (int i = Profile.getInstance().getSkills().length - 1; i >= 0; i--) {
                skillId = Integer.parseInt(Profile.getInstance().getSkills()[i]);

                if (skillId >= 0) {
                    for (int j = 0; j < DataHelper.getInstance().getSoftwareProficiencies().size(); j++) {

                        // Condition for last item in the Skills list.
                        if (skillId.equals(DataHelper.getInstance().getSoftwareProficiencies().size())) {
                            String softwareTypeName = "";
                            List<SoftwareProficiency> tempList = DataHelper.getInstance().getSoftwareProficiencies();
                            SoftwareProficiency tempSoftwareProficiency = new SoftwareProficiency();
                            tempSoftwareProficiency.setSoftwareTypeId(skillId);
                            int location = tempList.indexOf(tempSoftwareProficiency);
                            if (location >= 0) {
                                softwareTypeName = tempList.get(location).getSoftwareTypeName().trim();
                            }
                            if (!softwareTypeName.equals("Bilingual")) {
                                if (checkOnce) {
                                    Integer parentId = DataHelper.getInstance().getSoftwareProficiencies().get(skillId - 1).getParentId();

                                    if (parentId != null) {
                                        selectedList.add(skillId);
                                        wantedList.put(parentId, selectedList);
                                        if (!separateIds.contains(parentId)) {
                                            separateIds.add(parentId);
                                        }
                                        if (!separateIds.contains(skillId)) {
                                            separateIds.add(skillId);
                                        }
                                    }
                                    checkOnce = false;
                                }
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
                            if (!softwareTypeName.equals("Bilingual")) {
                                Integer parentId = DataHelper.getInstance().getSoftwareProficiencies().get(skillId).getParentId();

                                if (parentId != null) {
                                    selectedList.add(skillId);
                                    wantedList.put(parentId, selectedList);
                                    if (!separateIds.contains(parentId)) {
                                        separateIds.add(parentId);
                                    }
                                    if (!separateIds.contains(skillId)) {
                                        separateIds.add(skillId);
                                    }
                                }
                            } else {
                                containsBilingual = true;
                            }
                        }
                    }

                    // To print on the skills without sub-categories.
                    if (!separateIds.contains(skillId)) {
                        List<SoftwareProficiency> tempList = DataHelper.getInstance().getSoftwareProficiencies();
                        SoftwareProficiency tempSoftwareProficiency = new SoftwareProficiency();
                        tempSoftwareProficiency.setSoftwareTypeId(skillId);
                        int location = tempList.indexOf(tempSoftwareProficiency);
                        Log.d(LOG_TAG, "setupData: index :" + location + " " + Profile.getInstance().getSkills()[i]);
                        if (location >= 0) {
                            if (!tempList.get(location).getSoftwareTypeName().equalsIgnoreCase("Specialized Dental Assisting"))
                                skills += tempList.get(location).getSoftwareTypeName() + ", ";
                        }
                    }
                }

            }

            // To print all the skills with sub categories.
            if (wantedList.keySet().size() > 0) {
                String parentItemName = "";
                ArrayList<Integer> subItems;

                for (Integer skillID : wantedList.keySet()) {
                    subItems = wantedList.get(skillID);

                    List<SoftwareProficiency> tempList = DataHelper.getInstance().getSoftwareProficiencies();
                    SoftwareProficiency tempSoftwareProficiency = new SoftwareProficiency();
                    tempSoftwareProficiency.setSoftwareTypeId(skillID);
                    int location = tempList.indexOf(tempSoftwareProficiency);
                    if (location >= 0) {
                        parentItemName = tempList.get(location).getSoftwareTypeName();
                    }

                    StringBuffer subItemsName = new StringBuffer();
                    for (Integer sub : subItems) {
                        List<SoftwareProficiency> tempList2 = DataHelper.getInstance().getSoftwareProficiencies();
                        SoftwareProficiency tempSoftwareProficiency2 = new SoftwareProficiency();
                        tempSoftwareProficiency2.setSoftwareTypeId(sub);
                        int location2 = tempList2.indexOf(tempSoftwareProficiency2);
                        if (location2 >= 0) {
                            if (!tempList2.get(location2).getSoftwareTypeName().equalsIgnoreCase("Specialized Dental Assisting")) {
                                if (subItemsName.length() > 0) {
                                    subItemsName.append(", " + tempList2.get(location2).getSoftwareTypeName());
                                } else {
                                    subItemsName.append(tempList2.get(location2).getSoftwareTypeName());
                                }
                            }
                        }
                    }

                    skills += parentItemName + " (" + subItemsName + ") ";
                }
            }

            /*for (int i = 0; i < Profile.getInstance().getSkills().length; i++) {
                List<SoftwareProficiency> softwareProficiencies = DataHelper.getInstance().getSoftwareProficiencies();
                SoftwareProficiency tempSoftwareProficiency = new SoftwareProficiency();
                tempSoftwareProficiency.setSoftwareTypeId(Integer.parseInt(Profile.getInstance().getSkills()[i]));
                int location = softwareProficiencies.indexOf(tempSoftwareProficiency);
                if (location >= 0)
                    skills = softwareProficiencies.get(location).getSoftwareTypeName() + ", " + skills;
            }*/

            if (skills.length() > 0)
                skills = skills.substring(0, skills.length());
        } else
            skills = "-";


        additionalSkills.setText(skills);

        if (containsBilingual) {
            if (Profile.getInstance().getBilingualLanguages() != null && !Profile.getInstance().getBilingualLanguages().isEmpty()) {

                String modifiedLang = Profile.getInstance().getBilingualLanguages().replace(",", ", ");

                language.setText(modifiedLang);
            } else
                language.setText("-");
        } else {
            language.setText("-");
        }


        if (Profile.getInstance().getCompensationID() != 0) {
            CompensationRange compensationRange = new CompensationRange();
            compensationRange.setCompensationId(Profile.getInstance().getCompensationID());
            List<CompensationRange> compensationRanges = DataHelper.getInstance().getCompensationRanges();
            compensation.setText(compensationRanges.get(compensationRanges.indexOf(compensationRange)).getCompensationName());
        } else {
            compensation.setText("-");
        }

        if (Profile.getInstance().getSalaryMin() != null && Profile.getInstance().getSalaryMax() != null)
            expSalary.setText("$" + Profile.getInstance().getSalaryMin()+ " - $"+Profile.getInstance().getSalaryMax());
        else
            expSalary.setText("-");

        if (Profile.getInstance().getComments() != null)
            others_tv.setText(Profile.getInstance().getComments());
        else
            others_tv.setText("-");

        return rootView;
    }


}
