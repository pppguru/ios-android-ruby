package com.rapidbizapps.swissmonkey.jobs;

import android.Manifest;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.text.Html;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.gson.JsonObject;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.models.Job;
import com.rapidbizapps.swissmonkey.models.WeekdayInfo;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.DialogUtility;
import com.rapidbizapps.swissmonkey.utility.PreferencesData;
import com.rapidbizapps.swissmonkey.utility.Utility;

import org.w3c.dom.Text;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;


public class JobDetailInfoFragment extends Fragment {
    private static final String TAG = "JobDetailInfoFragment";
    private static final int CALL_PERMISSION_REQUEST = 504;

    int mJobId = -1;
    Job mJob;
    @BindView(R.id.job_detail_position)
    TextView jobPosition_tv;
    @BindView(R.id.job_detail_type)
    TextView jobDetailType_tv;
    @BindView(R.id.company_name)
    TextView companyName_tv; //practice name
    @BindView(R.id.primary_contact)
    TextView primaryContact_tv;
    @BindView(R.id.company_website)
    TextView companyWebsite_tv;
    @BindView(R.id.company_phoneno)
    TextView companyPhone_tv;
    @BindView(R.id.company_address)
    TextView companyAddress_tv;
    @BindView(R.id.company_city_state_zip)
    TextView companyCityStateZip;
    @BindView(R.id.company_logo)
    ImageView companyLogo_iv;
    @BindView(R.id.company_email)
    TextView companyEmail_tv;
    @BindView(R.id.apply_now)
    Button applyNow_btn;
    @BindView(R.id.job_description)
    TextView jobDescription_tv;
    @BindView(R.id.experience)
    TextView experience_tv;
    @BindView(R.id.additional_skills)
    TextView additionalSkills_tv;
    @BindView(R.id.languages)
    TextView languages_tv;
    @BindView(R.id.practice_management_system)
    TextView practiceManagementSystem_tv;
    @BindView(R.id.compensation_type)
    TextView compensationType_tv;
    @BindView(R.id.compensation_amount)
    TextView compensationAmount_tv;
    @BindView(R.id.job_type)
    TextView jobType_tv;
    @BindView(R.id.morning_shift)
    TextView morningShift_tv;
    @BindView(R.id.afternoon_shift)
    TextView afternoonShift_tv;
    @BindView(R.id.evevning_shift)
    TextView eveningShift_tv;
    WeekdayInfo[] mShifts;
    String[] morningDays, afternoonDays, eveningdays;
    private OnJobDetailInfoFragmentListener mListener;

    private String url;
    private String companyEmail;

