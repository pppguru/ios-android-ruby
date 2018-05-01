package com.rapidbizapps.swissmonkey.jobs;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.nostra13.universalimageloader.core.ImageLoader;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.fragments.EnlargedImageDialog;
import com.rapidbizapps.swissmonkey.models.Job;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.ExpandableHeightGridView;

import java.net.MalformedURLException;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnItemClick;


public class PracticeInfoFragment extends Fragment {
    private static final String LOG_TAG = "PracticeInfoFragment";
    Job mJob;
    @BindView(R.id.practice_established)
    TextView practiceEstablished_tv;

    @BindView(R.id.practice_management_system)
    TextView practiceManagement_tv;

    @BindView(R.id.digital_x_rays)
    TextView digitalXRays_tv;

    @BindView(R.id.number_of_doctors)
    TextView totalNUmberOfDoctors_tv;

    @BindView(R.id.number_of_operatories)
    TextView totalNumberOfOperatories;

    @BindView(R.id.length_of_appointment)
    TextView lengthOfAppointment_tv;

    @BindView(R.id.benefits)
    TextView benefits_tv;

    @BindView(R.id.practice_description)
    TextView practiceDescription_tv;

    @BindView(R.id.photos_grid)
    ExpandableHeightGridView practicePhotos_gv;

    @BindView(R.id.video_link)
    ImageView videoLink_iv;

    @BindView(R.id.video_label)
    TextView videoLabel_tv;

    @BindView(R.id.phots_not_avaialable_label)
    TextView photos_not_avaialable_label;

    @BindView(R.id.videos_not_avaialable_label)
    TextView videos_not_avaialable_label;

    @BindView(R.id.practice_info_frag_content_after_about_the_practice_ll)
    LinearLayout llContentAfterAboutThePractice;

    String[] mPracticePhotos;

    private onPracticeInfoFragmentListener mListener;
    private String videoID;
    private boolean youtubeLink;

    SimpleDateFormat originalFormat = new SimpleDateFormat("yyyy-mm-dd");
    SimpleDateFormat targetFormat = new SimpleDateFormat("mm-dd-yyyy");

    public PracticeInfoFragment() {
        // Required empty public constructor
    }

    Activity actv;

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        actv = activity;
    }

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment PracticeInfoFragment.
     */
    // TODO: Rename and change types and number of parameters
    public static PracticeInfoFragment newInstance(Job job) {
        PracticeInfoFragment fragment = new PracticeInfoFragment();
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
                mPracticePhotos = mJob.getPracticePhotos();
            }
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_practice_info, container, false);
        ButterKnife.bind(this, view);

        if (mJob != null) {

            // If the Company Name/Practice Info. is ANONYMOUS, then we hide: Practice Description,
            // Photos, and Videos.
            if (mJob.getCompanyName().equalsIgnoreCase(Constants.ANONYMOUS)) {
                llContentAfterAboutThePractice.setVisibility(View.GONE);
            } else {
                llContentAfterAboutThePractice.setVisibility(View.VISIBLE);
            }

            if (mJob.getCompanyEstablished() != null) {


                Date date = null;
                try {

                    date = originalFormat.parse(mJob.getCompanyEstablished());
                    String formattedDate = targetFormat.format(date);

                    practiceEstablished_tv.setText(formattedDate);

                } catch (ParseException e) {
                    e.printStackTrace();
                }

            } else
                practiceEstablished_tv.setText("-");

            String practiceManagementsystem = mJob.getCompanyPracticeManagementSystem();
            if (practiceManagementsystem != null)
                practiceManagementsystem = practiceManagementsystem.replace(",", ", ");
            else
                practiceManagementsystem = "-";

            practiceManagement_tv.setText(practiceManagementsystem);
            digitalXRays_tv.setText(mJob.getDigitalXRay());

            totalNUmberOfDoctors_tv.setText(mJob.getTotalNumberOfDoctors());

            if (mJob.getTotalNumberOfOperatories() != null) {
                totalNumberOfOperatories.setText(mJob.getTotalNumberOfOperatories());
            } else {
                totalNumberOfOperatories.setText("-");
            }

            lengthOfAppointment_tv.setText(mJob.getLengthOfAppointment());

            String benefits = mJob.getBenefits();
            if (benefits != null)
                benefits = benefits.replace(",", ", ");
            else
                benefits = "-";

            benefits_tv.setText(benefits);

            if (mJob.getAboutYourCompany() != null)
                practiceDescription_tv.setText(mJob.getAboutYourCompany());

            if (mPracticePhotos.length > 0) {
                ImageAdapter imageAdapter = new ImageAdapter(actv, mPracticePhotos);
                practicePhotos_gv.setExpanded(true);
                practicePhotos_gv.setAdapter(imageAdapter);
                practicePhotos_gv.setVisibility(View.VISIBLE);
            } else {
                photos_not_avaialable_label.setVisibility(View.GONE);
            }

            Log.d(LOG_TAG, "length " + mPracticePhotos.length);
            Log.d(LOG_TAG, "video link: " + mJob.getVideoLink());

            if (mJob.getVideoLink() == null) {
                videoLink_iv.setVisibility(View.GONE);
                videos_not_avaialable_label.setVisibility(View.VISIBLE);
            } else {
                extractVideoId();
            }
        }

        return view;
    }

    private void extractVideoId() {
        try {
            URL url = new URL(mJob.getVideoLink());
            if (url.getHost().equalsIgnoreCase("www.youtube.com")) {
                String query = url.getQuery();
                if (query != null) {
                    String[] queries = query.split("&");
                    videoID = queries[0].substring(2);
                    Log.d(LOG_TAG, "extractVideoId: " + queries[0]);

                    String videoThumbnail = "http://img.youtube.com/vi/" + videoID + "/0.jpg";
                    youtubeLink = true;
                    ImageLoader.getInstance().displayImage(videoThumbnail, videoLink_iv);
                }
            } else {
                videoLink_iv.setBackgroundResource(R.drawable.invalid_video_link);
                youtubeLink = false;
            }

        } catch (MalformedURLException e) {
            Log.e(LOG_TAG, "extractVideoId: " + e.getMessage());
        }
    }

    @OnClick(R.id.video_link)
    void onVideoImageClick() {
        Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(mJob.getVideoLink()));
        startActivity(intent);
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof onPracticeInfoFragmentListener) {
            mListener = (onPracticeInfoFragmentListener) context;
        } else {
            throw new RuntimeException(context.toString() + " must implement OnJobDetailInfoFragmentListener");
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    @OnItemClick(R.id.photos_grid)
    void onPhotoClicked(AdapterView<?> parent, View view, int position, long id) {
        Intent intent = new Intent(actv, EnlargedImageDialog.class);
        intent.putExtra("imageUrl", mPracticePhotos[position]);
        startActivity(intent);
    }

    public interface onPracticeInfoFragmentListener {
        // TODO: Update argument type and name
        void onFragmentInteraction(Uri uri);
    }
}
