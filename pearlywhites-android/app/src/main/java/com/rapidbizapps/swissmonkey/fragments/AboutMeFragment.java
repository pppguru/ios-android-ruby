package com.rapidbizapps.swissmonkey.fragments;


import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.text.Html;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.ImageLoader;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.Services.DataHelper;
import com.rapidbizapps.swissmonkey.Services.ProfileHelper;
import com.rapidbizapps.swissmonkey.models.Position;
import com.rapidbizapps.swissmonkey.models.Profile;
import com.rapidbizapps.swissmonkey.profile.DownloadCompleteCallback;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.DownloadFileTask;
import com.rapidbizapps.swissmonkey.utility.PreferencesData;
import com.rapidbizapps.swissmonkey.utility.Utility;

import java.io.File;
import java.util.HashMap;
import java.util.List;

import butterknife.BindView;
import butterknife.BindViews;
import butterknife.ButterKnife;
import me.grantland.widget.AutofitTextView;


/**
 * A simple {@link Fragment} subclass.
 */
public class AboutMeFragment extends Fragment {

    private static final String LOG_TAG = "AboutMeFragment";
    Profile profile;
    @BindView(R.id.iv_profile)
    ImageView profileimage;
    @BindView(R.id.tv_name)
    TextView name;
    @BindView(R.id.tv_jobprofile)
    TextView jobprofile;
    @BindView(R.id.tv_address)
    TextView address;
    @BindView(R.id.tv_email)
    AutofitTextView email;
    @BindView(R.id.tv_phoneNumber)
    TextView phoneNumber;
    @BindView(R.id.tv_noPhotos)
    TextView nophoto_label;
    @BindView(R.id.profile_detail_photos_row)
    LinearLayout photosLayout_row;
    @BindView(R.id.profile_detail_photo_1)
    ImageView photo1;
    @BindView(R.id.profile_detail_photo_2)
    ImageView photo2;
    @BindView(R.id.profile_detail_photo_3)
    ImageView photo3;
    @BindView(R.id.tv_noVideos)
    TextView noVideo_label;
    @BindView(R.id.profile_detail_videos_row)
    LinearLayout videosLayout_row;
    @BindView(R.id.profile_detail_video_1)
    ImageView video1;
    @BindView(R.id.profile_detail_video_2)
    ImageView video2;
    @BindView(R.id.profile_detail_video_3)
    ImageView video3;
    @BindView(R.id.about_resume_photos_group_1)
    LinearLayout resumePhotosRow_ll;
    @BindView(R.id.about_resume_photos_group_2)
    LinearLayout resumePhotosRow2_ll;
    @BindView(R.id.about_recommendation_photos_group)
    LinearLayout lors_ll;
    @BindView(R.id.about_profile_resumes_label)
    TextView resumesLabel_tv;
    @BindView(R.id.tv_noResume)
    TextView no_resumesLabel_tv;
    @BindView(R.id.about_resume_layout_1)
    ImageView resumeLayout1;
    @BindView(R.id.about_resume_layout_2)
    ImageView resumeLayout2;
    @BindView(R.id.about_resume_layout_3)
    ImageView resumeLayout3;
    @BindView(R.id.about_resume_layout_4)
    ImageView resumeLayout4;
    @BindView(R.id.about_resume_layout_5)
    ImageView resumeLayout5;
    @BindView(R.id.about_profile_recommendation_letters_label)
    TextView recommendationLettersLabel_tv;
    @BindView(R.id.tv_bioDescription)
    TextView bioDescription_tv;
    @BindView(R.id.tv_noRecommend)
    TextView no_recommend_tv;
    @BindView(R.id.about_frag_lor_layout_1)
    ImageView lorLayout1;
    @BindView(R.id.about_frag_lor_layout_2)
    ImageView lorLayout2;
    @BindViews({R.id.profile_detail_photo_1, R.id.profile_detail_photo_2, R.id.profile_detail_photo_3})
    List<ImageView> photos_iv;
    @BindViews({R.id.profile_detail_video_1, R.id.profile_detail_video_2, R.id.profile_detail_video_3})
    List<ImageView> videos_iv;
    @BindViews({R.id.about_resume_layout_1, R.id.about_resume_layout_2, R.id.about_resume_layout_3, R.id.about_resume_layout_4, R.id.about_resume_layout_5})
    List<ImageView> resumePhotos_iv;
    @BindViews({R.id.about_frag_lor_layout_1, R.id.about_frag_lor_layout_2})
    List<ImageView> recommPhotos_iv;
    String mAuthToken;