    public JobDetailInfoFragment() {
        // Required empty public constructor
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment JobDetailInfoFragment.
     */
    public static JobDetailInfoFragment newInstance(Job job) {
        JobDetailInfoFragment fragment = new JobDetailInfoFragment();
        Bundle args = new Bundle();
        args.putParcelable(Constants.JOB_INTENT_EXTRA, job);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mJob = getArguments().getParcelable(Constants.JOB_INTENT_EXTRA);
            if (mJob != null) {
                mJobId = mJob.getJobId();
            }
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.job_detail_info, container, false);
        ButterKnife.bind(this, view);

        if (mJob != null) {
            jobPosition_tv.setText(mJob.getPosition());
            jobDetailType_tv.setText(mJob.getJobType());
            String companyName = ""; // String to check if the Company Name/Practice Info. is: ANONYMOUS.


            url = mJob.getWebsite();
            if (url != null) {
                if (url.equalsIgnoreCase(Constants.ANONYMOUS)) {
                    companyWebsite_tv.setText(getString(R.string.anonymous));
                } else if (!url.startsWith("https://") && !url.startsWith("http://")) {
                    url = "http://" + url;
                    companyWebsite_tv.setText(Html.fromHtml("<u>" + url + "</u>"));
                }
            }

/*        String address = mJob.getAddress1();
        if (address != null)
            address = address.replace(",", ", ");
        else
            address = "";*/

            // PRACTICE INFO.
            if (mJob.getCompanyName() != null && !mJob.getCompanyName().isEmpty()) {
                companyName = mJob.getCompanyName();

                if (mJob.getCompanyName().equalsIgnoreCase(Constants.ANONYMOUS)) {
                    companyName_tv.setVisibility(View.GONE);
                    companyWebsite_tv.setVisibility(View.GONE);
                    companyAddress_tv.setVisibility(View.GONE);

                } else {
                    companyName_tv.setVisibility(View.VISIBLE);
                    companyName_tv.setText(mJob.getCompanyName());
                }

            }

            // PRACTICE CONTACT INFO.
            if (mJob.getContactName() != null && !mJob.getContactName().isEmpty()) {

                if (companyName.equalsIgnoreCase(Constants.ANONYMOUS)) {
                    primaryContact_tv.setVisibility(View.GONE);
                } else {
                    primaryContact_tv.setVisibility(View.VISIBLE);
                    primaryContact_tv.setText(mJob.getContactName());
                }

                if (mJob.getContactName().equalsIgnoreCase(Constants.ANONYMOUS)) {
                    primaryContact_tv.setText(getString(R.string.anonymous));
                    companyPhone_tv.setVisibility(View.GONE);
                    companyEmail_tv.setVisibility(View.GONE);
                }
            }

            // LOCATION ADDRESS.
            companyAddress_tv.setText(mJob.getAddress1());
            companyCityStateZip.setText(mJob.getCity() + ", " + mJob.getState() + ", " + mJob.getZipCode());

            // PHONE NUMBER.
            if (companyName.equalsIgnoreCase(Constants.ANONYMOUS)) {
                companyPhone_tv.setVisibility(View.GONE);
            } else {
                companyPhone_tv.setVisibility(View.VISIBLE);
                companyPhone_tv.setText(mJob.getCompanyPhoneNumber());
            }

            // EMAIL ADDRESS.
            if (companyName.equalsIgnoreCase(Constants.ANONYMOUS)) {
                companyEmail_tv.setVisibility(View.GONE);
            } else {
                companyEmail_tv.setVisibility(View.VISIBLE);
                companyEmail = mJob.getCompanyEmail();
                if (companyEmail != null && !companyEmail.isEmpty()) {
                    companyEmail_tv.setText(Html.fromHtml("<u>" + companyEmail + "</u>"));
                }
            }

            // COMPANY LOGO.
            if (mJob.getCompanyLogo() != null) {
                ImageLoader.getInstance().displayImage(mJob.getCompanyLogo(), companyLogo_iv, Utility.getDisplayOptions());
            } else {
                companyLogo_iv.setImageResource(R.drawable.images);
            }

            jobDescription_tv.setText(mJob.getJobDescription());
            experience_tv.setText(mJob.getYearsOfExperience());

            String skills = mJob.getSkills();
            if (skills != null)
                skills = skills.replace(",", ", ");
            else
                skills = "-";
            additionalSkills_tv.setText(skills);

            if (mJob.getLanguages() != null && !mJob.getLanguages().isEmpty()) {
                languages_tv.setText(mJob.getLanguages());
            } else {
                languages_tv.setText("-");
            }

            String practiceManagementsystem = mJob.getPracticeManagementSystem();
            if (practiceManagementsystem != null)
                practiceManagementsystem = practiceManagementsystem.replace(",", ", ");
            else
                practiceManagementsystem = "-";

            practiceManagementSystem_tv.setText(practiceManagementsystem);
            jobType_tv.setText(mJob.getJobType());

            if (!mJob.getJobType().equalsIgnoreCase(Constants.FULL_TIME)) {
                if (mJob.getShifts() != null && mJob.getShifts().length != 0) {
                    mShifts = mJob.getShifts();
                    String morning = "", afternoon = "", evening = "";

                    for (WeekdayInfo mShift : mShifts) {
                        if (mShift.getShiftID() == 1) morningDays = mShift.getDays();
                        else if (mShift.getShiftID() == 2) afternoonDays = mShift.getDays();
                        else if (mShift.getShiftID() == 3) eveningdays = mShift.getDays();
                    }

                    if (morningDays != null) {
                        for (String day : morningDays) {
                            morning += day + ", ";
                            Log.d(TAG, "onCreateView: morning " + morning);
                        }

                        morningShift_tv.setText(getString(R.string.morning_shift_label, morning.substring(0, morning.length() - 2)));
                    } else {
                        morningShift_tv.setVisibility(View.GONE);
                    }

                    if (afternoonDays != null) {
                        for (String day : afternoonDays) {
                            afternoon += day + ", ";
                            Log.d(TAG, "onCreateView: afternoon " + afternoon);
                        }
                        afternoonShift_tv.setText(getString(R.string.afternoon_shift_label, afternoon.substring(0, afternoon.length() - 2)));
                    } else {
                        afternoonShift_tv.setVisibility(View.GONE);
                    }

                    if (eveningdays != null) {
                        for (String day : eveningdays) {
                            evening += day + ", ";
                            Log.d(TAG, "onCreateViw: evening" + evening);
                        }
                        eveningShift_tv.setText(getString(R.string.evening_shift_label, evening.substring(0, evening.length() - 2)));
                    } else {
                        eveningShift_tv.setVisibility(View.GONE);
                    }
                }
            }


            compensationType_tv.setText(mJob.getCompensations());

            String formattedString;
            if (mJob.getFromcompensationAmount() == null && mJob.getTocompensationAmount() == null) {
                formattedString = "Not Specified - (Not Specified)";
            } else if (mJob.getFromcompensationAmount() == null && mJob.getTocompensationAmount() != null) {
                formattedString = "Not Specified - $" + mJob.getTocompensationAmount().equals("null");
            } else if (mJob.getFromcompensationAmount() != null && mJob.getTocompensationAmount() == null) {
                formattedString = "$" + mJob.getFromcompensationAmount().equals("null") + " - (Not Specified)";
            } else {
                formattedString = "$" + mJob.getFromcompensationAmount() + "-$" + mJob.getTocompensationAmount();
            }

            compensationAmount_tv.setText(formattedString);
        }

        return view;
    }

