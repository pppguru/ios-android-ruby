package com.rapidbizapps.swissmonkey.utility;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.ContentUris;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.RectF;
import android.media.ExifInterface;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.DocumentsContract;
import android.provider.MediaStore;
import android.support.v7.app.AlertDialog;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.Toast;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.nostra13.universalimageloader.cache.memory.impl.LruMemoryCache;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.display.RoundedBitmapDisplayer;
import com.rapidbizapps.swissmonkey.HomeActivity;
import com.rapidbizapps.swissmonkey.LoginActivity;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.Services.ProfileHelper;
import com.rapidbizapps.swissmonkey.Services.RetroHelper;
import com.rba.dialog.MaterialDialog;
import com.rba.dialog.Theme;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;
import retrofit.mime.MultipartTypedOutput;
import retrofit.mime.TypedByteArray;
import retrofit.mime.TypedFile;
import retrofit.mime.TypedString;

/**
 * Created by mjain on 5/20/2016.
 */
public class Utility {
    private static final int IMAGE_TYPE = 786;
    private static final int VIDEO_TYPE = 687;


    private static final String LOG_TAG = Utility.class.getSimpleName();
    static MaterialDialog ringProgressDialog = null;

    public static boolean isConnectingToInternet(Context context) {
        ConnectivityManager connectivity = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        if (connectivity != null) {
            NetworkInfo[] info = connectivity.getAllNetworkInfo();
            if (info != null)
                for (int i = 0; i < info.length; i++)
                    if (info[i].getState() == NetworkInfo.State.CONNECTED) {
                        return true;
                    }

        }
        return false;
    }

