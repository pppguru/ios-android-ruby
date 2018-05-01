package com.rapidbizapps.swissmonkey.profile;


import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.content.FileProvider;
import android.support.v7.app.AlertDialog;
import android.text.Editable;
import android.text.InputFilter;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextWatcher;
import android.text.method.LinkMovementMethod;
import android.text.style.ClickableSpan;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.rapidbizapps.swissmonkey.HomeActivity;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.Services.DataHelper;
import com.rapidbizapps.swissmonkey.Services.ProfileHelper;
import com.rapidbizapps.swissmonkey.Services.RetroHelper;
import com.rapidbizapps.swissmonkey.fragments.EnlargedImageDialog;
import com.rapidbizapps.swissmonkey.models.CompensationRange;
import com.rapidbizapps.swissmonkey.models.Profile;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.DialogUtility;
import com.rapidbizapps.swissmonkey.utility.DropdownAdapter;
import com.rapidbizapps.swissmonkey.utility.FirstLetterCapFilter;
import com.rapidbizapps.swissmonkey.utility.PreferencesData;
import com.rapidbizapps.swissmonkey.utility.Utility;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.BindViews;
import butterknife.ButterKnife;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;
import butterknife.OnTextChanged;
import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;
import retrofit.mime.MultipartTypedOutput;
import retrofit.mime.TypedFile;
import retrofit.mime.TypedString;


public class ProfileFragment4 extends Fragment {

    private static final String TAG = "ProfileFragment4";
    private static final String LOG_TAG = "ProfileFragment4";
    private static final int RESUME_PERMISSION_REQUEST_CODE = 2016;
    private static final int LoR_PERMISSION_REQUEST_CODE = 6102;

    String imgDecodableString;

    private static final int RESUME_PICK_REQUEST = 432;
    private static final int RESUME_CAPTURE_REQUEST = 234;

    private static final int LOR_PICK_REQUEST = 132;
    private static final int LOR_CAPTURE_REQUEST = 231;

    private static final int IMAGE_TYPE = 786;

    DialogInterface.OnClickListener resumesListener, lorsListener;

    ImageView resumePhoto1, resumePhoto2, resumePhoto3, resumePhoto4, resumePhoto5,
            recommPhoto1, recommPhoto2;

    ImageButton deleteResume1_ib, deleteResume2_ib, deleteResume3_ib, deleteResume4_ib, deleteResume5_ib,
            deleteLoR1, deleteLoR2;


    String[] lorUrls = new String[2];
    String[] resumeUrls = new String[5];

    Uri photoURI = null;

    List<ImageView> resumePhotos_iv, recommPhotos_iv;

    @BindView(R.id.et_expectedSalaryMin)
    EditText et_expectedSalaryMin;

    @BindView(R.id.et_expectedSalaryMax)
    EditText et_expectedSalaryMax;

    @BindView(R.id.profile_resumes_label)
    TextView resumesLabel_tv;

    @BindView(R.id.resume_photos_group_1)
    LinearLayout resumePhotosRow_ll;

    @BindView(R.id.resume_photos_group_2)
    LinearLayout resumePhotosRow2_ll;


    @BindView(R.id.resume_layout_1)
    RelativeLayout resumeLayout1;

    @BindView(R.id.resume_layout_2)
    RelativeLayout resumeLayout2;

    @BindView(R.id.resume_layout_3)
    RelativeLayout resumeLayout3;

    @BindView(R.id.resume_layout_4)
    RelativeLayout resumeLayout4;

    @BindView(R.id.resume_layout_5)
    RelativeLayout resumeLayout5;


    @BindViews({R.id.resume_layout_1, R.id.resume_layout_2, R.id.resume_layout_3, R.id.resume_layout_4, R.id.resume_layout_5})
    List<RelativeLayout> profileResumeLayout_iv;

    @BindView(R.id.lor_layout_1)
    RelativeLayout lorLayout1;

    @BindView(R.id.lor_layout_2)
    RelativeLayout lorLayout2;

    @BindViews({R.id.lor_layout_1, R.id.lor_layout_2})
    List<RelativeLayout> profileRecommendLayout_iv;

    @BindView(R.id.tv_uploadRecommendationLetter)
    TextView tv_uploadRecommendationLetter;

    @BindView(R.id.profile_recommendation_letters_label)
    TextView recommendationLettersLabel_tv;

    @BindView(R.id.recommendation_photos_group)
    LinearLayout lors_ll;

    String mAuthToken;
    AlertDialog mAlertDialog;

    @BindView(R.id.et_compensation_preferences)
    EditText et_compensation_preferences;

    //prof 4
    @BindView(R.id.et_otherRequirements)
    EditText otherReqs_et;

    @BindView(R.id.tandc_cb)
    CheckBox tAndC_cb;

    @BindView(R.id.show_terms_and_conditions)
    TextView showTermsAndConditions_tv;

    private int compensationId = -1;
    private HomeActivity mActivity;


    int mRecommendSize;

    int mResumesSize;
    private InputFilter[] mFilters;

    public ProfileFragment4() {
        // Required empty public constructor
    }

    public static ProfileFragment4 newInstance() {
        ProfileFragment4 fragment = new ProfileFragment4();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mAuthToken = PreferencesData.getString(mActivity, Constants.AUTHORIZATION_KEY, "");
        mFilters = new InputFilter[]{new FirstLetterCapFilter()};

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_profile_4, container, false);
        ButterKnife.bind(this, view);

