package com.rapidbizapps.swissmonkey.profile;


import android.app.DatePickerDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.AlertDialog;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.google.gson.JsonArray;
import com.google.gson.JsonPrimitive;
import com.rapidbizapps.swissmonkey.HomeActivity;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.Services.DataHelper;
import com.rapidbizapps.swissmonkey.Services.ProfileHelper;
import com.rapidbizapps.swissmonkey.models.BoardCertified;
import com.rapidbizapps.swissmonkey.models.ExperienceRange;
import com.rapidbizapps.swissmonkey.models.Position;
import com.rapidbizapps.swissmonkey.models.Profile;
import com.rapidbizapps.swissmonkey.models.State;
import com.rapidbizapps.swissmonkey.utility.DatePickerFragment;
import com.rapidbizapps.swissmonkey.utility.DropdownAdapter;
import com.rapidbizapps.swissmonkey.utility.Utility;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;
import butterknife.OnTextChanged;

public class ProfileFragment2 extends Fragment {
    private static final String LOG_TAG = "ProfileFragment2";
    private Context mContext;
    @BindView(R.id.et_seekingPosition)
    EditText et_seekingPosition;

    @BindView(R.id.et_experience)
    EditText et_experience;

    @BindView(R.id.et_boardCertified)
    EditText et_boardCertified;

    @BindView(R.id.et_licenceNumber)
    EditText et_licenceNumber;

    @BindView(R.id.cb_licenceVerified)
    CheckBox cb_licenceVerified;

    @BindView(R.id.ll_licenceExpDate)
    LinearLayout licenceExpDate;

    @BindView(R.id.tv_profile_date)
    TextView tv_profile_date;

    @BindView(R.id.tv_profile_month)
    TextView tv_profile_month;

    @BindView(R.id.tv_profile_year)
    TextView tv_profile_year;

    @BindView(R.id.frag_prog_2_ll_expiry_date)
    LinearLayout expiryDateLayout;

    @BindView(R.id.et_selectStates)
    EditText et_selectStates;

    AlertDialog mAlertDialog;
    Calendar dateandtime;
    private int experienceId = -1;
    private int boardCertifiedId = -1;
    private static String licenceExpiration;
    ArrayList<Integer> mSelectedStates;
    ArrayList<Integer> mSelectedPositions;
    private boolean[] mSelectedStatesArray, mSelectedPositionArray;

    final List<BoardCertified> boardCertifiedList = new ArrayList<>();
    private HomeActivity mActivity;


    public ProfileFragment2() {
        // Required empty public constructor
    }

    public static ProfileFragment2 newInstance() {
        ProfileFragment2 fragment = new ProfileFragment2();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mContext = this.getContext();
        boardCertifiedList.add(new BoardCertified("0", "NO"));
        boardCertifiedList.add(new BoardCertified("1", "YES"));
        boardCertifiedList.add(new BoardCertified("2", "N/A"));

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_profile_2, container, false);
        ButterKnife.bind(this, view);

        et_seekingPosition.setKeyListener(null);
        et_experience.setKeyListener(null);
        et_seekingPosition.setFocusable(false);
        et_experience.setFocusable(false);
        et_boardCertified.setKeyListener(null);
        et_boardCertified.setFocusable(false);
        tv_profile_date.setKeyListener(null);
        tv_profile_month.setKeyListener(null);
        tv_profile_year.setKeyListener(null);
        et_selectStates.setFocusable(false);
        et_selectStates.setKeyListener(null);