    public void onButtonPressed(Uri uri) {
        if (mListener != null) {
            mListener.onFragmentInteraction(uri);
        }
    }

    @OnClick(R.id.company_phoneno)
    void onCallClick() {
        if (ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.CALL_PHONE) == PackageManager.PERMISSION_GRANTED) {
            callCompany();
        } else {
            ActivityCompat.requestPermissions(getActivity(), new String[]{Manifest.permission.CALL_PHONE}, CALL_PERMISSION_REQUEST);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == CALL_PERMISSION_REQUEST) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                callCompany();
            }
        }
    }

    private void callCompany() {
        Intent callIntent = new Intent(Intent.ACTION_CALL);
        callIntent.setData(Uri.parse("tel:" + mJob.getCompanyPhoneNumber().trim()));
        startActivity(callIntent);
    }

    @OnClick(R.id.company_website)
    void onWebsiteClick() {
        try {
            Intent browserIntent = new Intent(Intent.ACTION_VIEW);
            browserIntent.setData(Uri.parse(url));
            startActivity(browserIntent);
        } catch (ActivityNotFoundException e) {
            Log.e(TAG, "onWebsiteClick: " + e.getMessage());
        }
    }

    @OnClick(R.id.company_email)
    void onEmailClick() {
        if (companyEmail != null) {
            Intent intent = new Intent(Intent.ACTION_SENDTO, Uri.parse("mailto:" + companyEmail));
            if (intent.resolveActivity(getActivity().getPackageManager()) != null) {
                startActivity(intent);
            }
        }
    }

    @OnClick(R.id.apply_now)
    void onApplyNowClick() {
        final JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty(Constants.JOB_ID_KEY, mJobId);
        jsonObject.addProperty(Constants.AUTH_TOKEN_KEY, PreferencesData.getString(getContext(), Constants.AUTHORIZATION_KEY, ""));

        DialogUtility.showDialogWithTwoButtons(getActivity(), Constants.APP_NAME, getString(R.string.apply_job_confirmation), jsonObject);
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof OnJobDetailInfoFragmentListener) {
            mListener = (OnJobDetailInfoFragmentListener) context;
        } else {
            throw new RuntimeException(context.toString()
                    + " must implement OnJobDetailInfoFragmentListener");
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    /**
     * This interface must be implemented by activities that contain this
     * fragment to allow an interaction in this fragment to be communicated
     * to the activity and potentially other fragments contained in that
     * activity.
     * <p/>
     * See the Android Training lesson <a href=
     * "http://developer.android.com/training/basics/fragments/communicating.html"
     * >Communicating with Other Fragments</a> for more information.
     */
    public interface OnJobDetailInfoFragmentListener {
        // TODO: Update argument type and name
        void onFragmentInteraction(Uri uri);
    }
}
