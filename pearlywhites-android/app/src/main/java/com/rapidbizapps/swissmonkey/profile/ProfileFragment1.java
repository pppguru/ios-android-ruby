package com.rapidbizapps.swissmonkey.profile;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;
import android.media.ThumbnailUtils;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.PowerManager;
import android.provider.MediaStore;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.content.FileProvider;
import android.support.v7.app.AlertDialog;
import android.telephony.PhoneNumberFormattingTextWatcher;
import android.text.InputFilter;
import android.util.Base64;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.JsonObject;
import com.netcompss.ffmpeg4android.GeneralUtils;
import com.netcompss.ffmpeg4android.Prefs;
import com.netcompss.loader.LoadJNI;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.rapidbizapps.swissmonkey.HomeActivity;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.Services.ProfileHelper;
import com.rapidbizapps.swissmonkey.Services.RetroHelper;
import com.rapidbizapps.swissmonkey.fragments.EnlargedImageDialog;
import com.rapidbizapps.swissmonkey.models.Profile;
import com.rapidbizapps.swissmonkey.utility.Constants;
import com.rapidbizapps.swissmonkey.utility.DialogUtility;
import com.rapidbizapps.swissmonkey.utility.DownloadFileTask;
import com.rapidbizapps.swissmonkey.utility.FirstLetterCapFilter;
import com.rapidbizapps.swissmonkey.utility.PreferencesData;
import com.rapidbizapps.swissmonkey.utility.Utility;
import com.rba.ScrollView;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.protocol.HTTP;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import butterknife.BindView;
import butterknife.BindViews;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnTextChanged;
import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;
import retrofit.mime.MultipartTypedOutput;
import retrofit.mime.TypedFile;
import retrofit.mime.TypedString;


public class ProfileFragment1 extends Fragment {
    private static final int PROFILE_PIC_PICK_REQUEST = 529;
    private static final int PROFILE_PIC_CAPTURE_REQUEST = 925;

    private static final int PHOTO_PICK_REQUEST = 532;
    private static final int PHOTO_CAPTURE_REQUEST = 533;

    private static final int VIDEO_PICK_REQUEST = 235;
    private static final int VIDEO_CAPTURE_REQUEST = 236;

    private static final int IMAGE_TYPE = 786;
    private static final int VIDEO_TYPE = 687;

    private static final int PHOTO_PERMISSION_REQUEST_CODE = 429;
    private static final int PHOTO_PERMISSION_REQUEST_CODE_1 = 430;
    private static final int PROFILE_PHOTO_PERMISSION_REQUEST_CODE = 455;

    private static final int VIDEO_PERMISSION_REQUEST_CODE = 924;
    private static final int DOWNLOAD_FILE_TASK_PERMISSION = 1908;


    private static final int MY_PERMISSIONS_WRITE_EXTERNAL_STORAGE = 1;
    private static final int MY_PERMISSIONS_READ_EXTERNAL_STORAGE = 2;


    String imgDecodableString;
    Uri photoURI;
    String photoPath;


    Uri[] videoUris = new Uri[3];

    DialogInterface.OnClickListener videosListener, photosListener, profilePicListener;


    @BindView(R.id.iv_profileImage)
    ImageView iv_profileImage;

    @BindView(R.id.et_name)
    com.rba.MaterialEditText et_name;

    @BindView(R.id.et_addressLine1)
    com.rba.MaterialEditText et_addressLine1;

    @BindView(R.id.et_addressLine2)
    com.rba.MaterialEditText et_addressLine2;

    @BindView(R.id.et_city)
    com.rba.MaterialEditText et_city;

    @BindView(R.id.et_state)
    com.rba.MaterialEditText et_state;

    @BindView(R.id.et_zip)
    com.rba.MaterialEditText et_zip;

    @BindView(R.id.et_email)
    com.rba.MaterialEditText et_email;

    @BindView(R.id.et_phoneNumber)
    com.rba.MaterialEditText et_phoneNumber;

    @BindView(R.id.et_aboutMe)
    EditText et_aboutMe;

    @BindView(R.id.tv_uploadPhoto)
    TextView tv_uploadPhoto;

    List<ImageView> profilePhotos_iv;

    @BindViews({R.id.photo_layout_1, R.id.photo_layout_2, R.id.photo_layout_3})
    List<RelativeLayout> profileLayout_iv;


    @BindView(R.id.profile_photos_group)
    LinearLayout photosRow_ll;

    @BindView(R.id.profile_photos_label)
    TextView photosLabel_tv;

    ImageView profilePhoto1, profilePhoto2, profilePhoto3;

    ImageButton deletePhoto1_ib, deletePhoto2_ib, deletePhoto3_ib,
            deleteVideo1_ib, deleteVideo2_ib, deleteVideo3_ib;


    @BindView(R.id.tv_uploadVideo)
    TextView tv_uploadVideo;

    @BindView(R.id.profile_videos_label)
    TextView videosLabel_tv;

    @BindView(R.id.profile_videos_group)
    LinearLayout videosRow_ll;

    List<ImageView> profileVideos_iv;
    ImageView profileVideo1, profileVideo2, profileVideo3;

    @BindView(R.id.photo_layout_1)
    RelativeLayout photoLayout1;

    @BindView(R.id.photo_layout_2)
    RelativeLayout photoLayout2;

    @BindView(R.id.photo_layout_3)
    RelativeLayout photoLayout3;

    @BindView(R.id.video_layout_1)
    RelativeLayout videoLayout1_rl;

    @BindView(R.id.video_layout_2)
    RelativeLayout videoLayout2_rl;

    @BindView(R.id.video_layout_3)
    RelativeLayout videoLayout3_rl;
    @BindViews({R.id.video_layout_1, R.id.video_layout_2, R.id.video_layout_3})
    List<RelativeLayout> profileVideoLayout_iv;

    @BindView(R.id.profile1_scrollview)
    ScrollView profile1_scrollview;


    private String mAuthToken;

    private int length;


    int mNumberOfVideos = 0;

    HomeActivity mActivity;

    private static final String LOG_TAG = "ProfileFragment1";