    //for images
    private int length;
    String[] imageUrls;
    String[] modifiedUrls;
    String[] imagesArray;
    //for vidoes
    String[] videoUrls;
    String[] vidoesArray;
    int mNumberOfVideos = 0;
    //for recommends
    String[] mRecommendUrls;
    String[] mRecommendArray;
    int mRecommendSize;
    //for resumes
    String[] mModifiedResumeUrls;
    String[] mResumesArray;
    int mResumesSize;
    Activity actv;

    private static final int MY_PERMISSIONS_WRITE_EXTERNAL_STORAGE = 1;
    private static final int MY_PERMISSIONS_READ_EXTERNAL_STORAGE = 2;


    private int mClickedIndex;


    public AboutMeFragment() {
        // Required empty public constructor
    }


    public static AboutMeFragment newInstance(Profile profile) {
        AboutMeFragment fragment = new AboutMeFragment();
        Bundle args = new Bundle();
        args.putParcelable(Constants.JOB_INTENT_EXTRA, profile);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        actv = activity;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            profile = getArguments().getParcelable(Constants.JOB_INTENT_EXTRA);
        }

        mAuthToken = PreferencesData.getString(actv, Constants.AUTHORIZATION_KEY, "");
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View rootView = inflater.inflate(R.layout.fragment_about_me, container, false);
        ButterKnife.bind(this, rootView);
        setUpMediaViews();

        if (profile != null)
            setupData();