        et_compensation_preferences.setKeyListener(null);
        et_compensation_preferences.setFocusable(false);

        String terms = "I agree to the terms of service of Swiss Monkey.";
        String link = "terms of service";
        SpannableString spannableString = new SpannableString(terms);
        ClickableSpan clickableSpan = new ClickableSpan() {
            @Override
            public void onClick(View widget) {
                DialogUtility.showTermsAndConditionsDialog(getActivity(), false, tAndC_cb);
            }

        };
        spannableString.setSpan(clickableSpan, terms.indexOf(link), terms.indexOf(link) + link.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        showTermsAndConditions_tv.setText(spannableString);
        showTermsAndConditions_tv.setMovementMethod(LinkMovementMethod.getInstance());
        showTermsAndConditions_tv.setHighlightColor(Color.TRANSPARENT);

        et_expectedSalaryMin.addTextChangedListener(new TextWatcher() {
            int len = 0;

            @Override
            public void afterTextChanged(Editable s) {
                String str = et_expectedSalaryMin.getText().toString();
                if (str.length() == 1 && len < str.length()) {//len check for backspace
                    et_expectedSalaryMin.setText(str);
                    et_expectedSalaryMin.setSelection(1);
                } else if (str.length() == 1 && len > str.length()) {
                    et_expectedSalaryMin.setText("");
                }else if(str.length() == 0) {
                    mActivity.salaryMin = "";
                    et_expectedSalaryMin.setText("$");
                }
                else {
                    mActivity.salaryMin = et_expectedSalaryMin.getText().toString().trim();
                }
            }

            @Override
            public void beforeTextChanged(CharSequence arg0, int arg1, int arg2, int arg3) {

                String str = et_expectedSalaryMin.getText().toString();
                len = str.length();
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
            }


        });

        et_expectedSalaryMax.addTextChangedListener(new TextWatcher() {


            int len = 0;

            @Override
            public void afterTextChanged(Editable s) {
                String str = et_expectedSalaryMax.getText().toString();
                if (str.length() == 1 && len < str.length()) {//len check for backspace
                    et_expectedSalaryMax.setText(str);
                    et_expectedSalaryMax.setSelection(1);
                } 
                else if (str.length() == 1 && len > str.length()) {
                    et_expectedSalaryMax.setText("");
                }
                else if(str.length() == 0) {
                    mActivity.salaryMax = "";
                    et_expectedSalaryMax.setText("$");
                }
                else {
                    mActivity.salaryMax = et_expectedSalaryMax.getText().toString().trim();
                }
//                Log.d(TAG, "afterTextChanged: ");
            }

            @Override
            public void beforeTextChanged(CharSequence arg0, int arg1, int arg2, int arg3) {

                String str = et_expectedSalaryMax.getText().toString();
                len = str.length();
//                Log.d(TAG, "beforeTextChanged: ");
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

        });

        // Showing cursor when user clicks on the edittext window
        et_expectedSalaryMax.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                et_expectedSalaryMax.setCursorVisible(true);
            }
        });

        et_expectedSalaryMax.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                et_expectedSalaryMax.setCursorVisible(true);
                return false;
            }
        });

        et_expectedSalaryMin.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                et_expectedSalaryMin.setCursorVisible(true);
                return false;
            }
        });