        setupData();
        return view;
    }

    private void setupData() {

        if (DataHelper.getInstance().getPositions() != null) {
            String positions = "";

            mSelectedPositionArray = new boolean[DataHelper.getInstance().getPositions().size()];

            if (Profile.getInstance().getPositionIDs() != null) {
                for (int i = 0; i < Profile.getInstance().getPositionIDs().length; i++) {
                    if (Profile.getInstance().getPositionIDs()[i] >= 0) {
                        List<Position> tempList = DataHelper.getInstance().getPositions();
                        Position tempPosition = new Position();
                        tempPosition.setPositionId(Profile.getInstance().getPositionIDs()[i]);
                        int location = tempList.indexOf(tempPosition);
                        if (location >= 0) {
                            positions += tempList.get(location).getPositionName() + ", ";
                            Log.d(LOG_TAG, "setupData: " + tempPosition.getPositionName());
                            mSelectedPositionArray[location] = true;
                        }
                    }
                }
            }

            if (positions.length() > 0)
                positions = positions.substring(0, positions.length() - 2);
            et_seekingPosition.setText(positions);

            Log.d(LOG_TAG, "setupData: experienceID" + Profile.getInstance().getExperienceID());
            if (Profile.getInstance().getExperienceID() > -1) {
                ExperienceRange tempExpRange = new ExperienceRange();
                tempExpRange.setExperienceRangeId(Profile.getInstance().getExperienceID());
                int temp = DataHelper.getInstance().getExperiences().indexOf(tempExpRange);

                if (temp > -1) {
                    et_experience.setText(DataHelper.getInstance().getExperiences().get(temp).getExperienceRange());
                }
            }
        }

        if (Profile.getInstance().getBoardCertifiedID() > -1)
            et_boardCertified.setText(boardCertifiedList.get(Profile.getInstance().getBoardCertifiedID()).getBoardCertifiedName());

        et_licenceNumber.setText(Profile.getInstance().getLicenseNumber());

        et_licenceNumber.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                if (s.toString().trim().length() > 0) {
                    expiryDateLayout.setVisibility(View.VISIBLE);
                } else {
                    expiryDateLayout.setVisibility(View.GONE);
                }
            }
        });

        if (et_licenceNumber.getText().toString().trim().length() > 0) {
            expiryDateLayout.setVisibility(View.VISIBLE);
            if (Profile.getInstance().getLicenseExpiry() != null) {
                String[] licenseDate = Profile.getInstance().getLicenseExpiry().split("-");

                tv_profile_year.setText(licenseDate[0]);
                tv_profile_month.setText(licenseDate[1]);
                tv_profile_date.setText(licenseDate[2]);
            }
        }

        if (Profile.getInstance().getLicenseVerified() != null) {
            if (Profile.getInstance().getLicenseVerified().equals("1"))
                cb_licenceVerified.setChecked(true);
            else
                cb_licenceVerified.setChecked(false);
        }


        if (DataHelper.getInstance().getStates() != null) {
            mSelectedStatesArray = new boolean[DataHelper.getInstance().getStates().size()];
            Arrays.fill(mSelectedStatesArray, Boolean.FALSE);

            if (Profile.getInstance().getLicenseVerifiedStates() != null) {
                for (int i = 0; i < Profile.getInstance().getLicenseVerifiedStates().length; i++) {
                    List<State> tempList = DataHelper.getInstance().getStates();
                    State tempState = new State();
                    tempState.setStateId(Profile.getInstance().getLicenseVerifiedStates()[i]);
                    int location = tempList.indexOf(tempState);
                    Log.d(LOG_TAG, "setupData: index :" + location + " " + Profile.getInstance().getLicenseVerifiedStates()[i]);
                    if (location >= 0) {
                        mSelectedStatesArray[location] = true;
                    }
                }
            }
        }


    }

    @OnClick(R.id.et_licenceNumber)
    void onLicenceClick() {
        et_licenceNumber.setCursorVisible(true);
    }


    @OnClick(R.id.et_seekingPosition)
    void onSelectPositionClick() {
        mSelectedPositions = new ArrayList<>();

        AlertDialog.Builder builder = new AlertDialog.Builder(mActivity, R.style.customAlertDialog);
        CharSequence[] dialogList = new CharSequence[DataHelper.getInstance().getPositions().size()];
        // set the dialog title
        for (int i = 0; i < DataHelper.getInstance().getPositions().size(); i++) {
            dialogList[i] = DataHelper.getInstance().getPositions().get(i).getPositionName();
        }

        // specify the list array, the items to be selected by default (null for none),
        // and the listener through which to receive call backs when items are selected
        // R.array.choices were set in the resources res/values/strings.xml


        builder.setMultiChoiceItems(dialogList, mSelectedPositionArray, new DialogInterface.OnMultiChoiceClickListener() {
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
                        mSelectedPositionArray[i] = true;
                        int positionID = DataHelper.getInstance().getPositions().get(i).getPositionId();
                        mSelectedPositions.add(positionID);
                    } else {
                        // else if the item is already in the array, remove it
                        mSelectedPositionArray[i] = false;
                        if (mSelectedPositions.size() > 0) {
                            int positionID = DataHelper.getInstance().getPositions().get(i).getPositionId();
                            int index = mSelectedPositions.indexOf(positionID);

                            Log.d(LOG_TAG, "onClick: " + positionID);

                            if (index >= 0)
                                mSelectedPositions.remove(index);
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
                    et_seekingPosition.setText(stringBuilder);
                } else {
                    et_seekingPosition.setText("");
                }

                JsonArray mPositionsArray = new JsonArray();
                for (int item : mSelectedPositions) {
                    mPositionsArray.add(new JsonPrimitive(item + ""));
                }

                // TODO: 21-06-2016
                ProfileHelper.getInstance().setSelectedPositions(mPositionsArray);

            }
        }).setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //
            }
        }).show();
    }

    @OnClick(R.id.et_experience)
    void onExperienceClick() {

        ArrayAdapter<ExperienceRange> spinnerAdapter = new DropdownAdapter<>(mActivity, android.R.layout.simple_list_item_1, DataHelper.getInstance().getExperiences());
        spinnerAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        mAlertDialog = new AlertDialog.Builder(mActivity)
                .setAdapter(spinnerAdapter, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        et_experience.setText(DataHelper.getInstance().getExperiences().get(which).toString());
                        experienceId = DataHelper.getInstance().getExperiences().get(which).getExperienceRangeId();
                        ProfileHelper.getInstance().setExperienceId(experienceId);
                        dialog.dismiss();
                    }
                }).create();

        if (mAlertDialog != null && !mAlertDialog.isShowing()) {
            Utility.setupSpinnerView(mActivity, mAlertDialog);
            mAlertDialog.show();
        }

        //  return true;
    }

    @OnClick(R.id.et_boardCertified)
    void boardCertifiedClick() {

        ArrayAdapter<BoardCertified> spinnerAdapter = new DropdownAdapter<>(mActivity, android.R.layout.simple_list_item_1, boardCertifiedList);
        spinnerAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        mAlertDialog = new AlertDialog.Builder(mActivity)
                .setAdapter(spinnerAdapter, new DialogInterface.OnClickListener() {

                    public void onClick(DialogInterface dialog, int which) {
                        et_boardCertified.setText(boardCertifiedList.get(which).getBoardCertifiedName());
                        boardCertifiedId = Integer.parseInt(boardCertifiedList.get(which).getBoardCertifiedId());
                        Log.d(LOG_TAG, "onClick: boardCertifiedID" + boardCertifiedId);
                        ProfileHelper.getInstance().setBoardCertifiedId(boardCertifiedId);
                        dialog.dismiss();
                    }
                }).create();

        if (mAlertDialog != null && !mAlertDialog.isShowing()) {
            Utility.setupSpinnerView(mActivity, mAlertDialog);
            mAlertDialog.show();
        }
    }

    @OnClick(R.id.et_selectStates)
    void onStatesListClick() {

        mSelectedStates = new ArrayList<>();

        AlertDialog.Builder builder = new AlertDialog.Builder(mActivity);
        CharSequence[] dialogList = new CharSequence[DataHelper.getInstance().getStates().size()];
        // set the dialog title
        for (int i = 0; i < DataHelper.getInstance().getStates().size(); i++) {
            dialogList[i] = DataHelper.getInstance().getStates().get(i).getStateName().toUpperCase(); //states should be in caps
        }

        // specify the list array, the items to be selected by default (null for none),
        // and the listener through which to receive call backs when items are selected
        // R.array.choices were set in the resources res/values/strings.xml
        builder.setMultiChoiceItems(dialogList, mSelectedStatesArray, new DialogInterface.OnMultiChoiceClickListener() {
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
                        mSelectedStatesArray[i] = true;
                        int stateID = Integer.parseInt(DataHelper.getInstance().getStates().get(i).getStateId());
                        mSelectedStates.add(stateID);


                    } else {
                        // else if the item is already in the array, remove it
                        mSelectedStatesArray[i] = false;
                        if (mSelectedStates.size() > 0) {
                            int stateID = Integer.parseInt(DataHelper.getInstance().getStates().get(i).getStateId());
                            int index = mSelectedStates.indexOf(stateID);
                            if (index >= 0)
                                mSelectedStates.remove(index);
                        }
                    }

                    if (checked) {
                        if (stringBuilder.length() > 0) stringBuilder.append(", ");
                        stringBuilder.append(DataHelper.getInstance().getStates().get(i).getStateName());
                    }
                }

                JsonArray statesArray = new JsonArray();

                for (int item : mSelectedStates) {
                    Log.d(LOG_TAG, "onClick: states" + item);
                    statesArray.add(new JsonPrimitive(item + ""));
                }

                et_selectStates.setText(stringBuilder.toString());

                ProfileHelper.getInstance().setSelectedStatesArray(statesArray);
            }
        }).setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //
            }
        }).show();
    }

    @OnTextChanged(R.id.et_licenceNumber)
    void onLicenseNumberChange(CharSequence charSequence) {
        mActivity.licenseNumber = charSequence.toString();
    }

    @OnCheckedChanged(R.id.cb_licenceVerified)
    void onLicenseVerified(CompoundButton compoundButton, boolean checked) {
        Log.d(LOG_TAG, "onLicenseVerified: " + checked);
        if (checked) ProfileHelper.getInstance().setLicenseVerified("1");
        else ProfileHelper.getInstance().setLicenseVerified("0");
    }

    @OnClick({R.id.ll_licenceExpDate})
    void licenceExpireClick() {
        showDatePicker2();
    }


    @OnClick({R.id.tv_profile_date})
    void onDateClick() {
        showDatePicker2();
    }

    @OnClick({R.id.tv_profile_month})
    void onMonthClick() {
        showDatePicker2();
    }

    @OnClick({R.id.tv_profile_year})
    void onYearClick() {
        showDatePicker2();
    }


    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        mActivity = (HomeActivity) context;
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
            tv_profile_date.setText(String.valueOf(dayOfMonth));
            tv_profile_month.setText(String.valueOf(monthOfYear + 1));
            tv_profile_year.setText(String.valueOf(year));
        }

    };


    @OnTextChanged(R.id.tv_profile_date)
    void onLicenseDateChange(CharSequence charSequence) {
        mActivity.licenseDate = charSequence.toString();
        Log.d(LOG_TAG, "onLicenseDateChange: " + mActivity.licenseDate);
    }

    @OnTextChanged(R.id.tv_profile_month)
    void onLicenseMonthChange(CharSequence charSequence) {
        mActivity.licenseMonth = charSequence.toString();
        Log.d(LOG_TAG, "onLicenseMonthChange: " + mActivity.licenseMonth);
    }

    @OnTextChanged(R.id.tv_profile_year)
    void onLicenseYearChange(CharSequence charSequence) {
        mActivity.licenseYear = charSequence.toString();
        Log.d(LOG_TAG, "onLicenseYearChange: " + mActivity.licenseYear);
    }

}
