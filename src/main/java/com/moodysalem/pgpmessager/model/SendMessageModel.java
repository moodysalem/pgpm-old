package com.moodysalem.pgpmessager.model;

import com.moodysalem.pgpmessager.hibernate.Entry;

public class SendMessageModel {
    private Entry entry;
    private String message;
    private String requestUrl;

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Entry getEntry() {
        return entry;
    }

    public void setEntry(Entry entry) {
        this.entry = entry;
    }

    public String getRequestUrl() {
        return requestUrl;
    }

    public void setRequestUrl(String requestUrl) {
        this.requestUrl = requestUrl;
    }
}