//        reset previously stored values
        mActivity.salaryMax = "";
        mActivity.salaryMin = "";
        setupMediaViews();
        try {
            setupData();
        } catch (Exception e) {
            e.printStackTrace();
        }

        setupDialogListeners();

        return view;
    }

    private void setupMediaViews() {
        resumePhoto1 = (ImageView) resumeLayout1.findViewById(R.id.profile_image);
        deleteResume1_ib = (ImageButton) resumeLayout1.findViewById(R.id.delete_image_button);
        deleteResume1_ib.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                deleteFile(0, ProfileHelper.getInstance().getmResumesArray()[0], Constants.RESUME_FILE_TYPE_KEY);
            }
        });

        resumePhoto1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(mActivity, EnlargedImageDialog.class);
                intent.putExtra("imageUrl", ProfileHelper.getInstance().getmModifiedResumeUrls()[0]);
                startActivity(intent);
            }
        });

        resumePhoto2 = (ImageView) resumeLayout2.findViewById(R.id.profile_image);
        deleteResume2_ib = (ImageButton) resumeLayout2.findViewById(R.id.delete_image_button);
        deleteResume2_ib.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                deleteFile(1, ProfileHelper.getInstance().getmResumesArray()[1], Constants.RESUME_FILE_TYPE_KEY);
            }
        });

        resumePhoto2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(mActivity, EnlargedImageDialog.class);
                intent.putExtra("imageUrl", ProfileHelper.getInstance().getmModifiedResumeUrls()[1]);
                startActivity(intent);
            }
        });

        resumePhoto3 = (ImageView) resumeLayout3.findViewById(R.id.profile_image);
        deleteResume3_ib = (ImageButton) resumeLayout3.findViewById(R.id.delete_image_button);
        deleteResume3_ib.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                deleteFile(2, ProfileHelper.getInstance().getmResumesArray()[2], Constants.RESUME_FILE_TYPE_KEY);
            }
        });

        resumePhoto3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(mActivity, EnlargedImageDialog.class);
                intent.putExtra("imageUrl", ProfileHelper.getInstance().getmModifiedResumeUrls()[2]);
                startActivity(intent);
            }
        });

        resumePhoto4 = (ImageView) resumeLayout4.findViewById(R.id.profile_image);
        deleteResume4_ib = (ImageButton) resumeLayout4.findViewById(R.id.delete_image_button);
        deleteResume4_ib.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                deleteFile(3, ProfileHelper.getInstance().getmResumesArray()[3], Constants.RESUME_FILE_TYPE_KEY);
            }
        });
        resumePhoto4.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(mActivity, EnlargedImageDialog.class);
                intent.putExtra("imageUrl", ProfileHelper.getInstance().getmModifiedResumeUrls()[3]);
                startActivity(intent);
            }
        });


        resumePhoto5 = (ImageView) resumeLayout5.findViewById(R.id.profile_image);
        deleteResume5_ib = (ImageButton) resumeLayout5.findViewById(R.id.delete_image_button);
        deleteResume5_ib.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                deleteFile(4, ProfileHelper.getInstance().getmResumesArray()[4], Constants.RESUME_FILE_TYPE_KEY);
            }
        });

        resumePhoto5.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(mActivity, EnlargedImageDialog.class);
                intent.putExtra("imageUrl", ProfileHelper.getInstance().getmModifiedResumeUrls()[4]);
                startActivity(intent);
            }
        });


        recommPhoto1 = (ImageView) lorLayout1.findViewById(R.id.profile_image);
        deleteLoR1 = (ImageButton) lorLayout1.findViewById(R.id.delete_image_button);
        deleteLoR1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                deleteFile(0, ProfileHelper.getInstance().getmRecommendArray()[0], Constants.RECO_LETTER_FILE_TYPE_KEY);
            }
        });
        recommPhoto1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(mActivity, EnlargedImageDialog.class);
                intent.putExtra("imageUrl", ProfileHelper.getInstance().getmRecommendUrls()[0]);
                startActivity(intent);
            }
        });

        recommPhoto2 = (ImageView) lorLayout2.findViewById(R.id.profile_image);
        deleteLoR2 = (ImageButton) lorLayout2.findViewById(R.id.delete_image_button);
        deleteLoR2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                deleteFile(1, ProfileHelper.getInstance().getmRecommendArray()[1], Constants.RECO_LETTER_FILE_TYPE_KEY);
            }
        });
        recommPhoto2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(mActivity, EnlargedImageDialog.class);
                intent.putExtra("imageUrl", ProfileHelper.getInstance().getmRecommendUrls()[1]);
                startActivity(intent);
            }
        });

        resumePhotos_iv = new ArrayList<>();
        resumePhotos_iv.add(resumePhoto1);
        resumePhotos_iv.add(resumePhoto2);
        resumePhotos_iv.add(resumePhoto3);
        resumePhotos_iv.add(resumePhoto4);
        resumePhotos_iv.add(resumePhoto5);


        recommPhotos_iv = new ArrayList<>();
        recommPhotos_iv.add(recommPhoto1);
        recommPhotos_iv.add(recommPhoto2);
    }

    private void setupDialogListeners() {
        resumesListener = new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                switch (which) {
                    case 0: //album
                        Intent galleryIntent = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
                        startActivityForResult(galleryIntent, RESUME_PICK_REQUEST);

                        break;

                    case 1: //camera
                        createCameraIntent(RESUME_CAPTURE_REQUEST);
                        break;
                }
            }
        };

        lorsListener = new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                switch (which) {
                    case 0: //album
                        Intent galleryIntent = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
                        startActivityForResult(galleryIntent, LOR_PICK_REQUEST);
                        break;

                    case 1: //camera
                        createCameraIntent(LOR_CAPTURE_REQUEST);
                        break;
                }
            }
        };
    }

    private void createCameraIntent(int captureRequestCode) {
        Intent takePicture = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (Utility.createCapturedPhotoFile() != null) {
            photoURI = FileProvider.getUriForFile(mActivity, "com.rapidbizapps.swissmonkey.fileprovider", Utility.createCapturedPhotoFile());
            takePicture.putExtra(MediaStore.EXTRA_OUTPUT, photoURI);
        }
        startActivityForResult(takePicture, captureRequestCode);
    }

    private void setupData() {
        if (Profile.getInstance().getSalaryMin() != null && Profile.getInstance().getSalaryMax() != null) {
            if (Profile.getInstance().getSalaryMin().length() > 0 && Profile.getInstance().getSalaryMax().length() > 0) {
                //  Making sure old data is not still present.
                mActivity.salaryMax = Profile.getInstance().getSalaryMax();
                mActivity.salaryMin = Profile.getInstance().getSalaryMin();
                et_expectedSalaryMin.setText("$" + Profile.getInstance().getSalaryMin());
                et_expectedSalaryMax.setText("$" + Profile.getInstance().getSalaryMax());
            }
        }

        Log.d(LOG_TAG, "setupData: compensationID" + Profile.getInstance().getCompensationID());
        if (Profile.getInstance().getCompensationID() != 0) {
            CompensationRange tempCompensationRange = new CompensationRange();
            tempCompensationRange.setCompensationId(Profile.getInstance().getCompensationID());

            int index = DataHelper.getInstance().getCompensationRanges().indexOf(tempCompensationRange);
            if (index > -1) {
                et_compensation_preferences.setText(DataHelper.getInstance().getCompensationRanges().get(index).getCompensationName());
            }
        }

        otherReqs_et.setFilters(mFilters);
        otherReqs_et.setText(Utility.capitalizeFirstLetter(Profile.getInstance().getComments()));

        //for resumes
        mResumesSize = ProfileHelper.getInstance().getmResumesArray().length;
        if (Profile.getInstance().getResume_url() != null) {
            for (int i = 0; i < mResumesSize; i++) {
                if (Profile.getInstance().getResume_url().length > i && Profile.getInstance().getResume() != null) {
                    ProfileHelper.getInstance().getmResumesArray()[i] = Profile.getInstance().getResume()[i];
                    ProfileHelper.getInstance().getmModifiedResumeUrls()[i] = Profile.getInstance().getResume_url()[i];
                }
            }
            Profile.getInstance().setResume(null);
        }

        for (int i = 0; i < mResumesSize; i++) {
            String resumeURL = ProfileHelper.getInstance().getmModifiedResumeUrls()[i];
            if (resumeURL != null) {
                ImageLoader.getInstance().displayImage(resumeURL, resumePhotos_iv.get(i), Utility.getCircularDisplayOptions(50));
                resumePhotos_iv.get(i).setVisibility(View.VISIBLE);
                profileResumeLayout_iv.get(i).setVisibility(View.VISIBLE);
                resumesLabel_tv.setVisibility(View.VISIBLE);
            }
        }
        showOrHideResumesTitle();

        //for recommendations
        mRecommendSize = ProfileHelper.getInstance().getmRecommendArray().length;
        if (Profile.getInstance().getRecommendationLetters() != null && Profile.getInstance().getRecommendationLetters() != null) {
            for (int i = 0; i < mRecommendSize; i++) {
                if (Profile.getInstance().getRecommendationLetters().length > i) {
                    ProfileHelper.getInstance().getmRecommendArray()[i] = Profile.getInstance().getRecommendationLetters()[i];
                    ProfileHelper.getInstance().getmRecommendUrls()[i] = Profile.getInstance().getRecomendationLettrs_url()[i];
                }
            }
            Profile.getInstance().setRecommendationLetters(null);
        }

        for (int i = 0; i < mRecommendSize; i++) {
            String recommendUrl = ProfileHelper.getInstance().getmRecommendUrls()[i];
            if (recommendUrl != null) {
                ImageLoader.getInstance().displayImage(recommendUrl, recommPhotos_iv.get(i), Utility.getCircularDisplayOptions(50));
                recommPhotos_iv.get(i).setVisibility(View.VISIBLE);
                profileRecommendLayout_iv.get(i).setVisibility(View.VISIBLE);
                recommendationLettersLabel_tv.setVisibility(View.VISIBLE);
            }
        }
        showOrHideRecommendsTitle();

    }


    private void loadResumes(final int i) {
        if (i >= mResumesSize) {
            showOrHideResumesTitle();
            loadRecommendations(0);
            return;
        }

        if (ProfileHelper.getInstance().getmResumesArray()[i] == null) {
            loadResumes(i + 1);
            return;
        }
        JsonObject photosRequest = new JsonObject();
        photosRequest.addProperty(Constants.AUTH_TOKEN_KEY, mAuthToken);
        photosRequest.addProperty(Constants.TYPE_KEY, "resume");
        photosRequest.addProperty("file", ProfileHelper.getInstance().getmResumesArray()[i]);
        Log.d(LOG_TAG, "Resume name: " + ProfileHelper.getInstance().getmResumesArray()[i]);

        RetroHelper.getBaseClassService(mActivity, "", "").downloadFiles(photosRequest, new Callback<JsonObject>() {
            @Override
            public void success(JsonObject jsonObject, Response response) {
                Log.d(LOG_TAG, "photo success: ");
                if (jsonObject != null) {
                    JsonElement url = jsonObject.get("url");
                    ProfileHelper.getInstance().getmModifiedResumeUrls()[i] = url.getAsString();
                    ImageLoader.getInstance().displayImage(url.getAsString(), resumePhotos_iv.get(i), Utility.getCircularDisplayOptions(50));
                    resumePhotos_iv.get(i).setVisibility(View.VISIBLE);
                    profileResumeLayout_iv.get(i).setVisibility(View.VISIBLE);
                    resumesLabel_tv.setVisibility(View.VISIBLE);
                }
                loadResumes(i + 1);
            }

            @Override
            public void failure(RetrofitError error) {
                Utility.serviceCallFailureMessage(error, mActivity);
            }
        });
    }


    private void loadRecommendations(final int i) {

        if (i >= mRecommendSize) {
            showOrHideRecommendsTitle();
            return;
        }
        if (ProfileHelper.getInstance().getmRecommendArray()[i] == null) {
            loadRecommendations(i + 1);
            return;
        }
        JsonObject photosRequest = new JsonObject();
        photosRequest.addProperty(Constants.AUTH_TOKEN_KEY, mAuthToken);
        photosRequest.addProperty(Constants.TYPE_KEY, "recommendationletters");
        photosRequest.addProperty("file", ProfileHelper.getInstance().getmRecommendArray()[i]);
        Log.d(LOG_TAG, "Recommend name: " + ProfileHelper.getInstance().getmRecommendArray()[i]);

        RetroHelper.getBaseClassService(mActivity, "", "").downloadFiles(photosRequest, new Callback<JsonObject>() {
            @Override
            public void success(JsonObject jsonObject, Response response) {
                Log.d(LOG_TAG, "recommendations success: ");
                if (jsonObject != null) {
                    JsonElement url = jsonObject.get("url");
                    ProfileHelper.getInstance().getmRecommendUrls()[i] = url.getAsString();
                    ImageLoader.getInstance().displayImage(url.getAsString(), recommPhotos_iv.get(i), Utility.getCircularDisplayOptions(50));
                    recommPhotos_iv.get(i).setVisibility(View.VISIBLE);
                    profileRecommendLayout_iv.get(i).setVisibility(View.VISIBLE);
                    recommendationLettersLabel_tv.setVisibility(View.VISIBLE);
                }
                loadRecommendations(i + 1);
            }

            @Override
            public void failure(RetrofitError error) {
                Utility.serviceCallFailureMessage(error, mActivity);
            }
        });
    }


    @OnClick(R.id.et_expectedSalaryMin)
    void onSalaryClick() {
        et_expectedSalaryMin.setCursorVisible(true);
    }


    @OnClick(R.id.et_compensation_preferences)
    void onJobTypeClick() {
        ArrayAdapter<CompensationRange> spinnerAdapter = new DropdownAdapter<>(mActivity,
                android.R.layout.simple_list_item_1, DataHelper.getInstance().getCompensationRanges());
        spinnerAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        mAlertDialog = new AlertDialog.Builder(mActivity)
                .setAdapter(spinnerAdapter, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        CompensationRange compensationRange = DataHelper.getInstance().getCompensationRanges().get(which);
                        et_compensation_preferences.setText(compensationRange.toString());
                        compensationId = compensationRange.getCompensationId();
                        ProfileHelper.getInstance().setCompensationId(compensationId);
                        dialog.dismiss();
                    }
                })
                .create();

        mAlertDialog.show();

        Utility.setupSpinnerView(mActivity, mAlertDialog);
        //   return true;
    }

    @OnClick(R.id.tv_uploadResume)
    void onUploadResumeClick() {
        // TODO: 30-06-2016 change this condition
        int firstRowCount = resumePhotosRow_ll.getChildCount();
        int secondRowCount = resumePhotosRow2_ll.getChildCount();
        int visibilityCount = 0;
        for (int i = 0; i < firstRowCount; i++) {
            if (resumePhotosRow_ll.getChildAt(i).getVisibility() == View.VISIBLE) {
                visibilityCount += 1;
            }
        }
        for (int i = 0; i < secondRowCount; i++) {
            if (resumePhotosRow2_ll.getChildAt(i).getVisibility() == View.VISIBLE) {
                visibilityCount += 1;
            }
        }


        if (visibilityCount >= 5) {
            DialogUtility.showDialogWithOneButton(mActivity, "Already uploaded the maximum number of resumes", "Please remove an existing resume to add a new one");
        } else {
            if (ActivityCompat.checkSelfPermission(mActivity, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
                Log.d(LOG_TAG, "onUploadResumeClick: permission already granted");
                Utility.createDialog(mActivity, resumesListener);
            } else {
                Log.d(LOG_TAG, "onUploadResumeClick: requesting permission");
                requestPermissions(new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.CAMERA}, RESUME_PERMISSION_REQUEST_CODE);
            }
        }
    }

    @OnCheckedChanged(R.id.tandc_cb)
    void onAgreeToTerms(CompoundButton compoundButton, boolean checked) {
        ProfileHelper.getInstance().setAgreeToTerms(checked);
    }

    @OnClick(R.id.tv_uploadRecommendationLetter)
    void onUploadRecommendationLetters() {
        // TODO: 30-06-2016 change this condition
        int childCount = lors_ll.getChildCount();
        int visibilityCount = 0;
        for (int i = 0; i < childCount; i++) {
            if (lors_ll.getChildAt(i).getVisibility() == View.VISIBLE) {
                visibilityCount += 1;
            }
        }
        if (visibilityCount >= 2) {
            DialogUtility.showDialogWithOneButton(mActivity, "Already uploaded the maximum number of letters of recommendation", "Please remove an existing letter to add a new one");
        } else {
            if (ActivityCompat.checkSelfPermission(mActivity, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
                Log.d(LOG_TAG, "onUploadRecommendationClick: permission already granted");
                Utility.createDialog(mActivity, lorsListener);
            } else {
                Log.d(LOG_TAG, "onUploadRecommendationClick: requesting permission");
                requestPermissions(new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.CAMERA}, LoR_PERMISSION_REQUEST_CODE);
            }
        }
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        // To pick image for Resume
        if (requestCode == RESUME_PICK_REQUEST && resultCode == FragmentActivity.RESULT_OK && null != data) {
            Log.d(LOG_TAG, "onActivityResult: resume pick");
            Uri selectedImage = data.getData();
            String[] filePathColumn = {MediaStore.Images.Media.DATA};
            Cursor cursor = mActivity.getContentResolver().query(selectedImage, filePathColumn, null, null, null);
            cursor.moveToFirst();

            int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
            imgDecodableString = cursor.getString(columnIndex);
            cursor.close();
            if (imgDecodableString != null) {
                Bitmap bitmap, rotatedBitmap;
                try {
                    bitmap = Utility.decodeUri(mActivity, selectedImage);
                    rotatedBitmap = Utility.rotateImage(imgDecodableString, bitmap, false);
                    setResumes(rotatedBitmap, Utility.getFile(rotatedBitmap, IMAGE_TYPE));

                } catch (FileNotFoundException e) {
                    Log.e(LOG_TAG, "onActivityResult: " + e.getMessage());
                }
            } else {
                Toast.makeText(mActivity, "Image not found", Toast.LENGTH_LONG).show();
            }
        }
        if (requestCode == RESUME_CAPTURE_REQUEST && resultCode == FragmentActivity.RESULT_OK) {
            Log.d(LOG_TAG, "onActivityResult: resume capture");
            Bitmap bitmap, rotatedBitmap;

            try {
                Log.d(LOG_TAG, "onActivityResult: photo URI" + photoURI);
                bitmap = Utility.decodeUri(mActivity, photoURI);
                rotatedBitmap = Utility.rotateImage(photoURI.toString(), bitmap, true);
                setResumes(rotatedBitmap, Utility.getFile(rotatedBitmap, IMAGE_TYPE));
            } catch (FileNotFoundException e) {
                e.printStackTrace();
                Log.e(LOG_TAG, "onActivityResult: " + e.getLocalizedMessage());
            }
        }

        //to pick image for recommendation letter
        if (requestCode == LOR_PICK_REQUEST && resultCode == FragmentActivity.RESULT_OK && null != data) {
            Log.d(LOG_TAG, "onActivityResult: lor pick");
            Uri selectedImage = data.getData();
            String[] filePathColumn = {MediaStore.Images.Media.DATA};
            Cursor cursor = mActivity.getContentResolver().query(selectedImage, filePathColumn, null, null, null);
            cursor.moveToFirst();

            int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
            imgDecodableString = cursor.getString(columnIndex);
            cursor.close();
            if (imgDecodableString != null) {
                Bitmap bitmap, rotatedBitmap;
                try {
                    bitmap = Utility.decodeUri(mActivity, selectedImage);
                    rotatedBitmap = Utility.rotateImage(imgDecodableString, bitmap, false);
                    setLettersOfRecommendation(rotatedBitmap, Utility.getFile(rotatedBitmap, IMAGE_TYPE));
                } catch (FileNotFoundException e) {
                    Log.e(LOG_TAG, "onActivityResult: " + e.getMessage());
                }
            } else {
                Toast.makeText(mActivity, "Image not found", Toast.LENGTH_LONG).show();
            }
        }
        //to capture letter
        if (requestCode == LOR_CAPTURE_REQUEST && resultCode == FragmentActivity.RESULT_OK) {
            Log.d(LOG_TAG, "onActivityResult: lor capture");
            Bitmap bitmap, rotatedBitmap;

            try {
                Log.d(LOG_TAG, "onActivityResult: photo URI" + photoURI);
                bitmap = Utility.decodeUri(mActivity, photoURI);
                rotatedBitmap = Utility.rotateImage(photoURI.toString(), bitmap, true);
                setLettersOfRecommendation(rotatedBitmap, Utility.getFile(rotatedBitmap, IMAGE_TYPE));
            } catch (FileNotFoundException e) {
                e.printStackTrace();
                Log.e(LOG_TAG, "onActivityResult: " + e.getLocalizedMessage());
            }
        }

    }

    private void setResumes(Bitmap bmp, File file) {
        if (resumeLayout1.getVisibility() == View.GONE) {
            resumeLayout1.setVisibility(View.VISIBLE);
            resumePhoto1.setImageBitmap(bmp);
            saveResumeToServer(file, 0);
        } else if (resumeLayout2.getVisibility() == View.GONE) {
            resumeLayout2.setVisibility(View.VISIBLE);
            resumePhoto2.setImageBitmap(bmp);
            saveResumeToServer(file, 1);
        } else if (resumeLayout3.getVisibility() == View.GONE) {
            resumeLayout3.setVisibility(View.VISIBLE);
            resumePhoto3.setImageBitmap(bmp);
            saveResumeToServer(file, 2);
        } else if (resumeLayout4.getVisibility() == View.GONE) {
            resumeLayout4.setVisibility(View.VISIBLE);
            resumePhoto4.setImageBitmap(bmp);
            saveResumeToServer(file, 3);
        } else if (resumeLayout5.getVisibility() == View.GONE) {
            resumeLayout5.setVisibility(View.VISIBLE);
            resumePhoto5.setImageBitmap(bmp);
            saveResumeToServer(file, 4);
        }
    }

    private void setLettersOfRecommendation(Bitmap bitmap, File file) {
        if (lorLayout1.getVisibility() == View.GONE) {
            lorLayout1.setVisibility(View.VISIBLE);
            recommPhoto1.setImageBitmap(bitmap);
            saveLoRsToServer(file, 0);

        } else if (lorLayout2.getVisibility() == View.GONE) {
            lorLayout2.setVisibility(View.VISIBLE);
            recommPhoto2.setImageBitmap(bitmap);
            saveLoRsToServer(file, 1);
        }
    }


    private void deleteFile(final int index, final String fileName, final String type) {
        if (Utility.isConnectingToInternet(mActivity)) {
            new AlertDialog.Builder(mActivity)
                    .setTitle(Constants.APP_NAME)
                    .setMessage("Are you sure you want to delete this file?")
                    .setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            Utility.showProgressDialog(mActivity);
                            JsonObject requestBody = new JsonObject();
                            requestBody.addProperty(Constants.AUTH_TOKEN_KEY, mAuthToken);
                            requestBody.addProperty(Constants.TYPE_KEY, type);
                            requestBody.addProperty(Constants.FILE_KEY, fileName);
                            RetroHelper.getBaseClassService(mActivity, "", "").deleteFiles(requestBody, new Callback<JsonObject>() {
                                @Override
                                public void success(JsonObject jsonObject, Response response) {
                                    Utility.dismissDialog();
                                    if (type.equals(Constants.RESUME_FILE_TYPE_KEY)) {
                                        PreferencesData.saveBoolean(mActivity, Constants.CAN_ADD_RESUMES, true);
                                        ProfileHelper.getInstance().getmResumesArray()[index] = null;
                                        ProfileHelper.getInstance().getmModifiedResumeUrls()[index] = null;
                                        showOrHideResumesTitle();
                                        switch (index) {
                                            case 0:
                                                resumeLayout1.setVisibility(View.GONE);
                                                break;
                                            case 1:
                                                resumeLayout2.setVisibility(View.GONE);
                                                break;
                                            case 3:
                                                resumeLayout3.setVisibility(View.GONE);
                                                break;
                                            case 4:
                                                resumeLayout4.setVisibility(View.GONE);
                                                break;
                                            case 5:
                                                resumeLayout5.setVisibility(View.GONE);
                                                break;
                                        }
                                    } else if (type.equals(Constants.RECO_LETTER_FILE_TYPE_KEY)) {
                                        PreferencesData.saveBoolean(mActivity, Constants.CAN_ADD_LOR, true);

                                        ProfileHelper.getInstance().getmRecommendArray()[index] = null;
                                        ProfileHelper.getInstance().getmRecommendUrls()[index] = null;

                                        showOrHideRecommendsTitle();

                                        switch (index) {
                                            case 0:
                                                lorLayout1.setVisibility(View.GONE);
                                                break;
                                            case 1:
                                                lorLayout2.setVisibility(View.GONE);
                                                break;
                                        }
                                    }
                                }

                                @Override
                                public void failure(RetrofitError error) {
                                    Utility.dismissDialog();
                                    if (error != null && error.getResponse() != null && error.getResponse().getStatus() == 501) {
                                        Utility.showAppUpdateAlert(mActivity);
                                    } else {
                                        DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, "Cannot delete file. Please try later");
                                    }
                                }
                            });
                        }
                    })
                    .setNegativeButton("No", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            dialog.dismiss();
                        }
                    })
                    .show();
        } else {
            DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, mActivity.getString(R.string.cannot_delete_check_internet));
        }
    }

    /*@OnTextChanged(R.id.et_expectedSalaryMin)
    void onExpectedSalaryChange(CharSequence charSequence) {
        mActivity.salaryMin = charSequence.toString();
    }*/

    //call this to upload photos from profile
    void saveResumeToServer(final File file, final int index) {
        MultipartTypedOutput multipartTypedOutput = new MultipartTypedOutput();
        multipartTypedOutput.addPart(Constants.AUTH_TOKEN_KEY, new TypedString(mAuthToken));
        multipartTypedOutput.addPart(Constants.TYPE_KEY, new TypedString(Constants.RESUME_FILE_TYPE_KEY));
        multipartTypedOutput.addPart(Constants.KEYS_KEY, new TypedString(Constants.RESUME_FILE_TYPE_KEY));
        multipartTypedOutput.addPart(Constants.RESUME_FILE_TYPE_KEY, new TypedFile("multipart/form-data", file));


        if (Utility.isConnectingToInternet(mActivity)) {
            Utility.showProgressDialog(mActivity);
            RetroHelper.getBaseClassService(mActivity, "", "").uploadFile(multipartTypedOutput, new Callback<JsonObject>() {
                @Override
                public void success(JsonObject jsonObject, Response response) {
                    Utility.dismissDialog();
                    if (jsonObject != null) {

                        ProfileHelper.getInstance().getmResumesArray()[index] = file.getName();
                        ProfileHelper.getInstance().getmModifiedResumeUrls()[index] = file.getAbsolutePath();
                        resumesLabel_tv.setVisibility(View.VISIBLE);

                        if (ProfileHelper.getInstance().getmModifiedResumeUrls()[0] == null) {
                            resumeLayout1.setVisibility(View.GONE);
                        } else {
                            resumeLayout1.setVisibility(View.VISIBLE);
                        }
                        if (ProfileHelper.getInstance().getmModifiedResumeUrls()[1] == null) {
                            resumeLayout2.setVisibility(View.GONE);
                        } else {
                            resumeLayout2.setVisibility(View.VISIBLE);
                        }


                        if (ProfileHelper.getInstance().getmModifiedResumeUrls()[2] == null) {
                            resumeLayout3.setVisibility(View.GONE);
                        } else {
                            resumeLayout3.setVisibility(View.VISIBLE);
                        }
                        if (ProfileHelper.getInstance().getmModifiedResumeUrls()[3] == null) {
                            resumeLayout4.setVisibility(View.GONE);
                        } else {
                            resumeLayout4.setVisibility(View.VISIBLE);
                        }

                        if (ProfileHelper.getInstance().getmModifiedResumeUrls()[4] == null) {
                            resumeLayout5.setVisibility(View.GONE);
                        } else {
                            resumeLayout5.setVisibility(View.VISIBLE);
                        }

                        DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, "Uploaded Successfully");
                    }

                }

                @Override
                public void failure(RetrofitError error) {
                    Utility.dismissDialog();
                    Utility.serviceCallFailureMessage(error, mActivity);
                    //if uploading failed,no point in showing images! wrong impression to user
                    switch (index) {
                        case 0:
                            resumeLayout1.setVisibility(View.GONE);
                            break;
                        case 1:
                            resumeLayout2.setVisibility(View.GONE);
                            break;
                        case 2:
                            resumeLayout3.setVisibility(View.GONE);
                            break;
                        case 3:
                            resumeLayout4.setVisibility(View.GONE);
                            break;
                        case 4:
                            resumeLayout5.setVisibility(View.GONE);
                            break;
                    }

                }
            });
        }
    }

    //call this to upload lors from profile
    void saveLoRsToServer(final File file, final int index) {
        MultipartTypedOutput multipartTypedOutput = new MultipartTypedOutput();
        multipartTypedOutput.addPart(Constants.AUTH_TOKEN_KEY, new TypedString(mAuthToken));
        multipartTypedOutput.addPart(Constants.TYPE_KEY, new TypedString(Constants.RECO_LETTER_FILE_TYPE_KEY));
        multipartTypedOutput.addPart(Constants.KEYS_KEY, new TypedString(Constants.RECO_LETTER_FILE_TYPE_KEY));
        multipartTypedOutput.addPart(Constants.RECO_LETTER_FILE_TYPE_KEY, new TypedFile("multipart/form-data", file));


        if (Utility.isConnectingToInternet(mActivity)) {
            Utility.showProgressDialog(mActivity);
            RetroHelper.getBaseClassService(mActivity, "", "").uploadFile(multipartTypedOutput, new Callback<JsonObject>() {
                @Override
                public void success(JsonObject jsonObject, Response response) {
                    Utility.dismissDialog();
                    if (jsonObject != null) {

                        ProfileHelper.getInstance().getmRecommendArray()[index] = file.getName();
                        ProfileHelper.getInstance().getmRecommendUrls()[index] = file.getAbsolutePath();
                        recommendationLettersLabel_tv.setVisibility(View.VISIBLE);
                        if (ProfileHelper.getInstance().getmRecommendUrls()[0] == null) {
                            lorLayout1.setVisibility(View.GONE);
                        } else {
                            lorLayout1.setVisibility(View.VISIBLE);
                        }
                        if (ProfileHelper.getInstance().getmRecommendUrls()[1] == null) {
                            lorLayout2.setVisibility(View.GONE);
                        } else {
                            lorLayout2.setVisibility(View.VISIBLE);
                        }
                        DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, "Uploaded Successfully");


                    }
                }

                @Override
                public void failure(RetrofitError error) {
                    Utility.dismissDialog();

                    Utility.serviceCallFailureMessage(error, mActivity);
                    //if uploading failed,no point in showing lors! wrong impression to user
                    switch (index) {
                        case 0:
                            lorLayout1.setVisibility(View.GONE);
                            break;
                        case 1:
                            lorLayout2.setVisibility(View.GONE);
                            break;
                    }
                }
            });
        }
    }


    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == RESUME_PERMISSION_REQUEST_CODE) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Utility.createDialog(mActivity, resumesListener);
            } else {
                DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, mActivity.getString(R.string.allow_permission_photo_prompt));
            }
        }

        if (requestCode == LoR_PERMISSION_REQUEST_CODE) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Utility.createDialog(mActivity, lorsListener);
            } else {
                DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, mActivity.getString(R.string.allow_permission_photo_prompt));
            }
        }
    }


    @Override
    public void onDestroyView() {
        super.onDestroyView();
        //deleting the files in local folder while destroying fragemnt.
        deleteFiles(ProfileHelper.getInstance().getmModifiedResumeUrls());
        deleteFiles(ProfileHelper.getInstance().getmRecommendUrls());

    }

    private void deleteFiles(String[] files) {
        for (int i = 0; i < files.length; i++) {
            try {
                File f = new File(files[0]);
                if (f.exists()) {
                    f.delete();
                }
            } catch (Exception e) {

            }


        }
    }

    private void showOrHideResumesTitle() {
        boolean isShow = false;
        for (int i = 0; i < ProfileHelper.getInstance().getmResumesArray().length; i++) {
            resumesLabel_tv.setVisibility(View.GONE);
            if (ProfileHelper.getInstance().getmResumesArray()[i] != null) {
                isShow = true;
            }
        }
        if (isShow) {
            resumesLabel_tv.setVisibility(View.VISIBLE);
        }
    }

    private void showOrHideRecommendsTitle() {
        boolean isShow = false;
        for (int i = 0; i < ProfileHelper.getInstance().getmRecommendArray().length; i++) {
            recommendationLettersLabel_tv.setVisibility(View.GONE);
            if (ProfileHelper.getInstance().getmRecommendArray()[i] != null) {
                isShow = true;
            }
        }
        if (isShow) {
            recommendationLettersLabel_tv.setVisibility(View.VISIBLE);
        }
    }


    @OnTextChanged(R.id.et_otherRequirements)
    void onOtherChange(CharSequence charSequence) {
        mActivity.otherReqs = charSequence.toString();
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        mActivity = (HomeActivity) context;
    }
}