    private int mClickedIndex;
    private boolean commandValidationFailedFlag;
    private InputFilter[] mFilters;


    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        mActivity = (HomeActivity) context;
    }

    public ProfileFragment1() {
        // Required empty public constructor
    }

    // TODO: Rename and change types and number of parameters
    public static ProfileFragment1 newInstance() {
        ProfileFragment1 fragment = new ProfileFragment1();
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
        View view = inflater.inflate(R.layout.fragment_profile_1, container, false);
        ButterKnife.bind(this, view);
        Log.e("---", "onCreateView called");
        setupMediaViews();


        setupData();
        setupDialogListeners();

        return view;
    }


    private void setupDialogListeners() {
        photosListener = new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {

                switch (which) {
                    case 0: //album
                        Intent galleryIntent = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
                        galleryIntent.putExtra(Intent.EXTRA_LOCAL_ONLY, true);
                        startActivityForResult(galleryIntent, PHOTO_PICK_REQUEST);
                        break;
                    case 1: //camera
                        createCameraIntent(PHOTO_CAPTURE_REQUEST);
                        break;
                }
            }
        };

        videosListener = new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {


                switch (which) {
                    case 0:
                        Intent videoPickIntent = new Intent(Intent.ACTION_PICK, MediaStore.Video.Media.EXTERNAL_CONTENT_URI);
                        videoPickIntent.putExtra("android.intent.extra.durationLimit", 180);
                        videoPickIntent.putExtra(Intent.EXTRA_LOCAL_ONLY, true);
                        videoPickIntent.setType("video/*");
                        startActivityForResult(videoPickIntent, VIDEO_PICK_REQUEST);
                        break;
                    case 1:
                        // TODO: 14-06-2016 permissions!
                        createVideoIntent();
                        break;
                }
            }
        };

        profilePicListener = new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {

                switch (which) {
                    case 0: //album
                        Intent galleryIntent = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
                        startActivityForResult(galleryIntent, PROFILE_PIC_PICK_REQUEST);

                        break;

                    case 1: //camera
                        /*Intent takePicture = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
                        startActivityForResult(takePicture,PROFILE_PIC_CAPTURE_REQUEST);*/
                        createCameraIntent(PROFILE_PIC_CAPTURE_REQUEST);
                        break;
                }

            }
        };
    }

    private void setupData() {
        if (Profile.getInstance().getProfilePic() != null && !Profile.getInstance().getProfilePic().isEmpty()) {
            ProfileHelper.getInstance().setProfilePicSet(true);
            Log.d(LOG_TAG, "setupData: isProfilePic set?" + ProfileHelper.getInstance().isProfilePicSet());
        } else {
            ProfileHelper.getInstance().setProfilePicSet(false);
        }

        et_name.setText(Utility.capitalizeFirstLetter(Profile.getInstance().getName()));
        et_name.setFilters(mFilters);

        et_addressLine1.setText(Utility.capitalizeFirstLetter(Profile.getInstance().getAddressLine1()));
        et_addressLine1.setFilters(mFilters);

        et_addressLine2.setText(Utility.capitalizeFirstLetter(Profile.getInstance().getAddressLine2()));
        et_addressLine2.setFilters(mFilters);

        et_city.setText(Utility.capitalizeFirstLetter(Profile.getInstance().getCityname()));
        et_city.setFilters(mFilters);

        if (Profile.getInstance().getStatename() != null)
            et_state.setText(Profile.getInstance().getStatename().toUpperCase());

        et_state.setFilters(new InputFilter[]{new InputFilter.AllCaps()});
        et_zip.setText(Profile.getInstance().getZipcode());

        et_email.setText(Profile.getInstance().getEmail());

        et_phoneNumber.setText(Profile.getInstance().getPhoneNumber());
        et_phoneNumber.addTextChangedListener(new PhoneNumberFormattingTextWatcher());


        et_aboutMe.setText(Utility.capitalizeFirstLetter(Profile.getInstance().getAboutMe()));
        et_aboutMe.setFilters(mFilters);
        et_aboutMe.setOnTouchListener(new View.OnTouchListener() {
            public boolean onTouch(View view, MotionEvent event) {
                if (view.getId() == R.id.et_aboutMe) {
                    view.getParent().requestDisallowInterceptTouchEvent(true);
                    switch (event.getAction() & MotionEvent.ACTION_MASK) {
                        case MotionEvent.ACTION_UP:
                            view.getParent().requestDisallowInterceptTouchEvent(false);
                            break;
                    }
                }
                return false;
            }
        });


        //set profile picture
        if (Profile.getInstance().getProfile_url() != null) {
            ImageLoader.getInstance().displayImage(Profile.getInstance().getProfile_url(), iv_profileImage, Utility.getProfilePicDisplayOptions(Constants.CIRCULAR_IMAGE_RADIUS));
        } else {
            iv_profileImage.setImageResource(R.drawable.avatar_add);
        }


        //TODO:remove the below line to fix the getting more number of images

        length = ProfileHelper.getInstance().getModifiedUrls().length;
        if (Profile.getInstance().getImage_url() != null) {
            for (int i = 0; i < length; i++) {
                if (Profile.getInstance().getImage_url().length > i && Profile.getInstance().getImage() != null) {
                    ProfileHelper.getInstance().getModifiedUrls()[i] = Profile.getInstance().getImage_url()[i];
                    ProfileHelper.getInstance().getImagesArray()[i] = Profile.getInstance().getImage()[i];
                }
            }
            Profile.getInstance().setImage(null);
        }

        for (int i = 0; i < length; i++) {
            String imageURL = ProfileHelper.getInstance().getModifiedUrls()[i];
            if (imageURL != null) {
                ImageLoader.getInstance().displayImage(imageURL, profilePhotos_iv.get(i), Utility.getCircularDisplayOptions(50));
                profilePhotos_iv.get(i).setVisibility(View.VISIBLE);
                profileLayout_iv.get(i).setVisibility(View.VISIBLE);
                photosLabel_tv.setVisibility(View.VISIBLE);
            }
        }
        showOrHidePhotosTitle();

        mNumberOfVideos = ProfileHelper.getInstance().getVidoesArray().length;
        if (Profile.getInstance().getVideo() != null) {
            for (int j = 0; j < mNumberOfVideos; j++) {
                if (Profile.getInstance().getVideo().length > j && Profile.getInstance().getVideo() != null) {
                    ProfileHelper.getInstance().getVidoesArray()[j] = Profile.getInstance().getVideo()[j];
                    ProfileHelper.getInstance().getVideoUrls()[j] = Profile.getInstance().getVideo_url()[j];
                    Log.d(LOG_TAG, "setupData: video url " + ProfileHelper.getInstance().getVideoUrls()[j]);
                }
            }
            Profile.getInstance().setVideo(null);
        }
        if (Profile.getInstance().getVideoThumbnail() != null) {
            for (int j = 0; j < Profile.getInstance().getVideoThumbnail().length; j++) {
                ProfileHelper.getInstance().getVideosThumbnailsArray()[j] = Profile.getInstance().getVideoThumbnail()[j];
                Log.d(LOG_TAG, "setupData: local thumbnails " + ProfileHelper.getInstance().getVideosThumbnailsArray()[j]);
                Log.d(LOG_TAG, "setupData: local thumbnails length" + ProfileHelper.getInstance().getVideosThumbnailsArray().length);
            }
        }

        if (mNumberOfVideos > 0)
            showVideoThumbnails(0);

        showOrHideVideosTitle();
        //profile1_scrollview.fullScroll(ScrollView.FOCUS_UP);
        profile1_scrollview.postDelayed(new Runnable() {
            @Override
            public void run() {
                profile1_scrollview.fullScroll(ScrollView.FOCUS_UP);
            }
        }, 600);
    }

    private void showVideoThumbnails(int i) {
//        if (i < mNumberOfVideos) {
            /*if (ProfileHelper.getInstance().getVideoUrls() == null) {
                showVideoThumbnails(i + 1);
                return;
            }
            new RetrieveVideoFrameTask(mActivity, new DownloadCompleteCallback() {
                @Override
                public void done(int next) {
                    showVideoThumbnails(next + 1);
                }
            }).execute(i);

*/
        Log.d(LOG_TAG, "showVideoThumbnails: #thumbnails" + ProfileHelper.getInstance().getVideosThumbnailsArray().length);
        for (int k = 0; k < ProfileHelper.getInstance().getVideosThumbnailsArray().length; k++) {

            if (ProfileHelper.getInstance().getVideosThumbnailsArray()[k] != null && !ProfileHelper.getInstance().getVideosThumbnailsArray()[k].isEmpty()) {
                if (ProfileHelper.getInstance().getVideosThumbnailsArray()[k].contains("amazonaws")) {
                    ImageLoader.getInstance().displayImage(ProfileHelper.getInstance().getVideosThumbnailsArray()[k], profileVideos_iv.get(k), Utility.getCircularDisplayOptions(50));
                } else {
                    profileVideos_iv.get(k).setImageURI(Uri.parse(ProfileHelper.getInstance().getVideosThumbnailsArray()[k]));
                }
                profileVideos_iv.get(k).setVisibility(View.VISIBLE);
                profileVideoLayout_iv.get(k).setVisibility(View.VISIBLE);
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
                Log.d(LOG_TAG, "doInBackground: " + ProfileHelper.getInstance().getVideoUrls()[index]);
                thumbBitmap = retriveVideoFrameFromVideo(ProfileHelper.getInstance().getVideoUrls()[index]);
            } catch (Throwable throwable) {
                throwable.printStackTrace();
            }

            return null;
        }

        @Override
        protected void onPostExecute(Void aVoid) {
            super.onPostExecute(aVoid);

            if (thumbBitmap != null) {
                profileVideos_iv.get(index).setImageBitmap(thumbBitmap);
                profileVideos_iv.get(index).setVisibility(View.VISIBLE);
                profileVideoLayout_iv.get(index).setVisibility(View.VISIBLE);
            }
            callback.done(index + 1);
        }
    }

    public Bitmap retriveVideoFrameFromVideo(String videoPath) throws Throwable {
        Bitmap bitmap = null;
        MediaMetadataRetriever mediaMetadataRetriever = null;
        Log.d(LOG_TAG, "retriveVideoFrameFromVideo: videoPath " + videoPath);
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
                    "Exception in retriveVideoFrameFromVideo(String videoPath)"
                            + e.getMessage());

        } finally {
            if (mediaMetadataRetriever != null) {
                mediaMetadataRetriever.release();
            }
        }
        return bitmap;
    }

    private void initiateDownload(int i) {
        if (Utility.isConnectingToInternet(mActivity)) {
            Utility.showProgressDialog(mActivity);
            new DownloadFileTask(mActivity, new DownloadCompleteCallback() {
                @Override
                public void done(int next) {
                    Utility.dismissDialog();
                    showVideo(Constants.baseUrl + ProfileHelper.getInstance().getVidoesArray()[mClickedIndex]);
                }
            }).execute("" + i);
        } else {

        }
    }


    private boolean checkVideoExist(String addUrl) {
        String url = Constants.baseUrl + addUrl;

        File f = new File(url);

        return f.exists();
    }

    private void setupMediaViews() {
        profilePhoto1 = (ImageView) photoLayout1.findViewById(R.id.profile_image);
        deletePhoto1_ib = (ImageButton) photoLayout1.findViewById(R.id.delete_image_button);

        profilePhoto1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(mActivity, EnlargedImageDialog.class);
                intent.putExtra("imageUrl", ProfileHelper.getInstance().getModifiedUrls()[0]);
                startActivity(intent);
            }
        });
        deletePhoto1_ib.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                deleteFile(0, ProfileHelper.getInstance().getImagesArray()[0], Constants.IMAGE_FILE_TYPE_KEY);
            }
        });

        profilePhoto2 = (ImageView) photoLayout2.findViewById(R.id.profile_image);
        deletePhoto2_ib = (ImageButton) photoLayout2.findViewById(R.id.delete_image_button);
        deletePhoto2_ib.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                deleteFile(1, ProfileHelper.getInstance().getImagesArray()[1], Constants.IMAGE_FILE_TYPE_KEY);
            }
        });

        profilePhoto2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(mActivity, EnlargedImageDialog.class);
                intent.putExtra("imageUrl", ProfileHelper.getInstance().getModifiedUrls()[1]);
                startActivity(intent);
            }
        });


        profilePhoto3 = (ImageView) photoLayout3.findViewById(R.id.profile_image);
        deletePhoto3_ib = (ImageButton) photoLayout3.findViewById(R.id.delete_image_button);
        deletePhoto3_ib.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                deleteFile(2, ProfileHelper.getInstance().getImagesArray()[2], Constants.IMAGE_FILE_TYPE_KEY);
            }
        });
        profilePhoto3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(mActivity, EnlargedImageDialog.class);
                intent.putExtra("imageUrl", ProfileHelper.getInstance().getModifiedUrls()[2]);
                startActivity(intent);
            }
        });


        profileVideo1 = (ImageView) videoLayout1_rl.findViewById(R.id.profile_video);

        profileVideo1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                mClickedIndex = 0;
                checkStoragePermission();
            }
        });


        // TODO: 28-06-2016 do not show video if it is not uploaded successfully
        deleteVideo1_ib = (ImageButton) videoLayout1_rl.findViewById(R.id.delete_video_button);
        deleteVideo1_ib.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                deleteFile(0, ProfileHelper.getInstance().getVidoesArray()[0], Constants.VIDEO_FILE_TYPE_KEY);
            }
        });


        profileVideo2 = (ImageView) videoLayout2_rl.findViewById(R.id.profile_video);
        profileVideo2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mClickedIndex = 1;
                checkStoragePermission();

            }
        });

        deleteVideo2_ib = (ImageButton) videoLayout2_rl.findViewById(R.id.delete_video_button);
        deleteVideo2_ib.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                deleteFile(1, ProfileHelper.getInstance().getVidoesArray()[1], Constants.VIDEO_FILE_TYPE_KEY);
            }
        });

        profileVideo3 = (ImageView) videoLayout3_rl.findViewById(R.id.profile_video);
        profileVideo3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mClickedIndex = 2;
                checkStoragePermission();

            }
        });

        deleteVideo3_ib = (ImageButton) videoLayout3_rl.findViewById(R.id.delete_video_button);
        deleteVideo3_ib.setOnClickListener(new View.OnClickListener() {
                                               @Override
                                               public void onClick(View v) {
                                                   deleteFile(2, ProfileHelper.getInstance().getVidoesArray()[2], Constants.VIDEO_FILE_TYPE_KEY);
                                               }
                                           }
        );

        profilePhotos_iv = new ArrayList<>();
        profilePhotos_iv.add(profilePhoto1);
        profilePhotos_iv.add(profilePhoto2);
        profilePhotos_iv.add(profilePhoto3);


        profileVideos_iv = new ArrayList<>();
        profileVideos_iv.add(profileVideo1);
        profileVideos_iv.add(profileVideo2);
        profileVideos_iv.add(profileVideo3);
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
                                            if (type.equals(Constants.IMAGE_FILE_TYPE_KEY)) {
                                                PreferencesData.saveBoolean(mActivity, Constants.CAN_ADD_PHOTOS, true);
                                                //  Profile.getInstance().getImage()[index]=null;
                                                ProfileHelper.getInstance().getImagesArray()[index] = null;
                                                ProfileHelper.getInstance().getModifiedUrls()[index] = null;
                                                showOrHidePhotosTitle();
                                                switch (index) {
                                                    case 0:
                                                        photoLayout1.setVisibility(View.GONE);
                                                        break;
                                                    case 1:
                                                        photoLayout2.setVisibility(View.GONE);
                                                        break;
                                                    case 2:
                                                        photoLayout3.setVisibility(View.GONE);
                                                        break;
                                                }
                                            } else if (type.equals(Constants.VIDEO_FILE_TYPE_KEY)) {
                                                PreferencesData.saveBoolean(mActivity, Constants.CAN_ADD_VIDEOS, true);
                                                //hide the layout and make the uri null
                                                File f = new File(Constants.baseUrl + fileName);
                                                if (f.exists()) {
                                                    f.delete();
                                                }

                                                ProfileHelper.getInstance().getVidoesArray()[index] = null;
                                                ProfileHelper.getInstance().getVideoUrls()[index] = null;

                                                showOrHideVideosTitle();

                                                switch (index) {
                                                    case 0:
                                                        videoLayout1_rl.setVisibility(View.GONE);
                                                        ProfileHelper.getInstance().getVidoesArray()[0] = null;
                                                        break;
                                                    case 1:
                                                        videoLayout2_rl.setVisibility(View.GONE);
                                                        ProfileHelper.getInstance().getVidoesArray()[1] = null;
                                                        break;
                                                    case 2:
                                                        videoLayout3_rl.setVisibility(View.GONE);
                                                        ProfileHelper.getInstance().getVidoesArray()[2] = null;
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
                            }

                    )
                    .setNegativeButton("No", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            dialog.dismiss();
                        }
                    }).

                    show();
        } else {
            DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, getString(R.string.cannot_delete_check_internet));
        }
    }

    private void showOrHidePhotosTitle() {
        boolean isShow = false;
        for (int i = 0; i < ProfileHelper.getInstance().getImagesArray().length; i++) {
            photosLabel_tv.setVisibility(View.GONE);
            if (ProfileHelper.getInstance().getImagesArray()[i] != null) {
                isShow = true;
            }
        }
        if (isShow) {
            photosLabel_tv.setVisibility(View.VISIBLE);
        }

    }

    private boolean showOrHideVideosTitle() {
        boolean isShow = false;
        for (int i = 0; i < ProfileHelper.getInstance().getVidoesArray().length; i++) {
            videosLabel_tv.setVisibility(View.GONE);
            if (ProfileHelper.getInstance().getVidoesArray()[i] != null) {

                isShow = true;
            }
        }
        if (isShow) {
            videosLabel_tv.setVisibility(View.VISIBLE);
        }
        return isShow;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        // to pick image for profile
        if (requestCode == PROFILE_PIC_PICK_REQUEST && resultCode == FragmentActivity.RESULT_OK && null != data) {
            Log.d(LOG_TAG, "onActivityResult: profile pic pick ");
            Uri selectedImage = data.getData();
            String[] filePathColumn = {MediaStore.Images.Media.DATA};
            Cursor cursor = mActivity.getContentResolver().query(selectedImage, filePathColumn, null, null, null);
            cursor.moveToFirst();

            int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
            imgDecodableString = cursor.getString(columnIndex);
            Log.d(LOG_TAG, "onActivityResult: imageDecodableString" + imgDecodableString);
            cursor.close();
            if (imgDecodableString != null) {
                Bitmap bm;
                try {
                    bm = Utility.decodeUri(mActivity, selectedImage);
                    Bitmap rotatedBitmap;
                    rotatedBitmap = Utility.rotateImage(imgDecodableString, bm, false);
                    iv_profileImage.setImageBitmap(rotatedBitmap);

                    File imgFile = new File(imgDecodableString);
                    /*if (imgFile.exists()) {
                        Utility.saveFileToServer(mActivity, Constants.PROFILE_FILE_TYPE_KEY, imgFile);
                    }*/

                    Utility.saveFileToServer(mActivity,Constants.PROFILE_FILE_TYPE_KEY,Utility.getFile(rotatedBitmap,IMAGE_TYPE));
                } catch (FileNotFoundException e) {
                    Log.e(LOG_TAG, "onActivityResult: " + e.getMessage());
                }
            } else {
                Toast.makeText(mActivity, "Image not found", Toast.LENGTH_LONG).show();
            }
        }

        if (requestCode == PROFILE_PIC_CAPTURE_REQUEST && resultCode == FragmentActivity.RESULT_OK) {
            Log.d(LOG_TAG, "onActivityResult: profile capture");
            Bitmap bitmap, rotatedBitmap;

            try {
                Log.d(LOG_TAG, "onActivityResult: photo URI" + photoURI);
                bitmap = Utility.decodeUri(mActivity, photoURI);


                rotatedBitmap = Utility.rotateImage(photoPath, bitmap, true);
                iv_profileImage.setImageBitmap(rotatedBitmap);

                Utility.saveFileToServer(mActivity, Constants.PROFILE_FILE_TYPE_KEY, Utility.getFile(rotatedBitmap, IMAGE_TYPE));
            } catch (FileNotFoundException e) {
                e.printStackTrace();
                Log.e(LOG_TAG, "onActivityResult: " + e.getLocalizedMessage());
            }
        }

        if (requestCode == PHOTO_PICK_REQUEST && resultCode == FragmentActivity.RESULT_OK && data != null) {
            Log.d(LOG_TAG, "onActivityResult: photo pick ");
            Uri selectedImage = data.getData();
            String[] filePathColumn = {MediaStore.Images.Media.DATA};
            Cursor cursor = mActivity.getContentResolver().query(selectedImage, filePathColumn, null, null, null);
            cursor.moveToFirst();
            int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
            String picturePath = cursor.getString(columnIndex);
            cursor.close();
            if (picturePath != null) {
                Bitmap bitmap, rotatedBitmap;
                try {
                    bitmap = Utility.decodeUri(mActivity, selectedImage);
                    rotatedBitmap = Utility.rotateImage(picturePath, bitmap, false);
                    setPhotos(rotatedBitmap, Utility.getFile(rotatedBitmap, IMAGE_TYPE));
                } catch (FileNotFoundException e) {
                    Log.e(LOG_TAG, "onActivityResult: " + e.getMessage());
                }
            } else {
                Toast.makeText(mActivity, "Image not found", Toast.LENGTH_LONG).show();
            }

        }

        if (requestCode == PHOTO_CAPTURE_REQUEST && resultCode == FragmentActivity.RESULT_OK) {
            Log.d(LOG_TAG, "onActivityResult: photo capture ");
            Bitmap bitmap, rotatedBitmap;

            try {
                Log.d(LOG_TAG, "onActivityResult: photo URI" + photoURI);
                bitmap = Utility.decodeUri(mActivity, photoURI);
                rotatedBitmap = Utility.rotateImage(photoURI.toString(), bitmap, true);
                setPhotos(rotatedBitmap, Utility.getFile(rotatedBitmap, IMAGE_TYPE));
            } catch (FileNotFoundException e) {
                e.printStackTrace();
                Log.e(LOG_TAG, "onActivityResult: " + e.getLocalizedMessage());
            }
        }

        if (requestCode == VIDEO_PICK_REQUEST && resultCode == FragmentActivity.RESULT_OK && data != null) {
            Uri selectedVideo = data.getData();
            Log.d(LOG_TAG, "onActivityResult: selected video " + selectedVideo.toString());
            File source = null;
            try {
                String[] filePathColumn = {MediaStore.Video.Media.DATA};
                Cursor cursor = mActivity.getContentResolver().query(selectedVideo, filePathColumn, null, null, null);
                cursor.moveToFirst();
                int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
                String videoPath = cursor.getString(columnIndex);
                cursor.close();
                source = new File(videoPath);

                File dest = new File(Constants.baseUrl + System.currentTimeMillis() + ".mp4");
                String compressedVideoName = Constants.baseUrl + System.currentTimeMillis() + "_sm.mp4";
                Log.d(LOG_TAG, "onActivityResult:picked source path" + source.getPath());
                Log.d(LOG_TAG, "onActivityResult: dest path" + dest.getPath());

                if (GeneralUtils.checkIfFileExistAndNotEmpty(source.getPath())) {
                    Log.d(LOG_TAG, "onActivityResult: spurce exists");
                    new TranscodingBackground(source.getPath(), compressedVideoName).execute();
                }

            } catch (Exception e) {
                e.printStackTrace();
                Toast.makeText(mActivity, "Video is not available", Toast.LENGTH_LONG).show();
            }

        }

        if (requestCode == VIDEO_CAPTURE_REQUEST && resultCode == FragmentActivity.RESULT_OK && data != null) {
            Uri selectedVideo = data.getData();
            Log.d(LOG_TAG, "onActivityResult:video capture " + data.getData().toString());
            File source = null;

            String[] filePathColumn = {MediaStore.Video.Media.DATA};
            Cursor cursor = mActivity.getContentResolver().query(selectedVideo, filePathColumn, null, null, null);
            if (cursor != null) {
                cursor.moveToFirst();
                int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
                String videoPath = cursor.getString(columnIndex);
                cursor.close();
                source = new File(videoPath);

            } else {
                try {
                    source = new File(new URI(selectedVideo.toString()));
                } catch (URISyntaxException e) {
                    e.printStackTrace();
                }
            }
            File dest = new File(Constants.baseUrl + System.currentTimeMillis() + ".mp4");
            String compressedVideoName = Constants.baseUrl + System.currentTimeMillis() + "_sm.mp4";
            Log.d(LOG_TAG, "onActivityResult:captured source path" + source.getPath());

            if (GeneralUtils.checkIfFileExistAndNotEmpty(source.getPath())) {
                Log.d(LOG_TAG, "onActivityResult: spurce exists");
                new TranscodingBackground(source.getPath(), compressedVideoName).execute();
            }

            /*try {
                copyFileUsingStream(source, dest);
                source.delete();
            } catch (IOException e) {
                e.printStackTrace();
            }*/
//            setVideos(selectedVideo, dest);
        }

    }

    private void setVideos(Uri selectedVideo, File file) {
        Log.d(LOG_TAG, "setVideos: " + file.getPath());
        if (videoLayout1_rl.getVisibility() == View.GONE) {
            videoLayout1_rl.setVisibility(View.VISIBLE);
            saveVideoToServer(file, 0);
        } else if (videoLayout2_rl.getVisibility() == View.GONE) {
            videoLayout2_rl.setVisibility(View.VISIBLE);
            saveVideoToServer(file, 1);
        } else if (videoLayout3_rl.getVisibility() == View.GONE) {
            videoLayout3_rl.setVisibility(View.VISIBLE);
            saveVideoToServer(file, 2);
        }

    }

    @OnClick(R.id.tv_uploadPhoto)
    void onUploadPhotosClick() {
        Log.d(LOG_TAG, "onUploadPhotosClick: ");
        //TODO:tweaking the code.(modified the code image deletion code)
        int childCount = photosRow_ll.getChildCount();
        int visibilityCount = 0;
        for (int i = 0; i < childCount; i++) {
            if (photosRow_ll.getChildAt(i).getVisibility() == View.VISIBLE) {
                visibilityCount += 1;
            }
        }
        if (visibilityCount >= 3) {
            DialogUtility.showDialogWithOneButton(mActivity, getString(R.string.already_uploaded), getString(R.string.remove_existing_image));
        } else {
            if (ActivityCompat.checkSelfPermission(mActivity, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED
                    ) {
                Log.d(LOG_TAG, "onUploadPhotosClick: permission already granted");
                Utility.createDialog(mActivity, photosListener);
            } else {
                Log.d(LOG_TAG, "onUploadPhotosClick: requesting permission");
                requestPermissions(new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, PHOTO_PERMISSION_REQUEST_CODE);
            }
        }
    }

    @OnClick(R.id.tv_uploadVideo)
    void onUploadVideoClick() {
        Log.d(LOG_TAG, "onUploadVideoClick: ");
        int childCount = videosRow_ll.getChildCount();
        int visibilityCount = 0;
        for (int i = 0; i < childCount; i++) {
            if (videosRow_ll.getChildAt(i).getVisibility() == View.VISIBLE) {
                visibilityCount += 1;
            }
        }
        if (visibilityCount >= 3) {
            DialogUtility.showDialogWithOneButton(mActivity, getString(R.string.already_uploaded), getString(R.string.remove_existing_video));
        } else {
            if (ActivityCompat.checkSelfPermission(mActivity, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED
                    ) {
                Log.d(LOG_TAG, "onUploadVideoClick: permission already granted");
                Utility.createDialog(mActivity, videosListener);

            } else {
                Log.d(LOG_TAG, "onUploadVideoClick: requesting permission");
                requestPermissions(new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, VIDEO_PERMISSION_REQUEST_CODE);
            }
        }

    }

    private void createCameraIntent(int captureRequestCode) {
        Intent takePicture = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (Utility.createCapturedPhotoFile() != null) {
            File file = Utility.createCapturedPhotoFile();
            photoPath = file.getAbsolutePath();
            photoURI = FileProvider.getUriForFile(mActivity, "com.rapidbizapps.swissmonkey.fileprovider", file);
            takePicture.putExtra(MediaStore.EXTRA_OUTPUT, photoURI);
        }
        startActivityForResult(takePicture, captureRequestCode);
    }

    private void createVideoIntent() {

        Intent videoCameraIntent = new Intent(MediaStore.ACTION_VIDEO_CAPTURE);
        Uri videoUri = Uri.fromFile(Utility.getFile(null, VIDEO_TYPE));
        // videoCameraIntent.putExtra(MediaStore.EXTRA_DURATION_LIMIT, 180); // TODO: 30-06-2016 change this?
//        videoCameraIntent.putExtra(MediaStore.EXTRA_SIZE_LIMIT, 41943040L);//40*1024*1024)
        videoCameraIntent.putExtra("android.intent.extra.durationLimit", 180);
//        videoCameraIntent.putExtra("EXTRA_VIDEO_QUALITY", 0);
        //videoCameraIntent.putExtra(MediaStore.EXTRA_OUTPUT,Uri.fromFile(new File(Constants.baseUrl+"temp.mp4")));
        startActivityForResult(videoCameraIntent, VIDEO_CAPTURE_REQUEST);
    }

    /**
     * method that sets up the view after capturing/picking images
     *
     * @param bitmap
     */
    private void setPhotos(Bitmap bitmap, final File file) {
        if (photoLayout1.getVisibility() == View.GONE) {
            photoLayout1.setVisibility(View.VISIBLE);
            profilePhoto1.setImageBitmap(ThumbnailUtils.extractThumbnail(bitmap, 48, 48));
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    savePhotoToServer(file, 0);
                }
            }, 1000);

        } else if (photoLayout2.getVisibility() == View.GONE) {
            photoLayout2.setVisibility(View.VISIBLE);
            profilePhoto2.setImageBitmap(ThumbnailUtils.extractThumbnail(bitmap, 48, 48));
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    savePhotoToServer(file, 1);
                }
            }, 1000);

        } else if (photoLayout3.getVisibility() == View.GONE) {
            photoLayout3.setVisibility(View.VISIBLE);
            profilePhoto3.setImageBitmap(ThumbnailUtils.extractThumbnail(bitmap, 48, 48));
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    savePhotoToServer(file, 2);
                }
            }, 1000);


        }

    }

    //these listeners are to let the fields in the activity be up-to-date.That's where the data is fetched from,to create request body in ProfileRootFragment
    @OnTextChanged(R.id.et_name)
    void onNameChange(CharSequence charSequence) {
        mActivity.name = charSequence.toString();
        Log.d(LOG_TAG, "onNameChange: " + mActivity.name);
    }

    @OnTextChanged(R.id.et_addressLine1)
    void onAddressLine1Change(CharSequence charSequence) {
        mActivity.addressLine1 = charSequence.toString();
        Log.d(LOG_TAG, "onAddressLine1Change: " + mActivity.addressLine1);
    }

    @OnTextChanged(R.id.et_city)
    void onCityChange(CharSequence charSequence) {
        mActivity.city = charSequence.toString();
        Log.d(LOG_TAG, "onCityChange: " + mActivity.city);
    }

    @OnTextChanged(R.id.et_state)
    void onStateChange(CharSequence charSequence) {
        mActivity.state = charSequence.toString();
        Log.d(LOG_TAG, "onStateChange: " + mActivity.state);
    }

    @OnTextChanged(R.id.et_zip)
    void onZipChange(CharSequence charSequence) {
        mActivity.zip = charSequence.toString();
        Log.d(LOG_TAG, "onZipChange: " + mActivity.zip);
    }

    @OnTextChanged(R.id.et_email)
    void onEmailChange(CharSequence charSequence) {
        if (mActivity.email == null || mActivity.email.equalsIgnoreCase(charSequence.toString())) {
            mActivity.isNewEmail = false;
            mActivity.email = charSequence.toString();
        } else {
            mActivity.isNewEmail = true;
            mActivity.newEmail = charSequence.toString();
        }
    }

    @OnTextChanged(R.id.et_phoneNumber)
    void onPhoneNumberChange(CharSequence charSequence) {
        mActivity.phoneNumber = charSequence.toString();
        Log.d(LOG_TAG, "onPhoneNumberChange: " + mActivity.phoneNumber);
    }

    @OnTextChanged(R.id.et_aboutMe)
    void onAboutMeChange(CharSequence charSequence) {
        mActivity.aboutMe = charSequence.toString();
        Log.d(LOG_TAG, "onAboutMeChange: " + mActivity.aboutMe);
    }

    //call this to upload photos from profile
    void savePhotoToServer(final File file, final int index) {
        MultipartTypedOutput multipartTypedOutput = new MultipartTypedOutput();
        multipartTypedOutput.addPart(Constants.AUTH_TOKEN_KEY, new TypedString(mAuthToken));
        multipartTypedOutput.addPart(Constants.TYPE_KEY, new TypedString(Constants.IMAGE_FILE_TYPE_KEY));
        multipartTypedOutput.addPart(Constants.KEYS_KEY, new TypedString(Constants.IMAGE_FILE_TYPE_KEY));
        multipartTypedOutput.addPart(Constants.IMAGE_FILE_TYPE_KEY, new TypedFile("multipart/form-data", file));


        if (Utility.isConnectingToInternet(mActivity)) {
            Utility.showProgressDialog(mActivity);
            RetroHelper.getBaseClassService(mActivity, "", "").uploadFile(multipartTypedOutput, new Callback<JsonObject>() {
                @Override
                public void success(JsonObject jsonObject, Response response) {
                    Utility.dismissDialog();

                    if (jsonObject != null) {
                        photosLabel_tv.setVisibility(View.VISIBLE);
                        ProfileHelper.getInstance().getImagesArray()[index] = file.getName();
                        ProfileHelper.getInstance().getModifiedUrls()[index] = file.getAbsolutePath();
                        if (ProfileHelper.getInstance().getModifiedUrls()[0] == null) {
                            photoLayout1.setVisibility(View.GONE);
                        } else {
                            photoLayout1.setVisibility(View.VISIBLE);

                        }
                        if (ProfileHelper.getInstance().getModifiedUrls()[1] == null) {
                            photoLayout2.setVisibility(View.GONE);
                        } else {
                            photoLayout2.setVisibility(View.VISIBLE);
                        }

                        if (ProfileHelper.getInstance().getModifiedUrls()[2] == null) {
                            photoLayout3.setVisibility(View.GONE);
                        } else {
                            photoLayout3.setVisibility(View.VISIBLE);
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
                            photoLayout1.setVisibility(View.GONE);
                            break;
                        case 1:
                            photoLayout2.setVisibility(View.GONE);
                            break;
                        case 2:
                            photoLayout3.setVisibility(View.GONE);
                            break;
                    }
                }
            });
        }
    }


    private class SaveVideoFileTask extends AsyncTask<String, Void, String[]> {
        String fileName, filePath;
        int index;

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            //  Utility.showProgressDialog(mActivity);

        }

        @Override
        protected String[] doInBackground(String... params) {
            fileName = params[0];
            filePath = params[1];
            index = Integer.parseInt(params[2]);

            Log.e(LOG_TAG, "saveVideoFiletoServer params[0] : " + fileName);
            Log.e(LOG_TAG, "saveVideoFiletoServer params[1] : " + filePath);
            Log.e(LOG_TAG, "saveVideoFiletoServer params[2] : " + index);
            Log.e(LOG_TAG, "saveVideoFiletoServer szie : " + new File(filePath).length());
            Log.e(LOG_TAG, "saveVideoFiletoServer url : " + mActivity.getString(R.string.server_url) + "/profile/upload");

            HttpClient httpclient = new DefaultHttpClient();
            HttpPost httppost = new HttpPost(mActivity.getString(R.string.server_url) + "/profile/upload");
            MultipartEntityBuilder builder = MultipartEntityBuilder.create();
            builder.setMode(HttpMultipartMode.BROWSER_COMPATIBLE);
            builder.addTextBody(Constants.AUTH_TOKEN_KEY, mAuthToken);
            builder.addTextBody(Constants.TYPE_KEY, Constants.VIDEO_FILE_TYPE_KEY);
            builder.addTextBody(Constants.KEYS_KEY, Constants.VIDEO_FILE_TYPE_KEY);
            builder.addPart(Constants.VIDEO_FILE_TYPE_KEY, new FileBody(new File(filePath)));
            httppost.setEntity(builder.build());
            HttpResponse response = null;
            try {
                response = httpclient.execute(httppost);
                int statusCode = response.getStatusLine().getStatusCode();
                HttpEntity resEntity = response.getEntity();
                String responseString = convertStreamToString(resEntity.getContent());
                Log.e(LOG_TAG, "saveVideoFiletoServer Response String : " + statusCode + " : " + responseString);
                return new String[]{"" + statusCode, responseString};

            } catch (IOException e) {
                e.printStackTrace();
            }
            httpclient.getConnectionManager().shutdown();

            return null;
        }

        @Override
        protected void onPostExecute(String[] s) {
            super.onPostExecute(s);
            Utility.dismissDialog();
            if (s != null) {
                int statusCode = Integer.parseInt(s[0]);
                if (statusCode == 200) {
                    ProfileHelper.getInstance().getVidoesArray()[index] = fileName;
                    ProfileHelper.getInstance().getVideoUrls()[index] = filePath;

                    Bitmap videoThumbnail = ThumbnailUtils.createVideoThumbnail(filePath, MediaStore.Video.Thumbnails.MINI_KIND);
                    profileVideos_iv.get(index).setImageBitmap(videoThumbnail);
                    profileVideos_iv.get(index).setVisibility(View.VISIBLE);
                    videosLabel_tv.setVisibility(View.VISIBLE);
                } else {
                    DialogUtility.showDialogWithOneButton(mActivity, "Upload Failure", s[1]);
                    //if uploading failed,no point in showing videos! wrong impression to user
                    switch (index) {
                        case 0:
                            videoLayout1_rl.setVisibility(View.GONE);
                            break;
                        case 1:
                            videoLayout2_rl.setVisibility(View.GONE);
                            break;
                        case 2:
                            videoLayout3_rl.setVisibility(View.GONE);
                            break;
                    }

                }

            } else {
                DialogUtility.showDialogWithOneButton(mActivity, "Upload Failure", "Server error..!");
                //if uploading failed,no point in showing videos! wrong impression to user
                switch (index) {
                    case 0:
                        videoLayout1_rl.setVisibility(View.GONE);
                        break;
                    case 1:
                        videoLayout2_rl.setVisibility(View.GONE);
                        break;
                    case 2:
                        videoLayout3_rl.setVisibility(View.GONE);
                        break;
                }

            }

        }
    }


    //call this to upload videos from profile
    void saveVideoToServer(final File file, final int index) {
      /*  String[] objects = {file.getName(), file.getAbsolutePath(), "" + index};
        if (Utility.isConnectingToInternet(mActivity)) {
            new SaveVideoFileTask().execute(objects);
        }*/

        Log.d(LOG_TAG, "saveVideoToServer: file path" + file.getPath());

        final Bitmap videoThumbnail = ThumbnailUtils.createVideoThumbnail(file.getAbsolutePath(), MediaStore.Video.Thumbnails.MINI_KIND);
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        videoThumbnail.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream);
        byte[] byteArray = byteArrayOutputStream.toByteArray();
        final String encoded = Base64.encodeToString(byteArray, Base64.DEFAULT);

        final File bitmapFile = Utility.getBitmapFile(videoThumbnail, file.getName(), IMAGE_TYPE);
        Log.d(LOG_TAG, "saveVideoToServer: videoFileName" + file.getName());

        if (Utility.isConnectingToInternet(mActivity)) {
            Utility.showProgressDialog(mActivity);
            MultipartTypedOutput multipartTypedOutput = new MultipartTypedOutput();
            multipartTypedOutput.addPart(Constants.AUTH_TOKEN_KEY, new TypedString(mAuthToken));
            multipartTypedOutput.addPart(Constants.TYPE_KEY, new TypedString(Constants.VIDEO_FILE_TYPE_KEY));
            multipartTypedOutput.addPart(Constants.KEYS_KEY, new TypedString(Constants.VIDEO_FILE_TYPE_KEY));
            multipartTypedOutput.addPart("thumbnail", new TypedFile("multipart/form-data", bitmapFile));
            multipartTypedOutput.addPart(Constants.VIDEO_FILE_TYPE_KEY, new TypedFile("multipart/form-data", file));

            Log.d(LOG_TAG, "saveVideoToServer: bitmap path" + bitmapFile.getPath());
            Log.d(LOG_TAG, "saveVideoToServer: body" + multipartTypedOutput.toString());

            if (Utility.isConnectingToInternet(mActivity)) {
                Utility.showProgressDialog(mActivity);
                RetroHelper.getBaseClassService(mActivity, "", "").uploadFile(multipartTypedOutput, new Callback<JsonObject>() {
                    @Override
                    public void success(JsonObject jsonObject, Response response) {
                        Utility.dismissDialog();

                        ProfileHelper.getInstance().getVidoesArray()[index] = file.getName();
                        ProfileHelper.getInstance().getVideoUrls()[index] = file.getAbsolutePath();
//                        ProfileHelper.getInstance().getVideosThumbnailsArray()[index] = bitmapFile.getPath();

                        if (jsonObject.has("url")) {
                            ProfileHelper.getInstance().getVideosThumbnailsArray()[index] = jsonObject.get("url").getAsJsonArray().get(0).getAsString();
                            Log.d(LOG_TAG, "success: " + jsonObject.get("url").getAsJsonArray().get(0).getAsString());
                        }

                        profileVideos_iv.get(index).setImageBitmap(videoThumbnail);
                        profileVideos_iv.get(index).setVisibility(View.VISIBLE);
                        videosLabel_tv.setVisibility(View.VISIBLE);

                        Log.d(LOG_TAG, "success: video upload");
                    }

                    @Override
                    public void failure(RetrofitError error) {
                        Utility.dismissDialog();
                        Utility.serviceCallFailureMessage(error, mActivity);
                        Log.d(LOG_TAG, "failure: video upload");
                        //if uploading failed,no point in showing videos! wrong impression to user
                        switch (index) {
                            case 0:
                                videoLayout1_rl.setVisibility(View.GONE);
                                break;
                            case 1:
                                videoLayout2_rl.setVisibility(View.GONE);
                                break;
                            case 2:
                                videoLayout3_rl.setVisibility(View.GONE);
                                break;
                        }
                    }
                });
            }
        }
    }

    public void checkStoragePermission() {
        if (ActivityCompat.checkSelfPermission(mActivity,
                Manifest.permission.WRITE_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED) {

            requestPermissions(
                    new String[]{Manifest.permission.READ_EXTERNAL_STORAGE},
                    MY_PERMISSIONS_READ_EXTERNAL_STORAGE);


        } else {
            if (checkVideoExist(ProfileHelper.getInstance().getVidoesArray()[mClickedIndex])) {
                showVideo(Constants.baseUrl + ProfileHelper.getInstance().getVidoesArray()[mClickedIndex]);

            } else {

                initiateDownload(mClickedIndex);

            }


        }


    }

    private void showVideo(String url) {
        /*ShowVideoDialog videoDialog = new ShowVideoDialog();
        Bundle bundle = new Bundle();
        bundle.putString("video_url", url);
        videoDialog.setArguments(bundle);

        videoDialog.show(mActivity.getFragmentManager(), "Show Video");

*/
        Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
        intent.setDataAndType(Uri.parse(url), "video/mp4");
        startActivity(intent);

    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        Log.d(LOG_TAG, "onRequestPermissionsResult: ");


        if (requestCode == MY_PERMISSIONS_READ_EXTERNAL_STORAGE) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                if (checkVideoExist(ProfileHelper.getInstance().getVidoesArray()[mClickedIndex])) {
                    showVideo(Constants.baseUrl + ProfileHelper.getInstance().getVidoesArray()[mClickedIndex]);

                } else {

                    initiateDownload(mClickedIndex);

                }
            } else {
                DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, mActivity.getString(R.string.allow_permission_storage_prompt));
            }
        }

        if (requestCode == PROFILE_PHOTO_PERMISSION_REQUEST_CODE) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Log.d(LOG_TAG, "onRequestPermissionsResult: photo permission granted");
                Utility.createDialog(mActivity, profilePicListener);
            } else {
                Log.d(LOG_TAG, "onRequestPermissionsResult: photo permission denied");
                DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, mActivity.getString(R.string.allow_permission_photo_prompt));
            }
        }

        if (requestCode == PHOTO_PERMISSION_REQUEST_CODE) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Log.d(LOG_TAG, "onRequestPermissionsResult: photo permission granted");
                Utility.createDialog(mActivity, photosListener);
            } else {
                Log.d(LOG_TAG, "onRequestPermissionsResult: photo permission denied");
                DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, mActivity.getString(R.string.allow_permission_photo_prompt));
            }
        }

        if (requestCode == VIDEO_PERMISSION_REQUEST_CODE) {

            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Log.d(LOG_TAG, "onRequestPermissionsResult: video permission granted");
                Utility.createDialog(mActivity, videosListener);
            } else {
                Log.d(LOG_TAG, "onRequestPermissionsResult: video permission denied");
                DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, mActivity.getString(R.string.allow_permission_video_prompt));
            }
        }


    }

    @OnClick(R.id.iv_profileImage)
    void onProfileImageClick() {
        Log.d(LOG_TAG, "onProfileImageClick: ");
//        showDialogWithUploadOptions(mActivity, Constants.PROFILE_FILE_TYPE_KEY);

        if (ActivityCompat.checkSelfPermission(mActivity, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED
                ) {
            Utility.createDialog(mActivity, profilePicListener);
        } else {
            requestPermissions(new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, PROFILE_PHOTO_PERMISSION_REQUEST_CODE);
        }
    }

    public static String getRealPathFromUri(Context context, Uri contentUri) {
        Cursor cursor = null;
        try {
            String[] proj = {MediaStore.Video.Media.DATA};
            cursor = context.getContentResolver().query(contentUri, proj, null, null, null);
            int column_index = cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DATA);
            cursor.moveToFirst();
            return cursor.getString(column_index);
        } finally {
            if (cursor != null) {
                cursor.close();
            }
        }
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();

        for (int i = 0; i < ProfileHelper.getInstance().getModifiedUrls().length; i++) {
            try {
                File f = new File(ProfileHelper.getInstance().getModifiedUrls()[0]);
                if (f.exists()) {
                    f.delete();
                }
            } catch (Exception e) {


            }

        }
    }

    @OnTextChanged(R.id.et_addressLine2)
    void onAddressLine2Change(CharSequence charSequence) {
        mActivity.addressLine2 = charSequence.toString();
        Log.d(LOG_TAG, "onAddressLine2Change: " + mActivity.addressLine2);
    }

    /**
     * convert input stream to string
     *
     * @param is - input stream
     * @return - string
     * @throws java.io.UnsupportedEncodingException
     */
    private String convertStreamToString(InputStream is)
            throws UnsupportedEncodingException {

        BufferedReader reader = new BufferedReader(new InputStreamReader(is,
                HTTP.UTF_8));
        StringBuilder sb = new StringBuilder();

        String line = null;
        try {
            while ((line = reader.readLine()) != null) {
                sb.append(line + "\n");
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                is.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return sb.toString();
    }

    public class TranscodingBackground extends AsyncTask<String, Integer, Integer> {

        String commandStr;
        String workFolder;
        String destinationPath;
        String vkLogPath;
        String demoVideoFolder;

        public TranscodingBackground(String sourceVideoPath, String destinationVideoPath) {
//            commandStr = "ffmpeg -y -i " + sourceVideoPath + " -strict experimental -r 30 -s 160x120 -aspect 1:1 -ab 48000 -ac 2 -ar 22050 -b 2097k " + destinationVideoPath;
//            commandStr = "ffmpeg -y -i " + sourceVideoPath + " -strict experimental -vcodec libx264 -preset ultrafast -crf 24 -acodec aac -ar 44100 -ac 2 -b:a 96k -s 320x240 -aspect 4:3 " + destinationVideoPath;
            commandStr = "ffmpeg -y -i " + sourceVideoPath + " -strict experimental -s 160x120 -r 25 -vcodec mpeg4 -b 150k -ab 48000 -ac 2 -ar 22050 " + destinationVideoPath;
            Log.d(LOG_TAG, "the command " + commandStr);
            workFolder = mActivity.getFilesDir().getAbsolutePath() + "/";
            vkLogPath = workFolder + "vk.log";
            destinationPath = destinationVideoPath;
            demoVideoFolder = Constants.baseUrl;
        }

        @Override
        protected void onPreExecute() {
            Utility.showProgressDialog(mActivity, "Compressing video...");
            GeneralUtils.copyLicenseFromAssetsToSDIfNeeded(mActivity, workFolder);
            GeneralUtils.copyDemoVideoFromAssetsToSDIfNeeded(mActivity, demoVideoFolder);

        }

        protected Integer doInBackground(String... paths) {
            Log.i(Prefs.TAG, "doInBackground started...");
            // delete previous log
            boolean isDeleted = GeneralUtils.deleteFileUtil(workFolder + "/vk.log");
            Log.i(Prefs.TAG, "vk deleted: " + isDeleted);


            PowerManager powerManager = (PowerManager) mActivity.getSystemService(Activity.POWER_SERVICE);
            PowerManager.WakeLock wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "VK_LOCK");
            Log.d(Prefs.TAG, "Acquire wake lock");
            wakeLock.acquire();

            GeneralUtils.checkForPermissionsMAndAbove(mActivity, true);
            LoadJNI vk = new LoadJNI();
            try {
                vk.run(GeneralUtils.utilConvertToComplex(commandStr), workFolder, mActivity);
                GeneralUtils.copyFileToFolder(vkLogPath, demoVideoFolder);


            } catch (Throwable e) {
                Log.e(Prefs.TAG, "vk run exeption.", e);
            } finally {
                if (wakeLock.isHeld())
                    wakeLock.release();
                else {
                    Log.i(Prefs.TAG, "Wake lock is already released, doing nothing");
                }
            }
            Log.i(Prefs.TAG, "doInBackground finished");
            return 0;
        }

        protected void onProgressUpdate(Integer... progress) {
        }

        @Override
        protected void onCancelled() {
            Log.i(Prefs.TAG, "onCancelled");
            super.onCancelled();
        }

        @Override
        protected void onPostExecute(Integer result) {
            Log.i(Prefs.TAG, "onPostExecute");
            Utility.dismissDialog();
            super.onPostExecute(result);

            File compressedVideo = new File(destinationPath);

            //cannot upload more than 40MB file
            if (compressedVideo.length() > 40 * 1024 * 1024) {
                DialogUtility.showDialogWithOneButton(mActivity, Constants.APP_NAME, "Video size limit exceeded. Please try again");
            } else {
                setVideos(null, compressedVideo);
            }

            String rc = null;
            if (commandValidationFailedFlag) {
                rc = "Command Validation Failed";
            } else {
                rc = GeneralUtils.getReturnCodeFromLog(vkLogPath);
            }
            final String status = rc;
/*
            SimpleExample.this.runOnUiThread(new Runnable() {
                public void run() {
                    Toast.makeText(SimpleExample.this, status, Toast.LENGTH_LONG).show();
                    if (status.equals("Transcoding Status: Failed")) {
                        Toast.makeText(SimpleExample.this, "Check: " + vkLogPath + " for more information.", Toast.LENGTH_LONG).show();
                    }
                }
            });
*/

        }

    }

    private void copyFileUsingStream(File source, File dest) throws IOException {
        InputStream is = null;
        OutputStream os = null;
        try {
            is = new FileInputStream(source);
            os = new FileOutputStream(dest);
            byte[] buffer = new byte[1024];
            int length;
            while ((length = is.read(buffer)) > 0) {
                os.write(buffer, 0, length);
            }
        } finally {
            is.close();
            os.close();
        }
    }

}
