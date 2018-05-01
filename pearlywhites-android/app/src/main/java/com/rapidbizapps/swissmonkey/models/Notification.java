package com.rapidbizapps.swissmonkey.models;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * Created by kkalluri on 8/4/2016.
 */
public class Notification {

    private int id;
    private int job_id;
    private int user_id;
    private String notification_description;
    private String viewed;
    private String created_at;
    private String updated_at;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getJob_id() {
        return job_id;
    }

    public void setJob_id(int job_id) {
        this.job_id = job_id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getNotification_description() {
        return notification_description;
    }

    public void setNotification_description(String notification_description) {
        this.notification_description = notification_description;
    }

    public String getViewed() {
        return viewed;
    }

    public void setViewed(String viewed) {
        this.viewed = viewed;
    }

    public String getCreated_at() {
        return created_at;
    }

    public void setCreated_at(String created_at) {
        this.created_at = created_at;
    }

    public String getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(String updated_at) {
        this.updated_at = updated_at;
    }


    @Override
    public boolean equals(Object o) {
        return this.getViewed().equals(((Notification)o).getViewed());
    }

    public int getNumOfDaysOld() {

        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US);
        Date created, now;
        try {
            created = format.parse(getCreated_at());
            now = format.parse(format.format(new Date()));
        } catch (ParseException e) {
            e.printStackTrace();
            created = new Date();
            now = new Date();
        }

        long timeOne = created.getTime();
        long timeTwo = now.getTime();

        long oneDay = 1000 * 60 * 60 * 24;
        long delta = (timeTwo - timeOne) / oneDay;

        return (int) delta;

    }

}