        return rootView;
    }

    private void setUpMediaViews() {
        photo1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                showLarge(Profile.getInstance().getImage_url()[0]);
            }
        });
        photo2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showLarge(Profile.getInstance().getImage_url()[1]);
            }
        });
        photo3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showLarge(Profile.getInstance().getImage_url()[2]);
            }
        });

        video1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // checkVideoExist(String addUrl)
                mClickedIndex = 0;
                checkStoragePermission();
            }
        });

        video2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                mClickedIndex = 1;
                checkStoragePermission();
            }
        });
        video3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mClickedIndex = 2;
                checkStoragePermission();
            }
        });

        resumeLayout1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showLarge(Profile.getInstance().getResume_url()[0]);
            }
        });
        resumeLayout2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showLarge(Profile.getInstance().getResume_url()[1]);
            }
        });
        resumeLayout3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showLarge(Profile.getInstance().getResume_url()[2]);
            }
        });
        resumeLayout4.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showLarge(Profile.getInstance().getResume_url()[3]);
            }
        });
        resumeLayout5.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showLarge(Profile.getInstance().getResume_url()[4]);
            }
        });

        lorLayout1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Log.e("---", "onClick url : " + mRecommendUrls[0]);
                showLarge(Profile.getInstance().getRecomendationLettrs_url()[0]);
            }
        });
        lorLayout2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                showLarge(Profile.getInstance().getRecomendationLettrs_url()[1]);
            }
        });

    }

    private void showVideo(String url) {
/*
        ShowVideoDialog videoDialog = new ShowVideoDialog();
        Bundle bundle = new Bundle();
        bundle.putString("video_url", url);
        videoDialog.setArguments(bundle);

        videoDialog.show(actv.getFragmentManager(), "Show Video");
*/

        Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
        intent.setDataAndType(Uri.parse(url), "video/mp4");
        startActivity(intent);


    }

    private void showLarge(String url) {

        Intent intent = new Intent(actv, EnlargedImageDialog.class);
        intent.putExtra("imageUrl", url);
        startActivity(intent);

    }


    private void setupData() {

        name.setText(Profile.getInstance().getName());
        String add = "", addressLine1 = "", addressLine2 = "", city = "", state = "", zipCode = "";

        // TODO: 21-06-2016 why these toasts? :O
        if (Profile.getInstance().getAddressLine1() != null && Profile.getInstance().getAddressLine1().length() > 1) {
            addressLine1 = Profile.getInstance().getAddressLine1();
            add = add + addressLine1 + ",\n";
        }
        if (Profile.getInstance().getAddressLine2() != null && Profile.getInstance().getAddressLine2().length() > 1) {
            addressLine2 = Profile.getInstance().getAddressLine2();
            add = add + addressLine2 + ",\n";
        }

        if (Profile.getInstance().getCityname() != null) {
            city = Profile.getInstance().getCityname();
            add = add + city;
        }

        if (Profile.getInstance().getStatename() != null) {
            state = Profile.getInstance().getStatename();
            add = add + ", " + state;
        }
        if (Profile.getInstance().getZipcode() != null) {
            zipCode = Profile.getInstance().getZipcode();
            add = add + " " + zipCode;
        }

        address.setText(add);

        email.setText(Html.fromHtml(Profile.getInstance().getEmail()));
        phoneNumber.setText(Profile.getInstance().getPhoneNumber());


        List<Position> positions = DataHelper.getInstance().getPositions();
        if (positions != null) {
            String strPositions = "";
            if (Profile.getInstance().getPositionIDs() != null && Profile.getInstance().getPositionIDs().length > 0) {
                for (int positionId : Profile.getInstance().getPositionIDs()) {
                    Position position = new Position();
                    position.setPositionId(positionId);
                    int index = positions.indexOf(position);
                    if (index > -1) {
                        strPositions += positions.get(index).getPositionName() + ", ";
                    }
                }
                jobprofile.setText(strPositions.substring(0, strPositions.length() - 2));
            }
        }

        ImageLoader.getInstance().displayImage(Profile.getInstance().getProfile_url(), profileimage, Utility.getProfilePicDisplayOptions(Constants.CIRCULAR_IMAGE_RADIUS));
        Log.d(LOG_TAG, "setUpData: profile pic url " + Profile.getInstance().getProfile_url());

        if (profile.getAboutMe() != null) {
            bioDescription_tv.setText(profile.getAboutMe());
        }

        //  Utility.showProgressDialog(actv);

        //TODO:remove the below line to fix the getting more number of images
        if (Profile.getInstance().getImage() != null)
            length = Profile.getInstance().getImage().length > 3 ? 3 : Profile.getInstance().getImage().length;

        imagesArray = new String[3];
        modifiedUrls = new String[3];


        for (int i = 0; i < length; i++) {
            imagesArray[i] = Profile.getInstance().getImage()[i];
        }

        if (length == 0) {
            nophoto_label.setVisibility(View.VISIBLE);
            photosLayout_row.setVisibility(View.GONE);
        }

        mNumberOfVideos = Profile.getInstance().getVideo().length;
        if (mNumberOfVideos > 0) {
            videosLayout_row.setVisibility(View.VISIBLE);
        } else {
            noVideo_label.setVisibility(View.VISIBLE);
        }


        vidoesArray = new String[3];
        videoUrls = new String[3];
        for (int j = 0; j < mNumberOfVideos; j++) {
            vidoesArray[j] = Profile.getInstance().getVideo()[j];
            if (Profile.getInstance().getVideo().length > j) {
                ProfileHelper.getInstance().getVidoesArray()[j] = Profile.getInstance().getVideo()[j];
                ProfileHelper.getInstance().getVideoUrls()[j] = Profile.getInstance().getVideo_url()[j];
            }
        }


        imageUrls = new String[length];
        //set photos
        if (length > 0) {
            // loadImages(0);
            for (int i = 0; i < length; i++) {
                ImageLoader.getInstance().displayImage(Profile.getInstance().getImage_url()[i], photos_iv.get(i), Utility.getCircularDisplayOptions(50));
                photos_iv.get(i).setVisibility(View.VISIBLE);
            }


        }


        //for resumes
        mResumesArray = new String[5];
        mModifiedResumeUrls = new String[5];
        mResumesSize = Profile.getInstance().getResume().length > 5 ? 5 : Profile.getInstance().getResume().length;
        Log.e("---", "resume Size : " + mResumesSize);
        for (int i = 0; i < mResumesSize; i++) {
            mResumesArray[i] = Profile.getInstance().getResume()[i];
        }
        if (mResumesSize > 0) {
            //loadResumes(0);
            for (int i = 0; i < mResumesSize; i++) {
                ImageLoader.getInstance().displayImage(Profile.getInstance().getResume_url()[i], resumePhotos_iv.get(i), Utility.getCircularDisplayOptions(50));
                resumePhotos_iv.get(i).setVisibility(View.VISIBLE);
            }

            resumesLabel_tv.setVisibility(View.VISIBLE);
        } else {
            resumePhotosRow_ll.setVisibility(View.GONE);
            no_resumesLabel_tv.setVisibility(View.VISIBLE);
        }


        //for recommendations
        mRecommendArray = new String[2];
        mRecommendUrls = new String[2];
        mRecommendSize = Profile.getInstance().getRecommendationLetters().length > 2 ? 2 : Profile.getInstance().getRecommendationLetters().length;
        for (int i = 0; i < mRecommendSize; i++) {
            mRecommendArray[i] = Profile.getInstance().getRecommendationLetters()[i];
        }
        if (mRecommendSize > 0) {
            //loadRecommendations(0);

            for (int i = 0; i < mRecommendSize; i++) {
                ImageLoader.getInstance().displayImage(Profile.getInstance().getRecomendationLettrs_url()[i], recommPhotos_iv.get(i), Utility.getCircularDisplayOptions(50));
                recommPhotos_iv.get(i).setVisibility(View.VISIBLE);
            }

            recommendationLettersLabel_tv.setVisibility(View.VISIBLE);
        } else {
            lors_ll.setVisibility(View.GONE);
            no_recommend_tv.setVisibility(View.VISIBLE);
        }


        if (mNumberOfVideos > 0) {
            showVideoThumbnails(0);
        }
    }


    private void showVideoThumbnails(int i) {
      /*  if (i < mNumberOfVideos) {
            new RetrieveVideoFrameTask(actv, new DownloadCompleteCallback() {
                @Override
                public void done(int next) {
                    showVideoThumbnails(next + 1);
                }
            }).execute(i);
        }*/

        if (Profile.getInstance().getVideoThumbnail() != null) {
            for (int k = 0; k < Profile.getInstance().getVideoThumbnail().length; k++) {
                Log.d(LOG_TAG, "showVideoThumbnails: ");
                ImageLoader.getInstance().displayImage(Profile.getInstance().getVideoThumbnail()[k], videos_iv.get(k), Utility.getCircularDisplayOptions(50));
                videos_iv.get(k).setVisibility(View.VISIBLE);
                videos_iv.get(k).setVisibility(View.VISIBLE);
            }
        }

    }


    private class RetrieveVideoFrameTask extends AsyncTask<Integer, Void, Void> {

        int index;
        private Bitmap thumbBitmap;
        Context mContext;
        DownloadCompleteCallback callback;

        public RetrieveVideoFrameTask(Context context, DownloadCompleteCallback callback) {
            mContext = context;
            this.callback = callback;

        }

        @Override
        protected Void doInBackground(Integer... params) {

            index = params[0];
            try {
                thumbBitmap = retrieveVideoFrameFromVideo(Profile.getInstance().getVideo_url()[index]);
            } catch (Throwable throwable) {
                throwable.printStackTrace();
            }

            return null;
        }

        @Override
        protected void onPostExecute(Void aVoid) {
            super.onPostExecute(aVoid);

            if (thumbBitmap != null) {
                videos_iv.get(index).setImageBitmap(thumbBitmap);
                videos_iv.get(index).setVisibility(View.VISIBLE);
            }
            callback.done(index + 1);
        }
    }


    public Bitmap retrieveVideoFrameFromVideo(String videoPath)
            throws Throwable {
        Bitmap bitmap = null;
        MediaMetadataRetriever mediaMetadataRetriever = null;
        try {
            mediaMetadataRetriever = new MediaMetadataRetriever();
            if (Build.VERSION.SDK_INT >= 14)
                mediaMetadataRetriever.setDataSource(videoPath, new HashMap<String, String>());
            else
                mediaMetadataRetriever.setDataSource(videoPath);
            //   mediaMetadataRetriever.setDataSource(videoPath);
            bitmap = mediaMetadataRetriever.getFrameAtTime();
        } catch (Exception e) {
            e.printStackTrace();
            throw new Throwable(
                    "Exception in retrieveVideoFrameFromVideo(String videoPath)"
                            + e.getMessage());

        } finally {
            if (mediaMetadataRetriever != null) {
                mediaMetadataRetriever.release();
            }
        }
        return bitmap;
    }


    private boolean checkVideoExist(String addUrl) {
        String url = Constants.baseUrl + addUrl;

        File f = new File(url);

        return f.exists();
    }


    private void initiateDownload(int i) {
        if (Utility.isConnectingToInternet(actv)) {
            Utility.showProgressDialog(actv);
            new DownloadFileTask(actv, new DownloadCompleteCallback() {
                @Override
                public void done(int next) {
                    Utility.dismissDialog();
                    showVideo(Constants.baseUrl + Profile.getInstance().getVideo()[mClickedIndex]);
                }
            }).execute("" + i);
        } else {

        }
    }


    public void checkStoragePermission() {
        if (ActivityCompat.checkSelfPermission(actv,
                Manifest.permission.READ_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED) {

            requestPermissions(
                    new String[]{Manifest.permission.READ_EXTERNAL_STORAGE},
                    MY_PERMISSIONS_READ_EXTERNAL_STORAGE);


        } else {
            if (checkVideoExist(Profile.getInstance().getVideo()[mClickedIndex])) {
                showVideo(Constants.baseUrl + Profile.getInstance().getVideo()[mClickedIndex]);

            } else {

                initiateDownload(mClickedIndex);

            }


        }


    }


    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        Log.d(LOG_TAG, "onRequestPermissionsResult: ");


        if (requestCode == MY_PERMISSIONS_READ_EXTERNAL_STORAGE) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {

                if (checkVideoExist(Profile.getInstance().getVideo()[mClickedIndex])) {
                    showVideo(Constants.baseUrl + Profile.getInstance().getVideo()[mClickedIndex]);

                } else {

                    initiateDownload(mClickedIndex);

                }

            } else {
                Toast.makeText(actv, "Please enable storage permissions", Toast.LENGTH_SHORT).show();
            }
        }
    }
}
