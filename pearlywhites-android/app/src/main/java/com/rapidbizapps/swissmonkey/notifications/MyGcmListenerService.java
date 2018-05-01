package com.rapidbizapps.swissmonkey.notifications;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;

import com.google.android.gms.gcm.GcmListenerService;
import com.rapidbizapps.swissmonkey.HomeActivity;
import com.rapidbizapps.swissmonkey.R;
import com.rapidbizapps.swissmonkey.utility.Constants;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by mlanka on 24-03-2016.
 */
public class MyGcmListenerService extends GcmListenerService {

    private static final String LOG_TAG = MyGcmListenerService.class.getSimpleName();


    @Override
    public void onMessageReceived(String from, Bundle data) {
        Log.d(LOG_TAG, "onMessageReceived/from:" + from);
        Log.d(LOG_TAG, "onMessageReceived/msg:" + data.get("message"));

        String msg = data.getString("message");
        String message = data.getString("message");

        try {
            message = message.substring(1, message.length() - 1);
            Log.d(LOG_TAG, "message :" + message);
            message = message.replace("\\", "");
            Log.d(LOG_TAG, "message :" + message);
            JSONObject jsonObject = new JSONObject(message);
            message = jsonObject.getString("notification_description");
        } catch (JSONException e) {
            e.printStackTrace();
        }

        Intent intent = new Intent(Constants.MESSAGE_RECEIVED);
        intent.putExtra(Constants.NOTIFICATION, message);
        createNotification(message);

          /*//TODO:need to remove the below line
          msg=" {\n" +
               "      \"id\": 227,\n" +
               "      \"job_id\": 474,\n" +
               "      \"user_id\": 401,\n" +
               "      \"notification_description\": \"New Job added for Registered Dental Assistant (RDA)\",\n" +
               "      \"viewed\": \"YES\",\n" +
               "      \"created_at\": \"2016-08-04 05:57:51\",\n" +
               "      \"updated_at\": \"2016-08-04 05:57:51\"\n" +
               "    }";*/

        //adding to current list
        Intent intent1 = new Intent("notification");
        // You can also include some extra data.
        intent1.putExtra("message", msg);
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent1);

    }

    private void createNotification(String message) {
        Log.d(LOG_TAG, "createNotification: " + message);
        Uri defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
        Intent intent = new Intent(this, HomeActivity.class);
        intent.putExtra(Constants.NOTIFICATION_MESSAGE, message);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);

        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(getString(R.string.app_name))
                .setContentText(message)
                .setAutoCancel(true)
                .setSound(defaultSoundUri)
//                .setColor(getResources().getColor(R.color.purple))
                .setContentIntent(pendingIntent);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            notificationBuilder.setSmallIcon(R.drawable.ic_stat_swiss_monkey_logo);
        }
        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        int randomNumber = (int) Math.round(Math.random());
        notificationManager.notify(randomNumber, notificationBuilder.build());
    }
}