    public static void hideKeyboard(Activity activity) {
        // hiding keyboard by default
        activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN);
    }

    public static void showKeyboard(Activity activity) {
        // hiding keyboard by default
        activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_VISIBLE);
    }

    public static void showToast(Activity activity, String message) {
        Toast.makeText(activity, message, Toast.LENGTH_LONG).show();
    }

    public static void showProgressDialog(final Context ctx) {
        if (ringProgressDialog == null) {
            ringProgressDialog = new MaterialDialog.Builder(ctx)
                    .title(ctx.getResources().getString(R.string.app_name))
                    .content("Please wait.... ")
                    .progress(true, 0)
                    .theme(Theme.LIGHT)
                    .cancelable(false)
                    .show();
           /* ringProgressDialog.setOnShowListener(new DialogInterface.OnShowListener() {
                @Override
                public void onShow(DialogInterface dialog) {
                    try {
                        ProgressBar v = (ProgressBar) ringProgressDialog.findViewById(android.R.id.progress);
                        v.getIndeterminateDrawable().setColorFilter(ctx.getResources().getColor(R.color.statistics_bg),
                                PorterDuff.Mode.MULTIPLY);
                    } catch (Resources.NotFoundException e) {
                        e.printStackTrace();
                    }
                }
            });*/
        }
    }

    public static void showProgressDialog(final Context ctx, String message) {
        if (ringProgressDialog == null) {
            ringProgressDialog = new MaterialDialog.Builder(ctx)
                    .title(ctx.getResources().getString(R.string.app_name))
                    .content(message)
                    .progress(true, 0)
                    .theme(Theme.LIGHT)
                    .cancelable(false)
                    .show();
            ringProgressDialog.setOnShowListener(new DialogInterface.OnShowListener() {
                @Override
                public void onShow(DialogInterface dialog) {
                    ProgressBar v = (ProgressBar) ringProgressDialog.findViewById(android.R.id.progress);
                    v.getIndeterminateDrawable().setColorFilter(ctx.getResources().getColor(R.color.statistics_bg),
                            android.graphics.PorterDuff.Mode.MULTIPLY);
                }
            });
        }
    }

    public static void dismissDialog() {
        if (ringProgressDialog != null) {
            if (ringProgressDialog.isShowing()) {
                try {

                    ringProgressDialog.dismiss();
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    ringProgressDialog = null;
                }

            }
        }
    }

    public static boolean isShownDialog() {
        boolean isShown = false;
        if (ringProgressDialog != null) {
            if (ringProgressDialog.isShowing()) {
                return isShown = true;
            }
        }
        return isShown;

    }


    public static boolean isValidMobile(String phone) {

        String temp = phone.replaceAll("\\D+", "");
        if (temp.length() == 10) {
            return true;
        }
        return false;

       /* String phonePattern = "^[+]?[0-9]{10,13}$";
        return (phone.toString().matches(phonePattern));*/
        //return (android.util.Patterns.PHONE.matcher(phone).matches() && phone.toString().matches(phonePattern));
    }

    public static boolean isValidEmail(CharSequence emailId) {
        String emailPattern = "[a-zA-Z0-9.+-_]+@[a-zA-Z0-9.-]+\\.+[a-zA-Z]{2,4}";
        if (emailId != null && android.util.Patterns.EMAIL_ADDRESS.matcher(emailId).matches() && emailId.toString().matches(emailPattern)) {
            return true;
        } else {
            return false;
        }
    }

    public static void sendEmail(Activity activity, String bodyText, String subject, String mailTo) {

        if (Utility.isConnectingToInternet(activity)) {
            Intent intent = new Intent(Intent.ACTION_SENDTO, Uri.parse("mailto:" + mailTo));
            intent.putExtra(Intent.EXTRA_SUBJECT, subject);
            intent.putExtra(Intent.EXTRA_TEXT, bodyText);
            if (intent.resolveActivity(activity.getPackageManager()) != null) {
                activity.startActivity(intent);
            }
        } else {
            Toast.makeText(activity, "Please check the internet connection", Toast.LENGTH_LONG).show();
            //   singelButtonAlertDialog(activity,"Internet error", "Please check the internet connection");
        }
    }

    //costly operation Don't manipulate the actual photo! Just change the corresponding ImageView
    public static Bitmap getCircleBitmap(Bitmap bitmap) {
        final Bitmap output = Bitmap.createBitmap(bitmap.getWidth(), bitmap.getHeight(), Bitmap.Config.ARGB_8888);
        final Canvas canvas = new Canvas(output);

        final int color = Color.RED;
        final Paint paint = new Paint();
        final Rect rect = new Rect(0, 0, bitmap.getWidth(), bitmap.getHeight());
        final RectF rectF = new RectF(rect);

        paint.setAntiAlias(true);
        canvas.drawARGB(0, 0, 0, 0);
        paint.setColor(color);


        canvas.drawOval(rectF, paint);

        paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));
        canvas.drawBitmap(bitmap, rect, rect, paint);

        bitmap.recycle();

        return output;
    }

    public static void serviceCallFailureMessage(RetrofitError error, final Activity activity) {
        try {
            if (error != null && error.getResponse() != null) {
                if (error.getResponse().getStatus() == 501) {
                    Utility.showAppUpdateAlert(activity);
                } else {


                    // If the user is a Blocked User, then we directly navigate to the
                    // Login screen from anywhere in the app.
                    if (error.getResponse().getStatus() == 502) {
                        DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME,
                                activity.getString(R.string.account_blocked_alert), new View.OnClickListener() {
                                    @Override
                                    public void onClick(View v) {
                                        // Logging out the Blocked user.
                                        if (activity instanceof HomeActivity) {
                                            ((HomeActivity) activity).logoutUser();
                                        } else {
                                            activity.startActivity(new Intent(activity,
                                                    LoginActivity.class));
                                        }
                                    }
                                });

                    } else {

                        String body = new String(((TypedByteArray) error.getResponse().getBody()).getBytes());
                        JsonObject errorJson = new Gson().fromJson(body, JsonObject.class);

                        if (errorJson.get("error").getAsString().equalsIgnoreCase("Something went wrong please try again after sometime")) {
                            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, "Invalid Credentials");
                        } else if (errorJson.get("error").getAsString().equalsIgnoreCase("Invalid Credentials")) {
                            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, "Invalid Credentials");
                        } else if (errorJson.get("error").getAsString().equalsIgnoreCase("Email not registered")) {
                            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, errorJson.get("error").getAsString());
                        } else if (errorJson.get("error").getAsString().equalsIgnoreCase("Email id is not registered")) {
                            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, errorJson.get("error").getAsString());
                        } else if (errorJson.get("error").getAsString().equalsIgnoreCase("User already exists")) {
                            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, errorJson.get("error").getAsString());
                        } else if (errorJson.get("error").getAsString().equalsIgnoreCase("Verify your email to login")) {
                            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, "Please verify your email to login");
                        } else if (errorJson.get("error").getAsString().equalsIgnoreCase("Invalid Zip Code")) {
                            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, "Please enter valid zip code");
                        } else if (errorJson.get("error").getAsString().equalsIgnoreCase("Old password is incorrect")) {
                            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, "Old password is incorrect");
                        } else if (errorJson.get("error").getAsString().equalsIgnoreCase("Verify your email to change password")) {
                            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, "Please verify your email to change password");
                        } else if (errorJson.get("error").getAsString().equalsIgnoreCase("Please verify your email and login, Or login with your previous mail")) {
                            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, "Please verify your email to login");
                        } else {
                            DialogUtility.showDialogWithOneButton(activity, Constants.APP_NAME, "Please try again");
                        }
                    }
                }
            } else {
                DialogUtility.showDialogWithOneButton(activity, activity.getResources().getString(R.string.app_name), "Something went wrong. Please try again later.");
            }

        } catch (Exception e) {

            if (isConnectingToInternet(activity)) {
                DialogUtility.showDialogWithOneButton(activity, activity.getResources().getString(R.string.app_name), "Something went wrong. Please try again later.");
            } else {
                DialogUtility.showDialogWithOneButton(activity, activity.getResources().getString(R.string.app_name), "No network");
            }
            Log.e(LOG_TAG, "serviceCallFailureMessage: " + e.getMessage());
        }
    }


    public static DisplayImageOptions getCircularDisplayOptions(int cornerRadius) {
        return new DisplayImageOptions.Builder()
                .displayer(new RoundedBitmapDisplayer(cornerRadius))
                .showImageOnLoading(R.drawable.image_placeholder)
                .cacheOnDisk(true)
                .cacheInMemory(true)
                .showImageOnFail(R.drawable.image_placeholder) // TODO: 10-07-2016 get from Arunima
                .build();
    }

    public static DisplayImageOptions getProfilePicDisplayOptions(int cornerRadius) {
        DisplayImageOptions.Builder builder = new DisplayImageOptions.Builder();

//        builder.displayer(new RoundedBitmapDisplayer(cornerRadius))

        builder.cacheOnDisk(true)
                .cacheInMemory(true)
                .showImageOnFail(R.drawable.image_placeholder); // TODO: 10-07-2016 get from Arunima

        return builder.build();

    }


    public static DisplayImageOptions getDisplayOptions() {
        return new DisplayImageOptions.Builder()
                .showImageOnLoading(R.drawable.image_placeholder)
                .cacheOnDisk(true)
                .cacheInMemory(true)
                .showImageOnFail(R.drawable.image_placeholder)
                .build();

    }

    public static ImageLoader getImageLoader(Context context) {
        ImageLoaderConfiguration config = new ImageLoaderConfiguration.Builder(context)
                .memoryCache(new LruMemoryCache(2 * 1024 * 1024))
                .defaultDisplayImageOptions(DisplayImageOptions.createSimple())
                .writeDebugLogs()
                .build();

        ImageLoader imageLoader = ImageLoader.getInstance();
        imageLoader.init(config);
        return imageLoader;
    }

    /**
     * Creates a file for the image captured and returns it
     *
     * @param image the captured image
     */
    public static File getFile(Bitmap image, int type) {
        File file = null;

        final String DEFAULT_CURRENT_DIRECTORY = Constants.baseUrl;
        try {

            File root = new File(DEFAULT_CURRENT_DIRECTORY);
            root.mkdirs();

            if (type == IMAGE_TYPE) {
                String imagePath = System.currentTimeMillis() + ".jpg";
                file = new File(root, imagePath);
                file.createNewFile();
                FileOutputStream fOut = new FileOutputStream(file);

                image.compress(Bitmap.CompressFormat.PNG, 50, fOut);
                OutputStreamWriter myOutWriter = new OutputStreamWriter(fOut);
                myOutWriter.close();
                fOut.close();


            } else if (type == VIDEO_TYPE) {
                String videoPath = System.currentTimeMillis() + ".mp4";
                file = new File(root, videoPath);
                file.createNewFile();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return file;
    }

    public static File createCapturedPhotoFile() {
        File file = null;
        final String DEFAULT_CURRENT_DIRECTORY = Environment.getExternalStorageDirectory() + File.separator + ".rapidBizApps/";
        Log.d(LOG_TAG, "createCapturedPhotoFile: " + DEFAULT_CURRENT_DIRECTORY);
        try {
            File root = new File(DEFAULT_CURRENT_DIRECTORY);
            root.mkdirs();
            String imagePath = System.currentTimeMillis() + ".png";
            file = new File(root, imagePath);
            file.createNewFile();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return file;
    }


    /**
     * Creates a file for the image captured and returns it
     *
     * @param image the captured image
     */
    public static File getBitmapFile(Bitmap image, String fileName, int type) {
        File file = null;

        final String DEFAULT_CURRENT_DIRECTORY = Constants.baseUrl;
        try {

            File root = new File(DEFAULT_CURRENT_DIRECTORY);
            root.mkdirs();

            if (type == IMAGE_TYPE) {
                String imagePath = fileName.replaceAll(".mp4", ".jpg");
                file = new File(root, imagePath);
                file.createNewFile();

                FileOutputStream fOut = new FileOutputStream(file);
                image.compress(Bitmap.CompressFormat.PNG, 100, fOut);
                OutputStreamWriter myOutWriter = new OutputStreamWriter(fOut);
                myOutWriter.close();
                fOut.close();
            } else if (type == VIDEO_TYPE) {
                String videoPath = System.currentTimeMillis() + ".mp4";
                file = new File(root, videoPath);
                file.createNewFile();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return file;
    }


    //call this to upload any files from profile
    public static void saveFileToServer(final Context context, String type, File file1) {
        String authHeader = PreferencesData.getString(context, Constants.AUTHORIZATION_KEY, "");

        JsonObject profileJsonObject = new JsonObject();
        profileJsonObject.addProperty(Constants.AUTH_TOKEN_KEY, authHeader);

        //type can be any of these
        //recommendationletters,profile,resume,videoFiles

        MultipartTypedOutput multipartTypedOutput = new MultipartTypedOutput();
        multipartTypedOutput.addPart(Constants.AUTH_TOKEN_KEY, new TypedString(authHeader));
        multipartTypedOutput.addPart(Constants.TYPE_KEY, new TypedString(type));
        multipartTypedOutput.addPart(Constants.KEYS_KEY, new TypedString(type));
        multipartTypedOutput.addPart(type, new TypedFile("multipart/form-data", file1));


        if (Utility.isConnectingToInternet(context)) {
            Utility.showProgressDialog(context);
            RetroHelper.getBaseClassService(context, "", authHeader).uploadFile(multipartTypedOutput, new Callback<JsonObject>() {
                @Override
                public void success(JsonObject jsonObject, Response response) {
                    Utility.dismissDialog();
                    if (jsonObject != null) {
                        DialogUtility.showDialogWithOneButton((Activity) context, Constants.APP_NAME, "Uploaded successfully");
                    }
                    ProfileHelper.getInstance().setProfilePicSet(true);
                }

                @Override
                public void failure(RetrofitError error) {
                    Utility.dismissDialog();
                    Utility.serviceCallFailureMessage(error, (Activity) context);

                }
            });
        }

    }


    public static void createDialog(Context context, DialogInterface.OnClickListener listener) {
        new AlertDialog.Builder(context)
                .setTitle("Select your option")
                .setItems(new String[]{"Album", "Camera", "Cancel"}, listener).show();
    }


    /**
     * Scales the image and returns bitmap
     *
     * @param selectedImage Uri of the selected image from gallery
     * @throws FileNotFoundException
     */
    public static Bitmap decodeUri(Context context, Uri selectedImage) throws
            FileNotFoundException {
        BitmapFactory.Options o = new BitmapFactory.Options();
        o.inJustDecodeBounds = true;
        BitmapFactory.decodeStream(context.getContentResolver().openInputStream(selectedImage), null, o);

        final int REQUIRED_SIZE = 700;

        int width_tmp = o.outWidth, height_tmp = o.outHeight;
        int scale = 1;
        while (true) {
            if (width_tmp / 2 < REQUIRED_SIZE || height_tmp / 2 < REQUIRED_SIZE) {
                break;
            }
            width_tmp /= 2;
            height_tmp /= 2;
            scale *= 2;
        }

        BitmapFactory.Options o2 = new BitmapFactory.Options();
        o2.inSampleSize = scale;
        return BitmapFactory.decodeStream(context.getContentResolver().openInputStream(selectedImage), null, o2);
    }


    public static void setupSpinnerView(Context context, AlertDialog mAlertDialog) {
        ListView listView = mAlertDialog.getListView();
        listView.setBackground(context.getResources().getDrawable(R.drawable.list_dialog_background));
        listView.setDivider(context.getResources().getDrawable(R.drawable.list_divider));
        listView.setDividerHeight(1);
    }

    public static String dateFormat(long updatedTime) {

        long elapsed;
        String time;


        //milliseconds
        long curretTime = getTodayTime();
        long different = curretTime - updatedTime;
        long secondsInMilli = 1000;
        long minutesInMilli = secondsInMilli * 60;
        long hoursInMilli = minutesInMilli * 60;
        long daysInMilli = hoursInMilli * 24;

        if (different >= 86400000) {
            long str = different / daysInMilli;
            if (str > 365) {
                elapsed = str / 365;
                if (elapsed == 1)
                    time = String.valueOf(elapsed + " year");
                else
                    time = String.valueOf(elapsed + " years");
            } else if (str > 31) {
                elapsed = str / 31;
                if (elapsed == 1)
                    time = String.valueOf(elapsed + " month");
                else
                    time = String.valueOf(elapsed + " months");
            } else {
                elapsed = str;
                if (elapsed == 1) {
                    time = String.valueOf(elapsed + " day");
                } else
                    time = String.valueOf(elapsed + " days");
            }
        } else if (different >= 3600000) {
            elapsed = different / hoursInMilli;
            if (elapsed == 1)
                time = String.valueOf(elapsed + " hour");
            else
                time = String.valueOf(elapsed + " hours");
        } else if (different >= 60000) {
            elapsed = different / minutesInMilli;
            if (elapsed == 1)
                time = String.valueOf(elapsed + " minute");
            else
                time = String.valueOf(elapsed + " minutes");
        } else if (different >= 6000) {
            elapsed = different / secondsInMilli;

            time = String.valueOf(elapsed + " seconds");
        } else {
            time = String.valueOf("1 second");
        }

        return time;
    }

    private static long getTodayTime() {
        // Create a Date object set to the current date and time
        Date now = new Date();
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
        // Set a specific timezone
        df.setTimeZone(TimeZone.getTimeZone("UTC"));
        df.format(now);
        Calendar cal = df.getCalendar();
        return cal.getTimeInMillis();
    }


    public static Bitmap rotateImage(Bitmap bmp, Context context) {
        int rotate = 0;
        try {
            File f = new File(context.getCacheDir(), "" + System.currentTimeMillis() + ".PNG");
            Log.d(LOG_TAG, "rotateImage: " + f.getAbsolutePath());
            f.createNewFile();

            //Convert bitmap to byte array
            Bitmap bitmap = bmp;
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.PNG, 0 /*ignored for PNG*/, bos);
            byte[] bitmapData = bos.toByteArray();

            //write the bytes in file
            FileOutputStream fos = new FileOutputStream(f);
            fos.write(bitmapData);
            fos.flush();
            fos.close();

            ExifInterface exif = new ExifInterface(f.getAbsolutePath());
            int orientation = exif.getAttributeInt(
                    ExifInterface.TAG_ORIENTATION,
                    ExifInterface.ORIENTATION_NORMAL);

            switch (orientation) {
                case ExifInterface.ORIENTATION_ROTATE_270:
                    rotate = 270;
                    break;
                case ExifInterface.ORIENTATION_ROTATE_180:
                    rotate = 180;
                    break;
                case ExifInterface.ORIENTATION_ROTATE_90:
                    rotate = 90;
                    break;
            }

        } catch (IOException e) {
            e.printStackTrace();
        }

        Matrix matrix = new Matrix();
        matrix.postRotate(rotate);
        bmp = Bitmap.createBitmap(bmp, 0, 0, bmp.getWidth(), bmp.getHeight(), matrix, true);
        return bmp;
    }


    public static Bitmap rotateImage(String imageString, Bitmap bmp, boolean captured) {
        Log.d(LOG_TAG, "rotateImage: " + imageString);
        Log.d(LOG_TAG, "rotateImage: bitmap" + bmp);
        int rotate = 0;
        try {
            File f = new File(imageString);
            ExifInterface exif = new ExifInterface(f.getAbsolutePath());
            int orientation = exif.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL);
            switch (orientation) {
                case ExifInterface.ORIENTATION_ROTATE_270:
                    rotate = 270;
                    break;
                case ExifInterface.ORIENTATION_ROTATE_180:
                    rotate = 180;
                    break;
                case ExifInterface.ORIENTATION_ROTATE_90:
                    rotate = 90;
                    break;
                default:
                    Log.v("DEVICENAME", "" + Build.MODEL);
                    if (captured) {
                        if (Build.MODEL.equalsIgnoreCase("SM-N920T")) {
                            rotate = 90;
                        } else {
                            rotate = 0;
                        }
                    }
            }

        } catch (IOException ioException) {
            ioException.printStackTrace();
            Log.e(LOG_TAG, "rotateImage: " + ioException.getMessage());
        }

        Log.d(LOG_TAG, "rotateImage: rotate " + rotate);
        Matrix matrix = new Matrix();
        matrix.postRotate(rotate);
        if (bmp != null)
            bmp = Bitmap.createBitmap(bmp, 0, 0, bmp.getWidth(), bmp.getHeight(), matrix, true);
        return bmp;
    }


    public static void showAppUpdateAlert(final Activity context) {
        View.OnClickListener updateAppListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=com.rapidbizapps.swissmonkey"));
                    context.startActivity(intent);
                } catch (ActivityNotFoundException e) {
                    Log.d(LOG_TAG, "onClick: " + e.getMessage());
                }
            }
        };
        DialogUtility.showDialogWithOneButton(context, Constants.APP_NAME, "A required update is available in the Play Store. Please update from Play Store to continue using the application with improved features", updateAppListener);
    }


    public static String capitalizeFirstLetter(String string) {
        if (string != null && string.length() > 0) {
            if (Character.isLowerCase(string.charAt(0))) {
                return string.substring(0, 1).toUpperCase() + string.substring(1);
            }
        }
        return string;
    }

    public static void checkTermsAndConditionsStatus(final Activity activity) {
        Log.d(LOG_TAG, "checkTermsAndConditionsStatus: ");
        if (!PreferencesData.getBoolean(activity, Constants.TERMS_AND_CONDITIONS_ACCEPTED, false)) {
            Log.d(LOG_TAG, "checkTermsAndConditionsStatus: T&C not accepted");
            JsonObject requestBody = new JsonObject();
            requestBody.addProperty(Constants.AUTH_TOKEN_KEY, PreferencesData.getString(activity, Constants.AUTHORIZATION_KEY, ""));
            RetroHelper.getBaseClassService(activity, "", "").getToAStatus(requestBody, new Callback<JsonObject>() {
                @Override
                public void success(JsonObject jsonObject, Response response) {
                    if (jsonObject.has(Constants.PRIVACY_POLICY_STATUS_KEY) && jsonObject.get(Constants.PRIVACY_POLICY_STATUS_KEY).getAsBoolean()) {
                        PreferencesData.saveBoolean(activity, Constants.TERMS_AND_CONDITIONS_ACCEPTED, true);
                        Log.d(LOG_TAG, "success: T&C already accepted");
                    } else {
                        Log.d(LOG_TAG, "success: T&C accepted");
                        DialogUtility.showTermsAndConditionsDialog(activity, true, null); //not shown before. POST to server
                    }
                }

                @Override
                public void failure(RetrofitError error) {
                    Utility.serviceCallFailureMessage(error, activity);
                }
            });
        }
    }

    public static String parseFileToString(Context context, String filename) {
        try {
            InputStream stream = context.getAssets().open(filename);
            int size = stream.available();

            byte[] bytes = new byte[size];
            stream.read(bytes);
            stream.close();

            return new String(bytes);

        } catch (IOException e) {
            Log.e(LOG_TAG, "IOException: " + e.getMessage());
        }
        return null;
    }

    /**
     * Get a file path from a Uri. This will get the the path for Storage Access
     * Framework Documents, as well as the _data field for the MediaStore and
     * other file-based ContentProviders.
     *
     * @param context The context.
     * @param uri     The Uri to query.
     * @author paulburke
     */
    public static String getPath(final Context context, final Uri uri) {

        final boolean isKitKat = Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT;

        // DocumentProvider
        if (isKitKat && DocumentsContract.isDocumentUri(context, uri)) {
            // ExternalStorageProvider
            if (isExternalStorageDocument(uri)) {
                final String docId = DocumentsContract.getDocumentId(uri);
                final String[] split = docId.split(":");
                final String type = split[0];

                if ("primary".equalsIgnoreCase(type)) {
                    return Environment.getExternalStorageDirectory() + "/" + split[1];
                }

                // TODO handle non-primary volumes
            }
            // DownloadsProvider
            else if (isDownloadsDocument(uri)) {

                final String id = DocumentsContract.getDocumentId(uri);
                final Uri contentUri = ContentUris.withAppendedId(
                        Uri.parse("content://downloads/public_downloads"), Long.valueOf(id));

                return getDataColumn(context, contentUri, null, null);
            }
            // MediaProvider
            else if (isMediaDocument(uri)) {
                final String docId = DocumentsContract.getDocumentId(uri);
                final String[] split = docId.split(":");
                final String type = split[0];

                Uri contentUri = null;
                if ("image".equals(type)) {
                    contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
                } else if ("video".equals(type)) {
                    contentUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
                } else if ("audio".equals(type)) {
                    contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
                }

                final String selection = "_id=?";
                final String[] selectionArgs = new String[]{
                        split[1]
                };

                return getDataColumn(context, contentUri, selection, selectionArgs);
            }
        }
        // MediaStore (and general)
        else if ("content".equalsIgnoreCase(uri.getScheme())) {
            return getDataColumn(context, uri, null, null);
        }
        // File
        else if ("file".equalsIgnoreCase(uri.getScheme())) {
            return uri.getPath();
        }

        return null;
    }

    /**
     * Get the value of the data column for this Uri. This is useful for
     * MediaStore Uris, and other file-based ContentProviders.
     *
     * @param context       The context.
     * @param uri           The Uri to query.
     * @param selection     (Optional) Filter used in the query.
     * @param selectionArgs (Optional) Selection arguments used in the query.
     * @return The value of the _data column, which is typically a file path.
     */
    public static String getDataColumn(Context context, Uri uri, String selection,
                                       String[] selectionArgs) {

        Cursor cursor = null;
        final String column = "_data";
        final String[] projection = {
                column
        };

        try {
            cursor = context.getContentResolver().query(uri, projection, selection, selectionArgs,
                    null);
            if (cursor != null && cursor.moveToFirst()) {
                final int column_index = cursor.getColumnIndexOrThrow(column);
                return cursor.getString(column_index);
            }
        } finally {
            if (cursor != null)
                cursor.close();
        }
        return null;
    }


    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is ExternalStorageProvider.
     */
    public static boolean isExternalStorageDocument(Uri uri) {
        return "com.android.externalstorage.documents".equals(uri.getAuthority());
    }

    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is DownloadsProvider.
     */
    public static boolean isDownloadsDocument(Uri uri) {
        return "com.android.providers.downloads.documents".equals(uri.getAuthority());
    }

    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is MediaProvider.
     */
    public static boolean isMediaDocument(Uri uri) {
        return "com.android.providers.media.documents".equals(uri.getAuthority());
    }


}
